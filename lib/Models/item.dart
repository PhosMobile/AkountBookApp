class Item {
  String id, name, description, quantity, price, business_id, user_id;

  Item(this.id, this.name, this.description, this.quantity, this.price,
      this.business_id, this.user_id);

  Item.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['name'];
    this.description = jsonObject['email'];
    this.quantity = jsonObject['description'];
    this.price = jsonObject['address'];
    this.business_id = jsonObject['currency'];
    this.user_id = jsonObject['image_url'];
  }
}
