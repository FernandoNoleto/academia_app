import 'package:flutter/material.dart';
import 'package:academiaapp/pages/home_page.dart';
import 'package:academiaapp/pages/login_page.dart';

/*Plugins*/
import 'package:firebase_core/firebase_core.dart';
import 'package:academiaapp/firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gym App',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}