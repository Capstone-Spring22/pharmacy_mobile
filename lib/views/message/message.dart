import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/chat_controller.dart';
import 'package:pharmacy_mobile/models/message.dart';
import 'package:pharmacy_mobile/views/message/widgets/message_bubble.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

import '../../widgets/appbar.dart';
import '../../widgets/back_button.dart';
import '../drawer/cart_drawer.dart';
import '../drawer/menu_drawer.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late MessageController messageController;
  @override
  void initState() {
    messageController = Get.put(MessageController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MessageController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatid = Get.arguments['id'];

    final chat =
        chatController.chats.singleWhere((element) => element.id == chatid);
    final status = chat.status;
    return Scaffold(
      drawer: const MenuDrawer(),
      endDrawer: const CartDrawer(),
      appBar: PharmacyAppBar(
        leftWidget: const PharmacyBackButton(),
        midText: status == 'pending'
            ? 'Đang chờ phản hồi'
            : 'Đang nhắn với ${chat.pharmacistId}',
        rightWidget: NeumorphicButton(
          style: NeumorphicStyle(
            boxShape: const NeumorphicBoxShape.circle(),
            color: context.theme.canvasColor,
            shape: NeumorphicShape.flat,
          ),
          onPressed: () => chatController.createRequestDialog(),
          child: Icon(
            Icons.more_vert,
            color: context.theme.primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chat.id)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message =
                        ChatMessage.fromSnapshot(snapshot.data!.docs[index]);
                    final isSender = message.senderId == chat.patientId;
                    return MessageBubble(
                      isSender: isSender,
                      message: message,
                      fontSize: chat.fontSize,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () async {
                      var imgUrl = await MessageController.pickImage();
                      if (imgUrl.isImageFileName) {
                        messageController.sendImageUrl(imgUrl);
                      }
                    },
                    icon: const Icon(Icons.photo)),
                Expanded(
                  child: Input(
                    inputController: messageController.txt,
                    inputAction: TextInputAction.send,
                    onSubmit: (p0) async =>
                        await messageController.sendMessage(),
                  ),
                ),
                IconButton(
                  onPressed: () async => messageController.sendMessage(),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
