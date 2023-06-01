import 'package:flutter/material.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard screen')),
      body: const Center(
        child: Text('Dashboard screen', style: TextStyle(fontSize: 40)),
      ),
    );
  }
}
