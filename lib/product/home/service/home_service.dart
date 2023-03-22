import 'dart:convert';

import 'package:chatbot/core/constants/api_constant.dart';
import 'package:chatbot/product/home/model/profile_home_model.dart';
import 'package:chatbot/product/home/model/topic_model.dart';
import 'package:http/http.dart' as http;

class HomeService {
  Future<TopicModel> getTopics() async {
    final response = await http.get(
      Uri.parse(ApiConstant.instance.topicsUrl),
    );

    return TopicModel.fromJson(jsonDecode(response.body));
  }

  Future<ProfileHomeModel> getProfileInfo(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.profilUrl), headers: {
      'Authorization': 'Bearer $token',
    });



    return ProfileHomeModel.fromJson(jsonDecode(response.body));
  }
}
