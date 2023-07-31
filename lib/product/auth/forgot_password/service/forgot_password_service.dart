import 'dart:convert';

import 'package:chatbot/product/auth/forgot_password/model/forgot_password_model.dart';
import 'package:chatbot/product/auth/forgot_password/model/pin_code_model.dart';
import 'package:chatbot/product/auth/forgot_password/model/reset_password_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constant.dart';

class ForgotPasswordService {
  Future<ForgotPasswordModel> forgotPassword(ForgotPasswordModel model) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.forgotPassword),
      body: model.toJson(),
    );

    return ForgotPasswordModel.fromJson(jsonDecode(response.body));
  }

  Future<PinCodeModel> verifyResetToken(PinCodeModel model) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.verifyResetToken),
      body: model.toJson(),
    );

    return PinCodeModel.fromJson(jsonDecode(response.body));
  }

  Future<ResetPasswordModel> resetPassword(ResetPasswordModel model) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.resetPassword),
      body: model.toJson(),
    );

    return ResetPasswordModel.fromJson(jsonDecode(response.body));
  }
}
