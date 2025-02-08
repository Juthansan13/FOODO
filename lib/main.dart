import 'package:firebase/Onbording/onbording1.dart';
import 'package:firebase/firebase_options.dart';
import 'package:firebase/pages/Dashboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     //home: DashboardPage(),
      
      title: defaultFirebaseAppName,
      debugShowCheckedModeBanner: false,
      
      routes:{
        "/": (context) => const Onboarding(),
        "Homepage": (context) => const DashboardPage(),
       
      },
      

    );
  }
}