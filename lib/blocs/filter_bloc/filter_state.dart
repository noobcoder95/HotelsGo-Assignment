part of 'filter_bloc.dart';

class FilterState {
  const FilterState({
    this.sort = Sort.ourRecommendations,
    this.lastSort = Sort.ourRecommendations,
    this.price,
    this.hotelClass,
    this.rate});
  
  final num? price;
  final Rate? rate;
  final HotelClass? hotelClass;
  final Sort sort;
  final Sort lastSort;

  FilterState copyWith({
    num? price,
    Rate? rate,
    HotelClass? hotelClass,
    Sort? sort,
    Sort? lastSort
  })=> FilterState(
    price: price ?? this.price,
    rate: rate ?? this.rate,
    hotelClass: hotelClass ?? this.hotelClass,
    sort: sort ?? this.sort,
    lastSort: lastSort ?? this.lastSort);
}