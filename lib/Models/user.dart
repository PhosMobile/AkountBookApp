class User {
  String user_id, name, email, phone;

  User(
    this.user_id,
    this.name,
    this.phone,
    this.email,
  );

  User.fromJson(Map<String, dynamic> jsonObject) {
    this.user_id = jsonObject['id'];
    this.name = jsonObject['name'];
    this.phone = jsonObject['phone'];
    this.email = jsonObject['email'];
  }
}
