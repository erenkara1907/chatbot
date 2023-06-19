// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:chatbot/core/utils/page_transition.dart';
import 'package:chatbot/product/auth/login/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/enum/preference_keys.dart';
import '../../../bottom_bar/view/bottom_bar_view.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  GlobalKey<FormState> loginFormKey = GlobalKey();

  LoginService service = LoginService();

  bool isObscure = true;
  bool isActivePage = false;

  setActivePage() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        isActivePage = true;
        notifyListeners();
      },
    );
  }

  startFocusNode() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }

  changeObscureText() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future login(Map<String, dynamic> user, BuildContext context) async {
    final response = await service.login(user);

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    if (response.result == true) {
      await prefs.setString(
          PreferencesKeys.TOKEN.toString(), response.data!.token!);

      Navigator.pushAndRemoveUntil(
          context, createRoute(page: BottomBarView()), (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong email or password')),
      );
    }
  }
}
