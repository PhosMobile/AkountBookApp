class CurrentDate{
  String getCurrentDate(){
    DateTime now = new DateTime.now();
    String day = now.day.toString();
    String month = now.month.toString();
    String year = now.year.toString();

    return "$year-$month-$day";
  }
}