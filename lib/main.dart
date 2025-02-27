import 'package:flutter/material.dart';
import 'package:mess_scuf/auth.dart';
import 'package:mess_scuf/chats.dart';
import 'package:mess_scuf/contacts.dart';
import 'package:mess_scuf/recovery.dart';
import 'package:mess_scuf/reg.dart';

void main() {
  runApp(const AppTheme());
}

class AppTheme extends StatelessWidget {
  const AppTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          scaffoldBackgroundColor: Colors.white,
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blue)),
                ),
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                foregroundColor: WidgetStatePropertyAll(Colors.black)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(Colors.lightBlue),
                foregroundColor: WidgetStatePropertyAll(Colors.white)),
          )),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthPage(),
        '/reg': (context) => RegPage(),
        '/rec': (context) => RecoveryPage(),
        '/chats': (context) => ChatsPage(),
        '/contacts': (context) => ContactsPage(),
      },
    );
  }
}
