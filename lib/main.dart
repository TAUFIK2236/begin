



import 'package:flutter/material.dart';
import 'package:path/path.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/Constants/routes.dart';
import 'package:untitled/services/auth/auth_service.dart';
import 'package:untitled/view/Register.dart';
import 'package:untitled/view/login_view.dart';
import 'package:untitled/view/notes/new__note_view.dart';
import 'package:untitled/view/notes/notes_view.dart';
import 'package:untitled/view/verify_email.dart';
import 'firebase_options.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoutes: (context) => const LoginView(),
      registerRoutes: (context) => const RegisterView(),
      notesRoutes  :(context) => const NotesView(),
      verifyEmailRoutes:(context) => const VerifyEmailView(),
      newNoteRoute:(context) => const NewNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user =AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {

                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}




