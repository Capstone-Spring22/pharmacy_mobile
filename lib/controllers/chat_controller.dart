// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;

import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/message.dart';
import 'package:pharmacy_mobile/models/pharmacy_user.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

class ChatController extends GetxController {
  static ChatController instance = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Chat> chats = RxList<Chat>([]);
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        chats.clear();
      } else {
        ever(userController.user, (u) {
          if (u is PharmacyUser) {
            getChats(u.id!);
          }
        });
      }
    });
  }

  void createRequestDialog() {
    final txt = TextEditingController();
    Get.defaultDialog(
      title: 'Bạn cần giúp gì?',
      content: Column(
        children: [Input(inputController: txt)],
      ),
      textConfirm: 'Gửi',
      confirmTextColor: Colors.white,
      onConfirm: () {
        chatController.sendRequest(txt.text);
        Get.back();
      },
    );
  }

  Future<void> getChats(String patientId) async {
    try {
      _firestore
          .collection('chats')
          .where('patientId', isEqualTo: patientId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((event) {
        chats.value = event.docs.map((doc) => Chat.fromSnapshot(doc)).toList();
      });
      isLoading.value = false;
    } catch (e) {
      Get.log(e.toString());
    }
  }

  Future sendRequest(String request) async {
    const pharmacistId = '';
    final patientId = userController.user.value!.id;
    final timestamp = Timestamp.now();
    const status = 'pending';
    const lastMessage = 'lastMessage';

    final chat = Chat(
      id: '',
      lastMessage: lastMessage,
      status: status,
      patientId: patientId!,
      pharmacistId: pharmacistId,
      request: request,
      fontSize: 16,
      timestamp: timestamp,
    );

    final chatRef = await _firestore.collection('chats').add({
      'lastMessage': lastMessage,
      'status': status,
      'patientId': patientId,
      'pharmacistId': pharmacistId,
      'request': request,
      'timestamp': timestamp,
      'fontSize': 16,
    });

    final message = ChatMessage(
      message: request,
      senderId: patientId,
      timestamp: timestamp,
      type: 'text',
    );

    final messageRef = await _firestore
        .collection('chats')
        .doc(chatRef.id)
        .collection('messages')
        .add(
          message.toFirebase(),
        );

    chat.id = chatRef.id;
    chats.add(chat);
  }
}

class MessageController extends GetxController {
  static MessageController instance = Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<ChatMessage> messages = RxList<ChatMessage>([]);
  RxBool isLoading = true.obs;

  TextEditingController txt = TextEditingController();

  final String chatId = Get.arguments['id'];

  static Future<String> pickImage() async {
    final ImagePicker picker = ImagePicker();
    String url = '';
    XFile? image;
    //show a dialog asking the user to pick an image or take a photo
    await Get.defaultDialog(
      title: 'Chọn ảnh',
      middleText: 'Lấy ảnh từ thư viện hoặc chụp ảnh mới',
      actions: [
        // Pick an image.
        TextButton(
          onPressed: () async {
            image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              url = (await confirmImageSent(image, 'image'))!;
              Get.back();
            }
          },
          child: const Text('Thư viện ảnh'),
        ),
        // Capture a photo.
        TextButton(
          onPressed: () async {
            image = await picker.pickImage(source: ImageSource.camera);
            if (image != null) {
              url = (await confirmImageSent(image, 'photo'))!;
              Get.back();
            }
          },
          child: const Text('Chụp ảnh mới'),
        ),
      ],
    );
    return url;
  }

  static Future<String?> confirmImageSent(XFile? image, String type) async {
    String? url;
    if (image != null) {
      Completer<String?> completer = Completer<String?>(); // Create a completer
      await Get.dialog(
        AlertDialog(
          title: const Text('Chọn ảnh này'),
          content: SizedBox(
            height: Get.height * .3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.file(
                  File(image.path),
                  height: 180,
                ),
                const Text(
                    'Bạn có chắc muốn dùng ảnh này? Bạn có thể thay đổi lại bất cứ lúc nào.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(Get.overlayContext!).pop(); // Close the dialog
                completer.complete(null); // Complete the completer with null
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(Get.overlayContext!).pop(); // Close the dialog
                final ImagePicker picker = ImagePicker();
                if (type == 'image') {
                  await confirmImageSent(
                      await picker.pickImage(source: ImageSource.gallery),
                      'image');
                } else {
                  await confirmImageSent(
                      await picker.pickImage(source: ImageSource.gallery),
                      'photo');
                }
              },
              child: const Text('Chọn ảnh khác'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(Get.overlayContext!).pop(); // Close the dialog
                url = await uploadImage(image);
                completer.complete(url); // Complete the completer with the url
              },
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      );
      return completer.future; // Return the future of the completer
    }
    return url;
  }

  static Future<String> uploadImage(XFile imageFile) async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path,
          filename: '${imageFile.name}_${DateTime.now().toIso8601String()}'),
    });

    RxInt sent = 0.obs;
    RxInt total = 0.obs;
    Response? res;

    Get.dialog(
      Obx(() => AlertDialog(
            title: const Text('Đang tải ảnh lên'),
            content: SizedBox(
              height: Get.height * .3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.file(
                    File(imageFile.path),
                    height: 180,
                  ),
                  const Text('Xin đợi khi đang tải ảnh lên'),
                  LinearProgressIndicator(
                    value: total.value == 0 ? 0 : sent.value / total.value,
                  ),
                  Text(
                    '${((sent.value / total.value) * 100).toStringAsFixed(2)}%',
                  ),
                ],
              ),
            ),
          )),
    );

    res = await dio.post(
      '${api}Utility/UploadFile',
      data: formData,
      onSendProgress: (int s, int t) {
        sent.value = s;
        total.value = t;
      },
    );

    await Future.delayed(const Duration(milliseconds: 200));

    Get.back();
    return res.data;
  }

  Future<void> fetchMessages(String chatId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();
    messages.value =
        snapshot.docs.map((doc) => ChatMessage.fromSnapshot(doc)).toList();
    isLoading.value = false;
  }

  Future sendImageUrl(String url) async {
    final timestamp = Timestamp.now();
    final chatMessage = ChatMessage(
      message: url,
      senderId: userController.user.value!.id!,
      timestamp: timestamp,
      type: 'image',
    );

    final messageRef = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(
          chatMessage.toFirebase(),
        );

    messages.add(chatMessage);

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': 'Image',
      'timestamp': timestamp,
    });
  }

  Future<void> sendMessage() async {
    final timestamp = Timestamp.now();
    final chatMessage = ChatMessage(
      message: txt.text,
      senderId: userController.user.value!.id!,
      timestamp: timestamp,
      type: 'text',
    );

    final messageRef = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(
          chatMessage.toFirebase(),
        );

    messages.add(chatMessage);

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': txt.text,
      'timestamp': timestamp,
    });

    txt.clear();
  }
}

class ImageUploader extends StatefulWidget {
  final File imageFile;
  const ImageUploader({super.key, required this.imageFile});

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Uploading Image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LinearProgressIndicator(value: _progress),
          const SizedBox(height: 20),
          Text('${(_progress * 100).toStringAsFixed(2)}%'),
        ],
      ),
    );
  }

  Future<void> uploadImage() async {
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(widget.imageFile.path,
          filename: "image.jpg"),
    });

    try {
      await dio.post(
        "https://example.com/upload",
        data: formData,
        onSendProgress: (int sent, int total) {
          setState(() {
            _progress = sent / total;
          });
        },
      );
    } catch (e) {
      Get.log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    uploadImage();
  }
}
