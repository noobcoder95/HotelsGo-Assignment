import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotels_go/data/models/hotel.dart';
import 'package:hotels_go/localizations/locale_keys.g.dart';
import 'package:hotels_go/utils/assets.dart';
import 'package:hotels_go/utils/extension/currency.dart';
import 'package:image_network/image_network.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({super.key, required this.data});
  final Hotel data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
            ),
            child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if(kIsWeb) {
                        return ImageNetwork(
                          image: data.image,
                          borderRadius: BorderRadius.circular(10),
                          height: 200,
                          width: constraints.maxWidth,
                          fitWeb: BoxFitWeb.cover,
                          onLoading: const CircularProgressIndicator(),
                          onError: Icon(Icons.error, color: theme.colorScheme.error),
                        );
                      }
                      return Image.network(
                        data.image,
                        width: constraints.maxWidth,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, object, trace) =>
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Icon(Icons.error, color: theme.colorScheme.error),
                            ),
                          )
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20),
                      child: IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(.3)),
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.heart,
                          color: theme.colorScheme.background,
                        ),
                      ),
                    ),
                  )
                ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...List.generate((data.starts?.toInt() ?? 0), (index) =>
                        const Icon(Icons.star, size: 10, color: Colors.grey)),
                    const SizedBox(width: 5),
                    Text(
                      LocaleKeys.hotel,
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    data.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        '${data.reviewScore ?? 0}',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        data.review,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    JustTheTooltip(
                      tailLength: 0,
                      triggerMode: TooltipTriggerMode.tap,
                      backgroundColor: Colors.transparent,
                      content: InkWell(
                        onTap: () {
                          debugPrint('Tooltip Pressed');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theme.colorScheme.background,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(Assets.mapImage),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              FontAwesomeIcons.locationDot,
                              size: 10,
                            ),
                          ),
                          Text(
                            data.address,
                            style: theme.textTheme.labelMedium,
                          )
                        ],
                      ))
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey)
                ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: theme.colorScheme.primary.withOpacity(.5)
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          child: Text(
                            LocaleKeys.ourLowestPrice.tr(),
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  data.currencyEnum.symbol,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Text(
                                '${data.price ?? 0}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          LocaleKeys.renaissance.tr(),
                          style: theme.textTheme.labelSmall,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          LocaleKeys.viewDeal.tr(),
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 2, right: 5),
                          child: Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 14,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  LocaleKeys.morePrices.tr(),
                  style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.grey
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}