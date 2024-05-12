import 'package:flutter/material.dart';
import 'package:AIR/main.dart';
import 'package:AIR/registration_page.dart';
import 'package:AIR/services/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Aggiunge 16 pixel di spazio intorno al contenuto
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(
                      255, 204, 255, 145), // Imposta il colore di sfondo
                  filled: true, // Necessario per far funzionare fillColor
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(
                      255, 204, 255, 145), // Imposta il colore di sfondo
                  filled: true, // Necessario per far funzionare fillColor
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 199, 130, 255),
                ),
                onPressed: () {
                  String email = emailController.text;
                  String password = passwordController.text;
                  if (ApiService().login(email, password) != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                    );
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Navigate to registration page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()));
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
      ),
    );
  }
}