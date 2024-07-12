import 'package:colyak/controllers/auth_controller.dart';
import 'package:colyak/models/auth_model.dart';
import 'package:colyak/models/service/cacheManager.dart';
import 'package:colyak/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthController _authController = AuthController();
  final CustomCacheManager _customCacheManager = CustomCacheManager();

  void _logout(BuildContext context) async {
    await _authController.logout(context);
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _clearCache(BuildContext context) async {
    await _customCacheManager.cleanDefaultCacheManager();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Önbellek temizlendi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<AuthModel>(context).userName;
    final email = Provider.of<AuthModel>(context).email;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Center(
          child: Text('Çölyak'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_circle,
                size: 70,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$userName',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text('$email')
                  ],
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => _clearCache(context),
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent)),
            child: Text('Önbelliği Temizle'),
          ),
          TextButton(
              onPressed: () => _logout(context),
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent)),
              child: Text('Çıkış Yap'))
        ],
      ),
    );
  }
}
