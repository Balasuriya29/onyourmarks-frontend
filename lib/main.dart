import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onyourmarks/Pages/LoginPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          appId: "1:269652040859:android:49fa2700f8def261e1fa3e",
          messagingSenderId: "269652040859",
          projectId: "onyourmarks-60696",
          apiKey: 'AIzaSyD6WZ4OWlfjUrBw4B8d6tWJPWB23E6s114')
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginPage(),
    );
  }
}

