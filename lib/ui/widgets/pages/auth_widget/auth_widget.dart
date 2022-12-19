import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/common/text_form_widget.dart';
import 'package:social_net/ui/widgets/pages/auth_widget/auth_view_model.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              key: viewModel.formGlobalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _TitleWidget(),
                  TextFormWidget(
                    hintText: "Enter email",
                    labelText: "Email",
                    controller: viewModel.loginController,
                  ),
                  TextFormWidget(
                    hintText: "Enter password",
                    labelText: "Password",
                    controller: viewModel.passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  const _AuthButtonWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a member?"),
                      TextButton(
                        onPressed: viewModel.onRegistrationButtonPressed,
                        child: const Text("Register"),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  const _ProgressIndicator()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<AuthViewModel>(
        lazy: false,
        create: (context) => AuthViewModel(context),
        child: const AuthWidget(),
      );
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "SignIn",
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AuthViewModel>();
    final isLoading = context.select(((AuthViewModel value) => value.isLoading));

    return ElevatedButton(
      onPressed: !isLoading ? viewModel.onAuthButtonPressed : null,
      child: const Text("Sign In"),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoading = context.select((AuthViewModel value) => value.isLoading);

    return Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: isLoading ? const CircularProgressIndicator() : null,
      ),
    );
  }
}
