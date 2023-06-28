import 'package:flutter/material.dart';

class ErrorSnackBar {
  static showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Oops!",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )
          ),
        )
    );
  }

}
// class ErrorSnackBar extends StatelessWidget {
//   const ErrorSnackBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         content: Container(
//             padding: const EdgeInsets.all(16),
//             height: 90,
//             decoration: const BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   "Oops!",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 Text(
//                   "That email address is already in use! Please try with a different one.",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 )
//               ],
//             )
//         ),
//       );
//   }
// }
