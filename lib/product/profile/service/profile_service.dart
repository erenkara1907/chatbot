import 'dart:convert';
import 'dart:io';

import 'package:chatbot/product/profile/model/avatar_model.dart';
import 'package:chatbot/product/profile/model/profile_model.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constant.dart';

class ProfileService {
  Future<ProfileModel> getProfileInfo(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.profilUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    return ProfileModel.fromJson(jsonDecode(response.body));
  }

  Future<AvatarModel> getAvatars(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.avatarUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    return AvatarModel.fromJson(jsonDecode(response.body));
  }

  Future<ProfileModel> uploadFile(String token, File file) async {
    final req = http.MultipartRequest(
        "POST", Uri.parse(ApiConstant.instance.profilUrl));
    req.headers.addAll(
        {"Accept": "application/json", "Authorization": "Bearer $token"});
    req.files.add(http.MultipartFile(
      'profile_photo',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path.split('/').last,
    ));

    var res = await req.send();
    var response = await http.Response.fromStream(res);

    return ProfileModel.fromJson(jsonDecode(response.body));
  }

  Future<ProfileModel> updateProfile(
      String token, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.profilUrl),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: body,
    );

    return ProfileModel.fromJson(jsonDecode(response.body));
  }
}
