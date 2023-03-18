import 'dart:convert';

import 'package:chatbot/core/constants/api_constant.dart';
import 'package:chatbot/product/auth/language/model/language_level_model.dart';
import 'package:chatbot/product/auth/language/model/language_model.dart';
import 'package:http/http.dart' as http;

class LanguageService {
  Future<LanguageModel> getLanguages() async {
    final response = await http.get(
      Uri.parse(ApiConstant.instance.languageInfoUrl),
    );

    return LanguageModel.fromJson(jsonDecode(response.body));
  }

  Future<LanguageLevelModel> getLanguageLevels() async {
    final response = await http.get(
      Uri.parse(ApiConstant.instance.languageLevelsUrl),
    );

    return LanguageLevelModel.fromJson(jsonDecode(response.body));
  }
}
