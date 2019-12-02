import 'package:akount_books/Api/BusinessPage/get_invoice_items.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/item.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvoiceItems {
  Future<String> saveInvoiceItems(List<Item> items, invoiceId) async {
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createItem = new Mutations();
    items.forEach((item) async {
      await graphQLConfiguration.getGraphql().mutate(MutationOptions(
          document: createItem.createInvoiceItem(invoiceId, item.id)));
    });
    return "Done";
  }

  Future<String> updateInvoiceItems(List<Item> items, invoiceId) async {
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createItem = new Mutations();
    Mutations updateInvoiceIntem = new Mutations();
    List<dynamic> invoiceItems =
    await GetInvoiceItems().fetchInvoiceItems(invoiceId);
    if (invoiceItems.length==0) {
      items.forEach((updateItem) async {
        await graphQLConfiguration.getGraphql().mutate(MutationOptions(
            document: createItem.createInvoiceItem(invoiceId, updateItem.id)));
      });
    } else {
      for (var item in invoiceItems) {
        items.forEach((updateItem) async {
          if (updateItem.id == item["item_id"]) {

          }else if(item["item_id"]  != updateItem.id){
            QueryResult result = await graphQLConfiguration.getGraphql().mutate(
                MutationOptions(
                    document: updateInvoiceIntem.deleteInvoiceItem(
                        item["id"])));
            if(result.hasErrors){
              print(result.errors);
            }
          } else {
            await graphQLConfiguration.getGraphql().mutate(MutationOptions(
                document:
                createItem.createInvoiceItem(invoiceId, updateItem.id)));
          }
        });
      }
    }
    return "Done";
  }

}


