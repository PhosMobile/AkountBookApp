import 'customer.dart';
import 'item.dart';

class EditInvoice {
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
  int subTotalAmount,totalAmount;
  List<Item> invoiceItem = [];

  Customer invoiceCustomer;

  EditInvoice(
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
      this.invoiceItem,
      this.invoiceCustomer
      );


}
