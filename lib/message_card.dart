import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:pmtc/models.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final bool isSender;
  const MessageCard({
    super.key,
    required this.message,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return isSender
        ? BubbleSpecialThree(
            text: message.message,
            color: const Color(0xFF1B97F3),
            tail: false,
            textStyle: const TextStyle(color: Colors.white, fontSize: 16),
          )
        : BubbleSpecialThree(
            text: message.message,
            color: const Color(0xFFE8E8EE),
            tail: false,
            isSender: false,
          );
  }
}
