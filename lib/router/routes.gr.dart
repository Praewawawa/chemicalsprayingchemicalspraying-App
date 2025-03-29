// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:chemicalspraying/screen/addprofile.dart' as _i1;
import 'package:chemicalspraying/screen/control.dart' as _i2;
import 'package:chemicalspraying/screen/createaccount.dart' as _i3;
import 'package:chemicalspraying/screen/edit.dart' as _i4;
import 'package:chemicalspraying/screen/first.dart' as _i5;
import 'package:chemicalspraying/screen/forgot-password.dart' as _i6;
import 'package:chemicalspraying/screen/googlemap.dart' as _i9;
import 'package:chemicalspraying/screen/home.dart' as _i7;
import 'package:chemicalspraying/screen/login.dart' as _i8;
import 'package:chemicalspraying/screen/map.dart' as _i10;
import 'package:chemicalspraying/screen/nottification.dart' as _i11;
import 'package:chemicalspraying/screen/otpverification.dart' as _i13;
import 'package:chemicalspraying/screen/profilescreen.dart' as _i14;
import 'package:chemicalspraying/screen/resetpassword.dart' as _i15;
import 'package:chemicalspraying/screen/setting.dart' as _i12;
import 'package:chemicalspraying/screen/userprofile.dart' as _i16;
import 'package:flutter/material.dart' as _i18;

abstract class $AppRouter extends _i17.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i17.PageFactory> pagesMap = {
    AddprofileRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AddprofilePage(),
      );
    },
    ControlRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ControlScreen(),
      );
    },
    CreateAccountRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.CreateAccountPage(),
      );
    },
    EditRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.EditPage(),
      );
    },
    FirstRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.FirstPage(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ForgotPassword(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.HomePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.LoginPage(),
      );
    },
    MapRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.MapPage(),
      );
    },
    MyApp.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.MyApp(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.NotificationPage(),
      );
    },
    NotificationSettingRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.NotificationSettingPage(),
      );
    },
    OTPVerificationRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.OTPVerificationScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.ProfilePage(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      final args = routeData.argsAs<ResetPasswordRouteArgs>(
          orElse: () => const ResetPasswordRouteArgs());
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.ResetPasswordScreen(key: args.key),
      );
    },
    UserProfileRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.UserProfilePage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddprofilePage]
class AddprofileRoute extends _i17.PageRouteInfo<void> {
  const AddprofileRoute({List<_i17.PageRouteInfo>? children})
      : super(
          AddprofileRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddprofileRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ControlScreen]
class ControlRoute extends _i17.PageRouteInfo<void> {
  const ControlRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ControlRoute.name,
          initialChildren: children,
        );

  static const String name = 'ControlRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i3.CreateAccountPage]
class CreateAccountRoute extends _i17.PageRouteInfo<void> {
  const CreateAccountRoute({List<_i17.PageRouteInfo>? children})
      : super(
          CreateAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateAccountRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i4.EditPage]
class EditRoute extends _i17.PageRouteInfo<void> {
  const EditRoute({List<_i17.PageRouteInfo>? children})
      : super(
          EditRoute.name,
          initialChildren: children,
        );

  static const String name = 'EditRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i5.FirstPage]
class FirstRoute extends _i17.PageRouteInfo<void> {
  const FirstRoute({List<_i17.PageRouteInfo>? children})
      : super(
          FirstRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirstRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ForgotPassword]
class ForgotPasswordRoute extends _i17.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i7.HomePage]
class HomeRoute extends _i17.PageRouteInfo<void> {
  const HomeRoute({List<_i17.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i8.LoginPage]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i9.MapPage]
class MapRoute extends _i17.PageRouteInfo<void> {
  const MapRoute({List<_i17.PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i10.MyApp]
class MyApp extends _i17.PageRouteInfo<void> {
  const MyApp({List<_i17.PageRouteInfo>? children})
      : super(
          MyApp.name,
          initialChildren: children,
        );

  static const String name = 'MyApp';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i11.NotificationPage]
class NotificationRoute extends _i17.PageRouteInfo<void> {
  const NotificationRoute({List<_i17.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i12.NotificationSettingPage]
class NotificationSettingRoute extends _i17.PageRouteInfo<void> {
  const NotificationSettingRoute({List<_i17.PageRouteInfo>? children})
      : super(
          NotificationSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationSettingRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i13.OTPVerificationScreen]
class OTPVerificationRoute extends _i17.PageRouteInfo<void> {
  const OTPVerificationRoute({List<_i17.PageRouteInfo>? children})
      : super(
          OTPVerificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'OTPVerificationRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i14.ProfilePage]
class ProfileRoute extends _i17.PageRouteInfo<void> {
  const ProfileRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i15.ResetPasswordScreen]
class ResetPasswordRoute extends _i17.PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    _i18.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          ResetPasswordRoute.name,
          args: ResetPasswordRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i17.PageInfo<ResetPasswordRouteArgs> page =
      _i17.PageInfo<ResetPasswordRouteArgs>(name);
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({this.key});

  final _i18.Key? key;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i16.UserProfilePage]
class UserProfileRoute extends _i17.PageRouteInfo<void> {
  const UserProfileRoute({List<_i17.PageRouteInfo>? children})
      : super(
          UserProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}
