import 'package:akount_books/AppState/app_state.dart';
import 'package:akount_books/Models/customer.dart';
import 'package:akount_books/Models/invoice.dart';
import 'package:akount_books/Models/invoice_name.dart';
import 'package:akount_books/Models/item.dart';

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
        state.businessInvoices.add(invoice);
      }
    });
  }

}

