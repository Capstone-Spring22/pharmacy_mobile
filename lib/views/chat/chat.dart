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
        title: const Text('Liên hệ'),
        actions: [
          TextButton(
              onPressed: () => chatController.createRequestDialog(),
              child: const Text('Liên hệ dược sĩ'))
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Chưa có yêu cầu, nếu bạn có yêu cầu, xin đừng ngại liên hệ với chúng tôi",
                        ),
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
