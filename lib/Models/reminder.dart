class Reminder {
  String id, date, invoice_id, customer_id, user_id;

  Reminder(this.id, this.date, this.invoice_id, this.customer_id, this.user_id);

  Reminder.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.date = jsonObject['title'];
    this.invoice_id = jsonObject['number'];
    this.customer_id = jsonObject['po_so_number'];
    this.user_id = jsonObject['summary'];
  }
}
