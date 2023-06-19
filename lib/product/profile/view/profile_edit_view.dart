// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, use_build_context_synchronously, deprecated_member_use

import 'dart:ui';

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_state.dart';
import 'package:chatbot/core/view/widget/button/avatar_button.dart';
import 'package:chatbot/product/bottom_bar/view/bottom_bar_view.dart';
import 'package:chatbot/product/profile/viewmodel/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/icon_constant.dart';
import '../../../core/constants/image_constant.dart';
import '../../../core/view/widget/button/language_button.dart';
import '../../../core/view/widget/button/profile_button.dart';
import '../../../core/view/widget/formfield/app_form_field.dart';
import '../model/avatar_model.dart';

class ProfileEditView extends StatefulWidget {
  final String email;
  final String name;
  final String profilePhoto;
  final List<Avatars> avatars;
  final int nativeLanguageId;
  final String nativeLanguage;
  final Color profileBackgroundColor;

  const ProfileEditView({
    Key? key,
    required this.email,
    required this.name,
    required this.profilePhoto,
    required this.avatars,
    required this.nativeLanguageId,
    required this.nativeLanguage,
    required this.profileBackgroundColor,
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
      backgroundColor: ColorConstant.instance.paletteBackground,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              ImageConstant.instance.imageTopEllipse,
              width: width(1.0),
              fit: BoxFit.cover,
            ),
          ),
          profileEdit(),
        ],
      ),
    );
  }

  Consumer<ProfileViewModel> profileEdit() {
    return Consumer<ProfileViewModel>(
      builder: (context, state, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            height: height(0.9),
            child: Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      backButton(context),
                      Text(
                        LocaleKeys.personal_information.tr(),
                        style: currentTextTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.instance.additionalWhite,
                        ),
                      ),
                      saveButton(context),
                    ],
                  ),
                  const SizedBox(height: 40.0),
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
                              ? Hero(
                                  tag: "profilePhoto",
                                  child: Container(
                                    width: 60.0,
                                    height: 60.0,
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: widget.profileBackgroundColor,
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(widget.profilePhoto),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 60.0,
                                  height: 60.0,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color:
                                        const Color.fromRGBO(221, 212, 251, 1),
                                    image: DecorationImage(
                                      image: NetworkImage(viewModel.avatarUrl),
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
                                color: const Color.fromRGBO(221, 212, 251, 1),
                                image: DecorationImage(
                                  image: MemoryImage(state.bytes!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
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
                                Provider.of<ProfileViewModel>(context,
                                        listen: false)
                                    .setPhotoLoaded();
                                viewModel.isSelectAvatar = true;
                                viewModel.selectedAvatarId =
                                    widget.avatars[index].id! + 1;
                                viewModel.avatarUrl =
                                    widget.avatars[index].url!;
                                viewModel.selectedAvatarIndex = index;
                                // }
                              },
                              child: AvatarButton(
                                image: widget.avatars[index].url!,
                                padding: const EdgeInsets.all(0.0),
                                avatarId: widget.avatars[index].id!,
                                selectedIndex: viewModel.selectedAvatarIndex,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: Form(
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
                  ),
                  const SizedBox(height: 15.0),
                  ProfileButton(
                    onTap: () {
                      showModalBottomSheet(
                        isDismissible: false,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Consumer<ProfileViewModel>(
                              builder: (context, state, child) {
                                return FractionallySizedBox(
                                  heightFactor: 0.8,
                                  child: languages(context),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    image: IconConstant.instance.iconLanguage,
                    text: LocaleKeys.language.tr(),
                    isEnglish: true,
                    isDivider: false,
                    language: viewModel.selectedLanguage == ""
                        ? widget.nativeLanguage
                        : viewModel.selectedLanguage,
                  ),
                  Divider(
                    thickness: 1.0,
                    color: ColorConstant.instance.paletteGrey,
                  ),
                  const SizedBox(height: 24.0),
                  TextButton(
                    onPressed: () {
                      viewModel.deleteAccount(context);
                    },
                    child: Text(
                      LocaleKeys.delete_account.tr(),
                      style: currentTextTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.instance.additionalRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TextButton saveButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        Provider.of<ProfileViewModel>(context, listen: false).setUpdating();
        await viewModel.updateProfile(
          context,
          viewModel.passwordController.text.isNotEmpty
              ? viewModel.selectedAvatarId == -1
                  ? {
                      'name': viewModel.nameController.text,
                      'password': viewModel.passwordController.text,
                      'native_language_code': viewModel.selectedLanguageCode
                    }
                  : {
                      'avatar_id': viewModel.selectedAvatarId.toString(),
                      'name': viewModel.nameController.text,
                      'password': viewModel.passwordController.text,
                      'native_language_code': viewModel.selectedLanguageCode
                    }
              : viewModel.selectedAvatarId == -1
                  ? {
                      'name': viewModel.nameController.text,
                      'native_language_code': viewModel.selectedLanguageCode
                    }
                  : {
                      'avatar_id': viewModel.selectedAvatarId.toString(),
                      'name': viewModel.nameController.text,
                      'native_language_code': viewModel.selectedLanguageCode
                    },
        );

        Provider.of<ProfileViewModel>(context, listen: false).setUpdating();
      },
      child: Consumer<ProfileViewModel>(
        builder: (context, state, child) {
          if (state.isUpdating) {
            return Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  color: ColorConstant.instance.paletteBlue,
                ),
              ),
            );
          } else {
            return Text(
              'Save',
              style: currentTextTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: ColorConstant.instance.paletteBlue,
                fontSize: 14.0,
              ),
            );
          }
        },
      ),
    );
  }

  Container backButton(BuildContext context) {
    return Container(
      width: 25.0,
      height: 25.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: ColorConstant.instance.paletteGrey),
      ),
      child: IconButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomBarView()));
        },
        icon: SvgPicture.asset(
          IconConstant.instance.iconArrowBack,
          color: ColorConstant.instance.paletteGrey,
          width: 25.0,
          height: 25.0,
        ),
      ),
    );
  }

  SingleChildScrollView languages(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        width: width(1.0),
        decoration: BoxDecoration(
          color: ColorConstant.instance.paletteBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Image.asset(
                ImageConstant.instance.imageBottomEllipse,
                width: width(1.0),
                fit: BoxFit.cover,
              ),
            ),
            languageModal(context),
          ],
        ),
      ),
    );
  }

  Padding languageModal(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15.0),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    color: ColorConstant.instance.backIconColor,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.close,
                    size: 15.0,
                    color: ColorConstant.instance.backIconColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            LocaleKeys.all_lang.tr(),
            style: currentTextTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorConstant.instance.additionalWhite,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: viewModel.languages.length,
            itemBuilder: (context, index) {
              return Consumer<ProfileViewModel>(
                builder: (context, state, child) {
                  return Column(
                    children: [
                      LanguageButton(
                        image: viewModel.languages[index].flag.toString(),
                        languageId: index + 1,
                        selectedIndex: state.selectedIndex,
                        onTap: () {
                          viewModel.selectedLanguageId =
                              viewModel.languages[index].id!;
                          viewModel.selectedLanguageCode =
                              viewModel.languages[index].code!;

                          state.changeCheckboxStatus(index: index);
                          state.changeBottomSheet(true);

                          viewModel.selectedLanguage =
                              viewModel.languages[index].title.toString();
                          Navigator.pop(context);
                        },
                        widthValue: width(1.0),
                        heightValue: height(0.07),
                        backgroundColor: Colors.transparent,
                        borderRadius: 66.0,
                        text: viewModel.languages[index].title.toString(),
                        textStyle: currentTextTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.instance.greyScale900) ??
                            const TextStyle(),
                        onChangedCheckBox: (_) {
                          viewModel.selectedLanguageId =
                              viewModel.languages[index].id!;
                          viewModel.selectedLanguageCode =
                              viewModel.languages[index].code!;

                          state.changeCheckboxStatus(index: index);
                          state.changeBottomSheet(true);

                          viewModel.selectedLanguage =
                              viewModel.languages[index].title.toString();
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 15.0),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 30.0),
        ],
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
              style: currentTextTheme.displayLarge?.copyWith(
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
