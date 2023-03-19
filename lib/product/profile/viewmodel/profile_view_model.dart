// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:chatbot/product/auth/language/service/language_service.dart';
import 'package:chatbot/product/bottom_bar/view/bottom_bar_view.dart';
import 'package:chatbot/product/profile/model/profile_model.dart';
import 'package:chatbot/product/profile/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/enum/preference_keys.dart';
import '../../auth/language/model/language_level_model.dart';
import '../../auth/language/model/language_model.dart';
import '../model/avatar_model.dart';

class ProfileViewModel extends ChangeNotifier {
  GlobalKey<FormState> profileGlobalKey = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();

  ProfileModel profileModel = ProfileModel();
  List<Avatars> avatars = [];

  ProfileService service = ProfileService();
  LanguageService languageService = LanguageService();

  bool isLanguageLevelBottomSheet = false;

  int selectedIndex = -1;
  int selectedPopularIndex = -1;
  int selectedLevelIndex = -1;

  int selectedLanguageId = -1;
  int selectedPopularLanguageId = -1;

  int selectedLearnIndex = -1;
  int selectedLearnPopularIndex = -1;
  int selectedLearnLevelIndex = -1;

  int selectedLearnLanguageId = -1;
  int selectedLearnPopularLanguageId = -1;
  int selectedLanguageLevelId = -1;

  String avatarUrl = '';

  List<Languages> languages = [];
  List<Languages> searchLanguages = [];
  List<String> popularLanguageTitles = [];
  List<String> popularLanguageImages = [];
  List<int> popularLanguageIds = [];
  List<LanguageProficiencyLevels> languageLevels = [];

  XFile? image;
  Uint8List? bytes;
  File? imageFile;

  bool isPhotoLoaded = true;
  bool switchState = true;

  bool isSelectAvatar = true;
  int selectedAvatarId = -1;

  final ImagePicker _picker = ImagePicker();

  selectAvatar() {
    isSelectAvatar = true;
    notifyListeners();
  }

  // Pick an image
  Future pickImage(BuildContext context) async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    bytes = await xFileToImage(image!);

    imageFile = File(image!.path);

    if (bytes != null) {
      isPhotoLoaded = false;
    }
    notifyListeners();
  }

  Future<Uint8List> xFileToImage(XFile xFile) async {
    final path = xFile.path;
    final bytes = await File(path).readAsBytes();
    return bytes;
  }

  Future uploadFile(BuildContext context) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await service.uploadFile(token, imageFile!);

    if (response.result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil fotoğrafı başarıyla güncellendi'),
        ),
      );
      await service.updateProfile(
        token,
        {
          // 'avatar_id': response.id.toString(),
        },
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fotoğraf Yüklenemedi")));
    }

    notifyListeners();
  }

  Future updateProfile(BuildContext context, Map<String, dynamic> user) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final response = await service.updateProfile(
      token,
      user,
    );

    if (response.result == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomBarView()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Başarısız")));
    }

    notifyListeners();
  }

  changeSwitch() {
    switchState = !switchState;
    notifyListeners();
  }

  changeBottomSheet(bool status) {
    isLanguageLevelBottomSheet = status;
    notifyListeners();
  }

  startFocusNode() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    nameFocusNode.unfocus();
  }

  Future getProfileInfo() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    String token = prefs.getString(PreferencesKeys.TOKEN.toString())!;

    final profileResponse = await service.getProfileInfo(token);
    await getLanguages();
    await getAvatars(token);
    await getLanguageLevels();

    if (profileResponse.result == true) {
      profileModel = profileResponse;
    }
  }

  Future getLanguages() async {
    final model = await languageService.getLanguages();

    if (model.result == true) {
      for (var i = 0; i < model.data!.languages!.length; i++) {
        if (model.data!.languages![i].isPopular == 1) {
          popularLanguageTitles.add(model.data!.languages![i].title!);
          popularLanguageIds.add(model.data!.languages![i].id!);
          popularLanguageImages.add(model.data!.languages![i].flag!);
        } else {
          languages = model.data!.languages!;
        }
      }
    }
  }

  Future getLanguageLevels() async {
    final model = await languageService.getLanguageLevels();

    if (model.result == true) {
      languageLevels = model.data!.languageProficiencyLevels!;
    }
  }

  Future getAvatars(String token) async {
    final response = await service.getAvatars(token);

    if (response.result == true) {
      avatars = response.data!.avatars!;
    }
  }

  Future blankService() async {}

  changeCheckboxStatus({required int index}) {
    selectedPopularIndex = -1;
    selectedIndex = index;
    notifyListeners();
  }

  changeCheckboxStatusPopular({required int index}) {
    selectedIndex = -1;
    selectedPopularIndex = index;
    notifyListeners();
  }

  changeCheckboxLearnStatus({required int index}) {
    selectedLearnPopularIndex = -1;
    selectedLearnIndex = index;
    notifyListeners();
  }

  changeCheckboxLearnStatusPopular({required int index}) {
    selectedLearnIndex = -1;
    selectedLearnPopularIndex = index;
    notifyListeners();
  }

  changeCheckboxStatusLevels({required int index}) {
    selectedIndex = -1;
    selectedPopularIndex = -1;
    selectedLevelIndex = index;
    notifyListeners();
  }
}
