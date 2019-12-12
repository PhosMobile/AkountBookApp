class Business {
  String id, name, email, description, address, currency, imageUrl, userId;

  Business(this.id, this.name, this.email, this.description, this.address,
      this.currency, this.imageUrl, this.userId);

  Business.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['name'];
    this.email = jsonObject['email'];
    this.description = jsonObject['description'];
    this.address = jsonObject['address'];
    this.currency = jsonObject['currency'];
    this.imageUrl = jsonObject['image_url'];
    this.userId = jsonObject['user_id'];
  }
}
