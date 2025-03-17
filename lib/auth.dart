import 'package:flutter/material.dart';
import 'package:mess_scuf/database/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/logo.png",
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                controller: emailController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                controller: passController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    )),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, '/rec');
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.85,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passController.text.isEmpty) {
                    print("Поля пустые");
                  } else {
                    var user = await authService.signIn(
                        emailController.text, passController.text);
                    if (user != null) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', true);
                      Navigator.popAndPushNamed(context, '/chats');
                    } else {
                      print("Пользователь не существует");
                    }
                  }
                },
                child: Text("Sign In"),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    indent: MediaQuery.of(context).size.height * 0.05,
                    endIndent: MediaQuery.of(context).size.width * 0.02,
                    color: Colors.black38,
                    thickness: 1,
                  ),
                ),
                const Text("или"),
                Expanded(
                  child: Divider(
                    indent: MediaQuery.of(context).size.width * 0.02,
                    endIndent: MediaQuery.of(context).size.height * 0.05,
                    color: Colors.black38,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.85,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/reg');
                },
                child: Text("Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
