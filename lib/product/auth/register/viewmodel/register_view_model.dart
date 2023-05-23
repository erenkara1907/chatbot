import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();

  GlobalKey<FormState> registerFormKey = GlobalKey();

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
    nameFocusNode.unfocus();
  }

  changeObscureText() {
    isObscure = !isObscure;
    notifyListeners();
  }
}
