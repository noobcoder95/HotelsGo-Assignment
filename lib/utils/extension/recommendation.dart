import 'package:hotels_go/localizations/locale_keys.g.dart';
import 'package:hotels_go/utils/enums/recommendation.dart';

extension RecommendationExtension on Recommendation {
  String get label {
    switch (this) {
      case Recommendation.excellent:
        return LocaleKeys.excellent;
      case Recommendation.veryGood:
        return LocaleKeys.veryGood;
      case Recommendation.good:
        return LocaleKeys.good;
    }
  }
}