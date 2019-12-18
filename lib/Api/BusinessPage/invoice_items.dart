import 'package:akaunt/Api/BusinessPage/get_invoice_items.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/mutations.dart';
import 'package:akaunt/Models/item.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvoiceItems {
  Future<String> saveInvoiceItems(List<Item> items, invoiceId, context) async {
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createItem = new Mutations();
    items.forEach((item) async {
      await graphQLConfiguration.getGraphql(context).mutate(MutationOptions(
          document: createItem.createInvoiceItem(invoiceId, item.id)));
    });
    return "Done";
  }

  Future<String> updateInvoiceItems(List<Item> items, invoiceId, context) async {
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createItem = new Mutations();
    Mutations updateInvoiceItem = new Mutations();
    List<dynamic> invoiceItems =
        await GetInvoiceItems().fetchInvoiceItems(invoiceId, context);
    if (invoiceItems.length == 0) {
      items.forEach((updateItem) async {
        await graphQLConfiguration.getGraphql(context).mutate(MutationOptions(
            document: createItem.createInvoiceItem(invoiceId, updateItem.id)));
      });
    } else {
      for (var item in invoiceItems) {
        QueryResult result = await graphQLConfiguration.getGraphql(context).mutate(
            MutationOptions(
                document: updateInvoiceItem.deleteInvoiceItem(item["id"])));
        if (result.hasErrors) {
          print(result.errors);
        }
      }
      items.forEach((updateItem) async {
        await graphQLConfiguration.getGraphql(context).mutate(MutationOptions(
            document: createItem.createInvoiceItem(invoiceId, updateItem.id)));
      });
    }
    return "Done";
  }
}
