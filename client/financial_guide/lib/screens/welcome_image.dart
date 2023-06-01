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
    return Column(

      children: [
        const Text(
          "Financial Guide",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
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
    );
  }
}