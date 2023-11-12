part of 'hotel_bloc.dart';

abstract class HotelEvent {
  const HotelEvent();
}

class GetListHotel extends HotelEvent {
  const GetListHotel();
}

class FilterListHotel extends HotelEvent {
  final FilterState filter;
  const FilterListHotel(this.filter);
}

class SortListHotel extends HotelEvent {
  final Sort sort;
  const SortListHotel(this.sort);
}