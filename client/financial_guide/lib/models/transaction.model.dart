class TransactionModel {
  String userId;
  String type;
  int day;
  String month;
  int year;
  int amount;
  String? category;
  bool? isRecurring = false;
  TransactionModel({required this.userId, required this.type, required this.day, required this.month, required this.year,
      required this.amount, this.category, this.isRecurring});
}