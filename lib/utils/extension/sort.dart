import 'package:easy_localization/easy_localization.dart';
import 'package:hotels_go/localizations/locale_keys.g.dart';
import 'package:hotels_go/utils/enums/sort.dart';

extension SortExtension on Sort {
  String get label {
    switch (this) {
      case Sort.ourRecommendations:
        return LocaleKeys.ourRecommendations.tr();
      case Sort.priceAndRecommended:
        return LocaleKeys.priceAndRecommended.tr();
      case Sort.ratingAdRecommended:
        return LocaleKeys.ratingAdRecommended.tr();
      case Sort.distanceAndRecommended:
        return LocaleKeys.distanceAndRecommended.tr();
      case Sort.priceOnly:
        return LocaleKeys.priceOnly.tr();
      case Sort.ratingOnly:
        return LocaleKeys.ratingOnly.tr();
      case Sort.distanceOnly:
        return LocaleKeys.distanceOnly.tr();
    }
  }
}