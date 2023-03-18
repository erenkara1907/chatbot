import 'dart:convert';

import 'package:chatbot/core/constants/api_constant.dart';
import 'package:http/http.dart' as http;

import '../model/register_model.dart';

class RegisterService {
  Future<RegisterModel> register(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.registerUrl),
      body: user,
    );

    return RegisterModel.fromJson(jsonDecode(response.body));
  }  
}
