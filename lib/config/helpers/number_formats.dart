import 'package:intl/intl.dart';

class NumberFormats {
  static String number(double number) {
    final formattedNUmber =
        NumberFormat.compactCurrency(decimalDigits: 0, symbol: '', locale: 'en')
            .format(number);

    return formattedNUmber;
  }
}
