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
      String address, String currency, String image_url, String user_id) {
    return """
      mutation{
          create_business(
          name: "$name", 
          email: "$email", 
          description: "$description", 
          address:"$address"
          currency: "$currency" 
          image_url: "$image_url"
          user_id:"$user_id"
          ){
          id
          name
          }
      }
    """;
  }
}
