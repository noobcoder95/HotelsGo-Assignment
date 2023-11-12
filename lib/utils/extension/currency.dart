import 'package:hotels_go/utils/enums/currency.dart';

extension CurrencyExtension on Currency {
  String get symbol {
    switch (this) {
      case Currency.usd:
        return '\$';
    }
  }

  String get label {
    switch (this) {
      case Currency.usd:
        return 'USD';
    }
  }
}