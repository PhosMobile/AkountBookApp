class Receipt {
  String id,
      name,
      amount_paid,
      payment_date,
      payment_method,
      payment_type,
      status,
      invoice_id,
      business_id,
      user_id;

  Receipt(
      this.id,
      this.name,
      this.amount_paid,
      this.payment_date,
      this.payment_method,
      this.payment_type,
      this.status,
      this.invoice_id,
      this.business_id,
      this.user_id);

  Receipt.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['title'];
    this.amount_paid = jsonObject['number'];
    this.payment_date = jsonObject['po_so_number'];
    this.payment_method = jsonObject['summary'];
    this.payment_type = jsonObject['issue_date'];
    this.status = jsonObject['due_date'];
    this.invoice_id = jsonObject['sub_total_amount'];
    this.business_id = jsonObject['total_amount'];
    this.user_id = jsonObject['notes'];
  }
}
