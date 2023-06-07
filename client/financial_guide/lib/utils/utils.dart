import '../constants.dart';

String getMonth(int x) {
  DateTime now = DateTime.now();
  int currentMonth = now.month;

  String month = months[currentMonth + x - 1];
  return month;
}

String calculateSpending(String income, String goal) {
  if(income.isEmpty || goal.isEmpty){
    return 'Please enter values above';
  }
  int spending = int.parse(income) - int.parse(goal);
  return spending.toString();
}