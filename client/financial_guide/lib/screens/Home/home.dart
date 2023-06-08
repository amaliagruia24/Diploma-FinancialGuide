import 'dart:convert';

import 'package:financial_guide/constants.dart';
import 'package:financial_guide/models/budget.model.dart';
import 'package:financial_guide/models/response.budget.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:financial_guide/screens/Budget/new.budget.dart';
import '../../screens/Budget/budget.details.dart';
import 'package:financial_guide/screens/Profile/profile.dart';
import 'package:financial_guide/screens/Transactions/transactions.dart';
import 'package:financial_guide/screens/Dashboard/dashboard.dart';
import 'package:http/http.dart' as http;
import '../../utils/utils.dart';


class Home extends StatefulWidget {
  final token;
  const Home({@required this.token,Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int monthRequested = 0;
  late String email;
  late String fullName;
  late String userId;
  dynamic myToken;
  bool visible = false;
  ResponseBudget responseBudget = ResponseBudget(
      statusCode: false,
      budget: BudgetModel(
        userId: "",
        month: '',
        income: 0,
        planned_expense: 0,
        goal: 0,
        categories: []
      ), errorMesage: "message");
  late String ErrorMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    // myToken = widget.token;
    email = jwtDecodedToken['email'];
    fullName = jwtDecodedToken['fullName'];
    userId = jwtDecodedToken['_id'];
  }

  int currentTab = 0;

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = DashboardPage();

  Future<void> getCurrentMonthBudget(userId, month) async {
    final body = {
      "userId": userId,
      "month": month
    };
    final uri = Uri.http("192.168.1.5:3000","/api/getUserBudgetByMonth", body);
    final response = await http.get(uri);

    var jsonresponse = jsonDecode(response.body);

    if(jsonresponse['status']) {
      var content = jsonresponse['message'] as List;
      List<BudgetModel> list;
      list = content.map<BudgetModel>((json) => BudgetModel.fromJson(json)).toList();
      BudgetModel foundBudget = list[0];
      print(foundBudget.month);
      setState(() {
        responseBudget = ResponseBudget(statusCode: jsonresponse['status'], budget: foundBudget, errorMesage: "");
      });
    } else {
      setState(() {
        responseBudget = ResponseBudget(statusCode: jsonresponse['status'], budget: BudgetModel(
            userId: "",
            month: '',
            income: 0,
            planned_expense: 0,
            goal: 0,
            categories: []
        ), errorMesage: "Budget not set for this month.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: visible ? AppBar(
        automaticallyImplyLeading: false,
        elevation: 15,
        title: Container(
          height: 40,
          child: Row(
            children: [
              IconButton(
                  onPressed: () async {
                    setState(() {
                      monthRequested -= 1;
                    });
                    await getCurrentMonthBudget(
                        userId, getMonth(monthRequested).toLowerCase());

                    setState(() {
                      visible = true;
                      print(responseBudget.statusCode);
                      print(monthRequested);
                      responseBudget.statusCode ? currentScreen = BudgetDetails(
                          budget: responseBudget.budget,
                          userName: fullName,
                          month: getMonth(monthRequested)) :
                      currentScreen = BudgetPage(userId: userId,
                          userName: fullName,
                          month: getMonth(monthRequested));
                      currentTab = 2;
                    });
                  },
                  icon: Icon(Icons.arrow_left)
              ),
              Spacer(),
              Text(getMonth(monthRequested), style: TextStyle(fontSize: 20)),
              Spacer(),
              IconButton(
                  onPressed: () async {
                    setState(() {
                      monthRequested += 1;
                    });
                    await getCurrentMonthBudget(
                        userId, getMonth(monthRequested).toLowerCase());
                    setState(() {
                      visible = true;
                      print(responseBudget.statusCode);
                      print(monthRequested);

                      responseBudget.statusCode ? currentScreen = BudgetDetails(
                          budget: responseBudget.budget,
                          userName: fullName,
                          month: getMonth(monthRequested)) :
                      currentScreen = BudgetPage(userId: userId,
                          userName: fullName,
                          month: getMonth(monthRequested));
                      currentTab = 2;
                    });
                  },
                  icon: Icon(Icons.arrow_right)
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ) : null,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        visible = false;
                        currentScreen = DashboardPage();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dashboard,
                          color: currentTab == 0 ? kPrimaryColor : Colors.grey,
                        ),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: currentTab == 0 ? kPrimaryColor : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        visible = false;
                        currentScreen = TransactionsPage();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: currentTab == 1 ? kPrimaryColor : Colors.grey,
                        ),
                        Text(
                          'Transactions',
                          style: TextStyle(
                            color: currentTab == 1 ? kPrimaryColor : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () async {
                      await getCurrentMonthBudget(userId, getMonth(monthRequested).toLowerCase());
                      setState(() {
                        visible = true;
                        print(responseBudget.statusCode);
                        responseBudget.statusCode ? currentScreen = BudgetDetails(budget: responseBudget.budget, userName: fullName, month: getMonth(monthRequested)) :
                            currentScreen = BudgetPage(userId: userId, userName: fullName, month: getMonth(monthRequested));
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: currentTab == 2 ? kPrimaryColor : Colors.grey,
                        ),
                        Text(
                          'Budget',
                          style: TextStyle(
                            color: currentTab == 2 ? kPrimaryColor : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        visible = false;
                        currentScreen = ProfilePage();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: currentTab == 3 ? kPrimaryColor : Colors.grey,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: currentTab == 3 ? kPrimaryColor : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
