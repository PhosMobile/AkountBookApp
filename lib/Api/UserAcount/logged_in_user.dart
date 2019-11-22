import 'package:akount_books/Api/BusinessPage/current_business_data.dart';
import 'package:akount_books/AppState/actions/business_actions.dart';
import 'package:akount_books/AppState/actions/user_actions.dart';
import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Graphql/queries.dart';
import 'package:akount_books/Models/user.dart';
import 'package:akount_books/Models/business.dart';
import 'package:akount_books/Screens/business_created.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:localstorage/localstorage.dart';

class LoggedInUser {
  User user;
  List<Business> businesses = [];

  Future fetchLoggedInUser(context, from) async {
    final LocalStorage storage = new LocalStorage('some_key');
    final business = StoreProvider.of<AppState>(context);

    GqlConfig graphQLConfiguration = GqlConfig();
    Queries queries = Queries();
    QueryResult result = await graphQLConfiguration.getGraphql().query(
      QueryOptions(
        document: queries.getLoggedInUser,
      ),
    );
    if (!result.hasErrors) {
      var data = result.data["me"];
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
        CurrentBusinessData().getBusinessData(context, businesses[0].id);
//                              Navigator.pushNamed(context, "/user_dashboard");
        Navigator.push(
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
      print(result.source);
    }
  }
}
