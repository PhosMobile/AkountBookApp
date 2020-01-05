import 'dart:convert';

import 'package:akaunt/Api/BusinessPage/current_business_data.dart';
import 'package:akaunt/AppState/actions/business_actions.dart';
import 'package:akaunt/AppState/actions/user_actions.dart';
import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Graphql/graphql_config.dart';
import 'package:akaunt/Graphql/queries.dart';
import 'package:akaunt/Models/user.dart';
import 'package:akaunt/Models/business.dart';
import 'package:akaunt/Screens/business_created.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoggedInUser {
  User user;
  List<Business> businesses = [];

  Future fetchLoggedInUser(context, from) async {
    final prefs = await SharedPreferences.getInstance();
    final business = StoreProvider.of<AppState>(context);

    GqlConfig graphQLConfiguration = GqlConfig();
    Queries queries = Queries();
    QueryResult result = await graphQLConfiguration.getGraphql(context).query(
          QueryOptions(
            document: queries.getLoggedInUser,
          ),
        );
    if (!result.hasErrors) {
      var data = result.data["me"];
      prefs.setString("returningUser", jsonEncode(data));
      var userBusiness = result.data["me"]["businesses"];
      user = new User(data["id"], data["name"], data["phone"], data["email"]);
      for (var item in userBusiness) {
        Business business = Business(
            item["id"],
            item["name"],
            item["email"],
            item["description"],
            item["address"],
            item["currency"],
            item["image_url"],
            item["user_id"]);
        businesses.add(business);
      }
      final saveUser = StoreProvider.of<AppState>(context);
      final saveUserBusiness = StoreProvider.of<AppState>(context);
      saveUser.dispatch(AddUser(payload: user));
      saveUserBusiness.dispatch(SaveUserBusinesses(payload: businesses));

      if (from == "registeration") {
        business.dispatch(UserCurrentBusiness(payload: businesses[0]));
        await CurrentBusinessData().getBusinessData(context, businesses[0].id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BusinessCreated()),
        );
      } else {
        business.dispatch(UserCurrentBusiness(payload: businesses[0]));
        await CurrentBusinessData().getBusinessData(context, businesses[0].id);
        Navigator.pushNamed(context, "/user_dashboard");
      }
    } else {
      print(result.errors);
    }
  }
}
