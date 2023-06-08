import 'package:flutter/material.dart';
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
                    height: 220,
                    width: double.maxFinite,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(
                                categoryIcons[index],
                                size: 48.0,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.0),
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
                                    SizedBox(height: 4.0),
                                    Text(
                                      "Remaining ${widget.budget.categories[index].to_spend} RON",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
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
