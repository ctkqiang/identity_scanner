import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:identity_scanner/pages/search_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: MaterialApp(
        title: 'eJudgment Scanner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
          ),
        ),
        home: const SearchPage(),
      ),
    );
  }
}
