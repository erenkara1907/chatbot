// import 'package:chatbot/core/constants/color_constant.dart';
// import 'package:chatbot/core/constants/icon_constant.dart';
// import 'package:chatbot/core/view/base/base_state.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:skeletons/skeletons.dart';

// import '../../../core/language/locale_keys.g.dart';
// import '../../conversation/view/conversation_room_view.dart';
// import '../viewmodel/home_view_model.dart';

// class V2HomeView extends StatefulWidget {
//   const V2HomeView({Key? key}) : super(key: key);
//   @override
// // ignore: library_private_types_in_public_api
//   _V2HomeViewState createState() => _V2HomeViewState();
// }

// class _V2HomeViewState extends BaseState<V2HomeView> {
//   HomeViewModel viewModel = HomeViewModel();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstant.instance.additionalWhite,
//       body: FutureBuilder(
//         future: Provider.of<HomeViewModel>(context, listen: false)
//             .getScenarioAndCategories(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return skeletonLoading();
//           } else if (snapshot.connectionState == ConnectionState.done) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 70.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         top: 30.0, right: 24.0, left: 24.0),
//                     child: header(),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       top: 15.0,
//                       left: 24.0,
//                       right: 24.0,
//                     ),
//                     child: Consumer<HomeViewModel>(
//                       builder: (context, state, child) {
//                         return InkWell(
//                           onTap: () {
//                             categoryModal(context);
//                           },
//                           child: categoryButton(state),
//                         );
//                       },
//                     ),
//                   ),
//                   Consumer<HomeViewModel>(
//                     builder: (context, state, child) {
//                       return Expanded(
//                         child: ListView.builder(
//                           addAutomaticKeepAlives: false,
//                           addRepaintBoundaries: false,
//                           physics: const ClampingScrollPhysics(),
//                           itemCount: state.scenariosTemp.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 10.0),
//                               child: SizedBox(
//                                 width: width(1.0),
//                                 height: height(0.12),
//                                 child: scenarioCard(index),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return const Center(child: Text("error"));
//           }
//         },
//       ),
//     );
//   }

//   Padding skeletonLoading() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 70.0, right: 24.0, left: 24.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(
//               top: 30.0,
//             ),
//             child: SkeletonParagraph(
//               style: const SkeletonParagraphStyle(
//                 lines: 1,
//                 lineStyle: SkeletonLineStyle(
//                   width: 70.0,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               top: 15.0,
//             ),
//             child: SkeletonParagraph(
//               style: const SkeletonParagraphStyle(
//                 lines: 1,
//                 lineStyle: SkeletonLineStyle(
//                   width: 50.0,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               addAutomaticKeepAlives: false,
//               addRepaintBoundaries: false,
//               physics: const ClampingScrollPhysics(),
//               itemCount: 7,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10.0),
//                   child: SizedBox(
//                       width: width(1.0),
//                       height: height(0.11),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16.0),
//                           color: ColorConstant.instance.greyScale200,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: 35.0,
//                                 backgroundColor:
//                                     ColorConstant.instance.greyScale300,
//                               ),
//                               const SizedBox(width: 15.0),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SkeletonParagraph(
//                                     style: SkeletonParagraphStyle(
//                                       lines: 1,
//                                       lineStyle: SkeletonLineStyle(
//                                         width: width(0.4),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5.0),
//                                   SkeletonParagraph(
//                                     style: SkeletonParagraphStyle(
//                                       lines: 2,
//                                       spacing: 2,
//                                       lineStyle: SkeletonLineStyle(
//                                         width: width(0.6),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       )),
//                 );
//               },
//             ),
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
//                                 state.scenariosTemp[index].icon!,
//                               ),
//                             ),
//                             const SizedBox(height: 15.0),
//                             Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 state.scenariosTemp[index].title!,
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
//                               state.scenariosTemp[index].scenario!,
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
//                                             scenarioTitle: state
//                                                 .scenariosTemp[index].title!,
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

//   Future<dynamic> categoryModal(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: BoxDecoration(
//             color: ColorConstant.instance.additionalWhite,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(36.0),
//               topRight: Radius.circular(36.0),
//             ),
//           ),
//           height: MediaQuery.of(context).size.height *
//               0.8, // Ekranın %80'ini kaplar
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               vertical: 34.0,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                   child: modalHeader(context),
//                 ),
//                 const SizedBox(height: 24.0),
//                 Consumer<HomeViewModel>(
//                   builder: (context, state, child) {
//                     return Expanded(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         addAutomaticKeepAlives: false,
//                         addRepaintBoundaries: false,
//                         itemCount: state.categories.length,
//                         physics: const ClampingScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(
//                                 bottom: 10.0, right: 24.0, left: 24.0),
//                             child: SizedBox(
//                               width: width(1.0),
//                               height: height(0.11),
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(24.0),
//                                   ),
//                                   backgroundColor: index ==
//                                           (state.selectedCategory - 1)
//                                       ? const Color.fromRGBO(71, 115, 254, 0.2)
//                                       : ColorConstant.instance.additionalWhite,
//                                 ),
//                                 onPressed: () {
//                                   state.selectedScenarioIndex = -1;
//                                   state.selectedCategory =
//                                       state.categories[index].id!;
//                                   state.selectCategory(
//                                     state.scenarios,
//                                     state.categories[index].title!,
//                                   );

