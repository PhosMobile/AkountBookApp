class Customer {
  String id,
      name,
      email,
      phone,
      address,
      currency,
      imageUrl,
      businessId,
      userId;

  Customer(this.id, this.name, this.email, this.phone, this.address,
      this.currency, this.imageUrl, this.businessId, this.userId);

  Customer.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['name'];
    this.email = jsonObject['email'];
    this.phone = jsonObject['phone'];
    this.address = jsonObject['address'];
    this.currency = jsonObject['currency'];
    this.imageUrl = jsonObject['image_url'];
    this.businessId = jsonObject['business_id'];
    this.userId = jsonObject['user_id'];
  }

}
