import 'package:flutter/material.dart';
import 'package:hotels_go/utils/enums/rate.dart';

extension RateExtension on Rate {
  num get value {
    switch (this) {
      case Rate.formZero:
        return 0;
      case Rate.fromSeven:
        return 7;
      case Rate.fromSevenFive:
        return 7.5;
      case Rate.fromEight:
        return 8;
      case Rate.fromEightFive:
        return 8.5;
    }
  }

  Color get color {
    switch (this) {
      case Rate.formZero:
        return Colors.red;
      case Rate.fromSeven:
        return Colors.amber;
      case Rate.fromSevenFive:
        return const Color(0xFF4E9D0D);
      case Rate.fromEight:
        return const Color(0xFF017C06);
      case Rate.fromEightFive:
        return const Color(0xFF036407);
    }
  }
}