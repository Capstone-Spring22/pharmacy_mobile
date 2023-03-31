import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/chat_controller.dart';

import 'widgets/chat_list.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          TextButton(
              onPressed: () => chatController.createRequestDialog(),
              child: const Text('Contact Pharmacist'))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  final messages = chatController.chats;

                  if (chatController.isLoading.isTrue) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                        "No request sent, if you have any request, please contact pharmacist",
                      ),
                    );
                  } else {
                    return ChatList(
                      messages: messages,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
