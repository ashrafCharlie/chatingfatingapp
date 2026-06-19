import 'package:chatingfatingapp/screens/chat_screen.dart';
import 'package:chatingfatingapp/screens/login_screen.dart';
import 'package:chatingfatingapp/screens/registration_screen.dart';
import 'package:chatingfatingapp/screens/welcome_screen.dart';
import 'package:flutter/material.dart';


void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),

      initialRoute: WelcomeScreen.id,
      routes:{
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      } ,
    );
  }
}
