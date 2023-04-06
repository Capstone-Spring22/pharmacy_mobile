import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/models/message.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatList extends StatelessWidget {
  const ChatList({super.key, required this.messages});

  final RxList<Chat> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          onTap: () => Get.toNamed('/message', arguments: {
            "id": message.id,
            "request": message.request,
          }),
          title: Text(message.request),
          subtitle: Text(message.status),
          trailing: Text(timeago.format(message.timestamp.toDate())),
        );
      },
    );
  }
}
