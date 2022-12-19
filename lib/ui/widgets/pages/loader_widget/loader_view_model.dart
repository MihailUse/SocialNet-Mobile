import 'package:social_net/domain/services/auth_service.dart';
import 'package:social_net/ui/app_navigator.dart';

class LoaderViewModel {
  final _authService = AuthService();

  LoaderViewModel() {
    _asyncInit();
  }

  void _asyncInit() async {
    if (await _authService.checkAuth()) {
      AppNavigator.navigateTo(RouteAction.pushAndRemoveUntil, AppNavigationRoutes.main);
    } else {
      AppNavigator.navigateTo(RouteAction.pushAndRemoveUntil, AppNavigationRoutes.auth);
    }
  }
}
