import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tezda_task/common_widgets/common_textfield.dart';
import 'package:tezda_task/pages/tezda_profile_page.dart';
import 'package:tezda_task/services/firebase_store.dart';
import 'package:tezda_task/services/local_store.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
                    image: AssetImage('assets/tezda.png')),
                borderRadius: BorderRadius.circular(120),
              ),
            ),
            CustomTextField(
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter some valid email';
                  }
                  return null;
                },
                controller: emailController),
            const SizedBox(height: 16.0),
            CustomTextField(
                hintText: 'Enter your password',
                prefixIcon: Icons.lock,
                validator: (p0) => p0!.length < 6
                    ? 'Password must be at least 6 characters long'
                    : null,
                controller: passwordController),
            const SizedBox(height: 16.0),
            CustomTextField(
              hintText: 'Enter your address',
              prefixIcon: Icons.location_city,
              controller: addressController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some valid address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () async {
                if (emailController.text.contains('@') &&
                    passwordController.text.length > 6 &&
                    addressController.text.isNotEmpty) {
                  bool res = await signupMethod(
                    emailController.text,
                    passwordController.text,
                  );
                  if (res) {
                    Navigator.pushNamed(context, '/home');
                  }
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
                  'Sign Up',
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
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('I have an Account! Login',
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

  Future<bool> signupMethod(
    String email,
    String password,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential.user!.email);
      credential.toString();
      LocalStore.saveData(key: 'uid', value: credential.user?.uid.toString());
      useruuid.value = credential.user?.uid.toString() ?? '';
      FirebaseServices().addUserIfNotExists(
        credential.user?.uid.toString() ?? '',
        credential.user?.displayName.toString() ?? '',
        credential.user?.email.toString() ?? '',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
