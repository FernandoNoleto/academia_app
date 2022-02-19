import 'package:flutter/material.dart';
import 'package:academiaapp/pages/set_daily_exercises.dart';
import 'package:academiaapp/pages/home_page.dart';
import 'package:academiaapp/pages/login_page.dart';

/*Plugins*/
import 'package:firebase_core/firebase_core.dart';
// import 'package:academiaapp/firebase_options.dart';

/*
apiKey: 'AIzaSyDNQN3CqKN52imrBElkpA2cd0bPt6JzmQw',
appId: '1:623652127430:android:90cd8fdf32703d36118dc7',
messagingSenderId: '623652127430',
projectId: 'academia-app-8ac31',
storageBucket: 'academia-app-8ac31.appspot.com',
databaseURL: 'academia-app-8ac31-default-rtdb.firebaseio.com'
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // await Firebase.initializeApp();
  // if(Firebase.apps.isEmpty){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDNQN3CqKN52imrBElkpA2cd0bPt6JzmQw',
          appId: '1:623652127430:android:90cd8fdf32703d36118dc7',
          messagingSenderId: '623652127430',
          projectId: 'academia-app-8ac31',
          databaseURL: 'https://academia-app-8ac31-default-rtdb.firebaseio.com/',
      ),
    );
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gym App',
      home: SetDailyExercisesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}