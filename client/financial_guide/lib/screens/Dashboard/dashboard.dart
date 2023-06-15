import 'dart:convert';

import 'package:financial_guide/components/barchart.dart';
import 'package:financial_guide/models/budget.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:http/http.dart' as http;

import '../../models/transaction.model.dart';
import '../../utils/utils.dart';


class DashboardPage extends StatefulWidget {
  final String userName;
  final String userId;
  DashboardPage({Key? key, required this.userName, required this.userId}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  Map<String, double> categoriesMap = {};
  List<TransactionModel> userTransactions = [];
  late BudgetModel newMonthBudget;
  List<Color> colorList = [
    Colors.purple[200]!,
    Colors.purple[400]!,
    Colors.lightBlue[200]!,
    Colors.lightBlue[800]!,
  ];
  Future <List<TransactionModel>> getUserTransaction(userId) async {
    final body = {
      "userId": userId
    };

    final uri = Uri.http("192.168.1.5:3000","/api/getAllUserTransactions", body);
    final response = await http.get(uri);

    var jsonresponse = jsonDecode(response.body);

    if(jsonresponse['status']) {
      List<TransactionModel> transactions = [];
      var transactionData = jsonresponse['message'];

      for (var transactionJson in transactionData) {
        TransactionModel transaction = TransactionModel(
          userId: transactionJson['userId'],
          type: transactionJson['type'],
          day: transactionJson['day'],
          month: transactionJson['month'],
          year: transactionJson['year'],
          amount: transactionJson['amount'],
          category: transactionJson['category'],
        );
        transactions.add(transaction);
      }
      setState(() {
        userTransactions = transactions;
      });
      return userTransactions;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('something went wrong'))
      );
      return userTransactions;
    }
  }
  Future<Map<String, double>> getCurrentMonthBudget(userId, month) async {
    final body = {
      "userId": userId,
      "month": month
    };
    final uri = Uri.http("192.168.1.5:3000","/api/getUserBudgetByMonth", body);
    final response = await http.get(uri);

    var jsonresponse = jsonDecode(response.body);

    if(jsonresponse['status']) {
      var content = jsonresponse['message'] as Map<String, dynamic>;
      BudgetModel foundBudget = BudgetModel.fromJson(content);
      setState(() {
        newMonthBudget = foundBudget;
      });
      Map<String, double> categoriesMap = {};
      for (var category in foundBudget.categories) {
        categoriesMap[category.categoryName] = double.parse(category.spent.toString());
      }
      setState(() {
        this.categoriesMap = categoriesMap;
      });
      return categoriesMap;
    } else {
      setState(() {
        newMonthBudget = BudgetModel(
            userId: "",
            month: '',
            income: 0,
            planned_expense: 0,
            goal: 0,
            categories: []
        );
      });
      return categoriesMap;
    }
  }

  Map<String, double> getBarChartData() {
    Map<String, double> data = {};
    for (var transaction in userTransactions) {
      String date = "${transaction.day}-${transaction.month}-${transaction.year}";
      if(data.containsKey(date)) {
        if(transaction.type == "expense") {
          data[date] = (data[date] ?? 0.0) - transaction.amount;
        } else {
          data[date] = (data[date] ?? 0.0) + transaction.amount;
        }
      } else {
        if(transaction.type == "expense") {
          data[date] = transaction.amount * (-1);
        } else {
          data[date] = transaction.amount.toDouble();
        }
      }
    }
    double income = newMonthBudget.income.toDouble();
    Map<String, double> barChartData = {};
    double previousValue = 0;
    for(var entry in data.entries) {
      String currentKey = entry.key;
      double currentValue = entry.value;

      if (previousValue == 0) {
        barChartData[currentKey] = income + currentValue;
      } else {
        barChartData[currentKey] = previousValue + currentValue;
      }
      previousValue = barChartData[currentKey]!;
    }
    return barChartData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentMonthBudget(widget.userId, getMonth(0).toLowerCase());
    getUserTransaction(widget.userId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3, // Occupying 20% of the screen
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Adjust the color as needed
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        'assets/dashboard.svg', // Replace with your SVG asset path
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
                    ),
                    const Positioned(
                      left: 16.0,
                      bottom: 16.0,
                      child: Text(
                        'See your statistics here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16.0,
                      bottom: 52.0,
                      child: Text(
                        'Welcome, ${widget.userName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10.0, bottom: 6.0),
              child: const Text(
                'See where your money went',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3, // Adjust the height as needed
                    child: FutureBuilder<Map<String, double>>(
                      future: getCurrentMonthBudget(widget.userId, getMonth(0).toLowerCase()),
                      builder: (BuildContext context, AsyncSnapshot<Map<String, double>> snapshot) {
                        if (snapshot.hasData) {
                          return pie.PieChart(
                            dataMap: categoriesMap,
                            chartRadius: MediaQuery.of(context).size.width / 2,
                            legendOptions: const pie.LegendOptions(
                              legendPosition: pie.LegendPosition.right,
                            ),
                            chartValuesOptions: const pie.ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            colorList: colorList,
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                    child: const Text(
                      'Analytics',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9, // Adjust the fraction as needed
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Stack(
                        children: [
                          FutureBuilder(
                            future: Future.wait([
                              getCurrentMonthBudget(widget.userId, getMonth(0).toLowerCase()),
                              getUserTransaction(widget.userId),
                            ]),
                            builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
                              if (snapshot.hasData) {
                                return BarChartDetails(data: getBarChartData(),);
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
