
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/Constants/routes.dart';

import 'package:untitled/services/auth/bloc/auth_bloc.dart';
import 'package:untitled/services/auth/bloc/auth_event.dart';
import 'package:untitled/services/auth/bloc/auth_state.dart';
import 'package:untitled/services/auth/firebase_auth_provider.dart';
import 'package:untitled/view/Register.dart';
import 'package:untitled/view/login_view.dart';
import 'package:untitled/view/notes/create_update_note_view.dart';
import 'package:untitled/view/notes/notes_view.dart';
import 'package:untitled/view/verify_email.dart';

//import 'package:firebase_core/firebase_core.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
        child:  const HomePage()
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthStateLoggedIn) {
            return const NotesView();
          } else if (state is AuthStateNeedsVerification) {
            return VerifyEmailView();
          } else if (state is AuthStateLoggedOut) {
            return LoginView();
          }else if (state is AuthStateRegistering) {
            return RegisterView();//new one
          }  else {
            return Scaffold(
                body: CircularProgressIndicator()
            );
          }
        }
    );
  }
}


