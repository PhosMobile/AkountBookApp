
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/queries.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class GetInvoiceDiscounts{

  dynamic fetchInvoiceDiscounts(id, context) async {
    List<dynamic> invoiceDiscountList;
    GqlConfig graphQLConfiguration = GqlConfig();
    Queries queries = Queries();
    QueryResult result = await graphQLConfiguration.getGraphql(context).query(
      QueryOptions(
          document: queries.getDiscount,
          variables: {
            "invoice_id":id
          }
      ),
    );
    if (!result.hasErrors) {
      invoiceDiscountList =  result.data["get_discounts"];
      print(invoiceDiscountList);
      return invoiceDiscountList;
    }else{
      print(result.errors);
      return null;
    }
  }
}