import 'dart:convert';
import 'dart:io';

import 'package:chatbot/core/constants/api_constant.dart';
import 'package:chatbot/product/conversation/model/conversation_model.dart';
import 'package:chatbot/product/conversation/model/conversation_room_model.dart';
import 'package:chatbot/product/conversation/model/conversation_store_model.dart';
import 'package:chatbot/product/conversation/model/sound_model.dart';
import 'package:chatbot/product/conversation/model/transcription_model.dart';
import 'package:chatbot/product/conversation/model/translate_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../model/chat_model.dart';
import '../model/one_message_model.dart';
import '../model/rate_model.dart';

class ConversationService {
  Future<ConversationModel> getConversations(String token) async {
    final response = await http
        .get(Uri.parse(ApiConstant.instance.conversationUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    return ConversationModel.fromJson(jsonDecode(response.body));
  }

  Future<ConversationStoreModel> createConversation(String token,
      {required String scenarioId, required String cefr}) async {
    final response = await http
        .post(Uri.parse(ApiConstant.instance.conversationUrl), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'scenario_id': scenarioId,
      'cefr': cefr,
    });

    return ConversationStoreModel.fromJson(jsonDecode(response.body));
  }

  Future<ConversationRoomModel> getAllMessages(String token,
      {required int conversationId}) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstant.instance.conversationUrl}/$conversationId/message'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return ConversationRoomModel.fromJson(jsonDecode(response.body));
  }

  Future<OneMessageModel> getMessage(String token,
      {required int conversationId, required int messageId}) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstant.instance.conversationUrl}/$conversationId/message/$messageId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return OneMessageModel.fromJson(jsonDecode(response.body));
  }

  Future<List<ChatModel>> sendMessage(
    BuildContext context, {
    required String message,
    required int conversationId,
    required String token,
    required String soundRatio,
    required File soundFile,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
            '${ApiConstant.instance.conversationUrl}/$conversationId/message'),
      );
      request.headers.addAll(
        {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          'content-type': 'multipart/form-data'
        },
      );

      request.fields['sound_ratio'] = soundRatio;
      request.fields['message'] = message;

      if (await soundFile.exists()) {
        final bytes = await soundFile.readAsBytes();
        final file = http.MultipartFile.fromBytes(
          'sound_file',
          bytes,
          contentType: MediaType('audio', 'wav'),
          filename: basename(soundFile.path),
        );

        request.files.add(file);
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      Map jsonResponse = json.decode(responseBody);

      List<ChatModel> chatList = [];

      if (jsonResponse['data']['message'].length > 0) {
        chatList = List.generate(
          jsonResponse['data']['message'].length,
          (index) => ChatModel(
            message: jsonResponse['data']['message'][index]['message'],
            role: 'assistant',
            id: jsonResponse['data']['message'][index]['id'],
            conversationCompletionCount: jsonResponse['data']['message'][index]
                ['conversation_completion_count'],
            endConversation: jsonResponse['data']['message'][index]
                ['end_conversation'],
            betterSentence: jsonResponse['data']['message'][index]
                ['better_sentence'],
            correctSentence: jsonResponse['data']['message'][index]
                ['correct_sentence'],
            sound: jsonResponse['data']['message'][index]['sound'],
            soundRatio: jsonResponse['data']['message'][index]['sound_ratio'],
          ),
        );
      }

      return chatList;
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Something went wrong",
        ),
      );
      rethrow;
    }
  }

  Future<TranslateModel> translate(String token,
      {required int conversationId,
      required int messageId,
      required String translateLanguage}) async {
    final response = await http.get(
        Uri.parse(
            "${ApiConstant.instance.conversationUrl}/$conversationId/message/$messageId?translate=$translateLanguage"),
        headers: {
          'Authorization': 'Bearer $token',
        });

    return TranslateModel.fromJson(jsonDecode(response.body));
  }

  Future<TranscriptionModel> sendTextToPlayAPI(
      {required String content}) async {
    final response = await http.post(
      Uri.parse("https://play.ht/api/v1/convert"),
      headers: {
        'Authorization': '6f6a715ecf6149f2b04e275e675c89d0',
        'X-User-Id': 'UUoygIEjkvc71ChSDjOJxazkg192',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "content": [content],
        "voice": "Amy"
      }),
    );

    return TranscriptionModel.fromJson(jsonDecode(response.body));
  }

  Future<SoundModel> sendTranscriptionIdToPlayAPI(
      {required String transcriptionId}) async {
    SoundModel? soundModel;
    int attempts = 0;
    while (soundModel == null && attempts < 10) {
      final response = await http.get(
        Uri.parse(
            "https://play.ht/api/v1/articleStatus?transcriptionId=$transcriptionId"),
        headers: {
          'Authorization': '6f6a715ecf6149f2b04e275e675c89d0',
          'X-User-Id': 'UUoygIEjkvc71ChSDjOJxazkg192',
          'Accept': 'application/json',
        },
      );

      var data = jsonDecode(response.body);
      if (data["converted"] == true) {
        soundModel = SoundModel.fromJson(data);
      } else {
        attempts++;
        await Future.delayed(
            const Duration(microseconds: 100)); // wait for 5 seconds
      }
    }
    if (soundModel != null) {
      return soundModel;
    } else {
      throw Exception(
          "Failed to fetch transcription status after $attempts attempts");
    }
  }

  Future<RateModel> getRates(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.rateUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    return RateModel.fromJson(jsonDecode(response.body));
  }

  Future<ConversationModel> conversationUpdate(
    String token, {
    required int conversationId,
    int? endConversationId = -1,
    int rateId = 0,
  }) async {
    final response = await http.put(
        Uri.parse('${ApiConstant.instance.conversationUrl}/$conversationId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'end_conversation': endConversationId.toString(),
          'rate_id': rateId.toString(),
        });

    return ConversationModel.fromJson(jsonDecode(response.body));
  }
}
