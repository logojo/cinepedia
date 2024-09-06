import 'package:intl/intl.dart';

class NumberFormats {
  static String number(double number, [int decimals = 0]) {
    final formattedNUmber = NumberFormat.compactCurrency(
            decimalDigits: decimals, symbol: '', locale: 'en')
        .format(number);

    return formattedNUmber;
  }
}
