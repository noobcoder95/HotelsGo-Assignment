import 'package:equatable/equatable.dart';
import 'package:hotels_go/utils/enums/currency.dart';
import 'package:hotels_go/utils/enums/recommendation.dart';
import 'package:hotels_go/utils/extension/currency.dart';
import 'package:hotels_go/utils/extension/recommendation.dart';

/// Extend Equatable For Unit Testing Purpose
class Hotel extends Equatable {
  const Hotel({
    this.name = '',
    this.starts,
    this.price,
    this.currency = '',
    this.image = '',
    this.reviewScore,
    this.review = '',
    this.address = ''});

  factory Hotel.fromJson(dynamic json) => Hotel(
      name: json['name'] ?? '',
      starts: json['starts'],
      price: json['price'],
      currency: json['currency'] ?? '',
      image: json['image'] ?? '',
      reviewScore: json['review_score'],
      review: json['review'] ?? '',
      address: json['address'] ?? '');

  final String name;
  final num? starts;
  final num? price;
  final String currency;
  final String image;
  final num? reviewScore;
  final String review;
  final String address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['starts'] = starts;
    map['price'] = price;
    map['currency'] = currency;
    map['image'] = image;
    map['review_score'] = reviewScore;
    map['review'] = review;
    map['address'] = address;
    return map;
  }

  Currency get currencyEnum => Currency.values.firstWhere((e) => e.label == currency, orElse: ()=> Currency.usd);

  /// There is no distance value from the API, so i get the distance value from the address field
  /// which is still useless because all address values are the same
  num? get distance => num.tryParse(address.split(' ').first);

  /// Using review as recommendation value
  Recommendation get recommendation => Recommendation.values.firstWhere((e) => e.label == review, orElse: ()=> Recommendation.good);

  @override
  List<Object?> get props => [
    name,
    starts,
    price,
    currency,
    image,
    reviewScore,
    reviewScore,
    address
  ];
}