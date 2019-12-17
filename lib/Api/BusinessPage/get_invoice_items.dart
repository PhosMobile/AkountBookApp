
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/queries.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class GetInvoiceItems{

  dynamic fetchInvoiceItems(id, context) async {
    List<dynamic> invoiceItemList;
    GqlConfig graphQLConfiguration = GqlConfig();
    Queries queries = Queries();
    QueryResult result = await graphQLConfiguration.getGraphql(context).query(
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