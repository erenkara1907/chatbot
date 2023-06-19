import 'dart:convert';

import 'package:chatbot/product/auth/login/model/login_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constant.dart';

class LoginService {
  Future<LoginModel> login(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.loginUrl),
      body: user,
    );


    return LoginModel.fromJson(jsonDecode(response.body));
  }
}
