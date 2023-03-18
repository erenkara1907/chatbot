import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  GlobalKey<FormState> registerFormKey = GlobalKey();

  bool isObscure = true;

  startFocusNode() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }

  changeObscureText() {
    isObscure = !isObscure;
    notifyListeners();
  }
}
