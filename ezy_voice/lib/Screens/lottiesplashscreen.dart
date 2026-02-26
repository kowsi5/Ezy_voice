// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class LottieSplashScreen extends StatelessWidget {
//   const LottieSplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         height: 100,
//         width: 100,
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(247, 245, 245, 0.956).withOpacity(0.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(
//           child: Lottie.asset(
//             'assets/voice_loader.json',
//             width: 90,
//             height: 90,
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class LottieSplashScreen extends StatefulWidget {
  const LottieSplashScreen({super.key});

  @override
  State<LottieSplashScreen> createState() => _LottieSplashScreenState();
}

class _LottieSplashScreenState extends State<LottieSplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Lottie.asset(
              'assets/voice_loader.json',
              width: 90,
              height: 90,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}