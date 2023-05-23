// ignore_for_file: use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, must_be_immutable, use_build_context_synchronously

import 'package:chatbot/core/constants/color_constant.dart';
import 'package:chatbot/core/constants/icon_constant.dart';
import 'package:chatbot/core/enum/preference_keys.dart';
import 'package:chatbot/core/language/locale_keys.g.dart';
import 'package:chatbot/core/view/base/base_stateless.dart';
import 'package:chatbot/core/view/widget/button/profile_button.dart';
import 'package:chatbot/product/auth/login/view/login_view.dart';
import 'package:chatbot/product/bottom_bar/viewmodel/bottom_bar_view_model.dart';
import 'package:chatbot/product/profile/view/profile_edit_view.dart';
import 'package:chatbot/product/profile/viewmodel/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';

class ProfileView extends BaseStateless {
  ProfileViewModel viewModel = ProfileViewModel();
  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileViewModel>(context, listen: false).setActivePage();
    return Scaffold(
      backgroundColor: ColorConstant.instance.additionalWhite,
      body: FutureBuilder(
        future: viewModel.getProfileInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      width: 80.0,
                      height: 80.0,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SkeletonParagraph(
                      style: const SkeletonParagraphStyle(
                        lines: 1,
                        lineStyle: SkeletonLineStyle(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: ColorConstant.instance.greyScale300,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                    width: 35.0,
                                    height: 35.0,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: SkeletonParagraph(
                                  style: const SkeletonParagraphStyle(
                                    lines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Consumer<ProfileViewModel>(
                            builder: (context, state, child) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                width: state.isActivePage ? 100.0 : 50.0,
                                height: state.isActivePage ? 100.0 : 50.0,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            ColorConstant.instance.greyScale300,
                                        blurRadius: 10.0,
                                        spreadRadius: 1.0,
                                        offset: const Offset(3, 3),
                                      )
                                    ],
                                    color:
                                        ColorConstant.instance.additionalWhite,
                                    borderRadius: BorderRadius.circular(50.0),
                                    border: Border.all(
                                      width: 1.0,
                                      color: ColorConstant
                                          .instance.additionalWhite,
                                    )),
                                child: Container(
                                  width: 80.0,
                                  height: 80.0,
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Color.fromRGBO(
                                      viewModel
                                          .profileModel.data!.user!.color![0],
                                      viewModel
                                          .profileModel.data!.user!.color![1],
                                      viewModel
                                          .profileModel.data!.user!.color![2],
                                      1,
                                    ),
                                  ),
                                  child: Hero(
                                    tag: "profilePhoto",
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        image: DecorationImage(
                                          image: NetworkImage(viewModel
                                              .profileModel
                                              .data!
                                              .user!
                                              .profilePhoto!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                      const SizedBox(height: 12.0),
                      Text(
                        viewModel.profileModel.data!.user!.name!,
                        style: currentTextTheme(context).headline3?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.instance.greyScale900,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Consumer<ProfileViewModel>(
                    builder: (context, state, child) {
                      return AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                            horizontal: state.isActivePage ? 24.0 : 0.0),
                        child: Column(
                          children: [
                            ProfileButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEditView(
                                      nativeLanguageId: viewModel.profileModel
                                          .data!.user!.nativeLanguage!.id!,
                                      avatars: viewModel.avatars,
                                      profilePhoto: viewModel.profileModel.data!
                                          .user!.profilePhoto!,
                                      nativeLanguage: viewModel.profileModel
                                          .data!.user!.nativeLanguage!.title!,
                                      email: viewModel
                                          .profileModel.data!.user!.email!,
                                      name: viewModel
                                          .profileModel.data!.user!.name!,
                                      profileBackgroundColor: Color.fromRGBO(
                                        viewModel
                                            .profileModel.data!.user!.color![0],
                                        viewModel
                                            .profileModel.data!.user!.color![1],
                                        viewModel
                                            .profileModel.data!.user!.color![2],
                                        1,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              image: IconConstant.instance.iconPerson,
                              text: LocaleKeys.personal_information.tr(),
                            ),
                            ProfileButton(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width(
                                                context: context, value: 1.0),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 28.0,
                                              horizontal: 30.0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              color: ColorConstant
                                                  .instance.additionalWhite,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  IconConstant
                                                      .instance.iconStar,
                                                  width: 55.0,
                                                  height: 55.0,
                                                ),
                                                const SizedBox(height: 12.0),
                                                Text(
                                                  LocaleKeys.write_us.tr(),
                                                  style:
                                                      currentTextTheme(context)
                                                          .headline1
                                                          ?.copyWith(
                                                            fontSize: 24.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: ColorConstant
                                                                .instance
                                                                .greyScale900,
                                                          ),
                                                ),
                                                const SizedBox(height: 24.0),
                                                Text(
                                                  LocaleKeys.write_us_content
                                                      .tr(),
                                                  style:
                                                      currentTextTheme(context)
                                                          .headline4
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: ColorConstant
                                                                .instance
                                                                .greyScale900,
                                                          ),
                                                ),
                                                Text(
                                                  'info@ron.digital',
                                                  style:
                                                      currentTextTheme(context)
                                                          .headline4
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: ColorConstant
                                                                .instance
                                                                .greyScale900,
                                                          ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              image: IconConstant.instance.iconWriteUs,
                              text: LocaleKeys.write_us.tr(),
                            ),
                            ProfileButton(
                              image: IconConstant.instance.iconTerms,
                              text: LocaleKeys.terms.tr(),
                            ),
                            ProfileButton(
                              onTap: () async {
                                final Future<SharedPreferences> _prefs =
                                    SharedPreferences.getInstance();
                                final SharedPreferences prefs = await _prefs;
                                prefs.remove(PreferencesKeys.TOKEN.toString());
                                prefs.remove(
                                    PreferencesKeys.IS_FIRST_APP.toString());

                                Provider.of<BottomBarViewModel>(context,
                                        listen: false)
                                    .selectedIndex = 0;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginView()),
                                  (route) => false,
                                );
                              },
                              isIcon: true,
                              icon: Icons.exit_to_app_rounded,
                              text: LocaleKeys.logout.tr(),
                              isLogout: true,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17.0),
                              child: Divider(
                                thickness: 2,
                                color: ColorConstant.instance.greyScale200,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }
}
