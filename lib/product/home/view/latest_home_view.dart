// // ignore_for_file: use_key_in_widget_constructors, must_be_immutable, no_leading_underscores_for_local_identifiers

// import 'dart:math';

// import 'package:chatbot/core/constants/color_constant.dart';
// import 'package:chatbot/core/constants/icon_constant.dart';
// import 'package:chatbot/core/language/locale_keys.g.dart';
// import 'package:chatbot/core/view/base/base_state.dart';
// import 'package:chatbot/product/bottom_bar/view/bottom_bar_view.dart';
// import 'package:chatbot/product/bottom_bar/viewmodel/bottom_bar_view_model.dart';
// import 'package:chatbot/product/home/viewmodel/home_view_model.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:skeletons/skeletons.dart';

// import '../../../core/enum/preference_keys.dart';
// import '../../conversation/view/conversation_room_view.dart';

// class LatestHomeView extends StatefulWidget {
//   @override
//   State<LatestHomeView> createState() => _LatestHomeViewState();
// }

// class _LatestHomeViewState extends BaseState<LatestHomeView> {
//   HomeViewModel viewModel = HomeViewModel();

//   Future setFirstLogin() async {
//     final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
//     final SharedPreferences _prefs = await prefs;

//     viewModel.isFirst =
//         _prefs.getBool(PreferencesKeys.IS_FIRST_APP.toString())!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     Provider.of<HomeViewModel>(context, listen: false).setActivePage();
//     setFirstLogin();
//     return Scaffold(
//       backgroundColor: ColorConstant.instance.additionalWhite,
//       body: hasData(),
//     );
//   }

