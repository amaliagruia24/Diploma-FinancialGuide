import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String topImage;
  const Background ({
    Key? key,
    required this.child,
    this.topImage = "assets/welcome_screen.svg",
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset("assets/top_left_corner.png", width: 120,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset("assets/bottom_right_corner.png", width: 120,
              ),
            ),
            SafeArea(child: child)
          ],
        ),
      ),
    );
  }
}