import 'dart:convert';

import 'package:chatbot/core/constants/api_constant.dart';
import 'package:chatbot/product/conversation/model/conversation_message_send_model.dart';
import 'package:chatbot/product/conversation/model/conversation_model.dart';
import 'package:chatbot/product/conversation/model/conversation_room_model.dart';
import 'package:chatbot/product/conversation/model/conversation_store_model.dart';
import 'package:chatbot/product/conversation/model/translate_model.dart';
import 'package:http/http.dart' as http;

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
      {required String topicId}) async {
    final response = await http
        .post(Uri.parse(ApiConstant.instance.conversationUrl), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'topic_id': topicId,
    });

    print('conversation: ${response.body}');

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

  Future<ConversationMessageSendModel> sendMessage(String token,
      {required String message, required int conversationId}) async {
    final response = await http.post(
        Uri.parse(
            '${ApiConstant.instance.conversationUrl}/$conversationId/message'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'message': message,
        });

    return ConversationMessageSendModel.fromJson(jsonDecode(response.body));
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
    required int endConversationId,
    required int rateId,
  }) async {
    final response = await http.put(
        Uri.parse('${ApiConstant.instance.conversationUrl}/$conversationId'),
        headers: {
          'Authorization': 'Bearer $token',
        });

    return ConversationModel.fromJson(jsonDecode(response.body));
  }
}
