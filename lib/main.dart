import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tezda_task/pages/login_page.dart';
import 'package:tezda_task/pages/signup_page.dart';
import 'package:tezda_task/pages/tezda_home_page.dart';
import 'package:tezda_task/pages/tezda_profile_page.dart';
import 'package:tezda_task/services/local_store.dart';

String uid = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  uid = await LocalStore.readString('uid') ?? '';

  uid = uid.isEmpty ? '/login' : '/home';

  runApp(const TezdaApp());
}

class TezdaApp extends StatelessWidget {
  const TezdaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: uid,
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => TezdaHomePage(),
        '/profile': (context) => const ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
