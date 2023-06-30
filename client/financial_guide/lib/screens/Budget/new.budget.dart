import 'dart:convert';

import 'package:financial_guide/components/snackbar.success.dart';
import 'package:financial_guide/models/category.model.dart';
import 'package:financial_guide/screens/Budget/budget.details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:financial_guide/constants.dart';
import 'package:http/http.dart' as http;

import '../../components/multiselect.dart';
import '../../models/budget.model.dart';
import '../../models/response.budget.dart';
import '../../utils/utils.dart';
import '../../services/budget.service.dart';

class BudgetPage extends StatefulWidget {
  final String userId;
  final String userName;
  final String month;

  const BudgetPage({Key? key, required this.userId, required this.userName, required this.month}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int currentStep = 0;
  int counter = 0;
  List<String> _selectedCategories = [];
  List<int> categoriesAmount = [];
  final _formKey = GlobalKey<FormState>();
  final _goalKey = GlobalKey<FormState>();
  List<CategoryModel> categoriesModel = [];
  TextEditingController incomeController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController categoryAmountController = TextEditingController();
  List<TextEditingController> textControllers = List.generate(
    categories.length, (_) => TextEditingController());
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
  late String month = widget.month;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  int getIconIndex (category) {
    for(int i = 0; i < categories.length; ++i) {
      if(category == categories[i]) {
        return i;
      }
    }
    return 0;
  }

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
      SuccessSnackBar.showSuccess(context, "Budget created succesfully.");
    } else if (jsonresponse['status'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonresponse['message']))
      );
    }
  }

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
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stepper(
              physics: ClampingScrollPhysics(),
              steps: getSteps(),
              currentStep: currentStep,
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;
                if(currentStep == 0) {
                  if(_formKey.currentState!.validate()) {
                    setState(() {
                      currentStep += 1;
                    });
                  }
                } else if(currentStep == 1) {
                  if(_goalKey.currentState!.validate()) {
                    setState(() {
                      currentStep += 1;
                    });
                  }
                } else if(isLastStep) {
                  //List<CategoryModel> categoriesModel = [];
                  for (int i = 0; i < _selectedCategories.length; i++) {
                    CategoryModel categoryModel = CategoryModel(
                        categoryName: _selectedCategories[i],
                        to_spend: int.parse(textControllers[i].text),
                        spent: 0);
                    setState(() {
                      categoriesModel.add(categoryModel);
                    });
                  }
                  addBudget(
                      widget.userId,
                      //getMonth(counter).toLowerCase(),
                      widget.month.toLowerCase(),
                      int.parse(incomeController.text),
                      int.parse(calculateSpending(incomeController.text, goalController.text)),
                      int.parse(goalController.text),
                      categoriesModel);
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                if(currentStep == 0) {
                  null;
                } else {
                  setState(() {
                    currentStep = currentStep - 1;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiSelect() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: categories);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedCategories = results;
      });
    }
  }

  List<Step> getSteps() => [
    Step(
      isActive: currentStep >= 0,
      title: const Text('Monthly Income'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0), // Adjust the value as needed
            child: Text(
              'Start by entering your total money income',
              style: TextStyle(),
            ),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter income to proceed!';
                }
                return null;
              },
              controller: incomeController,
              decoration: InputDecoration(labelText: "Income: 0,00 RON"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8.0),
                  const Expanded(
                    child: Text(
                      'This value can be modified later if a new income is added.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
    Step(
      isActive: currentStep >= 1,
      title: const Text('Goal'),
      content: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text('Now, let us know how much you plan to save this month'),
          ),
          Form(
            key: _goalKey,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: goalController,
              decoration: InputDecoration(labelText: "Enter your goal here"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter a goal to proceed!';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'We recommend you to save at least 20% of your income.',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            incomeController.text.isNotEmpty ?
                            Text(
                              'Recommended savings goal: ${int.parse(incomeController.text) * 0.2} RON',
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green, fontWeight: FontWeight.bold),
                            ) :
                                Text(""),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
    Step(
      isActive: currentStep >= 2,
      title: const Text('Spendings'),
      content: RichText(
        text: TextSpan(
          text: 'The remaining amount of money to spend this month is ',
          style: TextStyle(fontSize: 16.0, color: Colors.black),
          children: [
            WidgetSpan(
              child: Container(
                padding: EdgeInsets.only(top: 3.0, left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  "${calculateSpending(incomeController.text, goalController.text)} RON.",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      )

    ),
    Step(
      isActive: currentStep >= 3,
      title: const Text('Categories'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: const Text('Choose the categories you would like to set budgets for:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
              onPressed: _showMultiSelect,
              child: const Text('Select categories')
          ),
          const Divider(
            height: 30,
          ),
          Wrap(
            spacing: 8.0,
            children: _selectedCategories.map((e) => Chip(label: Text(e),)).toList(),
          )
        ],
      ),
    ),
    Step(
      isActive: currentStep >= 4,
      title: const Text('Categories spendings'),
      content: ListView.builder(
        shrinkWrap: true,
        itemCount: _selectedCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(categoryIcons[getIconIndex(_selectedCategories[index])]),
                SizedBox(width: 10),
                Text(_selectedCategories[index]),
                Spacer(),
                SizedBox(
                    width: 100,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: "0,00 RON"),
                      controller: textControllers[index],
                      // onSaved: (value) {
                      //   categoriesAmount.add(int.parse(textControllers[index].text));
                      // },
                      keyboardType: TextInputType.number,
                    )
                ),
              ],
            ),
          );
        },
      ),
    ),
  ];
}


