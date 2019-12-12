class Item {
  String id, name, description, quantity, price, businessId, userId;
  Item(this.id, this.name, this.description, this.quantity, this.price,
      this.businessId, this.userId);

  Item.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['name'];
    this.description = jsonObject['email'];
    this.quantity = jsonObject['description'];
    this.price = jsonObject['address'];
    this.businessId = jsonObject['currency'];
    this.userId = jsonObject['image_url'];
  }

}
