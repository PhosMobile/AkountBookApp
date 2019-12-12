class Reminder {
  String id, date, invoiceId, customerId, userId;

  Reminder(this.id, this.date, this.invoiceId, this.customerId, this.userId);

  Reminder.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.date = jsonObject['title'];
    this.invoiceId = jsonObject['number'];
    this.customerId = jsonObject['po_so_number'];
    this.userId = jsonObject['summary'];
  }
}
