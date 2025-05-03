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
import 'package:chemicalspraying/screen/controlwaypoin.dart' as _i3;
import 'package:chemicalspraying/screen/createaccount.dart' as _i4;
import 'package:chemicalspraying/screen/editprofile.dart' as _i5;
import 'package:chemicalspraying/screen/first.dart' as _i6;
import 'package:chemicalspraying/screen/forgot-password.dart' as _i7;
import 'package:chemicalspraying/screen/googlemap.dart' as _i10;
import 'package:chemicalspraying/screen/home.dart' as _i8;
import 'package:chemicalspraying/screen/login.dart' as _i9;
import 'package:chemicalspraying/screen/map.dart' as _i11;
import 'package:chemicalspraying/screen/nottification.dart' as _i12;
import 'package:chemicalspraying/screen/otplogin.dart' as _i13;
import 'package:chemicalspraying/screen/otpverification.dart' as _i14;
import 'package:chemicalspraying/screen/profilescreen.dart' as _i15;
import 'package:chemicalspraying/screen/resetpassword.dart' as _i16;
import 'package:chemicalspraying/screen/userprofile.dart' as _i17;
import 'package:flutter/material.dart' as _i19;

abstract class $AppRouter extends _i18.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    AddprofileRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AddprofilePage(),
      );
    },
    ControlRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ControlScreen(),
      );
    },
    ControlwaypointRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ControlwaypoinPage(),
      );
    },
    CreateAccountRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.CreateAccountPage(),
      );
    },
    EditProfileRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.EditProfilePage(),
      );
    },
    FirstRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.FirstPage(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ForgotPassword(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.HomePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.LoginPage(),
      );
    },
    MapRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.MapPage(),
      );
    },
    MyApp.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.MyApp(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.NotificationPage(),
      );
    },
    OTPLoginRoute.name: (routeData) {
      final args = routeData.argsAs<OTPLoginRouteArgs>();
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.OTPLoginPage(
          key: args.key,
          email: args.email,
          purpose: args.purpose,
        ),
      );
    },
    OTPVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<OTPVerificationRouteArgs>();
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.OTPVerificationScreen(
          key: args.key,
          email: args.email,
          purpose: args.purpose,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.ProfilePage(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      final args = routeData.argsAs<ResetPasswordRouteArgs>();
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.ResetPassword(
          key: args.key,
          email: args.email,
        ),
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
class AddprofileRoute extends _i18.PageRouteInfo<void> {
  const AddprofileRoute({List<_i18.PageRouteInfo>? children})
      : super(
          AddprofileRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddprofileRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ControlScreen]
class ControlRoute extends _i18.PageRouteInfo<void> {
  const ControlRoute({List<_i18.PageRouteInfo>? children})
      : super(
          ControlRoute.name,
          initialChildren: children,
        );

  static const String name = 'ControlRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ControlwaypoinPage]
class ControlwaypointRoute extends _i18.PageRouteInfo<void> {
  const ControlwaypointRoute({List<_i18.PageRouteInfo>? children})
      : super(
          ControlwaypointRoute.name,
          initialChildren: children,
        );

  static const String name = 'ControlwaypointRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i4.CreateAccountPage]
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
/// [_i5.EditProfilePage]
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
/// [_i6.FirstPage]
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
/// [_i7.ForgotPassword]
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
/// [_i8.HomePage]
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
/// [_i9.LoginPage]
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
/// [_i10.MapPage]
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
/// [_i11.MyApp]
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
/// [_i12.NotificationPage]
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
/// [_i13.OTPLoginPage]
class OTPLoginRoute extends _i18.PageRouteInfo<OTPLoginRouteArgs> {
  OTPLoginRoute({
    _i19.Key? key,
    required String email,
    required String purpose,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          OTPLoginRoute.name,
          args: OTPLoginRouteArgs(
            key: key,
            email: email,
            purpose: purpose,
          ),
          initialChildren: children,
        );

  static const String name = 'OTPLoginRoute';

  static const _i18.PageInfo<OTPLoginRouteArgs> page =
      _i18.PageInfo<OTPLoginRouteArgs>(name);
}

class OTPLoginRouteArgs {
  const OTPLoginRouteArgs({
    this.key,
    required this.email,
    required this.purpose,
  });

  final _i19.Key? key;

  final String email;

  final String purpose;

  @override
  String toString() {
    return 'OTPLoginRouteArgs{key: $key, email: $email, purpose: $purpose}';
  }
}

/// generated route for
/// [_i14.OTPVerificationScreen]
class OTPVerificationRoute
    extends _i18.PageRouteInfo<OTPVerificationRouteArgs> {
  OTPVerificationRoute({
    _i19.Key? key,
    required String email,
    required String purpose,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          OTPVerificationRoute.name,
          args: OTPVerificationRouteArgs(
            key: key,
            email: email,
            purpose: purpose,
          ),
          initialChildren: children,
        );

  static const String name = 'OTPVerificationRoute';

  static const _i18.PageInfo<OTPVerificationRouteArgs> page =
      _i18.PageInfo<OTPVerificationRouteArgs>(name);
}

class OTPVerificationRouteArgs {
  const OTPVerificationRouteArgs({
    this.key,
    required this.email,
    required this.purpose,
  });

  final _i19.Key? key;

  final String email;

  final String purpose;

  @override
  String toString() {
    return 'OTPVerificationRouteArgs{key: $key, email: $email, purpose: $purpose}';
  }
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
    required String email,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          ResetPasswordRoute.name,
          args: ResetPasswordRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i18.PageInfo<ResetPasswordRouteArgs> page =
      _i18.PageInfo<ResetPasswordRouteArgs>(name);
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({
    this.key,
    required this.email,
  });

  final _i19.Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{key: $key, email: $email}';
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
