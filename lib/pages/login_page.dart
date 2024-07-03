import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tezda_task/common_widgets/common_textfield.dart';
import 'package:tezda_task/pages/tezda_profile_page.dart';
import 'package:tezda_task/services/firebase_store.dart';
import 'package:tezda_task/services/local_store.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 240,
              width: 240,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/tezda.png')),
                borderRadius: BorderRadius.circular(130),
              ),
            ),
            CustomTextField(
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !value.contains('@') && !value.endsWith('.com')) {
                    return 'Please enter some valid email';
                  }
                  return null;
                },
                controller: emailController),
            const SizedBox(height: 16.0),
            CustomTextField(
                hintText: 'Enter your password',
                prefixIcon: Icons.lock,
                controller: passwordController),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () async {
                bool res = await loginMethod(
                  emailController.text,
                  passwordController.text,
                );
                if (res) {
                  Navigator.pushNamed(context, '/home');
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Center(
                    child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('I Don\'t have an Account!  Sign Up',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> loginMethod(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      print(credential);
      LocalStore.saveData(key: 'uid', value: credential.user?.uid);
      useruuid.value = credential.user?.uid.toString() ?? '';
      FirebaseServices().addUserIfNotExists(
        credential.user?.uid.toString() ?? '',
        credential.user?.displayName.toString() ?? '',
        credential.user?.email.toString() ?? '',
      );
      return credential.user?.uid.isNotEmpty ?? false;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return false;
  }
}
