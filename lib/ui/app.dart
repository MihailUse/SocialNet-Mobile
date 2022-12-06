import 'package:flutter/material.dart';
import 'package:social_net/ui/app_navigator.dart';
import 'package:social_net/ui/widgets/loader_widget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Net',
      home: LoaderWidget.create(),
      navigatorKey: AppNavigator.navigatorKey,
      onGenerateRoute: AppNavigator.onGeneratedRoutes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
