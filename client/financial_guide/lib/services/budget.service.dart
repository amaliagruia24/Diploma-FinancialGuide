import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/budget.model.dart';
import 'package:http/http.dart' as http;

class BudgetService {
  BuildContext context;
  BudgetService({
    required this.context
  });

  void addBudget (userId, month, income, planned_expense, goal, userCategories) async {
    var newBudget = BudgetModel(
      userId: userId,
      month: month,
      income: income,
      planned_expense: planned_expense,
      goal: goal,
      categories: userCategories,
    );

    var response = await http.post(Uri.parse('http://192.168.1.5:3000/api/addBudget'),
      body: jsonEncode(newBudget.toJson()),
      headers: {"Content-Type": "application/json"},
    );

    var jsonresponse = jsonDecode(response.body);

    if(jsonresponse['status']) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('added budget'))
      );
    } else if (jsonresponse['status'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('cv eroare'))
      );
    }
  }


}