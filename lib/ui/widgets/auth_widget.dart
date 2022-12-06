import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/domain/exceptions/bad_request_exception.dart';
import 'package:social_net/domain/exceptions/internal_server_exception.dart';
import 'package:social_net/domain/exceptions/timeout_exception.dart';
import 'package:social_net/domain/exceptions/un_authorized_exception.dart';
import 'package:social_net/domain/services/auth_service.dart';
import 'package:social_net/ui/app_navigator.dart';

class _ViewModelState {
  String login = "user@example.com";
  String password = "string";
  String errorMessage = "";
  bool isLoading = false;
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final state = _ViewModelState();

  void onLoginChanged(String value) {
    state.login = value;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    state.password = value;
    notifyListeners();
  }

  void onIsLoadingChanged(bool value) {
    state.isLoading = value;
    notifyListeners();
  }

  bool get isValid => state.login.isNotEmpty && state.password.isNotEmpty;

  Future<void> onAuthButtonPressed() async {
    if (!isValid) return;
    state.errorMessage = "";
    onIsLoadingChanged(true);
    // await Future.delayed(const Duration(seconds: 10));

    try {
      await _authService.login(state.login, state.password);
      AppNavigator.toMain();
      return;
    } on TimeoutException {
      state.errorMessage = "timeout exceeded";
    } on InternalServerException {
      state.errorMessage = "try later";
    } catch (e) {
      if (e is BadRequestException && e.errorResponse?.errors != null) {
        final errors = e.errorResponse!.errors!;

        // display errors from server
        for (var element in errors.entries) {
          for (var errorString in element.value) {
            state.errorMessage += "$errorString\n";
          }
        }
      } else if(e is UnAuthorizedException){
        state.errorMessage = "invalid credentials";
      } else {
        state.errorMessage = "try later";
      }
    }

    onIsLoadingChanged(false);
    // notifyListeners();
  }

  String? validateLogin(String? value) {
    if (value == null || value.isEmpty) return "email required";
    if (!_emailRegExp.hasMatch(value)) return "invalid email";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "password required";
    if (value.length < 4) return "password is short";
    return null;
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = context.select((_ViewModel value) => value.state.isLoading);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _ErrorWidget(),
              const _TitleWidget(),
              const _LoginFieldWidget(),
              const _PasswordFieldWidget(),
              const SizedBox(height: 20),
              const _AuthButtonWidget(),
              if (isLoading) const Expanded(child: Center(child: CircularProgressIndicator()))
            ],
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        lazy: false,
        create: (_) => _ViewModel(),
        child: const AuthWidget(),
      );
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "SignIn",
      style: TextStyle(
        fontSize: 32,
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((_ViewModel value) => value.state.errorMessage);

    return Text(
      errorMessage,
      style: const TextStyle(
        color: Colors.red,
        fontSize: 24,
      ),
    );
  }
}

class _LoginFieldWidget extends StatelessWidget {
  const _LoginFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();

    return TextFormField(
      controller: TextEditingController(text: viewModel.state.login),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: viewModel.validateLogin,
      onChanged: viewModel.onLoginChanged,
      decoration: const InputDecoration(
        hintText: "Enter email",
        labelText: "Email",
      ),
    );
  }
}

class _PasswordFieldWidget extends StatelessWidget {
  const _PasswordFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();

    return TextFormField(
      controller: TextEditingController(text: viewModel.state.password),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: viewModel.validatePassword,
      onChanged: viewModel.onPasswordChanged,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Enter password",
        labelText: "Password",
      ),
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    final isValid = context.select(((_ViewModel value) => value.isValid));

    return ElevatedButton(
      onPressed: isValid ? viewModel.onAuthButtonPressed : null,
      child: const Text("Login"),
    );
  }
}
