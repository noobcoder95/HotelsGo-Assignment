import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotels_go/utils/enums/hotel_class.dart';
import 'package:hotels_go/utils/enums/rate.dart';
import 'package:hotels_go/utils/enums/sort.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc({FilterState? initialState}) : super(const FilterState()) {
    on<SetFilter>(_setFilter);
    on<SetSort>(_setSort);
    on<ResetFilter>(_resetFilter);
    on<SetLastSort>(_setLastSelectedSort);
  }

  _setFilter(
      SetFilter event,
      Emitter<FilterState> emitter) {
    emitter(state.copyWith(
      price: event.price,
      rate: event.rate,
      hotelClass: event.hotelClass));
  }

  _setSort(
      SetSort event,
      Emitter<FilterState> emitter) {
    emitter(state.copyWith(sort: event.sort));
  }

  _setLastSelectedSort(
      SetLastSort event,
      Emitter<FilterState> emitter) {
    emitter(state.copyWith(lastSort: event.sort));
  }

  _resetFilter(
      ResetFilter event,
      Emitter<FilterState> emitter) {
    final sort = state.lastSort;
    emitter(FilterState(lastSort: sort, sort: sort));
  }
}