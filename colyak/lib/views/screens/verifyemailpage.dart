import 'package:colyak/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  final String verificationId;

  VerifyEmailPage({required this.verificationId});

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final TextEditingController _oneTimeCodeController = TextEditingController();
  final AuthController _authController = AuthController();

  void _verifyEmail() async {
    final oneTimeCode = _oneTimeCodeController.text;
    final success = await _authController.verifyEmail(context, widget.verificationId, oneTimeCode);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-posta doğrulandı!'),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-posta doğrulama başarısız oldu.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('E-posta Doğrulama')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _oneTimeCodeController,
              decoration: InputDecoration(labelText: 'Doğrulama Kodu'),
            ),
            ElevatedButton(
              onPressed: _verifyEmail,
              child: Text('Doğrula'),
            ),
          ],
        ),
      ),
    );
  }
}
