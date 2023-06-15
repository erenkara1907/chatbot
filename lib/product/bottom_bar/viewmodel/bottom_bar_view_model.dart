import 'package:chatbot/product/conversation/view/conversation_view.dart';
import 'package:chatbot/product/profile/view/profile_view.dart';
import 'package:flutter/material.dart';

import '../../home/view/home_view.dart';

class BottomBarViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  changeSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  List<Widget> views = [
    const HomeView(),
    ConversationView(),
    ProfileView(),
  ];
}
