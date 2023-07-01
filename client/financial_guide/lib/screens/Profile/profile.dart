import 'dart:convert';

import 'package:financial_guide/constants.dart';
import 'package:financial_guide/screens/Profile/profile.menu.dart';
import 'package:financial_guide/screens/welcome_screen.dart';
import 'package:financial_guide/services/notification.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  NotificationsServices notificationsServices = NotificationsServices();

  @override
  void initState() {
    super.initState();
    notificationsServices.initialiseNotifications();
  }

  Future<void> updateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
    String email = jwtDecodedToken['email'];

    if(oldPasswordController.text.isNotEmpty && newPasswordController.text.isNotEmpty) {
      var reqBody = {
        "email": email,
        "password": oldPasswordController.text,
        "newPassword": newPasswordController.text
      };

      var response = await http.put(Uri.parse('http://192.168.1.5:3000/api/updatePassword'),
        body: jsonEncode(reqBody),
        headers: {"Content-Type": "application/json"},
      );

      var jsonResponse = jsonDecode(response.body);
      if(jsonResponse['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password updated succesfuly.'))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong.'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter Values'))
      );
    }

  }

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
                press: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0))),
                          title: const Text("Change your password"),
                          content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: oldPasswordController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    cursorColor: kPrimaryColor,
                                    onSaved: (value) {

                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter old password';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Old password",
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.all(defaultPadding),
                                        child: Icon(Icons.lock),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                                    child: TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: newPasswordController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      cursorColor: kPrimaryColor,
                                      onSaved: (value) {

                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter new password';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "New password",
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.all(defaultPadding),
                                          child: Icon(Icons.lock),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  oldPasswordController.clear();
                                  newPasswordController.clear();
                                },

                                child: Text("Cancel", style: TextStyle(color: Colors.red),),
                            ),
                            TextButton(
                                onPressed: () {
                                  if(_formKey.currentState!.validate()) {
                                    updateUser();
                                  }
                                  Navigator.pop(context);
                                  oldPasswordController.clear();
                                  newPasswordController.clear();
                                },
                                child: Text("Save new password", style: TextStyle(color: kPrimaryColor),))
                          ],
                        );
                      });
                }),
            ProfileMenu(
              text: "Log Out",
              icon: Icons.logout_sharp,
              press: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
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

              },
            ),
            ProfileMenu(
              text: "Enable Notifications",
              icon: Icons.notifications_active_outlined,
              press: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Enable notifications'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('Financial Guide wants to send you '
                                'notifications whenever new financial information '
                                'is available on the Dashboard Screen. New information '
                                'arrives every 24h. Allow this type of notifications?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Allow'),
                          onPressed: () {
                            notificationsServices.scheduleNotifications("Scheduled Notification", "Content");
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Don\'t allow'),
                          onPressed: () {
                            notificationsServices.stopNotifications();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      )
    );
  }
}
