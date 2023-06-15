// import 'dart:ui';

// import 'package:chatbot/core/constants/color_constant.dart';
// import 'package:chatbot/core/constants/icon_constant.dart';
// import 'package:chatbot/core/view/base/base_state.dart';
// import 'package:chatbot/product/home/view/category_view.dart';
// import 'package:chatbot/product/home/viewmodel/home_view_model.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';

// import '../../../core/language/locale_keys.g.dart';
// import '../../bottom_bar/view/bottom_bar_view.dart';
// import '../../bottom_bar/viewmodel/bottom_bar_view_model.dart';
// import '../../conversation/view/conversation_room_view.dart';
// import '../model/category_model.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({Key? key}) : super(key: key);
//   @override
// // ignore: library_private_types_in_public_api
//   _HomeViewState createState() => _HomeViewState();
// }

// class _HomeViewState extends BaseState<HomeView> {
//   HomeViewModel viewModel = HomeViewModel();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstant.instance.additionalWhite,
//       body: FutureBuilder(
//         future: viewModel.getCategories(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           } else if (snapshot.connectionState == ConnectionState.done) {
//             return SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: header(),
//                     ),
//                     chips(categoryItemCount: viewModel.categories.length),
//                     const SizedBox(height: 10.0),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 80.0),
//                       child: ListView.builder(
//                         addAutomaticKeepAlives: false,
//                         shrinkWrap: true,
//                         addRepaintBoundaries: false,
//                         physics: const ClampingScrollPhysics(),
//                         itemCount: viewModel.categories.length,
//                         itemBuilder: (context, indexCategory) {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               category(
//                                 categoryName:
//                                     viewModel.categories[indexCategory].title!,
//                                 scenariosOfCategory: viewModel
//                                     .categories[indexCategory].scenarios!,
//                               ),
//                               const SizedBox(height: 5.0),
//                               SizedBox(
//                                 height: 173.0,
//                                 child: ListView.builder(
//                                   padding: EdgeInsets.zero,
//                                   itemCount: viewModel.categories[indexCategory]
//                                       .scenarios!.length,
//                                   addAutomaticKeepAlives: false,
//                                   addRepaintBoundaries: false,
//                                   physics: const ClampingScrollPhysics(),
//                                   scrollDirection: Axis.horizontal,
//                                   itemBuilder: (context, index) {
//                                     return InkWell(
//                                       onTap: () {
//                                         scenarioDialog(
//                                           context,
//                                           photo: viewModel
//                                               .categories[indexCategory]
//                                               .scenarios![index]
//                                               .icon!,
//                                           title: viewModel
//                                               .categories[indexCategory]
//                                               .scenarios![index]
//                                               .title!,
//                                           scenario: viewModel
//                                               .categories[indexCategory]
//                                               .scenarios![index]
//                                               .scenario!,
//                                           scenarioId: viewModel
//                                               .categories[indexCategory]
//                                               .scenarios![index]
//                                               .id!,
//                                         );
//                                       },
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 10.0),
//                                         child: scenarioCard(
//                                           scenarioTitle: viewModel
//                                               .categories[indexCategory]
//                                               .scenarios![index]
//                                               .title!,
//                                           scenarioImage: viewModel
//                                               .categories[indexCategory]
//                                               .scenarios![index]
//                                               .photo!,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return const Text("error");
//           }
//         },
//       ),
//     );
//   }

