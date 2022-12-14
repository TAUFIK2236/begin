import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/Constants/routes.dart';
import 'package:untitled/services/auth/auth_service.dart';
import 'package:untitled/services/auth/bloc/auth_bloc.dart';
import 'package:untitled/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify"),
      ),
      body: Column(
        children: [
          Text("we have sent a verification email to your email account"),
          Text(
              "If you havent received a verification plz press the button below"),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    AuthEventSendEmailVerification(),
                  );
              // await AuthService.firebase().sendEmailVerification();
            },
            child: Text("Send email verification"),
          ),
          TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                  AuthEventLogOut(),
                );
                // await AuthService.firebase().logOut();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   registerRoutes,
                //   (route) => false,
                // );
              },
              child: Text("Restart")),
        ],
      ),
    );
  }
}
