
import 'package:financial_guide/constants.dart';
import 'package:financial_guide/models/transaction.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionsPage extends StatefulWidget {
  final String userId;
  final List<TransactionModel> userTransactions;
  const TransactionsPage({Key? key, required this.userId, required this.userTransactions}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<TransactionModel> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    filteredTransactions = widget.userTransactions;
  }

  void filterTransactions(String searchTerm) {
    print(searchTerm);
    setState(() {
      if (searchTerm.isEmpty) {
        filteredTransactions = widget.userTransactions;
      } else {
        filteredTransactions = widget.userTransactions
            .where((transaction) =>
        transaction.category!.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  int getIconIndex (category) {
    for(int i = 0; i < categories.length; ++i) {
      if(category == categories[i]) {
        return i;
      }
    }
    return 0;
  }
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:     TextField(
              controller: _searchController,
              onChanged: filterTransactions,
              decoration: InputDecoration(
                hintText: 'Search a transaction..',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    filterTransactions('');
                  },
                ),
                prefixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    filterTransactions(_searchController.text);
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: widget.userTransactions.isNotEmpty ? Column(
            children: List.generate(filteredTransactions.length, (index) {
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
                                child: widget.userTransactions[index].type == "income" ?
                                Icon(Icons.arrow_upward_outlined) :
                                Icon(
                                    categoryIcons[getIconIndex(filteredTransactions[index].category)]
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
                                  Text(
                                    widget.userTransactions[index].type == "income" ?
                                    "Income" : filteredTransactions[index].category!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "${widget.userTransactions[index].day}-${widget.userTransactions[index].month}-${widget.userTransactions[index].year}",
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
                              "${double.parse(widget.userTransactions[index].amount.toString()).toString()} RON",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: widget.userTransactions[index].type == "income" ? Colors.green : Colors.red),
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
                Container(
                  width: 250,
                  height: 400,
                  child: SvgPicture.asset("assets/no-transactions.svg"),
                ),
                Text("Looks like you don't have any transactions.",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold),
                ),
                Text("Tap the + button below to add a new transactions.",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        )
      )
    );
  }
}
