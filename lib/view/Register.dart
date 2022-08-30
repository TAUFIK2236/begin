import 'package:flutter/material.dart';
import 'package:untitled/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
    return Scaffold(
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
                        try{
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: email, password: password);
                          print(userCredential);
                        } on FirebaseAuthException catch(e) {
                          print(e.code);
                          if (e.code == "weak-password") {
                            print("Weak password");
                          }else if (e.code =="email-already-in-use" ){
                            print("Email already in use");
                          }
                          else if (e.code == "invalid-email"){
                            print("Invalid Email");
                          }
                        }

                      },
                      child: const Text("Register"),
                    ),
                  ],
                );
              default:
                return const Text('loading');
            }
          },
        )
    );
  }
}