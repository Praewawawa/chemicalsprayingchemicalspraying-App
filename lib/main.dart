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


/*import 'package:flutter/material.dart';
import 'package:chemicalspraying/l10n/locali18n.dart';
import 'package:chemicalspraying/router/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});  // ใช้ const เพื่อลดการสร้าง instance ที่ไม่จำเป็น

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

    // ตรวจสอบว่าฟังก์ชันนี้ใช้ได้จริงหรือไม่
    getLocale().then((Locale locale) {
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
      routerConfig: _appRouter.config(), // ✅ ใช้ config() ตาม AutoRoute v5+
    );
  }
}*/