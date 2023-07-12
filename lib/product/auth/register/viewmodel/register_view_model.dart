// ignore_for_file: use_build_context_synchronously

import 'package:chatbot/product/auth/register/service/register_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/enum/preference_keys.dart';
import '../../../../core/utils/page_transition.dart';
import '../../language/view/native_language_view.dart';

class RegisterViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();

  RegisterService service = RegisterService();

  GlobalKey<FormState> registerFormKey = GlobalKey();

  bool isObscure = true;
  bool isActivePage = false;
  bool termsValue = false;
  bool errorTerms = false;

  checkErrorTerms(bool value) {
    errorTerms = value;
    notifyListeners();
  }

  checkTermsValue(bool value) {
    termsValue = value;
    notifyListeners();
  }

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

  Future register(Map<String, dynamic> user, BuildContext context) async {
    final response = await service.register(user);

    final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;

    if (response.result == true) {
      await prefs.setString(
          PreferencesKeys.TOKEN.toString(), response.data!.token!);

      Navigator.pushAndRemoveUntil(
          context,
          createRoute(
            page: NativeLanguageView(),
          ),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.validationError!.email![0]),
        ),
      );
    }
  }
}
