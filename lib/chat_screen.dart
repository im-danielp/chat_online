import 'package:chat_online_novo/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void sendMessage(String text) {
    FirebaseFirestore.instance.collection('messages').add(
      {
        'text': text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Olá'),
        centerTitle: true,
      ),
      body: TextComposer(
        sendMessage: sendMessage,
      ),
    );
  }
}
