import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/mutations.dart';
import 'package:akount_books/Models/item.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvoiceItems {
  Future<String> saveInvoiceItems(List<Item> items, invoiceId) async {
    GqlConfig graphQLConfiguration = GqlConfig();
    Mutations createItem = new Mutations();
    items.forEach((item) async{
        await graphQLConfiguration.getGraphql().mutate(
          MutationOptions(
              document: createItem.createInvoiceItem(invoiceId, item.id)));
    });
    return "Done";
  }
}