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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }


}

