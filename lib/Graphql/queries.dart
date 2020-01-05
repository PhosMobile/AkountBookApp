class Queries {
  String getOTP = r"""
                    query GetOtp($otp : String!){
                      get_otp(otp:$otp){
                        email
                      }
                    }
                  """;
  String getLoggedInUser = r"""
                        query{
  me{
    id
    name
    email
    phone
    businesses{
      id
      name
      email
      description
      address
      address
      currency
      image_url
     	user_id
    }
  }
}
                  """;

  String getCurrentBusinessData = r"""
                    query GetOtp($id : ID!){
                      get_business(id:$id){
                       id
            name
            email
            description
            address
            currency
            image_url
            user_id
            customers{
              id
              name
              email
              phone
              address
              image_url
              business_id
              user_id
            }
            receipts{
              id
              name
              amount_paid
              payment_date
              payment_method
              payment_type
              status
              invoice_id
              business_id
              user_id
            }
            items{
              id
              name
              description
              business_id
              quantity
              price
              user_id
            }
            invoices{
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
            expenses{
              id
              name
              description
              quantity
              price
              date
              business_id
              user_id
              
            }
                              }
                            }
                          """;
  String getInvoiceItem = r"""
                    query GetInvoiceItem($invoice_id : ID!){
                      get_invoice_item(invoice_id:$invoice_id){
                        id
                        item_id
                        invoice_id
                      }
                    }
                  """;

  String getUserEmail = r"""
                    query GetUserEmail($email : String!){
                      get_user_email(email:$email){
                        id
                        name
                        email
                      }
                    }
                  """;
}