//   Future<dynamic> scenarioDialog(
//     BuildContext context, {
//     required String photo,
//     required String title,
//     required String scenario,
//     required int scenarioId,
//   }) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Consumer<HomeViewModel>(
//                   builder: (context, state, child) {
//                     return Container(
//                       padding: const EdgeInsets.all(42.0),
//                       width: width(1.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16.0),
//                         color: ColorConstant.instance.additionalWhite,
//                       ),
//                       child: Column(
//                         children: [
//                           Material(
//                             child: Align(
//                               alignment: Alignment.centerRight,
//                               child: CircleAvatar(
//                                 backgroundColor:
//                                     ColorConstant.instance.greyScale300,
//                                 radius: 15.0,
//                                 child: IconButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     icon: Icon(
//                                       Icons.close,
//                                       color: ColorConstant.instance.greyScale900,
//                                       size: 15.0,
//                                     )),
//                               ),
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: Image.network(
//                                   photo,
//                                 ),
//                               ),
//                               const SizedBox(height: 15.0),
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   title,
//                                   style: currentTextTheme.headline1?.copyWith(
//                                     fontSize: 24.0,
//                                     fontWeight: FontWeight.w600,
//                                     color: ColorConstant.instance.greyScale900,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                               const SizedBox(height: 24.0),
//                               Text(
//                                 scenario,
//                                 style: currentTextTheme.headline4?.copyWith(
//                                   fontWeight: FontWeight.w400,
//                                   color: ColorConstant.instance.greyScale900,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 15.0),
//                               const SizedBox(height: 24.0),
//                               SizedBox(
//                                 width: width(1.0) - 132.0,
//                                 height: height(0.07),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     state.chnageConversationStatus(false);
//                                     state.setFirstLogin();
//                                     final response = state.createConversation(
//                                       context,
//                                       scenarioId: scenarioId.toString(),
//                                     );
        
//                                     response.then((value) {
//                                       if (value.result == true) {
//                                         state.chnageConversationStatus(true);
//                                         Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ConversationRoomView(
//                                               conversationId:
//                                                   state.conversation.id!,
//                                               scenarioTitle: title,
//                                             ),
//                                           ),
//                                         );
//                                         // if (stateModel.barrierDismissible == false) {
//                                         //   stateModel.barrierDismissible = true;
//                                         // }
//                                       }
//                                     });
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         ColorConstant.instance.greyScale400,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(66.0),
//                                     ),
//                                     elevation: 0,
//                                   ),
//                                   child: state.isCreatedConversation
//                                       ? Text(
//                                           LocaleKeys.let_start.tr(),
//                                           style: currentTextTheme.headline3
//                                               ?.copyWith(
//                                             fontWeight: FontWeight.w400,
//                                             color: ColorConstant
//                                                 .instance.greyScale900,
//                                           ),
//                                         )
//                                       : Center(
//                                           child: CircularProgressIndicator(
//                                             color: ColorConstant
//                                                 .instance.additionalWhite,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Container scenarioCard(
//       {required String scenarioTitle, required String scenarioImage}) {
//     return Container(
//       width: 126.0,
//       height: 173.0,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.0),
//         image: DecorationImage(
//           fit: BoxFit.cover,
//           image: NetworkImage(
//             scenarioImage,
//           ),
//         ),
//       ),
//       child: Align(
//         alignment: Alignment.bottomLeft,
//         child: Padding(
//           padding: const EdgeInsets.only(
//             bottom: 19.0,
//             left: 8.0,
//             right: 8.0,
//           ),
//           child: Text(
//             scenarioTitle,
//             style: currentTextTheme.caption?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: ColorConstant.instance.additionalWhite,
//               fontSize: 12.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Row category(
//       {required String categoryName,
//       required List<ScenariosOfCategory> scenariosOfCategory}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           categoryName,
//           style: currentTextTheme.subtitle1?.copyWith(
//             fontWeight: FontWeight.w600,
//             fontSize: 18.0,
//             color: ColorConstant.instance.greyScale900,
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CategoryView(
//                   categoryName: categoryName,
//                   scenariosOfCategory: scenariosOfCategory,
//                 ),
//               ),
//             );
//           },
//           icon: const Icon(Icons.arrow_forward_ios),
//           iconSize: 16.0,
//           color: ColorConstant.instance.greyScale900,
//         ),
//       ],
//     );
//   }

//   Row chips({
//     required int categoryItemCount,
//   }) {
//     return Row(
//       children: [
//         InkWell(
//           child: chip(
//             label: "Category",
//             onTap: () {
//               chipDialogCategory();
//             },
//           ),
//         ),
//         const SizedBox(width: 15.0),
//         InkWell(
//           child: Consumer<HomeViewModel>(
//             builder: (context, state, child) {
//               return chip(
//                 label: state.selectedLevel == ""
//                     ? viewModel.profileModel.data!.user!.learnLanguages![0]
//                         .proficiencyLevel!.scale!
//                     : state.selectedLevel,
//                 onTap: () {
//                   chipDialogLevel();
//                   Provider.of<HomeViewModel>(context, listen: false)
//                       .selectLevel("level", -1);
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Future<dynamic> chipDialogCategory() {
//     return showDialog(
//       useSafeArea: false,
//       context: context,
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//           child: Container(
//             color: const Color.fromRGBO(38, 38, 38, 0.6),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 62.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Center(),
//                   ListView.builder(
//                     itemCount: viewModel.categories.length,
//                     addAutomaticKeepAlives: false,
//                     addRepaintBoundaries: false,
//                     physics: const ClampingScrollPhysics(),
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CategoryView(
//                                 categoryName:
//                                     viewModel.categories[index].title!,
//                                 scenariosOfCategory:
//                                     viewModel.categories[index].scenarios!,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 10.0),
//                           child: Text(
//                             viewModel.categories[index].title!,
//                             style: currentTextTheme.headline1?.copyWith(
//                               fontWeight: FontWeight.w400,
//                               color: ColorConstant.instance.additionalWhite,
//                               fontSize: 24.0,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   Material(
//                     borderRadius: BorderRadius.circular(50.0),
//                     child: CircleAvatar(
//                       radius: 30.0,
//                       backgroundColor: ColorConstant.instance.additionalWhite,
//                       child: IconButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         icon: Icon(
//                           Icons.close,
//                           size: 24.0,
//                           color: ColorConstant.instance.greyScale900,
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<dynamic> chipDialogLevel() {
//     return showDialog(
//       useSafeArea: false,
//       context: context,
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//           child: Container(
//             color: const Color.fromRGBO(38, 38, 38, 0.6),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 62.0),
//               child: Consumer<HomeViewModel>(
//                 builder: (context, state, child) {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Center(),
//                       ListView.builder(
//                         itemCount: viewModel.languageProficiency.length,
//                         addAutomaticKeepAlives: false,
//                         addRepaintBoundaries: false,
//                         physics: const ClampingScrollPhysics(),
//                         shrinkWrap: true,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 20.0),
//                             child: TextButton(
//                               onPressed: state.selectedLevelId != -1
//                                   ? () {}
//                                   : () {
//                                       viewModel.updateProfile(context, {
//                                         "learn_language_proficiency_cefr":
//                                             viewModel.languageProficiency[index]
//                                                 .code,
//                                       });
//                                       Provider.of<HomeViewModel>(context,
//                                               listen: false)
//                                           .selectLevel(
//                                         viewModel
//                                             .languageProficiency[index].title,
//                                         viewModel.languageProficiency[index].id,
//                                       );
//                                     },
//                               child: Text(
//                                 viewModel.languageProficiency[index].title,
//                                 style: currentTextTheme.headline1?.copyWith(
//                                   fontWeight: FontWeight.w400,
//                                   color: ColorConstant.instance.additionalWhite,
//                                   fontSize: 24.0,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       Material(
//                         borderRadius: BorderRadius.circular(50.0),
//                         child: CircleAvatar(
//                           radius: 30.0,
//                           backgroundColor:
//                               ColorConstant.instance.additionalWhite,
//                           child: IconButton(
//                             onPressed: state.selectedLevelId != -1
//                                 ? () {}
//                                 : () {
//                                     Navigator.of(context).pop();
//                                   },
//                             icon: state.selectedLevelId != -1
//                                 ? CircularProgressIndicator(
//                                     color: ColorConstant.instance.greyScale700,
//                                   )
//                                 : Icon(
//                                     Icons.close,
//                                     size: 24.0,
//                                     color: ColorConstant.instance.greyScale900,
//                                   ),
//                           ),
//                         ),
//                       )
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget chip({required String label, required void Function() onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: Chip(
//         label: Text(label),
//         labelStyle: currentTextTheme.subtitle1?.copyWith(
//           fontWeight: FontWeight.w500,
//           color: ColorConstant.instance.greyScale900,
//           fontSize: 12.0,
//         ),
//         backgroundColor: ColorConstant.instance.additionalWhite,
//         shadowColor: Colors.black,
//         deleteIcon: Padding(
//           padding: const EdgeInsets.only(right: 10.0),
//           child: InkWell(
//             onTap: onTap,
//             child: SvgPicture.asset(
//               IconConstant.instance.iconArrowDown,
//               width: 8.0,
//               height: 8.0,
//             ),
//           ),
//         ),
//         side: BorderSide(
//           color: ColorConstant.instance.greyScale900,
//           width: 1.0,
//         ),
//         surfaceTintColor: Colors.red,
//         onDeleted: () {},
//       ),
//     );
//   }

//   Row header() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Welcome",
//           style: currentTextTheme.headline1?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: ColorConstant.instance.greyScale900,
//             fontSize: 24.0,
//           ),
//         ),
//         avatar(),
//       ],
//     );
//   }

//   InkWell avatar() {
//     return InkWell(
//       onTap: () {
//         Provider.of<BottomBarViewModel>(context, listen: false).selectedIndex =
//             2;
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => BottomBarView()));
//       },
//       child: Container(
//         width: 55.0,
//         height: 55.0,
//         padding: const EdgeInsets.all(5.0),
//         decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: ColorConstant.instance.greyScale300,
//                 blurRadius: 10.0,
//                 spreadRadius: 1.0,
//                 offset: const Offset(3, 3),
//               ),
//             ],
//             color: Color.fromRGBO(
//               viewModel.profileModel.data!.user!.color![0],
//               viewModel.profileModel.data!.user!.color![1],
//               viewModel.profileModel.data!.user!.color![2],
//               1,
//             ),
//             borderRadius: BorderRadius.circular(50.0),
//             border: Border.all(
//               width: 1.0,
//               color: ColorConstant.instance.additionalWhite,
//             )),
//         child: Container(
//           width: 20.0,
//           height: 20.0,
//           padding: const EdgeInsets.all(15.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50.0),
//             image: DecorationImage(
//               image: NetworkImage(
//                   viewModel.profileModel.data!.user!.profilePhoto!),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
