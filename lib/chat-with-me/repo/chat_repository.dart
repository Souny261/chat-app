import 'dart:typed_data';

import 'package:chat_with_me/chat-with-me/models/message_model.dart';
import 'package:web_socket_channel/io.dart';

abstract class ChatRepository {
  Future<dynamic> userSigin();
  Future<dynamic> userSigup();
  Future<String> getAdminRoom({
    required String userId,
    required String authToken,
  });
  Future<MessageModel> getMessage(
      {required String userId,
      required String authToken,
      required String roomID});
  Future<dynamic> sendMessageUser(
      {required String userId,
      required String authToken,
      required String message,
      required String roomID});
  IOWebSocketChannel connectChannel();
  IOWebSocketChannel getStreamRoomMessage(
      IOWebSocketChannel channel, String roomID);
  Future<Uint8List?> fetchImage(
      {required String userId, required String authToken, required String uri});
}
