class Business {
  String id, name, email, description, address, currency, image_url, user_id;

  Business(this.id, this.name, this.email, this.description, this.address,
      this.currency, this.image_url, this.user_id);

  Business.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['name'];
    this.email = jsonObject['email'];
    this.description = jsonObject['description'];
    this.address = jsonObject['address'];
    this.currency = jsonObject['currency'];
    this.image_url = jsonObject['image_url'];
    this.user_id = jsonObject['user_id'];
  }
}
