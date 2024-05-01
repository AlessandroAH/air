import 'package:flutter/material.dart';
import 'package:flutter_application_1/registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement login logic here
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Navigate to registration page
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
              },
              child: Text(
                'Non hai un account? Registrati qui',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}