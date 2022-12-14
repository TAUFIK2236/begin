import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/Constants/routes.dart';
import 'package:untitled/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/services/auth/auth_except.dart';
import 'package:untitled/services/auth/auth_service.dart';
import 'package:untitled/services/auth/bloc/auth_bloc.dart';
import 'package:untitled/services/auth/bloc/auth_event.dart';
import 'package:untitled/services/auth/bloc/auth_state.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak password");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "Email is already in use");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to register");
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Register"),
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
                        decoration:
                            InputDecoration(hintText: "Enter ur password"),
                      ),
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  email,
                                  password,
                                ),
                              );
                          // try {
                          //   await AuthService.firebase().createUser(
                          //     email: email,
                          //     password: password,
                          //   );
                          //
                          //   AuthService.firebase().sendEmailVerification();
                          //   Navigator.of(context).pushNamed(verifyEmailRoutes);
                          // } on WeakPasswordAuthException {
                          //   await showErrorDialog(
                          //     context,
                          //     "WEAK PASSWORD",
                          //   );
                          // } on EmailAlreadyInUseAuthException {
                          //   await showErrorDialog(
                          //     context,
                          //     "Email already in use",
                          //   );
                          // } on InvalidEmailAuthException {
                          //   await showErrorDialog(
                          //     context,
                          //     "Invalid Email",
                          //   );
                          // } on GenericAuthException {
                          //   await showErrorDialog(
                          //       context, "Failed to register ");
                          // }
                        },
                        child: const Text("Register"),
                      ),
                      TextButton(
                          onPressed: () {

                            context.read<AuthBloc>().add(AuthEventLogOut(),);

                            // Navigator.of(context).pushNamedAndRemoveUntil(
                            //     loginRoutes, (route) => false);
                          },
                          child: Text("Already registered? Login here!"))
                    ],
                  );
                default:
                  return const Text('loading');
              }
            },
          )),
    );
  }
}
