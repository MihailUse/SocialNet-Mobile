import 'package:flutter/material.dart';
import 'package:social_net/domain/services/auth_service.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';

class LoaderWidget extends StatelessWidget {
  LoaderWidget({super.key}) {
    asyncInit();
  }

  final _authService = AuthService();

  void asyncInit() async {
    if (await _authService.checkAuth()) {
      await AppNavigator.toMain();
    } else {
      await AppNavigator.toAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
