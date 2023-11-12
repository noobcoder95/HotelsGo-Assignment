import 'package:hotels_go/utils/assets.dart';
import 'package:hotels_go/utils/enums/hotel_class.dart';

extension HotelClassExtension on HotelClass {
  num get value {
    switch (this) {
      case HotelClass.oneStar:
        return 1;
      case HotelClass.twoStar:
        return 2;
      case HotelClass.threeStar:
        return 3;
      case HotelClass.fourStar:
        return 4;
      case HotelClass.fiveStar:
        return 5;
    }
  }

  String get assetPath {
    switch (this) {
      case HotelClass.oneStar:
        return Assets.oneStarsImage;
      case HotelClass.twoStar:
        return Assets.twoStarsImage;
      case HotelClass.threeStar:
        return Assets.threeStarsImage;
      case HotelClass.fourStar:
        return Assets.fourStarsImage;
      case HotelClass.fiveStar:
        return Assets.fiveStarsImage;
    }
  }
}