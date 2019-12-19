import 'package:akaunt/AppState/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TotalAndSubTotal{
  double getSubTotal(context, isNewInvoice){
    double subTotal = 0;
    final store = StoreProvider.of<AppState>(context);
    if(isNewInvoice) {
      store.state.invoiceItems.forEach((item) {
        subTotal = subTotal + int.parse(item.price) * int.parse(item.quantity);
      });
    }else{
      store.state.editInvoice.invoiceItem.forEach((item) {
        subTotal = subTotal + int.parse(item.price);
      });
    }
    return subTotal;
  }

}