/*import 'package:auto_route/auto_route.dart';
import 'package:chemicalspraying/router/routes.gr.dart';



@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/login',
          page: LoginRoute.page,
        ),
        AutoRoute(
          path: '/home',
          page: HomeRoute.page,
        ),
        AutoRoute(
          path: '/userprofile',
          page: UserProfileRoute.page,
        ),
        AutoRoute(
          path: '/edit',
          page: EditRoute.page,
        ),
        AutoRoute(
          path: '/addprofile',
          page: AddprofileRoute.page,
        ),
        AutoRoute(
          path: '/createaccount',
          page: CreateAccountRoute.page,
        ),
        AutoRoute(
          path: '/nottification',
          page: NottificationRoute.page,
        ),
        AutoRoute(
          path: '/googlemap',
          page: MapRoute.page,
        ),
        AutoRoute(
          path: '/profile',
          page: Profile.page,
        ),
        AutoRoute(
          path: '/ForgotPassword',
          page: ForgotPassword.page,
        ),
        AutoRoute(
          path: '/otpverification',
          page: OTPVerification.page,
        ),
        AutoRoute(
            path: '/first',
            page: FirstRoute.page,
            initial: true,
            transitionsBuilder: TransitionsBuilders.slideLeft),
      ];*/


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
        AutoRoute(path: '/addprofile', page: AddprofileRoute.page),
        AutoRoute(path: '/createaccount', page: CreateAccountRoute.page),
        AutoRoute(path: '/nottification', page: NottificationRoute.page),
        AutoRoute(path: '/googlemap', page: MapRoute.page),
        AutoRoute(path: '/profile', page: Profile.page),
        AutoRoute(path: '/forgot-password', page: ForgotPassword.page),
        AutoRoute(path: '/otpverification', page: OTPVerificationRoute.page),
        AutoRoute(path: '/first', page: FirstRoute.page, initial: true),
      ];
}

// Compare this snippet from chemicalsprayingchemicalspraying-main/lib/router/routes.gr.dart:
// import 'package:auto_route/auto_route.dart' as _i1;
// import 'package:chemicalspraying/screen/addprofile.dart' as _i2;
// import 'package:chemicalspraying/screen/createaccount.dart' as _i3;
// import 'package:chemicalspraying/screen/edit.dart' as _i4;
// import 'package:chemicalspraying/screen/first.dart' as _i5;
// import 'package:chemicalspraying/screen/ForgotPassword.dart' as _i6;
// import 'package:chemicalspraying/screen/googlemap.dart' as _i9;
// import 'package:chemicalspraying/screen/home.dart' as _i7;
// import 'package:chemicalspraying/screen/login.dart' as _i8;
// import 'package:chemicalspraying/screen/nottification.dart' as _i11;
// import 'package:chemicalspraying/screen/otpverification.dart' as _i12;
// import 'package:chemicalspraying/screen/profile.dart' as _i13;
// import 'package:chemicalspraying/screen/profilescreen.dart' as _i10;
// import 'package:chemicalspraying/screen/userprofile.dart' as _i14;
//
// class AddprofileRoute extends _i1.PageRouteInfo {
//   const AddprofileRoute() : super(name, path: '/addprofile');
// }




