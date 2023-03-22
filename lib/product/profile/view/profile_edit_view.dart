// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:io';

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/core/view/widget/button/avatar_button.dart';
import 'package:chatbot/product/bottom_bar/view/bottom_bar_view.dart';
import 'package:chatbot/product/profile/viewmodel/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/view/widget/button/profile_button.dart';
import '../../../core/view/widget/formfield/app_form_field.dart';
import '../../auth/language/model/language_model.dart';
import '../model/avatar_model.dart';

class ProfileEditView extends StatefulWidget {
  final String email;
  final String name;
  final String profilePhoto;
  final List<Avatars> avatars;
  final int nativeLanguageId;
  final List<Languages> languages;

  const ProfileEditView({
    Key? key,
    required this.email,
    required this.name,
    required this.profilePhoto,
    required this.avatars,
    required this.nativeLanguageId,
    required this.languages,
  }) : super(key: key);
  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends BaseState<ProfileEditView> {
  ProfileViewModel viewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.nameController.text = widget.name;
    viewModel.emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.instance.additionalWhite,
      appBar: AppBar(
        toolbarHeight: 40.0,
        leadingWidth: 50.0,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              viewModel.isSelectAvatar
                  ? await viewModel.updateProfile(
                      context,
                      viewModel.selectedAvatarId == -1
                          ? viewModel.passwordController.text.isNotEmpty
                              ? {
                                  'name': viewModel.nameController.text,
                                  'password': viewModel.passwordController.text,
                                  'native_language_id':
                                      viewModel.selectedLanguageId == -1
                                          ? widget.nativeLanguageId.toString()
                                          : viewModel.selectedLanguageId
                                              .toString(),
                                }
                              : {
                                  'name': viewModel.nameController.text,
                                  'native_language_id':
                                      viewModel.selectedLanguageId == -1
                                          ? widget.nativeLanguageId.toString()
                                          : viewModel.selectedLanguageId
                                              .toString(),
                                }
                          : viewModel.passwordController.text.isNotEmpty
                              ? {
                                  'avatar_id': viewModel.selectedAvatarId
                                      .toString()
                                      .toString(),
                                  'name': viewModel.nameController.text,
                                  'password': viewModel.passwordController.text,
                                  'native_language_id':
                                      viewModel.selectedLanguageId == -1
                                          ? widget.nativeLanguageId.toString()
                                          : viewModel.selectedLanguageId
                                              .toString(),
                                }
                              : {
                                  'avatar_id': viewModel.selectedAvatarId
                                      .toString()
                                      .toString(),
                                  'name': viewModel.nameController.text,
                                  'native_language_id':
                                      viewModel.selectedLanguageId == -1
                                          ? widget.nativeLanguageId.toString()
                                          : viewModel.selectedLanguageId
                                              .toString(),
                                },
                    )
                  : await viewModel.uploadFile(context);
            },
            child: Text(
              'Save',
              style: currentTextTheme.headline4?.copyWith(
                fontWeight: FontWeight.w400,
                color: ColorConstant.instance.additionalGreen,
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: ColorConstant.instance.greyScale100),
            child: Center(
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => BottomBarView()));
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorConstant.instance.greyScale900,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          LocaleKeys.personal_information.tr(),
          style: currentTextTheme.headline3?.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorConstant.instance.greyScale900,
          ),
        ),
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, state, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Stack(
                children: [
                  SizedBox(
                    height: height(0.9),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorConstant.instance.greyScale300,
                                    blurRadius: 10.0,
                                    spreadRadius: 1.0,
                                    offset: const Offset(3, 3),
                                  )
                                ],
                                color: ColorConstant.instance.additionalWhite,
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                  width: 1.0,
                                  color: ColorConstant.instance.additionalWhite,
                                )),
                            child: state.isPhotoLoaded
                                ? viewModel.selectedAvatarId == -1
                                    ? Container(
                                        width: 60.0,
                                        height: 60.0,
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color: const Color.fromRGBO(
                                              221, 212, 251, 1),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                widget.profilePhoto),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 60.0,
                                        height: 60.0,
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color: const Color.fromRGBO(
                                              221, 212, 251, 1),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                viewModel.avatarUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                : Container(
                                    width: 60.0,
                                    height: 60.0,
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: const Color.fromRGBO(
                                          221, 212, 251, 1),
                                      image: DecorationImage(
                                        image: MemoryImage(state.bytes!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        SizedBox(
                          height: 60.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.avatars.length,
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  onTap: () async {
                                    if (widget.avatars[index].id == 1) {
                                      viewModel.isSelectAvatar = false;
                                      await state.pickImage(context);
                                      viewModel.imageFile =
                                          File(state.image!.path);
                                    } else {
                                      state.selectAvatar();
                                      viewModel.selectedAvatarId =
                                          widget.avatars[index].id!;
                                      viewModel.avatarUrl =
                                          widget.avatars[index].url!;
                                      viewModel.selectedAvatarIndex = index;
                                    }
                                  },
                                  child: AvatarButton(
                                    color: Color.fromRGBO(
                                      widget.avatars[index].color![0],
                                      widget.avatars[index].color![1],
                                      widget.avatars[index].color![2],
                                      1,
                                    ),
                                    image: widget.avatars[index].url!,
                                    padding: widget.avatars[index].id == 1
                                        ? const EdgeInsets.all(15.0)
                                        : const EdgeInsets.all(5.0),
                                    avatarId: widget.avatars[index].id!,
                                    selectedIndex:
                                        viewModel.selectedAvatarIndex,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          color: ColorConstant.instance.greyScale200,
                        ),
                        const SizedBox(height: 20.0),
                        Form(
                          child: Column(
                            children: [
                              AppFormField(
                                heightValue: height(0.07),
                                controller: viewModel.nameController,
                                focusNode: viewModel.nameFocusNode,
                                isPrefix: false,
                                hintText: LocaleKeys.name.tr(),
                              ),
                              const SizedBox(height: 15.0),
                              AppFormField(
                                enabled: true,
                                heightValue: height(0.07),
                                controller: viewModel.emailController,
                                focusNode: viewModel.emailFocusNode,
                                isPrefix: false,
                                hintText: LocaleKeys.email.tr(),
                              ),
                              const SizedBox(height: 15.0),
                              AppFormField(
                                heightValue: height(0.07),
                                controller: viewModel.passwordController,
                                focusNode: viewModel.passwordFocusNode,
                                isPrefix: false,
                                hintText: LocaleKeys.password.tr(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Divider(
                          thickness: 1.0,
                          color: ColorConstant.instance.greyScale200,
                        ),
                        const SizedBox(height: 15.0),
                        ProfileButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                double width =
                                    MediaQuery.of(context).size.width;
                                double height =
                                    MediaQuery.of(context).size.height;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 90.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                245, 245, 245, 0.7),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: ListView.builder(
                                            physics:
                                                const ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            addAutomaticKeepAlives: false,
                                            addRepaintBoundaries: false,
                                            itemCount: widget.languages.length,
                                            itemBuilder: (context, index) {
                                              return Material(
                                                child: InkWell(
                                                  onTap: () {
                                                    viewModel
                                                            .selectedLanguageId =
                                                        widget.languages[index]
                                                            .id!;

                                                    Navigator.pop(context);
                                                  },
                                                  child: selectLanguageButton(
                                                    context,
                                                    width,
                                                    height,
                                                    text: widget
                                                        .languages[index]
                                                        .title!,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          widget.languages[index]
                                                                      .id ==
                                                                  1
                                                              ? 10.0
                                                              : 0.0),
                                                      topRight: Radius.circular(
                                                          widget.languages[index]
                                                                      .id ==
                                                                  1
                                                              ? 10.0
                                                              : 0.0),
                                                      bottomLeft:
                                                          Radius.circular(widget
                                                                      .languages[
                                                                          index]
                                                                      .id ==
                                                                  14
                                                              ? 10.0
                                                              : 0.0),
                                                      bottomRight:
                                                          Radius.circular(widget
                                                                      .languages[
                                                                          index]
                                                                      .id ==
                                                                  14
                                                              ? 10.0
                                                              : 0.0),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0.0,
                                        right: 0.0,
                                        bottom: 20.0,
                                        child: SizedBox(
                                          height: height * 0.07,
                                          width: width - 16.0,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: ColorConstant
                                                    .instance.additionalWhite,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                )),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              LocaleKeys.cancel.tr(),
                                              style: currentTextTheme.headline1
                                                  ?.copyWith(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600,
                                                color: ColorConstant
                                                    .instance.greyScale900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          image: IconConstant.instance.iconLanguage,
                          text: LocaleKeys.language.tr(),
                          isEnglish: true,
                          isDivider: false,
                        ),
                        Divider(
                          thickness: 1.0,
                          color: ColorConstant.instance.greyScale200,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    left: 0.0,
                    right: 0.0,
                    child: TextButton(
                      onPressed: () {
                        viewModel.deleteAccount(context);
                      },
                      child: Text(
                        LocaleKeys.delete_account.tr(),
                        style: currentTextTheme.headline4?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.instance.additionalRed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Stack selectLanguageButton(
    BuildContext context,
    double width,
    double height, {
    required String text,
    BorderRadiusGeometry? borderRadius,
    void Function()? onTap,
  }) {
    return Stack(
      children: [
        SizedBox(
          width: width - 16.0,
          height: height * 0.07,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(60, 60, 67, 0.36),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ??
                      const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                )),
            onPressed: onTap ?? () {},
            child: const Center(),
          ),
        ),
        Container(
          width: width - 16.0,
          height: height * 0.07,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 245, 245, 0.7),
            borderRadius: borderRadius ??
                const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
          ),
          child: Center(
            child: Text(
              text,
              style: currentTextTheme.headline1?.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: ColorConstant.instance.greyScale900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
