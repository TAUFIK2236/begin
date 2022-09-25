import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/Constants/routes.dart';
import 'package:untitled/firebase_options.dart';
import 'package:untitled/services/auth/auth_except.dart';
import 'package:untitled/services/auth/auth_service.dart';
import 'package:untitled/services/auth/auth_user.dart';
import 'dart:developer' as devtools show log;

import '../utilities/show_erorr_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: "Enter ur email"),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(hintText: "Enter ur password"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {

                        await AuthService.firebase().logIn(
                          email: email,
                          password: password,
                        );

                        final user = await AuthService.firebase().currentUser;
                        if (user?.isEmailVerified ?? false) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              notesRoutes, (route) => false);
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoutes, (route) => false);
                        }
                      } on UserNotFoundAuthException  {
                        await showErrorDialog(
                          context,
                          "User not found",
                        );
                      } on WrongPasswordAuthException  {
                        await showErrorDialog(
                          context,
                          "Wrong password",
                        );
                      } on GenericAuthException  {
                        await showErrorDialog(context, 'Authentication Error');
                      }
                    },
                    child: const Text("Login"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoutes, (route) => false);
                    },
                    child: Text("Not Register yet?Register here!"),
                  )
                ],
              );
            default:
              return const Text('loading');
          }
        },
      ),
    );
  }
}
