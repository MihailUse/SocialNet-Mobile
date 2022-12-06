import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/domain/services/auth_service.dart';
import 'package:social_net/ui/app_navigator.dart';

class _ViewModel {
  final _authService = AuthService();

  _ViewModel() {
    _asyncInit();
  }

  void _asyncInit() async {
    if (await _authService.checkAuth()) {
      AppNavigator.toMain();
    } else {
      AppNavigator.toAuth();
    }
  }
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget create() => Provider<_ViewModel>(
        lazy: false,
        create: (_) => _ViewModel(),
        child: const LoaderWidget(),
      );
}
