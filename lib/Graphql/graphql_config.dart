import "package:flutter/material.dart";

//import "package:graphql_flutter/graphql_flutter.dart";
import 'package:localstorage/localstorage.dart';
import 'package:graphql/client.dart';

class GqlConfig {
  GraphQLClient getGraphql() {
    String tk = "";
    AuthLink _authLink = AuthLink(
      getToken: () async => '',
    );

    final LocalStorage storage = new LocalStorage('some_key');
    final HttpLink _httpLink = HttpLink(
      uri: 'http://10.0.2.2:8000//graphql',
    );
    if (storage.getItem("access_token") != null) {
      tk = storage.getItem("access_token")["access_token"];
      _authLink = AuthLink(
        getToken: () async => 'Bearer $tk',
      );
    }

    final Link _link = _authLink.concat(_httpLink);

    GraphQLClient clientToQuery = GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );
    return clientToQuery;
  }
}
