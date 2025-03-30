// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i18;
import 'package:chemicalspraying/screen/addprofile.dart' as _i1;
import 'package:chemicalspraying/screen/control.dart' as _i2;
import 'package:chemicalspraying/screen/createaccount.dart' as _i3;
import 'package:chemicalspraying/screen/editprofile.dart' as _i4;
import 'package:chemicalspraying/screen/first.dart' as _i5;
import 'package:chemicalspraying/screen/forgot-password.dart' as _i6;
import 'package:chemicalspraying/screen/googlemap.dart' as _i9;
import 'package:chemicalspraying/screen/home.dart' as _i7;
import 'package:chemicalspraying/screen/login.dart' as _i8;
import 'package:chemicalspraying/screen/map.dart' as _i10;
import 'package:chemicalspraying/screen/nottification.dart' as _i11;
import 'package:chemicalspraying/screen/otplogin.dart' as _i13;
import 'package:chemicalspraying/screen/otpverification.dart' as _i14;
import 'package:chemicalspraying/screen/profilescreen.dart' as _i15;
import 'package:chemicalspraying/screen/resetpassword.dart' as _i16;
import 'package:chemicalspraying/screen/setting.dart' as _i12;
import 'package:chemicalspraying/screen/userprofile.dart' as _i17;
import 'package:flutter/material.dart' as _i19;

abstract class $AppRouter extends _i18.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    AddprofileRoute.name: (routeData) {
      final args = routeData.argsAs<AddprofileRouteArgs>(
          orElse: () => const AddprofileRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddprofilePage(key: args.key),
      );
    },
    ControlRoute.name: (routeData) {
      final args = routeData.argsAs<ControlRouteArgs>(
          orElse: () => const ControlRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ControlScreen(key: args.key),
      );
    },
    CreateAccountRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.CreateAccountPage(),
      );
    },
    EditProfileRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.EditProfilePage(),
      );
    },
    FirstRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.FirstPage(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ForgotPassword(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.HomePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.LoginPage(),
      );
    },
    MapRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.MapPage(),
      );
    },
    MyApp.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.MyApp(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.NotificationPage(),
      );
    },
    NotificationSettingRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.NotificationSettingPage(),
      );
    },
    OTPLoginRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.OTPLoginPage(),
      );
    },
    OTPVerificationRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.OTPVerificationScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.ProfilePage(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      final args = routeData.argsAs<ResetPasswordRouteArgs>(
          orElse: () => const ResetPasswordRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.ResetPassword(key: args.key),
      );
    },
    UserProfileRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.UserProfilePage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddprofilePage]
class AddprofileRoute extends _i18.PageRouteInfo<AddprofileRouteArgs> {
  AddprofileRoute({
    _i19.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          AddprofileRoute.name,
          args: AddprofileRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AddprofileRoute';

  static const _i18.PageInfo<AddprofileRouteArgs> page =
      _i18.PageInfo<AddprofileRouteArgs>(name);
}

class AddprofileRouteArgs {
  const AddprofileRouteArgs({this.key});

  final _i19.Key? key;

  @override
  String toString() {
    return 'AddprofileRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.ControlScreen]
class ControlRoute extends _i18.PageRouteInfo<ControlRouteArgs> {
  ControlRoute({
    _i19.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          ControlRoute.name,
          args: ControlRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ControlRoute';

  static const _i18.PageInfo<ControlRouteArgs> page =
      _i18.PageInfo<ControlRouteArgs>(name);
}

class ControlRouteArgs {
  const ControlRouteArgs({this.key});

  final _i19.Key? key;

  @override
  String toString() {
    return 'ControlRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.CreateAccountPage]
class CreateAccountRoute extends _i18.PageRouteInfo<void> {
  const CreateAccountRoute({List<_i18.PageRouteInfo>? children})
      : super(
          CreateAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateAccountRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i4.EditProfilePage]
class EditProfileRoute extends _i18.PageRouteInfo<void> {
  const EditProfileRoute({List<_i18.PageRouteInfo>? children})
      : super(
          EditProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i5.FirstPage]
class FirstRoute extends _i18.PageRouteInfo<void> {
  const FirstRoute({List<_i18.PageRouteInfo>? children})
      : super(
          FirstRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirstRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ForgotPassword]
class ForgotPasswordRoute extends _i18.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i18.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i7.HomePage]
class HomeRoute extends _i18.PageRouteInfo<void> {
  const HomeRoute({List<_i18.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i8.LoginPage]
class LoginRoute extends _i18.PageRouteInfo<void> {
  const LoginRoute({List<_i18.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i9.MapPage]
class MapRoute extends _i18.PageRouteInfo<void> {
  const MapRoute({List<_i18.PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i10.MyApp]
class MyApp extends _i18.PageRouteInfo<void> {
  const MyApp({List<_i18.PageRouteInfo>? children})
      : super(
          MyApp.name,
          initialChildren: children,
        );

  static const String name = 'MyApp';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i11.NotificationPage]
class NotificationRoute extends _i18.PageRouteInfo<void> {
  const NotificationRoute({List<_i18.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i12.NotificationSettingPage]
class NotificationSettingRoute extends _i18.PageRouteInfo<void> {
  const NotificationSettingRoute({List<_i18.PageRouteInfo>? children})
      : super(
          NotificationSettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationSettingRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i13.OTPLoginPage]
class OTPLoginRoute extends _i18.PageRouteInfo<void> {
  const OTPLoginRoute({List<_i18.PageRouteInfo>? children})
      : super(
          OTPLoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'OTPLoginRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i14.OTPVerificationScreen]
class OTPVerificationRoute extends _i18.PageRouteInfo<void> {
  const OTPVerificationRoute({List<_i18.PageRouteInfo>? children})
      : super(
          OTPVerificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'OTPVerificationRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i15.ProfilePage]
class ProfileRoute extends _i18.PageRouteInfo<void> {
  const ProfileRoute({List<_i18.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i16.ResetPassword]
class ResetPasswordRoute extends _i18.PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    _i19.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          ResetPasswordRoute.name,
          args: ResetPasswordRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i18.PageInfo<ResetPasswordRouteArgs> page =
      _i18.PageInfo<ResetPasswordRouteArgs>(name);
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({this.key});

  final _i19.Key? key;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i17.UserProfilePage]
class UserProfileRoute extends _i18.PageRouteInfo<void> {
  const UserProfileRoute({List<_i18.PageRouteInfo>? children})
      : super(
          UserProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}
