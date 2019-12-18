import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/business.dart';

class BusinessReducers {
  updateEditedBusiness(Business business, AppState state) {
    state.userBusinesses.forEach((singleInvoice) {
      if (singleInvoice.id == business.id) {
        state.userBusinesses.remove(singleInvoice);
        state.userBusinesses.add(business);
      }
    });
  }
  removeEditedBusiness(Business business, AppState state) {
    var toRemove = [];
    state.userBusinesses.forEach( (removeBusiness) {
      if(removeBusiness.id == business.id)
        toRemove.add(removeBusiness);
    });
    state.userBusinesses.removeWhere( (removeBusiness) => toRemove.contains(removeBusiness));

  }

}




