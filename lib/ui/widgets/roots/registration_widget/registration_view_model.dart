import 'package:flutter/material.dart';

import 'package:social_net/domain/exceptions/exceptions.dart';
import 'package:social_net/domain/services/auth_service.dart';
import 'package:social_net/ui/navigation/app_navigator.dart';

class RegistrationState {
  final String email;
  final String nickname;
  final String password;
  final String passwordRetry;
  final bool isLoading;

  const RegistrationState({
    this.email = "",
    this.nickname = "",
    this.password = "",
    this.passwordRetry = "",
    this.isLoading = false,
  });

  RegistrationState copyWith({
    String? email,
    String? nickname,
    String? password,
    String? passwordRetry,
    bool? isLoading,
  }) {
    return RegistrationState(
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      password: password ?? this.password,
      passwordRetry: passwordRetry ?? this.passwordRetry,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RegistrationViewModel extends ChangeNotifier {
  RegistrationViewModel(this._context) {
    emailController = TextEditingController(text: state.email);
    nicknameController = TextEditingController(text: state.nickname);
    passwordController = TextEditingController(text: state.password);
    passwordRetryController = TextEditingController(text: state.passwordRetry);

    emailController.addListener(() => state = state.copyWith(email: emailController.text));
    nicknameController.addListener(() => state = state.copyWith(nickname: nicknameController.text));
    passwordController.addListener(() => state = state.copyWith(password: passwordController.text));
    passwordRetryController.addListener(() => state = state.copyWith(passwordRetry: passwordRetryController.text));
  }

  var _state = const RegistrationState();
  final BuildContext _context;
  final _authService = AuthService();
  final formGlobalKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController nicknameController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordRetryController;

  bool get isLoading => state.isLoading;
  set isLoading(bool value) => state = state.copyWith(isLoading: value);

  RegistrationState get state => _state;
  set state(RegistrationState value) {
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

  Future<void> onRegistrationButtonPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formGlobalKey.currentState!.validate()) return;

    isLoading = true;

    try {
      await _authService.createUser(state.email, state.nickname, state.password, state.passwordRetry);
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

  String? validateEmail(String? value) {
    final emailPattern = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value == null || value.isEmpty) return "email required";
    if (!emailPattern.hasMatch(value)) return "invalid email";
    if (value.length > 64) return "email is too long";
    return null;
  }

  String? validateNickname(String? value) {
    if (value == null || value.isEmpty) return "nickname required";
    if (value.length < 2) return "nickname is short";
    if (value.length > 64) return "nickname is too long";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "password required";
    if (value.length < 4) return "password is short";
    if (value.length > 64) return "password is too long";
    return null;
  }

  String? validatePasswordRetry(String? value) {
    if (value == null || value.isEmpty) return "retry password required";
    if (state.password != value) return "passwords not equals";
    return null;
  }

  void onAuthButtonPressed() async {
    await AppNavigator.toAuth();
  }
}
