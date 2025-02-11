import 'package:chat_online_novo/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // Firebase chatFlutter.

  runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance
      .collection('mensagens')
      .doc('msg1')
      .snapshots()
      .listen((doc) {
    // print(doc.data());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        iconTheme: const IconThemeData(color: Colors.amber),
        appBarTheme: const AppBarTheme(
          color: Colors.amber,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}
