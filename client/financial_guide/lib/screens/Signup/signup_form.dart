import 'dart:convert';

import 'package:financial_guide/components/snackbar.error.dart';
import 'package:financial_guide/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
final _formKey = GlobalKey<FormState>();

class SignUp extends StatefulWidget {
  @override
  SignupForm createState() => SignupForm();

}

class SignupForm extends State<SignUp> {
  SignupForm({
    Key? key,
  });

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValid = false;

  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  bool validatePassword(String pass){
    String _password = pass.trim();
    if(passValid.hasMatch(_password)){
      return true;
    }else{
      return false;
    }
  }

  void registerUser() async {
    if(emailController.text.isNotEmpty && nameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var registerBody = {
        "fullName": nameController.text,
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse('http://192.168.1.5:3000/api/register'),
          body: jsonEncode(registerBody), 
          headers: {"Content-Type": "application/json"},
      );

      var jsonresponse = jsonDecode(response.body);

      if(jsonresponse['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register Succesfully'))
        );
      } else if (jsonresponse['status'] == false) {
        ErrorSnackBar.showError(context, "That email address is already in use! Please try with a different one.");
      }
    } else {
      setState(() {
        _isNotValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (name) {

            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Your full name",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@') || !value.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (email) {

              },
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              validator: (value){
                if(value!.isEmpty){
                  return "Please enter password";
                }else{
                  //call function to check password
                  bool result = validatePassword(value);
                  if(result){
                    // create account event
                    return null;
                  }else{
                    return " Password should contain Capital, small letter & Number & Special Character";
                  }
                }
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              if(_formKey.currentState!.validate() && _isNotValid == false) {
                registerUser();
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
        ],
      ),
    );
  }
}