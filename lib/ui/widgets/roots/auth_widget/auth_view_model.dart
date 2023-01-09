import 'package:flutter/material.dart';
import 'package:social_net/domain/exceptions/bad_request_exception.dart';
import 'package:social_net/domain/exceptions/internal_server_exception.dart';
import 'package:social_net/domain/exceptions/timeout_exception.dart';
import 'package:social_net/domain/exceptions/un_authorized_exception.dart';
import 'package:social_net/domain/services/auth_service.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';

class AuthState {
  final String login;
  final String password;
  final bool isLoading;

  const AuthState({
    this.login = "user@example.com",
    this.password = "string",
    this.isLoading = false,
  });

  AuthState copyWith({
    String? login,
    String? password,
    bool? isLoading,
  }) {
    return AuthState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._context) {
    loginController = TextEditingController(text: state.login);
    passwordController = TextEditingController(text: state.password);

    loginController.addListener(() => state = state.copyWith(login: loginController.text));
    passwordController.addListener(() => state = state.copyWith(login: passwordController.text));
  }

  var _state = const AuthState();
  final BuildContext _context;
  final _authService = AuthService();
  final formGlobalKey = GlobalKey<FormState>();
  late final TextEditingController loginController;
  late final TextEditingController passwordController;

  bool get isLoading => state.isLoading;
  set isLoading(bool value) => state = state.copyWith(isLoading: value);

  AuthState get state => _state;
  set state(AuthState value) {
    _state = value;
    notifyListeners();
  }

  void showError(String text) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> onAuthButtonPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formGlobalKey.currentState!.validate()) return;

    isLoading = true;
    // await Future.delayed(const Duration(seconds: 10));

    try {
      await _authService.login(state.login, state.password);
      await AppNavigator.toMain();
      return;
    } on TimeoutException {
      showError("timeout exceeded");
    } on InternalServerException {
      showError("try later");
    } catch (e) {
      if (e is BadRequestException && e.errorResponse?.errors != null) {
        final errors = e.errorResponse!.errors!;
        String errorMessage = "";

        // display errors from server
        for (var element in errors.entries) {
          for (var errorString in element.value) {
            errorMessage += "$errorString\n";
          }
        }

        showError(errorMessage);
      } else if (e is UnAuthorizedException) {
        showError("invalid credentials");
      } else {
        showError("try later");
      }
    }

    isLoading = false;
  }

  String? validateLogin(String? value) {
    final emailPattern = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value == null || value.isEmpty) return "email required";
    if (!emailPattern.hasMatch(value)) return "invalid email";
    if (value.length > 64) return "email is too long";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "password required";
    if (value.length < 4) return "password is short";
    if (value.length > 64) return "password is too long";
    return null;
  }

  void onRegistrationButtonPressed() async {
    await AppNavigator.toRegistration();
  }
}
