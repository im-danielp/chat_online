import 'dart:developer';
import 'dart:io';
import 'package:chat_online_novo/chat_message.dart';
import 'package:chat_online_novo/text_composer.dart';
import 'package:chat_online_novo/utilities/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final googleSignIn = GoogleSignIn();
  User? currentUser;

  /// Sempre que o usuário trocar de conta, altera também a variável usuário.
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      currentUser = user;
    });
  }

  Future<User?> getUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return user;
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuthentication = await googleSignInAccount!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;
      return user;
    } catch (e) {
      log('getUser - catch: $e');
      return null;
    }
  }

  /// Salva o texto no FireBase.
  void sendMessage({String? text, File? imgFile}) async {
    try {
      final user = await getUser();

      if (user == null && mounted) {
        snackbarErro(context, msg: 'Não foi possível fazer o login. Tente novamente!');
      }

      Map<String, dynamic> data = {
        'uid': user?.uid ?? '',
        'senderName': user?.displayName ?? '',
        'senderPhotoUrl': user?.photoURL ?? '',
      };

      if (imgFile != null) {
        UploadTask task = FirebaseStorage.instance
            .ref()
            .child('${DateTime.now().microsecondsSinceEpoch.toString()}.jpg')
            .putFile(imgFile);

        TaskSnapshot taskSnapshot = await task;
        String url = await taskSnapshot.ref.getDownloadURL();
        data['imageUrl'] = url;
      }

      if (text != null) {
        data['text'] = text;
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      FirebaseFirestore.instance.collection('messages').add(data);
    } catch (e) {
      if (mounted) {
        snackbarErro(context, msg: 'Não foi possível enviar sua mensagem!');
        log('sendMessage catch - $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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

                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final data = documents[index].data() as Map<String, dynamic>;
                    return ChatMessage(data: data, mine: true);
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
