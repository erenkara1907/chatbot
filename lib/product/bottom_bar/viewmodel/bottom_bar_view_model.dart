import 'package:chatbot/product/conversation/view/conversation_view.dart';
import 'package:chatbot/product/home/view/new_home_view.dart';
import 'package:chatbot/product/profile/view/profile_view.dart';
import 'package:flutter/material.dart';

class BottomBarViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  changeSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  List<Widget> views = [
    const NewHomeView(),
    ConversationView(),
    ProfileView(),
  ];
}