//   SingleChildScrollView hasData() {
//     return SingleChildScrollView(
//       physics: const ClampingScrollPhysics(),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           FutureBuilder(
//             future: viewModel.getProfileInfo(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           const SkeletonAvatar(
//                             style: SkeletonAvatarStyle(
//                               width: 35.0,
//                               height: 35.0,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 5.0),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 SkeletonParagraph(
//                                   style: const SkeletonParagraphStyle(
//                                     lines: 1,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5.0),
//                                 SkeletonParagraph(
//                                   style: SkeletonParagraphStyle(
//                                     lines: 1,
//                                     lineStyle: SkeletonLineStyle(
//                                       width: width(0.1),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 5.0),
//                           const SkeletonAvatar(
//                             style: SkeletonAvatarStyle(
//                               width: 35.0,
//                               height: 35.0,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20.0),
//                       Container(
//                         height: height(0.085),
//                         width: width(1.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20.0),
//                           color: ColorConstant.instance.greyScale300,
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       SkeletonParagraph(
//                         style: SkeletonParagraphStyle(
//                             lines: 1,
//                             lineStyle: SkeletonLineStyle(width: width(0.15))),
//                       ),
//                       const SizedBox(height: 20.0),
//                       SizedBox(
//                         height: 80.0,
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: 6,
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.only(right: 14.0),
//                               child: Container(
//                                 width: width(0.20),
//                                 decoration: BoxDecoration(
//                                   color: ColorConstant.instance.greyScale300,
//                                   borderRadius: BorderRadius.circular(20.0),
//                                 ),
//                                 child: const Text(""),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: 12,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 15.0),
//                             child: Container(
//                               height: height(0.05),
//                               decoration: BoxDecoration(
//                                 color: ColorConstant.instance.greyScale300,
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               } else if (snapshot.connectionState == ConnectionState.done) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     customAppBar(context),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Divider(
//                             thickness: 1.0,
//                             color: ColorConstant.instance.greyScale300,
//                           ),
//                           const SizedBox(height: 20.0),
//                           lessonCard(context),
//                           const SizedBox(height: 24.0),
//                           Text(
//                             "Select Scenario",
//                             style: currentTextTheme.headline2?.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: ColorConstant.instance.greyScale900,
//                             ),
//                           ),
//                           const SizedBox(height: 16.0),
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//               } else {
//                 return const Text('error');
//               }
//             },
//           ),
//           FutureBuilder(
//             future: viewModel.getScenarioAndCategories(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center();
//               } else if (snapshot.connectionState == ConnectionState.done) {
//                 return Padding(
//                   padding: const EdgeInsets.only(
//                       bottom: 70.0, left: 24.0, right: 24.0),
//                   child: Column(
//                     children: [
//                       Consumer<HomeViewModel>(
//                         builder: (context, state, child) {
//                           return SizedBox(
//                             height: 80.0,
//                             child: ListView.builder(
//                               addAutomaticKeepAlives: false,
//                               addRepaintBoundaries: false,
//                               physics: const ClampingScrollPhysics(),
//                               scrollDirection: Axis.horizontal,
//                               itemCount: viewModel.categories.length,
//                               itemBuilder: (context, index) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: InkWell(
//                                     onTap: () {
//                                       state.selectedCategory =
//                                           viewModel.categories[index].id!;
//                                       state.selectCategory(viewModel.scenarios,
//                                           viewModel.categories[index].title!);
//                                     },
//                                     child: Container(
//                                       width: width(0.20),
//                                       decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(8.0),
//                                         color: state.selectedCategory ==
//                                                 viewModel.categories[index].id
//                                             ? const Color.fromRGBO(
//                                                 190, 240, 200, 1)
//                                             : ColorConstant
//                                                 .instance.greyScale50,
//                                         border: Border.all(
//                                           color: state.selectedCategory ==
//                                                   viewModel.categories[index].id
//                                               ? const Color.fromRGBO(
//                                                   0, 211, 148, 1)
//                                               : ColorConstant
//                                                   .instance.greyScale400,
//                                         ),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Image.network(
//                                             viewModel.categories[index].icon!,
//                                             width: 32.0,
//                                             height: 32.0,
//                                           ),
//                                           const SizedBox(height: 12.0),
//                                           Text(
//                                             viewModel.categories[index].title!,
//                                             style: currentTextTheme.subtitle2
//                                                 ?.copyWith(
//                                               fontWeight: FontWeight.w500,
//                                               color: ColorConstant
//                                                   .instance.greyScale900,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 24.0),
//                       Consumer<HomeViewModel>(
//                         builder: (context, state, child) {
//                           return state.selectedCategory == 1
//                               ? ListView.builder(
//                                   shrinkWrap: true,
//                                   addAutomaticKeepAlives: false,
//                                   addRepaintBoundaries: false,
//                                   physics: const ClampingScrollPhysics(),
//                                   itemCount: viewModel.scenariosTemp.length,
//                                   itemBuilder: (context, index) {
//                                     return InkWell(
//                                       onTap: () {
//                                         state.selectedScenarioId =
//                                             viewModel.scenariosTemp[index].id!;

//                                         scenarioDialog(context, index);
//                                       },
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(bottom: 20.0),
//                                         child: Container(
//                                           width: width(1.0),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(8.0),
//                                             color: ColorConstant
//                                                 .instance.greyScale50,
//                                             border: Border.all(
//                                               color: ColorConstant
//                                                   .instance.greyScale400,
//                                             ),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Image.network(
//                                                     viewModel
//                                                         .scenariosTemp[index]
//                                                         .icon!,
//                                                     width: 32.0,
//                                                     height: 32.0),
//                                                 const SizedBox(width: 21.0),
//                                                 Text(
//                                                   viewModel.scenariosTemp[index]
//                                                       .title!,
//                                                   style: currentTextTheme
//                                                       .subtitle2
//                                                       ?.copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: ColorConstant
//                                                               .instance
//                                                               .greyScale900),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 )
//                               : ListView.builder(
//                                   shrinkWrap: true,
//                                   addAutomaticKeepAlives: false,
//                                   addRepaintBoundaries: false,
//                                   physics: const ClampingScrollPhysics(),
//                                   itemCount: state.scenariosTemp.length,
//                                   itemBuilder: (context, index) {
//                                     return InkWell(
//                                       onTap: () {
//                                         state.selectedScenarioId =
//                                             state.scenariosTemp[index].id!;
//                                         scenarioDialog(context, index);
//                                       },
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(bottom: 20.0),
//                                         child: Container(
//                                           width: width(1.0),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(8.0),
//                                             color: ColorConstant
//                                                 .instance.greyScale50,
//                                             border: Border.all(
//                                               color: ColorConstant
//                                                   .instance.greyScale400,
//                                             ),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Image.network(
//                                                     state.scenariosTemp[index]
//                                                         .icon!,
//                                                     width: 32.0,
//                                                     height: 32.0),
//                                                 const SizedBox(width: 21.0),
//                                                 Text(
//                                                   state.scenariosTemp[index]
//                                                       .title!,
//                                                   style: currentTextTheme
//                                                       .subtitle2
//                                                       ?.copyWith(
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: ColorConstant
//                                                               .instance
//                                                               .greyScale900),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               } else {
//                 return const Text('error');
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<dynamic> scenarioDialog(BuildContext context, int index,
//       {HomeViewModel? stateModel, bool? barrier}) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Consumer<HomeViewModel>(
//                 builder: (context, state, child) {
//                   return Container(
//                     padding: const EdgeInsets.all(42.0),
//                     width: width(1.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.0),
//                       color: ColorConstant.instance.additionalWhite,
//                     ),
//                     child: Column(
//                       children: [
//                         Material(
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: CircleAvatar(
//                               backgroundColor:
//                                   ColorConstant.instance.greyScale300,
//                               radius: 15.0,
//                               child: IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   icon: Icon(
//                                     Icons.close,
//                                     color: ColorConstant.instance.greyScale900,
//                                     size: 15.0,
//                                   )),
//                             ),
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Align(
//                               alignment: Alignment.center,
//                               child: Image.network(
//                                 state.selectedCategory == 1
//                                     ? viewModel.scenariosTemp[index].icon!
//                                     : state.scenariosTemp[index].icon!,
//                               ),
//                             ),
//                             const SizedBox(height: 15.0),
//                             Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 state.selectedCategory == 1
//                                     ? viewModel.scenariosTemp[index].title!
//                                     : state.scenariosTemp[index].title!,
//                                 style: currentTextTheme.headline1?.copyWith(
//                                   fontSize: 24.0,
//                                   fontWeight: FontWeight.w600,
//                                   color: ColorConstant.instance.greyScale900,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             const SizedBox(height: 24.0),
//                             Text(
//                               state.selectedCategory == 1
//                                   ? viewModel.scenariosTemp[index].scenario!
//                                   : state.scenariosTemp[index].scenario!,
//                               style: currentTextTheme.headline4?.copyWith(
//                                 fontWeight: FontWeight.w400,
//                                 color: ColorConstant.instance.greyScale900,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 15.0),
//                             const SizedBox(height: 24.0),
//                             SizedBox(
//                               width: width(1.0) - 132.0,
//                               height: height(0.07),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   state.chnageConversationStatus(false);
//                                   state.setFirstLogin();
//                                   final response = state.createConversation(
//                                     context,
//                                     scenarioId:
//                                         state.selectedScenarioId.toString(),
//                                   );

//                                   response.then((value) {
//                                     if (value.result == true) {
//                                       state.chnageConversationStatus(true);
//                                       Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ConversationRoomView(
//                                             conversationId:
//                                                 state.conversation.id!,
//                                             scenarioTitle:
//                                                 state.selectedCategory == 1
//                                                     ? viewModel
//                                                         .scenariosTemp[index]
//                                                         .title!
//                                                     : state.scenariosTemp[index]
//                                                         .title!,
//                                           ),
//                                         ),
//                                       );
//                                       // if (stateModel.barrierDismissible == false) {
//                                       //   stateModel.barrierDismissible = true;
//                                       // }
//                                     }
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       ColorConstant.instance.greyScale400,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(66.0),
//                                   ),
//                                   elevation: 0,
//                                 ),
//                                 child: state.isCreatedConversation
//                                     ? Text(
//                                         LocaleKeys.let_start.tr(),
//                                         style: currentTextTheme.headline3
//                                             ?.copyWith(
//                                           fontWeight: FontWeight.w400,
//                                           color: ColorConstant
//                                               .instance.greyScale900,
//                                         ),
//                                       )
//                                     : Center(
//                                         child: CircularProgressIndicator(
//                                           color: ColorConstant
//                                               .instance.additionalWhite,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<dynamic> scenarioRandomDialog(BuildContext context, int index,
//       {HomeViewModel? stateModel, bool? barrier}) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Consumer<HomeViewModel>(
//                 builder: (context, state, child) {
//                   return Container(
//                     padding: const EdgeInsets.all(42.0),
//                     width: width(1.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.0),
//                       color: ColorConstant.instance.additionalWhite,
//                     ),
//                     child: Column(
//                       children: [
//                         Material(
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: CircleAvatar(
//                               backgroundColor:
//                                   ColorConstant.instance.greyScale300,
//                               radius: 15.0,
//                               child: IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   icon: Icon(
//                                     Icons.close,
//                                     color: ColorConstant.instance.greyScale900,
//                                     size: 15.0,
//                                   )),
//                             ),
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Align(
//                               alignment: Alignment.center,
//                               child: Image.network(
//                                   viewModel.scenarios[index].icon!),
//                             ),
//                             const SizedBox(height: 15.0),
//                             Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 viewModel.scenarios[index].title!,
//                                 style: currentTextTheme.headline1?.copyWith(
//                                   fontSize: 24.0,
//                                   fontWeight: FontWeight.w600,
//                                   color: ColorConstant.instance.greyScale900,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             const SizedBox(height: 24.0),
//                             Text(
//                               viewModel.scenarios[index].scenario!,
//                               style: currentTextTheme.headline4?.copyWith(
//                                 fontWeight: FontWeight.w400,
//                                 color: ColorConstant.instance.greyScale900,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 15.0),
//                             const SizedBox(height: 24.0),
//                             SizedBox(
//                               width: width(1.0) - 132.0,
//                               height: height(0.07),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   state.chnageConversationStatus(false);
//                                   state.setFirstLogin();
//                                   final response = viewModel.createConversation(
//                                       context,
//                                       scenarioId: viewModel.scenarios[index].id
//                                           .toString());

//                                   response.then((value) {
//                                     if (value.result == true) {
//                                       state.chnageConversationStatus(true);
//                                       Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ConversationRoomView(
//                                             conversationId:
//                                                 viewModel.conversation.id!,
//                                             scenarioTitle: viewModel
//                                                 .scenarios[index].scenario!,
//                                           ),
//                                         ),
//                                       );
//                                       // if (stateModel.barrierDismissible == false) {
//                                       //   stateModel.barrierDismissible = true;
//                                       // }
//                                     }
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       ColorConstant.instance.greyScale400,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(66.0),
//                                   ),
//                                   elevation: 0,
//                                 ),
//                                 child: state.isCreatedConversation
//                                     ? Text(
//                                         LocaleKeys.let_start.tr(),
//                                         style: currentTextTheme.headline3
//                                             ?.copyWith(
//                                           fontWeight: FontWeight.w400,
//                                           color: ColorConstant
//                                               .instance.greyScale900,
//                                         ),
//                                       )
//                                     : Center(
//                                         child: CircularProgressIndicator(
//                                           color: ColorConstant
//                                               .instance.additionalWhite,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget lessonCard(BuildContext context) {
//     return Consumer<HomeViewModel>(
//       builder: (context, state, child) {
//         return AnimatedPadding(
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//           padding: EdgeInsets.only(top: state.isActivePage ? 0.0 : 50.0),
//           child: Container(
//             width: width(1.0),
//             decoration: BoxDecoration(
//               color: ColorConstant.instance.greyScale100,
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 lessonCardTop(context),
//                 viewModel.isFirst ? lessonCardContent(context) : const Center(),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Padding lessonCardContent(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 16.0),
//           Text(
//             "So nice to meet you, ${viewModel.profileModel.data!.user!.name!}! I'm here for you.✌🏻 Let's start talking.",
//             style: currentTextTheme.headline3?.copyWith(
//               fontWeight: FontWeight.w400,
//               color: ColorConstant.instance.greyScale900,
//             ),
//           ),
//           const SizedBox(height: 16.0),
//           SizedBox(
//             width: width(0.41),
//             height: height(0.04),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorConstant.instance.greyScale300,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50.0),
//                 ),
//                 elevation: 0,
//               ),
//               onPressed: () {
//                 var randomNumber = Random();
//                 int index = 0;
//                 for (var i = 1; i < viewModel.scenarios.length; i++) {
//                   index = randomNumber.nextInt(viewModel.scenarios.length);
//                 }

//                 scenarioRandomDialog(context, index);
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     LocaleKeys.start_lesson.tr(),
//                     style: currentTextTheme.headline3?.copyWith(
//                       fontWeight: FontWeight.w400,
//                       color: ColorConstant.instance.greyScale900,
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_forward,
//                     color: ColorConstant.instance.greyScale900,
//                     size: 20.0,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 10.0),
//         ],
//       ),
//     );
//   }

//   Container lessonCardTop(BuildContext context) {
//     return Container(
//       height: height(0.09),
//       decoration: BoxDecoration(
//           borderRadius: viewModel.isFirst
//               ? const BorderRadius.only(
//                   topLeft: Radius.circular(20.0),
//                   topRight: Radius.circular(20.0),
//                 )
//               : BorderRadius.circular(20.0),
//           color: ColorConstant.instance.greyScale900),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               flex: 2,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     LocaleKeys.today_practice.tr(),
//                     style: currentTextTheme.headline1?.copyWith(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 20.0,
//                       color: ColorConstant.instance.additionalWhite,
//                     ),
//                   ),
//                   const SizedBox(height: 4.0),
//                   Row(
//                     children: [
//                       SvgPicture.asset(
//                         IconConstant.instance.iconCharge,
//                         color: ColorConstant.instance.additionalWhite,
//                       ),
//                       const SizedBox(width: 7.0),
//                       Text(
//                         '${viewModel.profileModel.data!.user!.dailyPractice!.completionPercentage} COMPLETED',
//                         style: currentTextTheme.headline6?.copyWith(
//                           fontWeight: FontWeight.w400,
//                           color: ColorConstant.instance.additionalWhite,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.symmetric(vertical: 20.0),
//                 height: 6.0,
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.all(
//                     Radius.circular(10.0),
//                   ),
//                   child: LinearProgressIndicator(
//                     backgroundColor: ColorConstant.instance.greyScale800,
//                     color: ColorConstant.instance.greyScale50,
//                     minHeight: 6.0,
//                     value: double.parse(
//                       viewModel.profileModel.data!.user!.dailyPractice!.count
//                           .toString(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget customAppBar(BuildContext context) {
//     return Consumer<HomeViewModel>(
//       builder: (context, state, child) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Provider.of<BottomBarViewModel>(context, listen: false)
//                         .selectedIndex = 2;
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => BottomBarView()));
//                   },
//                   child: AnimatedPadding(
//                     duration: const Duration(milliseconds: 500),
//                     curve: Curves.easeInOut,
//                     padding:
//                         EdgeInsets.only(left: state.isActivePage ? 24.0 : 0.0),
//                     child: Container(
//                       width: 55.0,
//                       height: 55.0,
//                       padding: const EdgeInsets.all(5.0),
//                       decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                               color: ColorConstant.instance.greyScale300,
//                               blurRadius: 10.0,
//                               spreadRadius: 1.0,
//                               offset: const Offset(3, 3),
//                             ),
//                           ],
//                           color: Color.fromRGBO(
//                             viewModel.profileModel.data!.user!.color![0],
//                             viewModel.profileModel.data!.user!.color![1],
//                             viewModel.profileModel.data!.user!.color![2],
//                             1,
//                           ),
//                           borderRadius: BorderRadius.circular(50.0),
//                           border: Border.all(
//                             width: 1.0,
//                             color: ColorConstant.instance.additionalWhite,
//                           )),
//                       child: Container(
//                         width: 20.0,
//                         height: 20.0,
//                         padding: const EdgeInsets.all(15.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50.0),
//                           image: DecorationImage(
//                             image: NetworkImage(viewModel
//                                 .profileModel.data!.user!.profilePhoto!),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10.0),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Hi ${viewModel.profileModel.data!.user!.name!}'
//                           .toUpperCase(),
//                       style: currentTextTheme.headline6?.copyWith(
//                         fontWeight: FontWeight.w400,
//                         color: ColorConstant.instance.greyScale600,
//                       ),
//                     ),
//                     Text(
//                       LocaleKeys.welcome.tr(),
//                       style: currentTextTheme.headline3?.copyWith(
//                         fontWeight: FontWeight.w600,
//                         color: ColorConstant.instance.greyScale900,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 24.0),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 500),
//                 width: state.isActivePage ? 40.0 : 10.0,
//                 height: state.isActivePage ? 40.0 : 10.0,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50.0),
//                   color: ColorConstant.instance.greyScale900,
//                 ),
//                 child: IconButton(
//                   onPressed: () {
//                     var randomNumber = Random();
//                     int index = 0;
//                     for (var i = 1; i < viewModel.scenarios.length; i++) {
//                       index = randomNumber.nextInt(viewModel.scenarios.length);
//                     }

//                     scenarioRandomDialog(context, index);
//                   },
//                   icon: Icon(
//                     Icons.add,
//                     color: ColorConstant.instance.additionalWhite,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
