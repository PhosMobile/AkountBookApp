class Receipt {
  String id,
      name,
      amountPaid,
      paymentDate,
      paymentMethod,
      paymentType,
      status,
      invoiceId,
      businessId,
      customerId,
      userId;

  Receipt(
      this.id,
      this.name,
      this.amountPaid,
      this.paymentDate,
      this.paymentMethod,
      this.paymentType,
      this.status,
      this.invoiceId,
      this.businessId,
      this.customerId,
      this.userId);

  Receipt.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.name = jsonObject['title'];
    this.amountPaid = jsonObject['number'];
    this.paymentDate = jsonObject['po_so_number'];
    this.paymentMethod = jsonObject['summary'];
    this.paymentType = jsonObject['issue_date'];
    this.status = jsonObject['due_date'];
    this.invoiceId = jsonObject['sub_total_amount'];
    this.businessId = jsonObject['total_amount'];
    this.userId = jsonObject['notes'];
  }

  static List<Receipt> invoiceReceipts(List<Receipt> invoices){
    List<Receipt> receipts = [];
    invoices.forEach((invoice){
      if(invoice.status.toLowerCase() == "sent"){
        receipts.add(invoice);
      }
    });
    return receipts;
  }

  static List<Receipt> customerReceipts(List<Receipt> receipts, invoiceId){
    List<Receipt> customerReceipts = [];
    receipts.forEach((receipt){
      if(receipt.invoiceId == invoiceId){
        customerReceipts.add(receipt);
      }
    });
    return customerReceipts;
  }


}
