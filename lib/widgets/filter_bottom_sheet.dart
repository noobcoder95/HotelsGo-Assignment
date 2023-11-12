import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotels_go/blocs/filter_bloc/filter_bloc.dart';
import 'package:hotels_go/blocs/hotel_bloc/hotel_bloc.dart';
import 'package:hotels_go/localizations/locale_keys.g.dart';
import 'package:hotels_go/utils/enums/currency.dart';
import 'package:hotels_go/utils/enums/hotel_class.dart';
import 'package:hotels_go/utils/enums/rate.dart';
import 'package:hotels_go/utils/extension/build_context.dart';
import 'package:hotels_go/utils/extension/currency.dart';
import 'package:hotels_go/utils/extension/hotel_class.dart';
import 'package:hotels_go/utils/extension/rate.dart';

class FilterBottomSheet extends StatelessWidget {
  final FilterBloc filterBloc;
  final HotelBloc hotelBloc;
  const FilterBottomSheet({
    super.key,
    required this.filterBloc,
    required this.hotelBloc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10)
          )
      ),
      child: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.pricePerNight.tr().toUpperCase(),
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: BlocBuilder<FilterBloc, FilterState>(
                        bloc: filterBloc,
                        builder: (context, state) {
                          return Text(
                            '${(state.price ?? 20).toInt()}+ ${Currency.usd.symbol}',
                            style: theme.textTheme.titleSmall,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<FilterBloc, FilterState>(
                        bloc: filterBloc,
                        builder: (context, state) {
                          return CupertinoSlider(
                            min: 20,
                            max: 540,
                            value: (state.price ?? 20).toDouble(),
                            onChanged: (value) => filterBloc.add(SetFilter(price: value)),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${Currency.usd.symbol}20',
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          '${Currency.usd.symbol}540+',
                          style: theme.textTheme.titleSmall,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.rating.tr().toUpperCase(),
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<FilterBloc, FilterState>(
                      bloc: filterBloc,
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: Rate.values.map((e) => InkWell(
                            onTap: ()=> filterBloc.add(SetFilter(rate: e)),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: e.color,
                                  borderRadius: BorderRadius.circular(4),
                                  border: state.rate == e
                                      ? Border.all(width: 2)
                                      : null
                              ),
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                '${e.value}+',
                                style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.background,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )).toList(),
                        );
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.hotelClass.tr().toUpperCase(),
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<FilterBloc, FilterState>(
                      bloc: filterBloc,
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: HotelClass.values.map((e) => InkWell(
                            onTap: ()=> filterBloc.add(SetFilter(hotelClass: e)),
                            child: Stack(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.amber),
                                      image: DecorationImage(image: AssetImage(e.assetPath), fit: BoxFit.cover)
                                  ),
                                ),
                                if(state.hotelClass == e)
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: theme.colorScheme.primary.withOpacity(0.2)
                                    ),
                                  )
                              ],
                            ),
                          )).toList(),
                        );
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  LocaleKeys.distanceFrom.tr().toUpperCase(),
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Divider(),
              ),
              InkWell(
                onTap: () {
                  debugPrint('Location Pressed');
                },
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            LocaleKeys.location.tr(),
                            style: theme.textTheme.titleSmall
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                LocaleKeys.cityCenter.tr(),
                                style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.grey
                                )
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                  FontAwesomeIcons.chevronRight,
                                  size: 14,
                                  color: Colors.grey
                              ),
                            )
                          ],
                        )
                      ],
                    )
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 100),
                child: Divider(),
              ),
            ],
          ),
          Positioned(
            top: 0,
            child: Card(
              elevation: 5,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)
                  )
              ),
              margin: EdgeInsets.zero,
              child: Container(
                width: context.maxBottomSheetWidth,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => filterBloc.add(const ResetFilter()),
                      child: Text(
                        LocaleKeys.reset.tr(),
                        style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      LocaleKeys.filters.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: context.maxBottomSheetWidth,
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, -1.0),
                    blurRadius: 6.0,
                  ),
                ]
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: MaterialButton(
                  color: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  onPressed: () {
                    hotelBloc.add(FilterListHotel(filterBloc.state));
                    Navigator.pop(context);
                  },
                  child: Text(
                    LocaleKeys.showResult.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.background),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}