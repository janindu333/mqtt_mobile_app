import 'package:flutter/material.dart';

import '../../utill/color_constant.dart';
import '../../utill/math_utils.dart';

class AppStyle {
  static TextStyle textstylepoppinsmedium16 = textstylepoppinsmedium22.copyWith(
    fontSize: getFontSize(
      16,
    ),
  );

  static TextStyle textstylepoppinsmedium161 =
      textstylepoppinsmedium16.copyWith(
    color: ColorConstant.whiteA700,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  static TextStyle textstyleregular20 = TextStyle(
    color: ColorConstant.black900,
    fontSize: getFontSize(
      20,
    ),
    fontWeight: FontWeight.w400,
  );

  static TextStyle textstylepoppinsmedium18 = TextStyle(
    color: ColorConstant.bluegray100,
    fontSize: getFontSize(
      18,
    ),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  static TextStyle textstylepoppinsmedium22 = TextStyle(
    color: ColorConstant.bluegray900,
    fontSize: getFontSize(
      22,
    ),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  static TextStyle textstylepoppinsmedium12 = TextStyle(
    color: ColorConstant.gray600,
    fontSize: getFontSize(
      12,
    ),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );

  static TextStyle textstyleregular16 = TextStyle(
    color: ColorConstant.bluegray400,
    fontSize: getFontSize(
      16,
    ),
    fontWeight: FontWeight.w400,
  );
}
