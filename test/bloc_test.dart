import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotels_go/blocs/hotel_bloc/hotel_bloc.dart';
import 'package:hotels_go/data/models/hotel.dart';
import 'package:hotels_go/utils/enums/data_state.dart';

void main() {
  group('Hotel Bloc Test', () {
    late HotelBloc hotelBloc;
    final List<Hotel> hotels = [];

    setUp(() {
      hotelBloc = HotelBloc();
      hotels.addAll([
        const Hotel(
            name: "Hotel Fairmont Nile City",
            starts: 5,
            price: 100,
            currency: "USD",
            image: "https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5cc0AnFUdZvcaT421NYlIIKB899kblH89FRaXRjheAxF0mYu56nxq7ybSts6ps0s7BI/8ugu12yto0k2T4b0SzW",
            reviewScore: 8.8,
            review: "Excellent",
            address: "12 miles from the center"
        ),
        const Hotel(
             name: "The Nile Ritz-Carlton, Cairo",
             starts: 4,
             price: 152,
             currency: "USD",
             image: "https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5e5v0qrAGTD8pPBsj8/wYA5F3wAmN3NGLXEf+D2LJSjb9wh5q02IPvgE5Y644jFmrhHfzPKD0sNS9BJ+6lw6D/4HVvQLPYLTJNBCInGWDJLoA==",
             reviewScore: 9.5,
             review: "Excellent",
             address: "12 miles from the center"
        ),
        const Hotel(
             name: "Sofitel Cairo Nile El Gezirah",
             starts: 4,
             price: 357,
             currency: "USD",
             image: "https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5e5v0qrAGTD8pPBsj8/wYA5F3wAmN3NGLVm2rNwwerpVUYiNRVVv8FNcYsn7tPDU3FV+magCmFcPSghPU9Lc2sJ",
             reviewScore: 7.5,
             review: "Very Good",
             address: "12 miles from the center"
        ),
        const Hotel(
             name: "Waldorf Astoria Cairo Heliopolis",
             starts: 3,
             price: 479,
             currency: "USD",
             image: "https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5e5v0qrAGTD8pPBsj8/wYA5F3wAmN3NGLVydclVdmtcN20XzatOF04maVnB/B4ONU7Qud5axMsZAmGLHS8N1w9QtQ0yEzkR3EzJ3iP3ioTs27Y8VLpNflZt",
             reviewScore: 6,
             review: "Good",
             address: "12 miles from the center"
        ),
        const Hotel(
             name: "The St. Regis Cairo",
             starts: 5,
             price: 450,
             currency: "USD",
             image: "https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5cnXBPA5qtgzmEk81OdW4gOACJSM44eMnSkPolkbCGAuWMC3o4nOPsWYljmT1TBwawng2VoXWR4s+9WPz3b0DmpEWCLBTXEGNoW00B1KNIg5mGBi4Gsz5hD",
             reviewScore: 10,
             review: "Excellent",
             address: "12 miles from the center"
        ),
        const Hotel(
             name: "Hilton Cairo Zamalek Residences",
             starts: 5,
             price: 500,
             currency: "USD",
             image: "https://www.tboholidays.com//imageresource.aspx?img=FbrGPTrju5e5v0qrAGTD8pPBsj8/wYA5F3wAmN3NGLVm2rNwwerpVezAcWi89O4bRddSNJQFnlp6VYyetJH/AV3V0tpWNIwVtYhhEkirVn4=",
             reviewScore: 9,
             review: "Very Good",
             address: "12 miles from the center"
        )
      ]);
    });

    blocTest<HotelBloc, HotelState>(
      'Test Get List Hotel Event',
      build: () => hotelBloc,
      act: (bloc) => bloc.add(const TestGetListHotel()),
      expect: () => [
        const HotelState(),
        HotelState(
          dataState: DataState.loaded,
          allItem: hotels,
          filteredItem: hotels
        )
      ]
    );
    
    tearDown(() => hotelBloc.close());
  });
}
