class Payment {
  String id,
      amount_paid,
      date,
      method,
      type,
      invoice_id,
      customer_id,
      business_id,
      user_id;

  Payment(this.id, this.amount_paid, this.date, this.method, this.type,
      this.invoice_id, this.customer_id, this.business_id, this.user_id);

  Payment.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.amount_paid = jsonObject['name'];
    this.date = jsonObject['email'];
    this.method = jsonObject['description'];
    this.type = jsonObject['address'];
    this.invoice_id = jsonObject['currency'];
    this.customer_id = jsonObject['image_url'];
    this.business_id = jsonObject['user_id'];
    this.user_id = jsonObject['user_id'];
  }
}
