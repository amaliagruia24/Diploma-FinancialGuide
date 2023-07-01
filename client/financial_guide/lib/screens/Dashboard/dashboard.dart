import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:financial_guide/components/barchart.dart';
import 'package:financial_guide/constants.dart';
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
  List<TransactionModel> recurrentTransactions = [];
  late BudgetModel newMonthBudget;
  List<Color> colorList = [
    Colors.purple[200]!,
    Colors.purple[400]!,
    Colors.lightBlue[200]!,
    Colors.lightBlue[800]!,
    Colors.purple[300]!,
    Colors.lightBlueAccent
  ];

  String currentKey = "";
  String currentInfo = "";
  Random _random = Random();
  Timer _timer = Timer(Duration(seconds: 10), () => {});

  void selectRandomEntry() {
    String randomKey = dailyTips.keys.elementAt(_random.nextInt(dailyTips.length));
    setState(() {
      currentKey = randomKey;
      currentInfo = dailyTips[randomKey]!;
    });
  }

  Future <List<TransactionModel>> getUserTransaction(userId) async {
    final body = {
      "userId": userId,
      "month": getMonth(0).toLowerCase()
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
          isRecurring: transactionJson['isRecurring']
        );
        transactions.add(transaction);
      }
      setState(() {
        userTransactions = transactions;
      });
      return userTransactions;
    } else {
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

  Future <List<TransactionModel>> getRecurringTransactions(userId, month) async {
    final body = {
      "userId": userId,
      "month": month
    };

    final uri = Uri.http("192.168.1.5:3000","/api/getReccuring", body);
    final response = await http.get(uri);

    var jsonresponse = jsonDecode(response.body);

    if(jsonresponse['status']) {
      List<TransactionModel> transactions = [];
      var transactionData = jsonresponse['message'];

      for (var transactionJson in transactionData) {
        if (transactionJson['isRecurring']) {
          String transMonth = transactionJson['month'];
          transMonth = transMonth[0].toUpperCase() + transMonth.substring(1);
          String nextMonth = "";
          for(int i = 0; i < months.length; ++i) {
            if(months[i] == transMonth){
              nextMonth = months[i+1];
            }
          }
          TransactionModel transaction = TransactionModel(
              userId: transactionJson['userId'],
              type: transactionJson['type'],
              day: transactionJson['day'],
              month: nextMonth,
              year: transactionJson['year'],
              amount: transactionJson['amount'],
              category: transactionJson['category'],
              isRecurring: transactionJson['isRecurring']
          );
          transactions.add(transaction);
        }
      }
      setState(() {
        recurrentTransactions = transactions;
      });
      return recurrentTransactions;
    } else {
      return recurrentTransactions;
    }
  }

  Map<String, double> getBarChartData() {
    Map<String, double> data = {};
    for (var transaction in userTransactions) {
      String date = "${transaction.day}-${transaction.month[0].toUpperCase() + transaction.month.substring(1)}";
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
  int getIconIndex (category) {
    for(int i = 0; i < categories.length; ++i) {
      if(categories[i] == category) {
        return i;
      }
    }
    return 0;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentMonthBudget(widget.userId, getMonth(0).toLowerCase());
    getUserTransaction(widget.userId);
    getRecurringTransactions(widget.userId, getMonth(0).toLowerCase());
    selectRandomEntry();
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      selectRandomEntry();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
              padding: EdgeInsets.all(16.0),
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0), // Adjust the left padding value as needed
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'See where your money went',
                    style: TextStyle(
                      color:  Colors.black54,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 0.8,
            ),
            Expanded(
              flex: 10,
              child: ListView(
                children: [
                  Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15), // Set the opacity here
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.yellow[600],
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'New information arrived!',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      TextButton(
                        onPressed: () async {
                          // Add your action here
                          await showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(currentKey),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(currentInfo),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          currentKey,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3, // Adjust the height as needed
                    child: FutureBuilder<Map<String, double>>(
                      future: getCurrentMonthBudget(widget.userId, getMonth(0).toLowerCase()),
                      //future: getUserTransaction(widget.userId),
                      builder: (BuildContext context, AsyncSnapshot<Map<String, double>> snapshot) {
                        if (snapshot.hasData) {
                          if(categoriesMap.isNotEmpty) {
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
                            return Center(child: Text("Set budget first."));
                          }

                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0), // Adjust the left padding value as needed
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Scheduled Payments',
                          style: TextStyle(
                            color:  Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(Radius.circular(30.0))
                    ),
                    child: recurrentTransactions.isNotEmpty ? Column(
                      children: List.generate(recurrentTransactions.length, (index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width - 40) * 0.7,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.withOpacity(0.1)
                                        ),
                                        child: Center(
                                          child: Icon(
                                              categoryIcons[getIconIndex(recurrentTransactions[index].category)]
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Container(
                                        width: (MediaQuery.of(context).size.width - 90) * 0.5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(recurrentTransactions[index].category!,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Due date: ${recurrentTransactions[index].day}-${recurrentTransactions[index].month}-${recurrentTransactions[index].year}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: (MediaQuery.of(context).size.width - 40) * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${double.parse(recurrentTransactions[index].amount.toString()).toString()} RON",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 65, top: 8),
                              child: Divider(
                                thickness: 0.8,
                              ),
                            ),
                          ],
                        );
                      }),
                    ) : Center(
                          child: Column(
                            children: [
                              Icon(Icons.account_balance_wallet_outlined),
                              Text("You don't have any recurrent payments this month.",
                                style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.bold),
                              ),
                              Text("Go to Budget screen and set a budget for this month",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0), // Adjust the left padding value as needed
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Analytics',
                          style: TextStyle(
                            color:  Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                                if(getBarChartData().isNotEmpty) {
                                  return BarChartDetails(data: getBarChartData(),);
                                } else {
                                  return Center(child: Text("Set budget first"),);
                                }

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
