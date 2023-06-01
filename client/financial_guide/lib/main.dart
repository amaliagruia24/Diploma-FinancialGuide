import 'package:financial_guide/constants.dart';
import 'package:financial_guide/screens/welcome_screen.dart';
import 'package:financial_guide/screens/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(token: prefs.getString('token'),));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({@required this.token,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: kPrimaryColor,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: kPrimaryLightColor,
          iconColor: kPrimaryColor,
          prefixIconColor: kPrimaryColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
          )),
      //home: (JwtDecoder.isExpired(token) == false) ? DashboardPage(token: token) : const WelcomeScreen(),
      home: const WelcomeScreen(),
      );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'communication',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.purple
//       ),
//       home: Scaffold(
//         appBar: AppBar(title: Text('Financial Guide')),
//         body: BodyWidget(),
//       ),
//     );
//   }
// }
//
// class BodyWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return new BodyWidgetState();
//   }
// }
//
// class BodyWidgetState extends State<BodyWidget> {
//   String message = 'Press here';
//   @override
//   Widget build(BuildContext context) {
//
//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: SizedBox(
//           width: 200,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton(
//                     onPressed: () {
//                       fetchData();
//                     },
//                     child: Text('Send request to sevrer')),
//                 Padding(padding: const EdgeInsets.all(8.0),
//                 child: Text(message))
//               ],
//             ),
//         ),
//       ),
//     );
//   }
//
//   Future<http.Response> fetchData() async {
//     final response = await http.get(Uri.parse('http://192.168.1.8:3000'));
//     setState(() {
//       message = response.body;
//     });
//     print("aici");
//     print(response.body);
//     return response;
//   }
// }

