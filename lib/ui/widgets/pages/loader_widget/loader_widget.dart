import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_net/ui/widgets/pages/loader_widget/loader_view_model.dart';

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

  static Widget create() => Provider<LoaderViewModel>(
        lazy: false,
        create: (_) => LoaderViewModel(),
        child: const LoaderWidget(),
      );
}
