// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:chatbot/product/auth/forgot_password/model/forgot_password_model.dart';
import 'package:chatbot/product/auth/forgot_password/model/pin_code_model.dart';
import 'package:chatbot/product/auth/forgot_password/model/reset_password_model.dart';
import 'package:chatbot/product/auth/forgot_password/service/forgot_password_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/enum/preference_keys.dart';
import '../../../../core/utils/page_transition.dart';
import '../../login/view/login_view.dart';
import '../view/password_view.dart';
import '../view/pin_code_view.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  ForgotPasswordService service = ForgotPasswordService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode rePasswordFocusNode = FocusNode();

  bool isObscure = true;
  bool isReObscure = true;

  changeObscureText() {
    isObscure = !isObscure;
    notifyListeners();
  }

  changeReObscureText() {
    isReObscure = !isReObscure;
    notifyListeners();
  }

  Future forgotPasswordAPI(String email, BuildContext context,
      {bool isPinView = false}) async {
    final response =
        await service.forgotPassword(ForgotPasswordModel(email: email));

    if (response.result!) {
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      await prefs.setString(PreferencesKeys.EMAIL.toString(), email);
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          message: "Please check your e-mail address",
        ),
        displayDuration: const Duration(milliseconds: 100),
      );
      isPinView
          ? null
          : Future.delayed(
              const Duration(milliseconds: 600),
              () {
                Navigator.push(
                  context,
                  createRoute(
                    page: PinCodeView(),
                  ),
                );
              },
            );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: response.validationError!.email![0],
        ),
        displayDuration: const Duration(milliseconds: 100),
      );
    }
  }

  Future verifyResetTokenAPI(String code, BuildContext context) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String email = prefs.getString(PreferencesKeys.EMAIL.toString())!;
    final response =
        await service.verifyResetToken(PinCodeModel(email: email, code: code));

    if (response.result!) {
      Navigator.push(
        context,
        createRoute(
          page: PasswordView(),
        ),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: response.errorMessage!,
        ),
        displayDuration: const Duration(milliseconds: 100),
      );
    }
  }

  Future resetPasswordAPI(String password, BuildContext context) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String email = prefs.getString(PreferencesKeys.EMAIL.toString())!;
    final response = await service.resetPassword(
      ResetPasswordModel(email: email, password: password),
    );

    if (response.result!) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Your password has been successfully reset",
        ),
        displayDuration: const Duration(milliseconds: 100),
      );
      Future.delayed(
        const Duration(milliseconds: 600),
        () {
          Navigator.pushReplacement(context, createRoute(page: LoginView()));
        },
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: response.errorMessage!,
        ),
        displayDuration: const Duration(milliseconds: 100),
      );
    }
  }
}
