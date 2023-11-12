part of 'filter_bloc.dart';

abstract class FilterEvent {
  const FilterEvent();
}

class SetFilter extends FilterEvent {
  final num? price;
  final Rate? rate;
  final HotelClass? hotelClass;
  const SetFilter({
    this.hotelClass,
    this.rate,
    this.price});
}

class SetSort extends FilterEvent {
  final Sort sort;
  const SetSort(this.sort);
}

class ResetFilter extends FilterEvent {
  const ResetFilter();
}

class SetLastSort extends FilterEvent {
  final Sort sort;
  const SetLastSort(this.sort);
}
