
import 'package:financial_guide/constants.dart';
import 'package:financial_guide/screens/Login/login_screen.dart';
import 'package:financial_guide/screens/Signup/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginAndSignUpBtn extends StatelessWidget {
  const LoginAndSignUpBtn({
    Key? key,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }
                  ),
              );
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SignUpScreen();
                }
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, elevation: 0),
            child: Text(
              "Sign Up".toUpperCase(),
              style: TextStyle(color: Colors.black),
            ),
        ),
      ],
    );
  }
}