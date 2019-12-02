import 'customer.dart';
import 'item.dart';

class EditInvoice {
  String id,
      title,
      summary,
      issue_date,
      due_date,
      notes,
      status,
      footer,
      customer_id,
      business_id,
      user_id,
      po_so_number;
  int number;
  int sub_total_amount,total_amount;
  List<Item> invoiceItem = [];

  Customer invoiceCustomer;

  EditInvoice(
      this.id,
      this.title,
      this.number,
      this.po_so_number,
      this.summary,
      this.issue_date,
      this.due_date,
      this.sub_total_amount,
      this.total_amount,
      this.notes,
      this.status,
      this.footer,
      this.customer_id,
      this.business_id,
      this.user_id,
      this.invoiceItem,
      this.invoiceCustomer
      );


}
