class Customer {
  String id,
      name,
      email,
      phone,
      address,
      currency,
      image_url,
      business_id,
      user_id;

  Customer(this.id, this.name, this.email, this.phone, this.address,
      this.currency, this.image_url, this.business_id, this.user_id);

  Customer.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['name'];
    this.email = jsonObject['email'];
    this.phone = jsonObject['phone'];
    this.address = jsonObject['address'];
    this.currency = jsonObject['currency'];
    this.image_url = jsonObject['image_url'];
    this.business_id = jsonObject['business_id'];
    this.user_id = jsonObject['user_id'];
  }

}
