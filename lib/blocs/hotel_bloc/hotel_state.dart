part of 'hotel_bloc.dart';

class HotelState {
  const HotelState({
    this.dataState = DataState.loading,
    this.allItem = const [],
    this.filteredItem = const []});
  
  final DataState dataState;
  final List<Hotel> allItem;
  final List<Hotel> filteredItem;

  bool get isLoaded => dataState == DataState.loaded;
  bool get isLoading => dataState == DataState.loading;
  bool get isError => dataState == DataState.error;

  HotelState copyWith({
    DataState? dataState,
    List<Hotel>? allItem,
    List<Hotel>? filteredItem
  })=> HotelState(
    dataState: dataState ?? this.dataState,
    allItem: allItem ?? this.allItem,
    filteredItem: filteredItem ?? this.filteredItem);
}