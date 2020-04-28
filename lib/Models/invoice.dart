import 'package:akaunt/Models/receipt.dart';

import 'customer.dart';
import 'item.dart';

class Invoice {
  String id,
      title,
      summary,
      issueDate,
      dueDate,
      notes,
      status,
      footer,
      customerId,
      businessId,
      userId,
      poSoNumber;
  int number;
  double subTotalAmount,totalAmount;

  List<Item> invoiceItem = [];
  Customer invoiceCustomer;

  Invoice(
      this.id,
      this.title,
      this.number,
      this.poSoNumber,
      this.summary,
      this.issueDate,
      this.dueDate,
      this.subTotalAmount,
      this.totalAmount,
      this.notes,
      this.status,
      this.footer,
      this.customerId,
      this.businessId,
      this.userId,
      );
  Invoice.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.title = jsonObject['title'];
    this.number = jsonObject['number'];
    this.poSoNumber = jsonObject['po_so_number'];
    this.summary = jsonObject['summary'];
    this.issueDate = jsonObject['issue_date'];
    this.dueDate = jsonObject['due_date'];
    this.subTotalAmount = jsonObject['sub_total_amount'];
    this.totalAmount = jsonObject['total_amount'];
    this.notes = jsonObject['notes'];
    this.status = jsonObject['status'];
    this.footer = jsonObject['footer'];
    this.customerId = jsonObject['customer_id'];
    this.businessId = jsonObject['business_id'];
    this.status = jsonObject['user_id'];
  }

  static List<Invoice> draftInvoices(List<Invoice> invoices){
    List<Invoice> draftInvoices = [];
    invoices.forEach((invoice){
        if(invoice.status.toLowerCase() == "draft"){
          draftInvoices.add(invoice);
        }
    });
    return draftInvoices;
  }

 static List<Invoice> sentInvoices(List<Invoice> invoices){
    List<Invoice> draftInvoices = [];
    invoices.forEach((invoice){
      if(invoice.status.toLowerCase() == "sent" || invoice.status.toLowerCase() == "paid" || invoice.status.toLowerCase() == "due"){
        draftInvoices.add(invoice);
      }
    });
    return draftInvoices;
  }

  static List<Invoice> customerInvoices(List<Invoice> invoices, customerId){
    List<Invoice> customerInvoices = [];
    invoices.forEach((invoice){
      if(invoice.customerId == customerId && invoice.status.toLowerCase() != "draft"){
        customerInvoices.add(invoice);
      }
    });
    return customerInvoices;
  }


  static Customer getInvoiceCustomer(String id, List<Customer> customers){
    Customer iCustomer;
    customers.forEach((customer){
      if(customer.id == id){
        iCustomer =customer;
      }
    });
    return iCustomer;
  }


  static double calculateInvoiceBalance(List<Receipt> receipts, double invoiceAmount){
    double amount = 0;
    receipts.forEach((re){
      amount = amount + double.parse(re.amountPaid);
    });
    return invoiceAmount - amount;
  }



}
