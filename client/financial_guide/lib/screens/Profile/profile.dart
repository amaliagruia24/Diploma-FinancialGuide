import 'package:financial_guide/constants.dart';
import 'package:financial_guide/screens/Profile/profile.menu.dart';
import 'package:financial_guide/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      backgroundColor: kPrimaryColor,),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: 115,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 4,
                  child: SvgPicture.asset("assets/profile-svgrepo-com.svg"),
                ),
              ),
            ),
            const SizedBox(height: 50,),
            ProfileMenu(text: "Personal details", icon: Icons.edit),
            ProfileMenu(
                text: "Change Password",
                icon: Icons.lock,
            ),
            ProfileMenu(
              text: "Log Out",
              icon: Icons.logout_sharp,
              press: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0))),
                        title: Text('Log out'),
                        content: Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel", style: TextStyle(color: Colors.red),)),
                          TextButton(onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.remove('token');
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                builder: (context) => WelcomeScreen()), (Route route) => false);
                            print(prefs.getString('token'));
                          }, child: Text("Log out", style: TextStyle(color: Colors.green),))
                        ],
                      );
                    });

              },)
          ],
        ),
      )
    );
  }
}
