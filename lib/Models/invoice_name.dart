class InvoiceName {
  String  title, poSoNumber, summary;
  int invoiceNumber;
  InvoiceName(this.title, this.invoiceNumber, this.poSoNumber, this.summary);

  InvoiceName.fromJson(Map<String, dynamic> jsonObject) {
    this.title = jsonObject['id'];
    this.invoiceNumber = jsonObject['name'];
    this.poSoNumber = jsonObject['email'];
    this.summary = jsonObject['description'];
  }
}
