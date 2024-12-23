import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:mobapp/pages/ligin.dart';
import 'package:mobapp/pages/Glavnay.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});


  // void regitration1() async{
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  // }


  String userMail = '';
  String userName = '';
  String userPass = '';
  String userPass2 = '';


  @override
  Widget build(BuildContext context) {
    // regitration1();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Моя онлайн\nбиблиотека",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "Регистрация",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Имя пользователя
                const Text(
                  "Имя пользователя",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (String value){
                    userName = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Как вас зовут?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Электронная почта
                const Text(
                  "Электронная почта",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (String value){
                    userMail = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(

                    hintText: "Введите ваш электронный адрес",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Пароль
                const Text(
                  "Пароль",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (String value){
                    userPass = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    suffixIcon: Icon(Icons.visibility_off),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Подтвердите пароль
                const Text(
                  "Подтвердите пароль",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (String value){
                    userPass2 = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    suffixIcon: Icon(Icons.visibility_off),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Кнопка "Зарегистрироваться"
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      print(userName);
                      print(userMail);
                      print(userPass);
                      print(userPass2);

                      if (userPass2 != userPass) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                "Пароли не совпадают",
                                style: TextStyle(fontSize: 16, color: Colors.redAccent),
                              ),
                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Окей"),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        FirebaseFirestore.instance.collection('userInfo').add({'name': userName, 'mail': userMail, 'pass': userPass, 'pass2': userPass2});

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContentView()),
                        );
                      }
                      // Действие при нажатии на кнопку
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Зарегистрироваться",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Текст "У меня уже есть аккаунт"
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => logInPage()),
                      );
                    },
                    child: const Text(
                      "У меня уже есть аккаунт",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
