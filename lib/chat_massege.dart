import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  ChatMessage({Key? key,required this.id}) : super(key: key);
  String? id;
  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message${widget.id}'),
      ),
    );
  }
}
