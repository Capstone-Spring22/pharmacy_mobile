import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/chat_controller.dart';
import 'package:pharmacy_mobile/models/message.dart';
import 'package:pharmacy_mobile/screens/message/widgets/message_bubble.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
      appBar: AppBar(
        title: Text(
          status == 'pending'
              ? 'Pending Request'
              : 'Chat with ${chat.pharmacistId}',
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Get.defaultDialog(
              //   title: 'Increase Font Size',
              //   content: const IncreaseFont(),
              // );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
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
                    onPressed: () {
                      messageController.pickImage();
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
