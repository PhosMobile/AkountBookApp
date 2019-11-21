class Expense {
  String id, name, description, quantity, price, date, business_id, user_id;

  Expense(this.id, this.name, this.description, this.quantity, this.price,
      this.date, this.business_id, this.user_id);

  Expense.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['title'];
    this.description = jsonObject['number'];
    this.quantity = jsonObject['po_so_number'];
    this.price = jsonObject['summary'];
    this.date = jsonObject['issue_date'];
    this.business_id = jsonObject['due_date'];
    this.user_id = jsonObject['sub_total_amount'];
  }
}
