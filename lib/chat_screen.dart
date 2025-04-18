import 'dart:developer';
import 'dart:io';
import 'package:chat_online_novo/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void sendMessage({String? text, File? imgFile}) async {
    if (imgFile != null) {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().microsecondsSinceEpoch.toString()}.jpg')
          .putFile(imgFile);

      TaskSnapshot taskSnapshot = await task;
      String url = await taskSnapshot.ref.getDownloadURL();

      log(url);
    }

    FirebaseFirestore.instance.collection('messages').add(
      {
        'text': text,
        'createdAt': FieldValue.serverTimestamp(), // Momento de criação da menssagem.
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar mensagens'),
                  );
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(documents[index].get('text')),
                    );
                  },
                );
              },
            ),
          ),
          TextComposer(
            sendMessage: sendMessage,
          ),
        ],
      ),
    );
  }
}
