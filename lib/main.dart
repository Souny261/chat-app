import 'dart:developer';

import 'package:chat_with_me/chat-with-me/binding/chat_binding.dart';
import 'package:chat_with_me/chat-with-me/repo/chat_repository_impl.dart';
import 'package:chat_with_me/chat-with-me/view/main.dart';
import 'package:chat_with_me/chat-with-me/widgets/chat_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat With Me',
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Select Your Chat"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    ChatBinding().dependencies();
                    Get.to(const ChatView());
                  },
                  child: const Text(
                    "Chat",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // MaterialButton(
                //   color: Colors.blue,
                //   onPressed: () {
                //     Get.to(const ChatPage());
                //   },
                //   child: const Text(
                //     "Chat Test",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}
