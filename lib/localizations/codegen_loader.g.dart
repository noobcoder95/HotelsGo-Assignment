// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "dataRetrieved": "Data Retrieved",
  "distanceAndRecommended": "Distance & Recommended",
  "distanceFrom": "Distance From",
  "distanceOnly": "Distance Only",
  "filters": "Filters",
  "hotel": "Hotel",
  "hotelClass": "Hotel Class",
  "location": "Location",
  "cityCenter": "City Center",
  "morePrices": "More prices",
  "noInternetConnection": "No Internet Connection",
  "ourLowestPrice": "Our lowest price",
  "ourRecommendations": "Our Recommendations",
  "priceAndRecommended": "Price & Recommended",
  "priceOnly": "Price Only",
  "pricePerNight": "Price Per Night",
  "rating": "Rating",
  "ratingAdRecommended": "Rating & Recommended",
  "ratingOnly": "Rating Only",
  "renaissance": "Renaissance",
  "reset": "Reset",
  "showResult": "Show results",
  "sort": "Sort",
  "sortBy": "Sort By",
  "viewDeal": "View Deal",
  "excellent": "Excellent",
  "good": "Good",
  "veryGood": "Very Good"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en};
}
