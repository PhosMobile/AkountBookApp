
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/queries.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class GetInvoiceItems{

  dynamic fetchInvoiceItems(id) async {
    List<dynamic> invoiceItemList;
    GqlConfig graphQLConfiguration = GqlConfig();
    Queries queries = Queries();
    QueryResult result = await graphQLConfiguration.getGraphql().query(
      QueryOptions(
        document: queries.getInvoiceItem,
        variables: {
          "invoice_id":id
        }
      ),
    );
    if (!result.hasErrors) {
      invoiceItemList =  result.data["get_invoice_item"];
      return invoiceItemList;
    }else{
      return null;
    }
  }
}