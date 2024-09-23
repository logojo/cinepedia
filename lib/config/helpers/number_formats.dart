import 'package:intl/intl.dart';

class NumberFormats {
  static String number(double number, [int decimals = 0]) {
    final formattedNUmber = NumberFormat.compactCurrency(
            decimalDigits: decimals, symbol: '', locale: 'en')
        .format(number);

    return formattedNUmber;
  }

  static String shortDate(DateTime date) {
    final format = DateFormat.yMMMEd('es');
    return format.format(date);
  }
}
