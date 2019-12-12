class Payment {
  String id,
      amountPaid,
      date,
      method,
      type,
      invoiceId,
      customerId,
      businessId,
      userId;

  Payment(this.id, this.amountPaid, this.date, this.method, this.type,
      this.invoiceId, this.customerId, this.businessId, this.userId);

  Payment.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.amountPaid = jsonObject['name'];
    this.date = jsonObject['email'];
    this.method = jsonObject['description'];
    this.type = jsonObject['address'];
    this.invoiceId = jsonObject['currency'];
    this.customerId = jsonObject['image_url'];
    this.businessId = jsonObject['user_id'];
    this.userId = jsonObject['user_id'];
  }
}
