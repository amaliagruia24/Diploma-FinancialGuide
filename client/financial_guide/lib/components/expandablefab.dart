import 'dart:convert';
import 'dart:math';

import 'package:financial_guide/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/budget.model.dart';

class ExpandableFab extends StatefulWidget {
  final String userId;
  const ExpandableFab({
    required this.userId,
    super.key});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>{
  final DateFormat dateFormat = DateFormat('dd-MMMM-yyyy');
  String transactionType = "";
  String date = "";
  int day = 0;
  String month = "";
  int year = 0;
  String category = "";
  int amount = 0;
  TextEditingController amountController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  final _incomeKey = GlobalKey<FormState>();
  final _expenseKey = GlobalKey<FormState>();
  bool isRecurring = false;
  List<String> userCategories = [];

  Future<void> addTransaction(userId, type, day, month, year, amount, category, isRecurring) async {
    final body = {
      "userId": userId,
      "type": type,
      "day": day,
      "month": month,
      "year": year,
      "amount": amount,
      "category": category,
      "isRecurring": isRecurring
    };

    var response = await http.post(Uri.parse('http://192.168.1.5:3000/api/addTransaction'),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    var jsonresponse = jsonDecode(response.body);

    if(jsonresponse['status']) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added transaction, shoul appear in Transaction page'))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('something went wrong'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SpeedDial(
      backgroundColor: kPrimaryColor,
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      icon: Icons.add,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.trending_down),
          backgroundColor: Colors.red,
          label: "New Expense",
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                title: Row(
                  children: const [
                    Icon(
                      Icons.trending_down,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8.0),
                    Text('Add new expense'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:
                            Form(
                              key: _expenseKey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                                  TextInputFormatter.withFunction(
                                        (oldValue, newValue) => newValue.copyWith(
                                      text: newValue.text.replaceAll('.', ','),
                                    ),
                                  ),
                                ],
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return 'Please add amount';
                                  }
                                  return null;
                                },
                                controller: expenseController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Amount (RON)',
                                ),
                              ),
                            ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0), // Adjust the padding as needed
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Category'),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField<String>(
                      value: categories[0], // Set the initial value
                      onChanged: (String? newValue) {
                        // TODO: Implement dropdown onChanged logic
                        setState(() {
                          category = newValue!;
                        });
                      },
                      items: categories.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0), // Adjust the padding as needed
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Date ${dateFormat.format(DateTime.now())}"),
                          ),
                        ),
                      ],
                    ),
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return CheckboxListTile(
                            title: const Text("Make it recurring?"),
                            value: isRecurring,
                            onChanged: (bool? value) {
                              setState(() {
                                isRecurring = value!;
                              });
                            },);
                        }),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // TODO: Implement the logic for saving the income
                      setState(() {
                        date = dateFormat.format(DateTime.now());
                        var arr = date.split('-');
                        day = int.parse(arr[0]);
                        month = arr[1].toLowerCase();
                        year = int.parse(arr[2]);
                        amount = int.parse(expenseController.text);
                        transactionType = "expense";
                      });
                      if(_expenseKey.currentState!.validate()) {
                        addTransaction(widget.userId, transactionType, day, month, year, amount, category, isRecurring);
                      }
                      expenseController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      expenseController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          ),
        ),
        SpeedDialChild(
          child: Icon(Icons.trending_up),
          backgroundColor: Colors.green,
          label:"New Income",
          onTap: () =>   showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                title: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8.0),
                    Text('Add new income'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _incomeKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'Please add amount';
                                }
                                return null;
                              },
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Amount (RON)',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0), // Adjust the padding as needed
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Category'),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField<String>(
                      value: 'Award', // Set the initial value
                      onChanged: (String? newValue) {
                        // TODO: Implement dropdown onChanged logic
                      },
                      items: <String>[
                        'Award',
                        'Gift',
                        'Investment',
                        'Other',
                      ].map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0), // Adjust the padding as needed
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Date ${dateFormat.format(DateTime.now())}"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // TODO: Implement the logic for saving the income
                      setState(() {
                        date = dateFormat.format(DateTime.now());
                        var arr = date.split('-');
                        day = int.parse(arr[0]);
                        month = arr[1].toLowerCase();
                        year = int.parse(arr[2]);
                        amount = int.parse(amountController.text);
                        transactionType = "income";
                        isRecurring = false;
                      });
                      print(widget.userId);
                      print(transactionType);
                      print(day.toString());
                      print(month);
                      print(year.toString());
                      print(amountController.text);
                      print(category);
                      if(_incomeKey.currentState!.validate()) {
                        addTransaction(widget.userId, transactionType, day, month, year, amount, category, isRecurring);
                      }
                      amountController.clear();
                      //addTransaction(widget.userId, transactionType, day, month, year, amount, category);
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      amountController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }

}


