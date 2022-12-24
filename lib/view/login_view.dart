import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/Constants/routes.dart';
import 'package:untitled/firebase_options.dart';
import 'package:untitled/services/auth/auth_except.dart';
import 'package:untitled/services/auth/auth_service.dart';
import 'package:untitled/services/auth/auth_user.dart';
import 'package:untitled/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/services/auth/bloc/auth_event.dart';
import 'package:untitled/services/auth/bloc/auth_state.dart';
import 'package:untitled/utilities/dialogs/loading_dialog.dart';
import 'dart:developer' as devtools show log;

import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

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
          if (state is AuthStateLoggedOut) {
            final closeDialog = _closeDialogHandle;

            if (!state.isLoading && closeDialog != null) {
              closeDialog();
              _closeDialogHandle = null;
            } else if (state.isLoading && closeDialog == null) {
              _closeDialogHandle = showLoadingDialog(
                context: context,
                text: "Loading....",
              );
            }

            if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(context, "User not Found");
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(context, "Wrong Credential");
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, "Authentication error");
            }
          }
        },
        child: Scaffold(
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
                        decoration: InputDecoration(
                          hintText: "Enter ur password",
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                                AuthEventlogIn(
                                  email,
                                  password,
                                ),
                              );
                        },
                        child: const Text("Login"),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                              AuthEventShouldRegister(),);
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
        ));
  }
}
