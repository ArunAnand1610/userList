import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:userlist_projects/Pages/authscrreen.dart';
import 'package:userlist_projects/Pages/homescreen.dart';
import 'package:userlist_projects/firebase_options.dart';

Future<void> main() async {
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
      ),
      home:StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snap) {
          final user = snap.data;
          if (user == null) {
            return const LoginPage();
          }
          return const HomeScreen();
        },
      ),
    );
  }
}

//apple_watch
//sample_image

