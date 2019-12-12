class Expense {
  String id, name, description, quantity, price, date, businessId, userId;

  Expense(this.id, this.name, this.description, this.quantity, this.price,
      this.date, this.businessId, this.userId);

  Expense.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['title'];
    this.description = jsonObject['number'];
    this.quantity = jsonObject['po_so_number'];
    this.price = jsonObject['summary'];
    this.date = jsonObject['issue_date'];
    this.businessId = jsonObject['due_date'];
    this.userId = jsonObject['sub_total_amount'];
  }
}
