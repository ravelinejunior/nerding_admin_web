import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nerding_admin_web/screen/home_screen/home_screen.dart';
import 'package:nerding_admin_web/screen/login_screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nerding Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
