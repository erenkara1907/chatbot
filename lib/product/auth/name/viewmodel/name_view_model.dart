import 'package:flutter/material.dart';

class NameViewModel extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();

  GlobalKey<FormState> nameFormKey = GlobalKey();

  startFocusNode() {
    nameFocusNode.unfocus();
  }
}
