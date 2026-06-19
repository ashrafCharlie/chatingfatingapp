import 'package:chatingfatingapp/components/rounded_button.dart';
import 'package:chatingfatingapp/constants.dart';
import 'package:chatingfatingapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: "logo",
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(height: 48.0),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value.trim();
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value.trim();
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: "Enter your Password",
              ),
            ),
            SizedBox(height: 24.0),

            RoundedButton(
              color: Colors.lightBlueAccent,
              buttonTitle: 'Log In',
              onTap: () async {
                if (email.isEmpty || password.isEmpty) {
                  print("Email password empty");
                  return;
                }
                //Implement login functionality.
                try {
                  final loggedUser = await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (!mounted) {
                    return;
                  }
                  if (loggedUser.user != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
