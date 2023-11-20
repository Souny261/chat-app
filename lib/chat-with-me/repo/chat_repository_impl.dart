import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:chat_with_me/chat-with-me/models/message_model.dart';
import 'package:chat_with_me/chat-with-me/repo/chat_repository.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

String password = "KKL-ROCKET-CHAT";
// TODO: Update User Admin Here
String adminUser = "tia007";
String baseUrl = "https://collabora.laotel.com";
String webSocketBaseUrl = "ws://collabora.laotel.com/websocket";
String calculateSHA256(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<dynamic> userSigin() async {
    try {
      final response = await Dio().post(
        '$baseUrl/api/v1/login',
        // TODO: Update User Here
        data: {
          "user": "02055889758",
          "password": password,
        },
        options: Options(
          headers: {
            "Content-type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        log('Login successful');
        return response.data;
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  @override
  Future<dynamic> userSigup() async {
    try {
      final response = await Dio().post(
        '$baseUrl/api/v1/users.register',
        // TODO: Update Payload Here
        data: {
          "username": "02055889758",
          "email": "02055889758@kokkok-ltry.com",
          "pass": password,
          "name": "Souny MALYVANH",
        },
        options: Options(
          headers: {
            "Content-type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        log('Registration successful');
        return response.data;
      } else {
        log('Registration failed');
        return response.data;
      }
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  @override
  Future<String> getAdminRoom(
      {required String userId, required String authToken}) async {
    final headers = {
      "X-Auth-Token": authToken,
      "X-User-Id": userId,
    };
    try {
      final response = await Dio().post(
        '$baseUrl/api/v1/im.create',
        data: {"username": adminUser},
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        return response.data['room']['rid'];
      } else {
        return "Error";
      }
    } on DioException catch (e) {
      log("Error: $e");
      return "Error";
    }
  }

  @override
  Future<MessageModel> getMessage(
      {required String userId,
      required String authToken,
      required String roomID}) async {
    final headers = {
      "X-Auth-Token": authToken,
      "X-User-Id": userId,
    };

    try {
      final response = await Dio().get(
        '$baseUrl/api/v1/im.messages?roomId=$roomID',
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        return MessageModel.fromJson(response.data);
      } else {
        return MessageModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      return MessageModel.fromJson(e.response!.data);
    }
  }

  @override
  Future<dynamic> sendMessageUser(
      {required String userId,
      required String authToken,
      required String message,
      required String roomID}) async {
    final headers = {
      "X-Auth-Token": authToken,
      "X-User-Id": userId,
    };

    try {
      final response = await Dio().post(
        '$baseUrl/api/v1/chat.sendMessage',
        data: {
          "message": {"rid": roomID, "msg": message}
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        log('Send Successful');
        return response.data;
      } else {
        log('Send Failed');
        return response.data;
      }
    } on DioException catch (e) {
      log('Error Res: ${e.response!.data}');
      return e.response!.data;
    }
  }

  @override
  IOWebSocketChannel connectChannel() {
    var uuid = const Uuid();
    String randomUuid = uuid.v4();
    IOWebSocketChannel channel = IOWebSocketChannel.connect(webSocketBaseUrl);
    final connectMessage = {
      "msg": "connect",
      "version": "1",
      "support": ["1"]
    };
    channel.sink.add(jsonEncode(connectMessage));
    final payload = {
      "msg": "method",
      "method": "login",
      "id": randomUuid,
      "params": [
        {
          "user": {
            // TODO: Update User Here
            "username": "02055889758",
          },
          "password": {
            "digest": calculateSHA256(password),
            "algorithm": "sha-256"
          }
        }
      ]
    };
    channel.sink.add(jsonEncode(payload));
    return channel;
  }

  @override
  IOWebSocketChannel getStreamRoomMessage(
    IOWebSocketChannel channel,
    String roomID,
  ) {
    String randomUuid = const Uuid().v4();
    final connectMessage = {
      "msg": "sub",
      "id": randomUuid,
      "name": "stream-room-messages",
      "params": [roomID, false]
    };
    channel.sink.add(jsonEncode(connectMessage));
    return channel;
  }

  @override
  Future<Uint8List?> fetchImage(
      {required String userId,
      required String authToken,
      required String uri}) async {
    try {
      final headers = {
        "X-Auth-Token": authToken,
        "X-User-Id": userId,
      };
      final response = await Dio().get(
        '$baseUrl$uri',
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
        ),
      );
      return Uint8List.fromList(response.data!);
      // log('response: ${response.data}');
      // return null;
    } on DioException catch (e) {
      log('Error Res: ${e.response!.data}');
      return null;
    }
  }
}
