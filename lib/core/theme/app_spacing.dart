import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double s2 = 2;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s40 = 40;
}

class AppRadius {
  AppRadius._();

  static const double xs = 2;
  static const double sm = 6;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 32;

  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}
