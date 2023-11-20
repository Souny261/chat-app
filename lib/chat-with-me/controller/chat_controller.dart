import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:chat_with_me/chat-with-me/repo/chat_repository.dart';
import 'package:chat_with_me/chat-with-me/repo/chat_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

import '../models/message_model.dart';

class ChatController extends GetxController {
  late ChatRepository chatRepository;
  ChatController() {
    chatRepository = Get.put(ChatRepositoryImpl());
  }
  final RxList<types.Message> messages = <types.Message>[].obs;

  RxString userId = "".obs;
  RxString authToken = "".obs;
  RxString adminRoomID = "".obs;

  Future<void> activeUser() async {
    var result = await chatRepository.userSigin();
    if (result['status'] == "error") {
      var createUserResult = await chatRepository.userSigup();
      if (createUserResult["success"]) {
        activeUser();
      }
    } else {
      userId.value = result['data']['userId'];
      authToken.value = result['data']['authToken'];
      log("rockeyUserId.value: ${userId.value}");
      log("rockeyAuthToken.value: ${authToken.value}");
    }
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: types.User(id: userId.value),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    // addMessage(textMessage);
    chatRepository.sendMessageUser(
        userId: userId.value,
        authToken: authToken.value,
        roomID: adminRoomID.value,
        message: textMessage.text);
  }

  void addMessage(types.Message message) {
    messages.insert(0, message);
  }

  Future<void> getAdminRoomID() async {
    String roomID = await chatRepository.getAdminRoom(
        userId: userId.value, authToken: authToken.value);
    if (roomID == "Error") {
      var snackBar =
          const SnackBar(content: Text('Error to get admin room id'));
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    } else {
      adminRoomID.value = roomID;
      log("adminRoomID.value: ${adminRoomID.value}");
    }
  }

  Future<void> getMessages() async {
    messages.clear();
    chatRepository
        .getMessage(
      userId: userId.value,
      authToken: authToken.value,
      roomID: adminRoomID.value,
    )
        .then((value) {
      for (var element in value.messages!.reversed) {
        createMessage(element);
      }
    });
  }

  StreamSubscription? subscription;
  Future streamMessage() async {
    IOWebSocketChannel channel = chatRepository.connectChannel();
    IOWebSocketChannel magChannel =
        chatRepository.getStreamRoomMessage(channel, adminRoomID.value);
    subscription = magChannel.stream.listen((message) {
      var data = jsonDecode(message);
      log("msg: ${jsonEncode(data)}");
      if (data['msg'] == "changed") {
        Messages messageModel = Messages.fromJson(data['fields']['args'][0]);
        createMessage(messageModel);
      }
    }, onDone: () {
      log("onDone");
      streamMessage();
    }, onError: (e) {
      log("onError: $e");
    });
  }

  void createMessage(Messages data) async {
    if (data.md != "") {
      if (data.md![0].type == "PARAGRAPH" || data.md![0].type == "BIG_EMOJI") {
        types.Message message;
        message = types.TextMessage(
          author: types.User(
              id: data.u!.sId!,
              firstName: data.u!.name,
              imageUrl:
                  "https://scontent.fvte2-2.fna.fbcdn.net/v/t39.30808-6/359837957_164124076682537_2051106502048174949_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEDlPHaIZUSbGgQ9cF2ZJWYP-fhP3x4RJM_5-E_fHhEk9yuE2Co6znvqf3QnBU0yfX291vtYenpAskEjOZHwQLZ&_nc_ohc=vVTkR_QdUhMAX8ENNPI&_nc_ht=scontent.fvte2-2.fna&oh=00_AfDPau2O4Q-qU4CMA7je4ic4P1mK2SefHO76NCRiioZ8jQ&oe=655C4715"),
          createdAt: data.ts!.millisecondsSinceEpoch,
          id: data.sId!,
          text: EmojiParser().emojify(data.msg!),
        );
        addMessage(message);
      }
    }
    if (data.attachments != null) {
      Uint8List? imgFromUri = await chatRepository.fetchImage(
        userId: userId.value,
        authToken: authToken.value,
        uri: data.attachments![0].imageUrl!,
      );
      types.Message img = types.ImageMessage(
        author: types.User(
            id: data.u!.sId!,
            firstName: data.u!.name,
            imageUrl:
                "https://scontent.fvte2-2.fna.fbcdn.net/v/t39.30808-6/359837957_164124076682537_2051106502048174949_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEDlPHaIZUSbGgQ9cF2ZJWYP-fhP3x4RJM_5-E_fHhEk9yuE2Co6znvqf3QnBU0yfX291vtYenpAskEjOZHwQLZ&_nc_ohc=vVTkR_QdUhMAX8ENNPI&_nc_ht=scontent.fvte2-2.fna&oh=00_AfDPau2O4Q-qU4CMA7je4ic4P1mK2SefHO76NCRiioZ8jQ&oe=655C4715"),
        createdAt: data.ts!.millisecondsSinceEpoch,
        height: data.attachments![0].imageDimensions!.height!.toDouble(),
        id: data.sId!,
        name: data.attachments![0].description!,
        size: data.attachments![0].imageSize!,
        showStatus: false,
        uri: String.fromCharCodes(imgFromUri!),
        width: data.attachments![0].imageDimensions!.width!.toDouble(),
      );
      addMessage(img);
    }
  }

  void fetchImage() {
    chatRepository
        .fetchImage(
      userId: userId.value,
      authToken: authToken.value,
      uri: "/file-upload/655ace83daf4e239c9060ed5/One_piece.png",
    )
        .then((value) {
      log("message: $value");
    });
  }

  @override
  void onInit() {
    activeUser().whenComplete(
      () => getAdminRoomID()
          .whenComplete(() => getMessages())
          .whenComplete(() => streamMessage()),
    );
    super.onInit();
  }

  @override
  void onClose() {
    log("onClose");
    subscription!.cancel();
    super.onClose();
  }
}
