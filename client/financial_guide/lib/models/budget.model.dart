import 'category.model.dart';

class BudgetModel {
  String userId;
  String month;
  int income;
  int planned_expense;
  int goal;
  List<CategoryModel> categories;

  BudgetModel({
    required this.userId,
    required this.month,
    required this.income,
    required this.planned_expense,
    required this.goal,
    required this.categories,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'month': month,
      'income': income,
      'planned_expense': planned_expense,
      'goal': goal,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
  
  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> categoryList = json['categories'] ?? [];
    final List<CategoryModel> categories = categoryList
        .map((category) => CategoryModel.fromJson(category))
        .toList();

    return BudgetModel(
        userId: json["userId"], 
        month: json["month"], 
        income: json["income"],
        planned_expense: json["planned_expense"],
        goal: json["goal"],
        categories: categories);

  }
}

class BudgetType {
  String userId;
  String month;
  int income;
  int planned_expense;
  int goal;
  List<CategoryModel> categories;

  BudgetType({
    required this.userId,
    required this.month,
    required this.income,
    required this.planned_expense,
    required this.goal,
    required this.categories,
  });
}
