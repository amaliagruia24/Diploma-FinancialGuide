import 'dart:convert';

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
                      getMonth(counter).toLowerCase(),
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
        children: [
          Text('Start by entering your total monthly income.'),
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
              decoration: InputDecoration(labelText: "Enter income"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          Text('Note that this value can be modified later if a new income is added.')
        ],
      ),
    ),
    Step(
      isActive: currentStep >= 1,
      title: const Text('Goal'),
      content: Column(
        children: [
          Text('Now, let us know how much you plan to save this month'),
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
          Text('We recommend you to save at least 20% of your income.'),
        ],
      ),
    ),
    Step(
      isActive: currentStep >= 2,
      title: const Text('Spendings'),
      content: Text('The remaining amount of money to spend this month is ${calculateSpending(incomeController.text, goalController.text)}'),
    ),
    Step(
      isActive: currentStep >= 3,
      title: const Text('Categories'),
      content: Column(
        children: [
          const Text('Choose which categories you would like to set budgets for:'),
          ElevatedButton(
              onPressed: _showMultiSelect,
              child: const Text('Select categories')
          ),
          const Divider(
            height: 30,
          ),
          Wrap(
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
                Icon(categoryIcons[index]),
                SizedBox(width: 10),
                Text(_selectedCategories[index]),
                Spacer(),
                SizedBox(
                    width: 100,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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


