
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:mobapp/pages/registration.dart';





void Fire() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void main() {
  Fire();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Моя онлайн библиотека',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: RegistrationPage(),
    );
  }
}
