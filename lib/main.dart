/*import 'package:flutter/material.dart';
import 'package:chemicalspraying/l10n/locali18n.dart';
import 'package:chemicalspraying/router/routes.dart';
import 'package:chemicalspraying/screen/mainhomescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    if (state != null) {
      state.setLocale(newLocale);
    }
  }

  @override

  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  Locale _locale = const Locale('en', '');

  setLocale(Locale locale) async {
    if (_locale == locale) return;
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();

    // ใช้ context หลังจาก build เสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Locale locale = await getLocale(context);
      if (_locale != locale) {
        setState(() {
          _locale = locale;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "chemicalspraying",
      debugShowCheckedModeBanner: false,
      locale: _locale,
      routerConfig: _appRouter.config(),
      // หรือถ้าใช้แบบไม่ผ่าน Router (ชั่วคราวเพื่อทดสอบ)
      // home: MainHomeScreen(),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:chemicalspraying/l10n/locali18n.dart';
import 'package:chemicalspraying/router/routes.dart';

    void main() {
      runApp(MyApp());
    }

    class MyApp extends StatefulWidget {
      const MyApp({super.key});

      static _MyAppState of(BuildContext context) =>
          context.findAncestorStateOfType<_MyAppState>()!;

      static void setLocale(BuildContext context, Locale newLocale) {
        _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
        if (state != null) {
          state.setLocale(newLocale);
        }
      }

      @override
      State<MyApp> createState() => _MyAppState();
    }

    class _MyAppState extends State<MyApp> {
      final _appRouter = AppRouter();
      Locale _locale = const Locale('en', '');

      setLocale(Locale locale) async {
        if (_locale == locale) return;
        setState(() {
          _locale = locale;
        });
      }

      @override
      void initState() {
        super.initState();

        // ใช้ context หลังจาก build เสร็จ
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Locale locale = await getLocale(context);
          if (_locale != locale) {
            setState(() {
              _locale = locale;
            });
          }
        });
      }

      @override
      Widget build(BuildContext context) {
        return MaterialApp.router(
          title: "chemicalspraying",
          debugShowCheckedModeBanner: false,
          locale: _locale,
          routerConfig: _appRouter.config(),
        );
      }
    }