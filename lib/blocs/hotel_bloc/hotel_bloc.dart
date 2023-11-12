import 'package:equatable/equatable.dart';
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
    on<TestGetListHotel>(_testGetListHotel);
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

  /// For Unit Testing Purpose
  Future<void> _testGetListHotel(
      TestGetListHotel event,
      Emitter<HotelState> emitter) async {
    final mockData = [
      {
        "name":"Hotel Fairmont Nile City",
        "starts":5,
        "price":100,
        "currency":"USD",
        "image":"https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5cc0AnFUdZvcaT421NYlIIKB899kblH89FRaXRjheAxF0mYu56nxq7ybSts6ps0s7BI/8ugu12yto0k2T4b0SzW",
        "review_score":8.8,
        "review":"Excellent",
        "address":"12 miles from the center"
      },
      {
        "name":"The Nile Ritz-Carlton, Cairo",
        "starts":4,
        "price":152,
        "currency":"USD",
        "image":"https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5e5v0qrAGTD8pPBsj8/wYA5F3wAmN3NGLXEf+D2LJSjb9wh5q02IPvgE5Y644jFmrhHfzPKD0sNS9BJ+6lw6D/4HVvQLPYLTJNBCInGWDJLoA==",
        "review_score":9.5,
        "review":"Excellent",
        "address":"12 miles from the center"
      },
      {
        "name":"Sofitel Cairo Nile El Gezirah",
        "starts":4,
        "price":357,
        "currency":"USD",
        "image":"https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5e5v0qrAGTD8pPBsj8/wYA5F3wAmN3NGLVm2rNwwerpVUYiNRVVv8FNcYsn7tPDU3FV+magCmFcPSghPU9Lc2sJ",
        "review_score":7.5,
        "review":"Very Good",
        "address":"12 miles from the center"
      },
      {
        "name":"Waldorf Astoria Cairo Heliopolis",
        "starts":3,
        "price":479,
        "currency":"USD",
        "image":"https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5e5v0qrAGTD8pPBsj8/wYA5F3wAmN3NGLVydclVdmtcN20XzatOF04maVnB/B4ONU7Qud5axMsZAmGLHS8N1w9QtQ0yEzkR3EzJ3iP3ioTs27Y8VLpNflZt",
        "review_score":6,
        "review":"Good",
        "address":"12 miles from the center"
      },
      {
        "name":"The St. Regis Cairo",
        "starts":5,
        "price":450,
        "currency":"USD",
        "image":"https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5cnXBPA5qtgzmEk81OdW4gOACJSM44eMnSkPolkbCGAuWMC3o4nOPsWYljmT1TBwawng2VoXWR4s+9WPz3b0DmpEWCLBTXEGNoW00B1KNIg5mGBi4Gsz5hD",
        "review_score":10,
        "review":"Excellent",
        "address":"12 miles from the center"
      },
      {
        "name":"Hilton Cairo Zamalek Residences",
        "starts":5,
        "price":500,
        "currency":"USD",
        "image":"https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5e5v0qrAGTD8pPBsj8/wYA5F3wAmN3NGLVm2rNwwerpVezAcWi89O4bRddSNJQFnlp6VYyetJH/AV3V0tpWNIwVtYhhEkirVn4=",
        "review_score":9,
        "review":"Very Good",
        "address":"12 miles from the center"
      }
    ];
    emitter(state.copyWith(dataState: DataState.loading));
    final result = mockData.map((e) => Hotel.fromJson(e)).toList();
    emitter(state.copyWith(allItem: result, filteredItem: result, dataState: DataState.loaded));
  }
}