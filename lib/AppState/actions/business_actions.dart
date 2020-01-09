import 'package:akaunt/Models/business.dart';
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

class UpdateEditedBusiness {
  final Business payload;

  UpdateEditedBusiness({@required this.payload});
}

class RemoveDeletedBusiness {
  final Business payload;

  RemoveDeletedBusiness({@required this.payload});
}
