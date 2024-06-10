import 'package:deteksi_buah_karbit/Home/main.dart';
import 'package:deteksi_buah_karbit/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:deteksi_buah_karbit/widgets/constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/hero.png',
              width: 400,
              height: 400,
            ),
            Column(
              children: [
                Text(
                  'Mango Detector',
                  style: mainTitleStyle,
                ),
                SizedBox(height: 10),
                Container(
                  width: 250,
                  child: Text(
                    'Deteksi Mangga Karbit Jaga Kesehatanmu',
                    style: subTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            SizedBox(height: 50),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [primaryColor, secondaryColor]),
                  borderRadius: BorderRadius.circular(50)),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Container(
                  width: 130,
                  child: Row(
                    children: [
                      Text('Get Started', style: buttonStyle),
                      SizedBox(width: 10),
                      Image.asset(
                        'assets/Icon/arrow_right.png',
                        width: 24,
                        height: 28,
                      )
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent),
              ),
            )
          ],
        ),
      ),
    );
  }
}
