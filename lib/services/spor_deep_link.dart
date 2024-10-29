// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:sport/views/search_screen/staduim_screen.dart';
//
// class DeepLinkService {
//   StreamSubscription? _sub;
//
//   void initUniLinks(BuildContext context) {
//     _sub = linkStream.listen((String? link) {
//       if (link != null) {
//         _handleDeepLink(link, context);
//       }
//     }, onError: (err) {
//       // Handle error
//     });
//
//     getInitialLink().then((initialLink) {
//       if (initialLink != null) {
//         _handleDeepLink(initialLink, context);
//       }
//     });
//   }
//
//   void _handleDeepLink(String link, BuildContext context) async {
//     if (link.contains('stadium-info')) {
//       final uri = Uri.parse(link);
//       final stadiumId = uri.queryParameters['stadium_id'];
//       if (stadiumId != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => StadiumDetailScreen(stadiumId: int.parse(stadiumId)),
//           ),
//         );
//       }
//     } else {
//       if (await canLaunch(link)) {
//         await launchUrl(Uri.parse(link), mode: LaunchMode.platformDefault);
//       } else {
//         throw 'Could not launch $link';
//       }
//     }
//   }
//
//   void dispose() {
//     _sub?.cancel();
//   }
// }