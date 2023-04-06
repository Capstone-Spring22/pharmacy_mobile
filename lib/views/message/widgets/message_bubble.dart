import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/models/message.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.isSender,
    required this.message,
    required this.fontSize,
  });

  final bool isSender;
  final ChatMessage message;
  final num fontSize;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  void _resetTap() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isTap = false;
        });
      }
    });
  }

  bool isTap = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isTap = !isTap);
        _resetTap();
      },
      child: Align(
        alignment: widget.isSender ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: context.theme.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (widget.message.type == 'image')
                CachedNetworkImage(
                  imageUrl: widget.message.message,
                  placeholder: (context, url) => LoadingWidget(),
                ),
              if (widget.message.type == 'text')
                SelectableText(
                  onTap: () {
                    setState(() => isTap = !isTap);
                    _resetTap();
                  },
                  widget.message.message,
                  style: TextStyle(
                    fontSize: widget.fontSize.toDouble(),
                    color: Colors.black,
                  ),
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isTap ? Get.height * .02 : 0.0,
                child: AnimatedOpacity(
                  opacity: isTap ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    timeago.format(widget.message.timestamp.toDate()),
                    style: TextStyle(
                      fontSize: widget.fontSize.toDouble() - 5,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
