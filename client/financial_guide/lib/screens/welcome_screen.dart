import 'package:financial_guide/screens/login_signup_btn.dart';
import 'package:financial_guide/screens/welcome_image.dart';
import 'package:flutter/material.dart';

import '../components/background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Background(
      child: SingleChildScrollView(
        child:SafeArea(
          child: const MobileWelcomeScreen(),
        )
      )
    );
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
      Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const WelcomeImage(),
        Row(
          children: const[
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginAndSignUpBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }

}