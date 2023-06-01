import 'package:financial_guide/components/background.dart';
import 'package:flutter/material.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Background(
        child: SingleChildScrollView(
          child: MobileLoginScreen(),
        )
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 100.0,
          width: 100.0,
          child: Text(
            "Sign In",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          ),
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Login(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}