import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';

class CustomerReducers{
  updateEditedCustomer(Customer customer, AppState state) {
    state.businessCustomers.forEach((exp) {
      if (customer.id == exp.id) {
        state.businessCustomers.remove(exp);
        state.businessCustomers.insert(0, customer);
      }
    });
  }
  deleteCustomer(Customer customer, AppState state) {
    state.businessCustomers.removeWhere((item) => item.id == customer.id);
  }
}