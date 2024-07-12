import 'package:colyak/controllers/auth_controller.dart';
import 'package:colyak/models/auth_model.dart';
import 'package:colyak/views/widgets/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _rememberMe = false;

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final success = await _authController.login(context, email, password);

    if (success) {
      if (_rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setBool('rememberMe', true);

        final authModel = Provider.of<AuthModel>(context, listen: false);
        await prefs.setString('token', authModel.token!);
        await prefs.setString('refreshToken', authModel.refreshToken!);
        await prefs.setString('userName', authModel.userName!);
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
            (Route<dynamic> route) => false,
      );
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            CheckboxListTile(
              title: Text('Remember Me'),
              value: _rememberMe,
              onChanged: (newValue) {
                setState(() {
                  _rememberMe = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
