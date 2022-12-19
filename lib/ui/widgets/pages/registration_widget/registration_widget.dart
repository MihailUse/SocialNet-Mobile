import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/common/text_form_widget.dart';
import 'package:social_net/ui/widgets/pages/registration_widget/registration_view_model.dart';

class RegistrationWidget extends StatelessWidget {
  const RegistrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<RegistrationViewModel>();
    bool isLoading = context.select((RegistrationViewModel value) => value.isLoading);

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
                    labelText: "Email",
                    hintText: "Enter email",
                    controller: viewModel.emailController,
                    validator: viewModel.validateEmail,
                  ),
                  TextFormWidget(
                    labelText: "Nickname",
                    hintText: "Enter nickname",
                    controller: viewModel.nicknameController,
                    validator: viewModel.validateNickname,
                    obscureText: true,
                  ),
                  TextFormWidget(
                    labelText: "Password",
                    hintText: "Enter password",
                    controller: viewModel.passwordController,
                    validator: viewModel.validatePassword,
                    obscureText: true,
                  ),
                  TextFormWidget(
                    hintText: "Retry password",
                    labelText: "Retry password",
                    controller: viewModel.passwordRetryController,
                    validator: viewModel.validatePasswordRetry,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  const _RegistrationButtonWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already signed up?"),
                      TextButton(
                        onPressed: viewModel.onRAuthButtonPressed,
                        child: const Text("Sign in"),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (isLoading) const CircularProgressIndicator.adaptive(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<RegistrationViewModel>(
        lazy: false,
        create: (context) => RegistrationViewModel(context),
        child: const RegistrationWidget(),
      );
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "SignUp",
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class _RegistrationButtonWidget extends StatelessWidget {
  const _RegistrationButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<RegistrationViewModel>();
    final isLoading = context.select(((RegistrationViewModel value) => value.isLoading));

    return ElevatedButton(
      onPressed: !isLoading ? viewModel.onRegistrationButtonPressed : null,
      child: const Text("Sign Up"),
    );
  }
}
