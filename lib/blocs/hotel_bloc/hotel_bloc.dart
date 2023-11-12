import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotels_go/blocs/filter_bloc/filter_bloc.dart';
import 'package:hotels_go/data/models/hotel.dart';
import 'package:hotels_go/utils/app_helpers.dart';
import 'package:hotels_go/utils/enums/data_state.dart';
import 'package:hotels_go/utils/enums/sort.dart';
import 'package:hotels_go/utils/extension/hotel_class.dart';
import 'package:hotels_go/utils/extension/rate.dart';
import 'package:hotels_go/utils/http_helper.dart';

part 'hotel_event.dart';
part 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  HotelBloc({HotelState? initialState}) : super(const HotelState()) {
    on<GetListHotel>(_getListHotel);
    on<FilterListHotel>(_filterListHotel);
    on<SortListHotel>(_sortListHotel);
  }

  Future<void> _getListHotel(
      GetListHotel event,
      Emitter<HotelState> emitter) async {
    emitter(state.copyWith(dataState: DataState.loading));
    final response = await HttpHelper.get('hotels');
    if(response.data == null) {
      AppHelpers.showSnackBar(message: response.message);
      emitter(state.copyWith(dataState: DataState.error));
    } else {
      final List<Hotel> items = ((response.data as List?) ?? [])
          .map((e) => Hotel.fromJson(e)).toList();
      emitter(state.copyWith(allItem: items, filteredItem: items, dataState: DataState.loaded));
    }
  }

  _filterListHotel(
      FilterListHotel event,
      Emitter<HotelState> emitter) {
    if(state.allItem.isNotEmpty) {
      final List<Hotel> items = [];
      items.addAll(state.allItem.where((e) {
        bool priceFilter = true;
        bool rateFilter = true;
        bool classFilter = true;
        if(event.filter.price != null) {
          priceFilter = (e.price ?? 0) >= event.filter.price!;
        }
        if(event.filter.rate != null) {
          rateFilter = (e.reviewScore ?? 0) >= event.filter.rate!.value;
        }
        if(event.filter.hotelClass != null) {
          classFilter = (e.starts ?? 0) >= event.filter.hotelClass!.value;
        }
        return priceFilter && classFilter && rateFilter;
      }));
      emitter(state.copyWith(filteredItem: items));
      add(SortListHotel(event.filter.lastSort));
    }
  }

  void _sortListHotel(
      SortListHotel event,
      Emitter<HotelState> emitter) {
    final List<Hotel> items = [];
    items.addAll(state.filteredItem);
    if(items.isNotEmpty && event.sort != Sort.ourRecommendations) {
      items.sort((a, b) {
        final priceA = a.price ?? 0;
        final priceARecommended = priceA + b.recommendation.index;
        final priceB = b.price ?? 0;
        final priceBRecommended = priceB + b.recommendation.index;

        final rateA = a.reviewScore ?? 0;
        final rateARecommended = rateA + b.recommendation.index;
        final rateB = b.reviewScore ?? 0;
        final rateBRecommended = rateB + b.recommendation.index;

        /// Since all distance values given by the API response are the same
        /// sorting item by distance is useless
        final distanceA = a.distance ?? 0;
        final distanceARecommended = distanceA + b.recommendation.index;
        final distanceB = b.distance ?? 0;
        final distanceBRecommended = rateB + b.recommendation.index;

        switch (event.sort) {
          case Sort.priceAndRecommended:
            return priceARecommended.compareTo(priceBRecommended);
          case Sort.ratingAdRecommended:
            return rateBRecommended.compareTo(rateARecommended);
          case Sort.distanceAndRecommended:
            return distanceBRecommended.compareTo(distanceARecommended);
          case Sort.priceOnly:
            return priceB.compareTo(priceA);
          case Sort.ratingOnly:
            return rateA.compareTo(rateB);
          case Sort.distanceOnly:
            return distanceA.compareTo(distanceB);
          default:
            return 0;
        }
      });
    }
    emitter(state.copyWith(filteredItem: items));
  }
}