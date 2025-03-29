
import 'package:auto_route/auto_route.dart';
import 'package:chemicalspraying/router/routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/login', page: LoginRoute.page),
        AutoRoute(path: '/home', page: HomeRoute.page),
        AutoRoute(path: '/userprofile', page: UserProfileRoute.page),
        AutoRoute(path: '/edit', page: EditRoute.page),
        AutoRoute(page: AddprofileRoute.page, path: '/addprofile'),
        AutoRoute(path: '/createaccount', page: CreateAccountRoute.page),
        AutoRoute(path: '/notification', page: NotificationRoute.page),
        AutoRoute(path: '/googlemap', page: MapRoute.page),
        AutoRoute(path: '/profile', page: ProfileRoute.page),
        AutoRoute(path: '/forgot-password', page: ForgotPasswordRoute.page),
        AutoRoute(path: '/otpverification', page: OTPVerificationRoute.page),
        AutoRoute(path: '/first', page: FirstRoute.page, initial: true),
        AutoRoute(path: '/setting', page: NotificationSettingRoute.page),

      ];
}
