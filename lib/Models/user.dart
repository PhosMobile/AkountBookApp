class User {
  String userId, name, email, phone;

  User(
    this.userId,
    this.name,
    this.phone,
    this.email,
  );

  User.fromJson(Map<String, dynamic> jsonObject) {
    this.userId = jsonObject['id'];
    this.name = jsonObject['name'];
    this.phone = jsonObject['phone'];
    this.email = jsonObject['email'];
  }
}
