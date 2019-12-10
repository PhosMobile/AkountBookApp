import 'package:intl/intl.dart';

class CurrencyConverter {
  final formatter = new NumberFormat("#,###");

  String formatPrice(price, currency) {
    var formattedPrice = formatter.format(price);
    var amount = "";
    switch (currency) {
      case "USD":
        {
          amount = "\$ " + formattedPrice;
          break;
        }

      case "NGN":
        {
          amount = "N " + formattedPrice;
          break;
        }

      case "EUR":
        {
          amount = "£ " + formattedPrice;
          break;
        }
      default:
        {
          amount = "N " + formattedPrice;
        }
    }

    return amount;
  }
}
