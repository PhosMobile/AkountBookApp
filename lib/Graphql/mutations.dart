class Mutations {
  String login(String username, String password) {
    return """
      mutation{
          login(input:{ 
          username: "$username", 
          password: "$password", 
          }){
            access_token
           user{
            id
            name
            email
            }
          }
      }
    """;
  }

  String forgotPassword(String email) {
    return """
      mutation{
          forgotPassword(input:{
          email: "$email", 
          }){
            message
            status
          }
      }
    """;
  }

  String createUser(
      String name, String phone, String email, String password, int otp) {
    return """
      mutation{
          create_user(
          name: "$name", 
          phone: "$phone", 
          email: "$email", 
          otp:"$otp"
          password: "$password" 
          ){
          id
          name
          email
          phone
          }
      }
    """;
  }

  String createBusiness(String name, String email, String description,
      String address, String currency, String imageUrl, String userId) {
    return """
      mutation{
          create_business(
          name: "$name", 
          email: "$email", 
          description: "$description", 
          address:"$address"
          currency: "$currency" 
          image_url: "$imageUrl"
          user_id:"$userId"
          ){
          id
          name
          email
          description
          address
          currency
          image_url
          user_id
          }
      }
    """;
  }

  String editBusiness(String id, String name, String email, String description,
      String address, String currency, String imageUrl,) {
    return """
      mutation{
          update_business(
          id:"$id",
          name: "$name", 
          email: "$email", 
          description: "$description", 
          address:"$address"
          currency: "$currency" 
          image_url: "$imageUrl"
          ){
          id
          name
          email
          description
          address
          currency
          image_url
          user_id
          }
      }
    """;
  }


  String deleteBusiness(String id) {
    return """
      mutation{
          delete_business(
          id:"$id",
          ){
          id
          }
      }
    """;
  }




  String createCustomer(String name, String email, String phone,
      String address, String businessId, String userId, String imageUrl) {
    return """
      mutation{
          create_customer(
          name: "$name", 
          email: "$email", 
          phone: "$phone", 
          address:"$address"
          business_id: "$businessId" 
          user_id: "$userId"
          image_url:"$imageUrl"
          ){
          id
          name
          email
          phone
          address
          image_url
          business_id
          user_id
          }
      }
    """;
  }


  String createItem(String name, String description, int quantity,
      int price, String businessId, String userId) {
    return """
      mutation{
          create_item(
          name: "$name", 
          description: "$description", 
          quantity: $quantity, 
          price:$price,
          business_id: "$businessId",
          user_id: "$userId",
          ){
          id
          name
          description
          quantity
          price
          business_id
          user_id
          }
      }
    """;
  }

  String createInvoice(
      String title,
      int number,
      String poSoNumber,
      String summary,
      String issueDate,
      String dueDate,
      int subTotalAmount,
      int totalAmount,
      String notes,
      String status,
      String footer,
      String customerId,
      String businessId,
      String userId
      ) {
    return """
      mutation{
          create_invoice(
          title: "$title", 
          number: $number, 
          po_so_number: "$poSoNumber", 
          summary:"$summary",
          issue_date: "$issueDate",
          due_date: "$dueDate",
          sub_total_amount: $subTotalAmount, 
          total_amount: $totalAmount, 
          notes: "$notes", 
          status:"$status",
          footer: "$footer",
          customer_id: "$customerId",
          business_id: "$businessId",
          user_id: "$userId",
          ){
id
title
number
po_so_number
summary
issue_date
due_date
sub_total_amount
total_amount
notes
status
footer
customer_id
business_id
user_id
          }
      }
    """;
  }

  String createInvoiceItem(String invoiceId, String itemId) {
    return """
      mutation{
          create_invoice_item( invoice_id: "$invoiceId", item_id: "$itemId", ){
            invoice_id
            item_id
          }
      }
    """;
  }


  String updateInvoice(
      String id,
      String title,
      int number,
      String poSoNumber,
      String summary,
      String issueDate,
      String dueDate,
      int subTotalAmount,
      int totalAmount,
      String notes,
      String status,
      String footer,
      String customerId,
      ) {
    return """
      mutation{
          update_invoice(
          id:"$id"
          title: "$title", 
          number: $number, 
          po_so_number: "$poSoNumber", 
          summary:"$summary",
          issue_date: "$issueDate",
          due_date: "$dueDate",
          sub_total_amount: $subTotalAmount, 
          total_amount: $totalAmount, 
          notes: "$notes", 
          status:"$status",
          footer: "$footer",
          customer_id: $customerId,
          ){
      id
          }
      }
    """;
  }

  String deleteInvoiceItem(
      String id,
      ) {
    return """
      mutation{
          delete_invoice_item(
          id:"$id"
          ){
          invoice_id
          }
      }
    """;
  }

  String deleteInvoice(
      String id,
      ) {
    return """
      mutation{
          delete_invoice(
          id:"$id"
          ){
          id
          }
      }
    """;
  }

  String createDiscount(
      String description,
      String amount,
      int dType,
      String invoiceId,
      String businessId,
      String userId,
      ) {
    return """
      mutation{
          create_discount(
          description:"$description"
          amount:$amount
          d_type:$dType
          invoice_id:"$invoiceId"
          business_id:"$businessId"
          user_id:"$userId"
          ){
          id
          description
          amount
          d_type
          invoice_id
          business_id
          user_id
          }
      }
    """;
  }

  String createReceipt(
  String name,
  int amountPaid,
  String paymentDate,
  String paymentMethod,
  String paymentType,
  String status,
  String invoiceId,
  String businessId,
  String customerId,
  String userId
      ) {
    return """
      mutation{
          create_receipt(
          name:"$name"
          amount_paid:$amountPaid
          payment_date:"$paymentDate"
          payment_method:"$paymentMethod"
          payment_type:"$paymentType"
          status:"$status"
          invoice_id:"$invoiceId"
          business_id:"$businessId"
          customer_id:"$customerId"
          user_id:"$userId"
          ){
            id
            name
            amount_paid
            payment_date
            payment_method
            payment_type
            status
            invoice_id
            business_id
            customer_id
            user_id
          }
      }
    """;
  }
}


