import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/customer.dart';
import 'package:akaunt/Models/invoice.dart';
import 'package:akaunt/Models/invoice_name.dart';
import 'package:akaunt/Models/item.dart';

class InvoiceReducers{
  updateEditInvoiceName(InvoiceName iName, AppState state){
    state.editInvoice.title = iName.title;
    state.editInvoice.number = iName.invoiceNumber;
    state.editInvoice.poSoNumber = iName.poSoNumber;
    state.editInvoice.summary = iName.summary;
  }
  editInvoiceCustomer(Customer customer, AppState state){
    state.editInvoice.invoiceCustomer = customer;
  }
  editInvoiceItems(List<Item> items, AppState state){
    state.editInvoice.invoiceItem = items;
  }
  updateBusinessInvoice(Invoice invoice, AppState state){
    state.businessInvoices.forEach((singleInvoice){
      if(singleInvoice.id == invoice.id){
        state.businessInvoices.remove(singleInvoice);
        state.businessInvoices.insert(0,invoice);
      }
    });
  }

}

