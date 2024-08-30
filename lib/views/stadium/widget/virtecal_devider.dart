import 'package:flutter/cupertino.dart';

import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';

Widget VirtecalDevider(BuildContext context) {
  return Container(
    height: Responsive.screenHeight(context) * 0.08,
    width: Responsive.screenWidth(context) * 0.005,
    decoration: const BoxDecoration(
      color: Constants.txtColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
    ),
  );
}
