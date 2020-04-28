import 'package:akaunt/Api/BusinessPage/get_invoice_items.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Models/discount.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvoiceDiscounts {
  Future<String> saveInvoiceDiscounts(
      List<Discount> discounts, invoiceId, context) async {
    final store = StoreProvider.of<AppState>(context);
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createDiscount = new Mutations();
    discounts.forEach((discount) async {
      await graphQLConfiguration.getGraphql(context).mutate(MutationOptions(
          document: createDiscount.createDiscount(
              discount.description,
              discount.amount,
              discount.dType,
              invoiceId,
              store.state.currentBusiness.id,
              store.state.loggedInUser.userId)));
    });
    return "Done";
  }

  Future<String> updateInvoiceDiscounts(
      List<Discount> discounts, invoiceId, context) async {
    final store = StoreProvider.of<AppState>(context);
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createItem = new Mutations();
    Mutations updateInvoiceDiscount = new Mutations();
    List<dynamic> invoiceItems =
        await GetInvoiceItems().fetchInvoiceItems(invoiceId, context);
    if (invoiceItems.length == 0) {
      discounts.forEach((updateDiscount) async {
        await graphQLConfiguration.getGraphql(context).mutate(MutationOptions(
            document: createItem.createDiscount( updateDiscount.description,
                updateDiscount.amount,
                updateDiscount.dType,
                invoiceId,
                store.state.currentBusiness.id,
                store.state.loggedInUser.userId)));
      });
    } else {
      for (var discount in invoiceItems) {
        QueryResult result = await graphQLConfiguration
            .getGraphql(context)
            .mutate(MutationOptions(
                document: updateInvoiceDiscount.deleteInvoiceDiscount(discount["id"])));
        if (result.hasErrors) {
          print(result.errors);
        }
      }
      discounts.forEach((updateDiscount) async {
        await graphQLConfiguration.getGraphql(context).mutate(MutationOptions(
            document: createItem.createDiscount( updateDiscount.description,
                updateDiscount.amount,
                updateDiscount.dType,
                invoiceId,
                store.state.currentBusiness.id,
                store.state.loggedInUser.userId)));
      });
    }
    return "Done";
  }
}
