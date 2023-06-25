import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../models/budget.model.dart';
import '../../utils/utils.dart';

class BudgetDetails extends StatefulWidget {
  final BudgetModel budget;
  final String userName;
  final String month;
  const BudgetDetails({Key? key, required this.budget, required this.userName, required this.month}) : super(key: key);

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  int counter = 0;
  late String month = widget.month;
  List<bool> alertDialogShownList = [];

  @override
  void initState() {
    super.initState();
    initializeAlertDialogFlags();
  }

  void initializeAlertDialogFlags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < widget.budget.categories.length; i++) {
      bool hasAlertDialogShown =
          prefs.getBool('${widget.userName}_${widget.month}_$i') ?? false;
      alertDialogShownList.add(hasAlertDialogShown);
    }
  }

  void setAlertDialogShownFlag(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.userName}_${widget.month}_$index', true);
  }

  double calculatePercentage(spent, to_spend) {
    if(spent == 0) {
      return 0.00;
    }
    return (spent/to_spend);
  }

  int getIconIndex (category) {
    for(int i = 0; i < categories.length; ++i) {
      if(category == categories[i]) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: widget.budget.categories.length,
              itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    height: 150,
                    width: double.maxFinite,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(
                                categoryIcons[getIconIndex(widget.budget.categories[index].categoryName)],
                                size: 48.0,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.budget.categories[index].categoryName,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      widget.budget.categories[index].to_spend > widget.budget.categories[index].spent ?
                                      "Remaining ${double.parse((
                                          widget.budget.categories[index].to_spend - widget.budget.categories[index].spent).toString())} RON" :
                                      "Exceeded ${double.parse((
                                          widget.budget.categories[index].spent - widget.budget.categories[index].to_spend).toString())} RON",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 6.0),
                                    LinearPercentIndicator(
                                      barRadius: const Radius.circular(16),
                                      center: Text("${(calculatePercentage(widget.budget.categories[index].spent, widget.budget.categories[index].to_spend) * 100).toStringAsFixed(2)} %", style: TextStyle(fontWeight: FontWeight.bold)),
                                      animation: true,
                                      animationDuration: 1000,
                                      lineHeight: 20,
                                      percent: calculatePercentage(widget.budget.categories[index].spent, widget.budget.categories[index].to_spend) < 1 ?
                                      calculatePercentage(widget.budget.categories[index].spent, widget.budget.categories[index].to_spend) : 1,
                                      progressColor: calculatePercentage(widget.budget.categories[index].spent, widget.budget.categories[index].to_spend) < 1 ? kPrimaryColor :
                                      Colors.red.shade300,
                                      backgroundColor: kPrimaryLightColor,
                                    ),
                                    SizedBox(height: 3.5),
                                    Text(
                                      "${double.parse(widget.budget.categories[index].spent.toString())} RON of ${double.parse(widget.budget.categories[index].to_spend.toString())} RON",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      ),
                    )
                  );
              }))
        ],
      )
    );
  }
}
