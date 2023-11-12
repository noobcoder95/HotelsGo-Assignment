import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotels_go/blocs/hotel_bloc/hotel_bloc.dart';
import 'package:hotels_go/localizations/locale_keys.g.dart';
import 'package:hotels_go/utils/assets.dart';
import 'package:hotels_go/utils/extension/build_context.dart';
import 'package:hotels_go/widgets/app_shimmer.dart';
import 'package:hotels_go/widgets/filter_bottom_sheet.dart';
import 'package:hotels_go/widgets/hotel_card.dart';
import 'package:hotels_go/widgets/sort_bottom_sheet.dart';

import 'blocs/filter_bloc/filter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _hotelBloc = HotelBloc();
  final _filterBloc = FilterBloc();

  @override
  void initState() {
    _hotelBloc.add(const GetListHotel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterAndSortShimmer = AppShimmer(height: 40, width: 80);
    return Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: context.screenWidth,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                /// Force mobile layout in web platform
                width: context.maxAllowedWidth,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: BlocBuilder<HotelBloc, HotelState>(
                        bloc: _hotelBloc,
                        builder: (context, state) {
                          if(state.isError || (state.isLoaded && state.filteredItem.isEmpty)) {
                            return Center(
                              child: Image.asset(Assets.emptyItemImage),
                            );
                          }

                          return ListView.separated(
                            separatorBuilder: (_, i) => const SizedBox(height: 10),
                            itemCount: state.isLoading
                                ? 3
                                : state.filteredItem.length,
                            itemBuilder: (context, index) {
                              Widget item;
                              if(state.isLoading) {
                                item = Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    child: AppShimmer(height: 300));
                              } else {
                                final data = state.filteredItem[index];
                                item = HotelCard(data: data);
                              }
                              if(index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 80),
                                  child: item,
                                );
                              }
                              return item;
                            },
                          );
                        },
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 10
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<HotelBloc, HotelState>(
                              bloc: _hotelBloc,
                              builder: (context, state) {
                                if(state.isLoading) {
                                  return filterAndSortShimmer;
                                }
                                return TextButton(
                                  onPressed: () => _showFilter(),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.sliders,
                                        color: theme.colorScheme.primary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        LocaleKeys.filters.tr(),
                                        style: theme.textTheme.titleMedium?.copyWith(
                                            color: theme.colorScheme.primary
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<HotelBloc, HotelState>(
                              bloc: _hotelBloc,
                              builder: (context, state) {
                                if(state.isLoading) {
                                  return filterAndSortShimmer;
                                }
                                return TextButton(
                                  onPressed: () => _showShort(),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.arrowDownWideShort,
                                        color: theme.colorScheme.primary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        LocaleKeys.sort.tr(),
                                        style: theme.textTheme.titleMedium?.copyWith(
                                            color: theme.colorScheme.primary,
                                            decoration: TextDecoration.underline,
                                            decorationColor: theme.colorScheme.primary
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  void _showFilter() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: false,
        builder: (context) {
          return FilterBottomSheet(
            filterBloc: _filterBloc,
            hotelBloc: _hotelBloc,
          );
        });
  }

  void _showShort() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: false,
        builder: (context) {
          return SortBottomSheet(
            filterBloc: _filterBloc,
            hotelBloc: _hotelBloc,
          );
        });
  }
}