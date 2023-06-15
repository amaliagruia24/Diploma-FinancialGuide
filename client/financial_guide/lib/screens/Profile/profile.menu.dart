import 'package:financial_guide/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileMenu extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback? press;
  const ProfileMenu({Key? key,
    required this.text,
    required this.icon,
    this.press,}) : super(key: key);

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: EdgeInsets.all(20),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: widget.press,
        child: Row(
          children: [
            Icon(widget.icon),
            SizedBox(width: 20),
            Expanded(child: Text(widget.text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
