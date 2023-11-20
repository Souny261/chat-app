import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:chat_with_me/chat-with-me/controller/chat_controller.dart';
import 'package:chat_with_me/chat-with-me/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        builder: (controller) => Obx(
              () => controller.messages.isEmpty
                  // TODO: Update Loading State Here
                  ? const Scaffold(
                      body: Center(child: Text("Loading...")),
                    )
                  : Scaffold(
                      appBar: AppBar(
                          actions: [
                            IconButton(
                              onPressed: () {
                                controller.fetchImage();
                              },
                              icon: const Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8)
                          ],
                          centerTitle: false,
                          backgroundColor: Colors.deepOrangeAccent,
                          elevation: 1,
                          automaticallyImplyLeading: false,
                          title: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Expanded(
                                child: ListTile(
                                  leading: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "https://scontent.fvte2-2.fna.fbcdn.net/v/t39.30808-6/359837957_164124076682537_2051106502048174949_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEDlPHaIZUSbGgQ9cF2ZJWYP-fhP3x4RJM_5-E_fHhEk9yuE2Co6znvqf3QnBU0yfX291vtYenpAskEjOZHwQLZ&_nc_ohc=vVTkR_QdUhMAX8ENNPI&_nc_ht=scontent.fvte2-2.fna&oh=00_AfDPau2O4Q-qU4CMA7je4ic4P1mK2SefHO76NCRiioZ8jQ&oe=655C4715"),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Icon(
                                          Icons.circle,
                                          color: Colors.green,
                                          size: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  subtitle: Text(
                                    "Online",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    "Kokkok Ltry Support",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      body: Obx(() => Chat(
                            messages: controller.messages.value,
                            onSendPressed: controller.handleSendPressed,
                            onAttachmentPressed: () {},
                            emptyState: const EmptyStateWidget(),
                            showUserAvatars: true,
                            showUserNames: true,
                            user: types.User(id: controller.userId.value),
                            imageMessageBuilder: (p0, {int? messageWidth}) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: p0.height,
                                    width: p0.width,
                                    child: CachedMemoryImage(
                                      uniqueKey: p0.id,
                                      errorWidget: const Text('Error'),
                                      base64: base64Encode(
                                          Uint8List.fromList(p0.uri.codeUnits)),
                                      placeholder:
                                          const CircularProgressIndicator(),
                                    ),
                                    // decoration: BoxDecoration(
                                    //     color: Colors.deepOrangeAccent,
                                    //     image: DecorationImage(
                                    //       image: MemoryImage(Uint8List.fromList(
                                    //           p0.uri.codeUnits)),
                                    //       fit: BoxFit.fill,
                                    //     )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(p0.name),
                                  ),
                                ],
                              );
                            },
                            l10n: const ChatL10nEn(
                              inputPlaceholder: 'Enter your message ...',
                            ),
                            theme: DefaultChatTheme(
                                userAvatarNameColors: const [
                                  Colors.deepOrangeAccent
                                ],
                                userAvatarImageBackgroundColor:
                                    Colors.deepOrangeAccent,
                                primaryColor: Colors.deepOrangeAccent,
                                inputBorderRadius: BorderRadius.circular(0),
                                inputBackgroundColor: Colors.grey.shade200,
                                inputTextColor: Colors.black,
                                inputTextCursorColor: Colors.black,
                                attachmentButtonIcon: const Icon(
                                  Icons.add_circle_outline_outlined,
                                  color: Colors.black,
                                )),
                          )),
                    ),
            ));
  }
}
