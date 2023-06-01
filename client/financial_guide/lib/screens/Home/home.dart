import 'package:financial_guide/constants.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:financial_guide/screens/Budget/budget.dart';
import 'package:financial_guide/screens/Profile/profile.dart';
import 'package:financial_guide/screens/Transactions/transactions.dart';
import 'package:financial_guide/screens/Dashboard/dashboard.dart';


class Home extends StatefulWidget {
  final token;
  const Home({@required this.token,Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String email;
  dynamic myToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    // myToken = widget.token;
    email = jwtDecodedToken['email'];
  }

  int currentTab = 0;
  final List<Widget> screens = [
    DashboardPage(),
    TransactionsPage(),
    ProfilePage(),
    BudgetPage()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = DashboardPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: () {
                      setState(() {
                        currentScreen = BudgetPage();
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
