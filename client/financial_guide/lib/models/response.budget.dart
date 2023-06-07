import 'package:financial_guide/models/budget.model.dart';

class ResponseBudget{
  bool statusCode;
  BudgetModel budget;
  String errorMesage;

  ResponseBudget({
    required this.statusCode,
    required this.budget,
    required this.errorMesage
});

}