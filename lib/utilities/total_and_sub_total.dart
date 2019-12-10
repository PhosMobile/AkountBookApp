import 'package:akount_books/AppState/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TotalAndSubTotal{
  int getSubTotal(context){
    int subTotal = 0;
    final state = StoreProvider.of<AppState>(context);

    state.state.invoiceItems.forEach((item){
      subTotal = subTotal + int.parse(item.price);
    });
    return subTotal;
  }

  int getTotal(context){
    int subTotal = 0;
    final state = StoreProvider.of<AppState>(context);

    state.state.invoiceItems.forEach((item){
      subTotal = subTotal + int.parse(item.price);
    });
    return subTotal;
  }


}