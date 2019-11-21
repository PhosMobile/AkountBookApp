import 'package:akount_books/Models/business.dart';
import 'package:flutter/cupertino.dart';

class SaveUserBusinesses {
  final List<Business> payload;

  SaveUserBusinesses({@required this.payload});
}

class UpdateUserBusiness {
  final Business payload;

  UpdateUserBusiness({@required this.payload});
}

class UserCurrentBusiness {
  final Business payload;

  UserCurrentBusiness({@required this.payload});
}
