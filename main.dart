import 'package:crudamd/home.dart';
import 'package:crudamd/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'amdsales',
    options: const FirebaseOptions(
        apiKey: ' AIzaSyCylcmuYWrW36gLDdquvIDq_ZyJTYTwvh8  ',
        appId: '1:673618353788:android:52f225f92d137ba67833f9',
        messagingSenderId: '673618353788',
        projectId: 'amdsales-26ae0')
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: 'splash_screen',
      routes: {
         'splash_screen': (context)=> SplashScreen(),
        'home': (context)=>home(),},
    );
  }
}



