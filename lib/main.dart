import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_providers_app/Common_access/Common.dart';
import 'package:travel_providers_app/splashscreen/index_splash.dart';
import 'package:travel_providers_app/splashscreen/splashscreen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences=await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:IndexSplash(),
    );
  }
}

