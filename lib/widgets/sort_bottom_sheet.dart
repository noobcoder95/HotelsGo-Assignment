import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotels_go/blocs/filter_bloc/filter_bloc.dart';
import 'package:hotels_go/blocs/hotel_bloc/hotel_bloc.dart';
import 'package:hotels_go/localizations/locale_keys.g.dart';
import 'package:hotels_go/utils/enums/sort.dart';
import 'package:hotels_go/utils/extension/build_context.dart';
import 'package:hotels_go/utils/extension/sort.dart';

class SortBottomSheet extends StatelessWidget {
  final FilterBloc filterBloc;
  final HotelBloc hotelBloc;
  const SortBottomSheet({
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
          BlocBuilder<FilterBloc, FilterState>(
            bloc: filterBloc,
            builder: (context, state) {
              return ListView.separated(
                itemCount: Sort.values.length,
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Divider(),
                  );
                },
                itemBuilder: (context, index) {
                  final item = ListTile(
                    onTap: ()=> filterBloc.add(SetSort(Sort.values[index])),
                    title: Text(Sort.values[index].label),
                    trailing: state.sort == Sort.values[index]
                        ? Icon(
                      FontAwesomeIcons.check,
                      color: theme.colorScheme.primary,
                    )
                        : null,
                  );
                  if(index == 0) {
                    return Column(
                      children: [
                        const SizedBox(height: 80),
                        item,
                      ],
                    );
                  }
                  if((index + 1) == Sort.values.length) {
                    return Column(
                      children: [
                        item,
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Divider(),
                        )
                      ],
                    );
                  }
                  return item;
                },
              );
            },
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
                    Expanded(
                      child: Text(
                        LocaleKeys.sortBy.tr(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        filterBloc.add(SetSort(filterBloc.state.lastSort));
                      },
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
                    filterBloc.add(SetLastSort(filterBloc.state.sort));
                    hotelBloc.add(SortListHotel(filterBloc.state.sort));
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