import 'package:crudamd/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_)=> home()));
    }
    );
  }
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white
          // gradient: LinearGradient(
          //     colors: [Colors.redAccent, Colors.orangeAccent],
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft
          // )
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset('assets/images/AMD1.png',
          fit: BoxFit.cover,
          width: 350),
        ),
      ),
    );
  }
}
