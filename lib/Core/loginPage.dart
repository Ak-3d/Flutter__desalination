import 'package:final_project/Widgets/alertShow.dart';
import 'package:final_project/main.dart';
import 'package:flutter/material.dart';

import '../Pages/Dashboard.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  Future<void> signIn(BuildContext context) async {
    final pass = objectbox.user.get(1);
    if (passwordController.text == pass!.password) {
      await alertDialog(context, "Successful Password", "Sign-in Ok");
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const Dashboard()),
          (e) => false);
    } else {
      // Display error message or handle sign-in failure
      alertDialog(context, "Wrong Password !!", "Sign-in Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
                constraints:
                    const BoxConstraints(maxWidth: 200, maxHeight: 200),
                child: Image.asset("assets/images/logo.png")),
            Column(
              children: [
                // TextField(
                //   controller: emailController,
                //   decoration: const InputDecoration(
                //       hintText: "Email@example.com",
                //       labelText: 'Email',
                //       prefixIcon: Icon(Icons.email)),
                // ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      hintText: "Enter your password here",
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.password)),
                  obscureText: true,
                ),

                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async => signIn(context),
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
