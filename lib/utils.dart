import 'dart:io';

import 'package:flutter/material.dart';

// ios has 2 pixel per point or something like that so we need to halve it
class Utils {
  static double deviceWidth(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    //return Platform.isIOS ? deviceWidth / 2 : deviceWidth;
    return deviceWidth;
  }

  static double deviceHeight(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    //return Platform.isIOS ? deviceHeight / 2 : deviceHeight;
    return deviceHeight;
  }

  static double deviceHeightWithoutAppBar(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - kToolbarHeight;
    //return Platform.isIOS ? deviceHeight / 2 : deviceHeight;
    return deviceHeight;
  }
}
