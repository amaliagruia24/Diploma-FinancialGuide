import 'package:financial_guide/components/background.dart';
import 'package:financial_guide/screens/Signup/signup_form.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Background(
        child: SingleChildScrollView(
          child: MobileSignupScreen(),
        )
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 100.0,
          width: 100.0,
          child: Text(
            "Sign Up",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
          ),
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: SignUp(),
            ),
            Spacer(),
          ],
        )
      ],
    );
  }
}