//                                   Future.delayed(
//                                     const Duration(milliseconds: 500),
//                                     () {
//                                       Navigator.pop(context);
//                                     },
//                                   );
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         Container(
//                                           alignment: Alignment.center,
//                                           child: CircularPercentIndicator(
//                                             radius: 45.0,
//                                             lineWidth: 10.0,
//                                             percent:
//                                                 0.0, // Yüzde değeri, 0.0 - 1.0 aralığında olmalı
//                                             center: const Text(
//                                               '50%',
//                                               style: TextStyle(fontSize: 20.0),
//                                             ),
//                                             progressColor: ColorConstant
//                                                 .instance.greyScale200,
//                                             backgroundColor: ColorConstant
//                                                 .instance.greyScale200,
//                                           ),
//                                         ),
//                                         CircleAvatar(
//                                           backgroundImage: NetworkImage(
//                                             state.categories[index].icon!,
//                                           ),
//                                           radius: 35.0,
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(width: 15.0),
//                                     Text(
//                                       state.categories[index].title!,
//                                       style:
//                                           currentTextTheme.subtitle1?.copyWith(
//                                         fontSize: 16.0,
//                                         fontWeight: FontWeight.w600,
//                                         color:
//                                             ColorConstant.instance.greyScale900,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ), // Alt sayfanın içeriği
//         );
//       },
//     );
//   }

//   Row modalHeader(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Categories",
//           style: currentTextTheme.headline1?.copyWith(
//             fontWeight: FontWeight.w500,
//             color: ColorConstant.instance.greyScale900,
//           ),
//         ),
//         CircleAvatar(
//           backgroundColor: ColorConstant.instance.greyScale300,
//           radius: 15.0,
//           child: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.close,
//                 color: ColorConstant.instance.greyScale900,
//                 size: 15.0,
//               )),
//         ),
//       ],
//     );
//   }

//   Widget scenarioCard(int index) {
//     return Consumer<HomeViewModel>(
//       builder: (context, state, child) {
//         return AnimatedPadding(
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.fastOutSlowIn,
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(24.0),
//               ),
//               backgroundColor: index == state.selectedScenarioIndex
//                   ? const Color.fromRGBO(71, 115, 254, 0.2)
//                   : ColorConstant.instance.additionalWhite,
//             ),
//             onPressed: () {
//               state.setScenarioIndex(index);

//               state.selectedScenarioId = state.scenariosTemp[index].id!;
//               Future.delayed(const Duration(milliseconds: 500), () {
//                 scenarioDialog(context, index);
//               });
//             },
//             child: Row(
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       alignment: Alignment.center,
//                       child: CircularPercentIndicator(
//                         radius: 45.0,
//                         lineWidth: 5.0,
//                         percent: double.parse(state.scenariosTemp[index]
//                             .conversationCompleted!), // Yüzde değeri, 0.0 - 1.0 aralığında olmalı
//                         center: const Text(
//                           '50%',
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                         progressColor: const Color.fromRGBO(71, 115, 254, 1),
//                         backgroundColor: ColorConstant.instance.greyScale200,
//                       ),
//                     ),
//                     CircleAvatar(
//                       backgroundImage:
//                           NetworkImage(state.scenariosTemp[index].icon!),
//                       radius: 35.0,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 20.0),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         state.scenariosTemp[index].title!,
//                         style: currentTextTheme.subtitle2?.copyWith(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18.0,
//                           color: ColorConstant.instance.greyScale900,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Chip categoryButton(HomeViewModel state) {
//     return Chip(
//       label: Text(state.selectedCategoryName),
//       labelStyle: const TextStyle(color: Colors.white),
//       backgroundColor: const Color.fromRGBO(71, 115, 254, 1),
//       shadowColor: Colors.black,
//       deleteIconColor: Colors.white,
//       deleteIcon: InkWell(
//         onTap: () {
//           categoryModal(context);
//         },
//         child: const Padding(
//           padding: EdgeInsets.only(bottom: 5.0, right: 10.0),
//           child: RotatedBox(
//             quarterTurns: 3,
//             child: Icon(
//               Icons.arrow_back_ios,
//               size: 16.0,
//             ),
//           ),
//         ),
//       ),
//       surfaceTintColor: Colors.grey,
//       onDeleted: () {},
//     );
//   }

//   Row header() {
//     return Row(
//       children: [
//         SvgPicture.asset(IconConstant.instance.iconChatBubble,
//             width: 24.0,
//             height: 24.0,
//             color: const Color.fromRGBO(71, 115, 254, 1)),
//         const SizedBox(width: 15.0),
//         Text(
//           "Scenarios",
//           style: currentTextTheme.headline1?.copyWith(
//             fontWeight: FontWeight.w600,
//             color: ColorConstant.instance.greyScale900,
//           ),
//         )
//       ],
//     );
//   }
// }
