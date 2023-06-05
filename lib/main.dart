import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_chat_app/screens/auth_screen.dart';
import 'package:project_chat_app/screens/chat_screen.dart';
import 'package:project_chat_app/screens/splash_screen.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
        builder: (context, snapshot){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
                primarySwatch: Colors.brown,
                primaryColor: Colors.brown,
                buttonTheme: ButtonTheme.of(context).copyWith(
                    buttonColor: Colors.brown,
                    textTheme: ButtonTextTheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                )
            ),
            home: snapshot.connectionState != ConnectionState.done ?
                const SplashScreen() :
                StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const SplashScreen();
                    }
                    if (userSnapshot.hasData) {
                      return const ChatScreen();
                    }
                    return const AuthScreen();
                  }
                ),
          );
        }
    );

  }
}