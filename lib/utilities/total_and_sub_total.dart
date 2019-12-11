import 'package:akount_books/AppState/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TotalAndSubTotal{
  int getSubTotal(context, isNewInvoice){
    int subTotal = 0;
    final store = StoreProvider.of<AppState>(context);
    if(isNewInvoice) {
      store.state.invoiceItems.forEach((item) {
        subTotal = subTotal + int.parse(item.price);
      });
    }else{
      store.state.editInvoice.invoiceItem.forEach((item) {
        subTotal = subTotal + int.parse(item.price);
      });
    }
    return subTotal;
  }

}