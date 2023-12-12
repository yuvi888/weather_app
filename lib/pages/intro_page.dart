import 'package:flutter/material.dart';
import 'package:weather_app_tutorial/constant/colors.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Container(
              height: 300,
              child: Image.asset(
                  'assets/4.png',
                  
                ), 
                
            ),
            const SizedBox(height: 30,),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        )
      ),
    );
  }
}