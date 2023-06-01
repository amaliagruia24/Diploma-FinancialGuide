import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions Page')),
      body: const Center(
        child: Text('Transactions page', style: TextStyle(fontSize: 40)),
      ),
    );
  }
}
