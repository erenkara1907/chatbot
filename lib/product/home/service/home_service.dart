import 'dart:convert';

import 'package:chatbot/core/constants/api_constant.dart';
import 'package:chatbot/product/home/model/category_model.dart';
import 'package:chatbot/product/home/model/profile_home_model.dart';
import 'package:chatbot/product/home/model/scenario_model.dart';
import 'package:chatbot/product/home/model/topic_model.dart';
import 'package:chatbot/product/profile/model/profile_model.dart';
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

  Future<ScenarioModel> getAllScenarios(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.scenarioUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    return ScenarioModel.fromJson(jsonDecode(response.body));
  }

  Future<CategoryModel> getAllCategories(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.categoryUrl), headers: {
      'Authorization': 'Bearer $token',
    });


    return CategoryModel.fromJson(jsonDecode(response.body));
  }

  Future<ProfileModel> updateProfile(
      String token, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.profilUrl),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: body,
    );

    return ProfileModel.fromJson(jsonDecode(response.body));
  }
}
