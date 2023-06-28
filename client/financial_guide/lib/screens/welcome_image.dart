import 'package:financial_guide/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 25.0, color: Colors.black),
              children: [
                TextSpan(
                  text: "Welcome to ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "Financial Guide\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: kPrimaryColor,
                  ),
                ),
                TextSpan(
                  text: "Helping you plan your monthly budget\nand track your expenses.",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 10,
                child: SizedBox(
                  width: 250.0,
                  height: 250.0,
                  child: SvgPicture.asset("assets/welcome_screen.svg",),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}