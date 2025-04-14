import 'package:dacn1/features/auth/screens/auth_screen.dart';
import 'package:dacn1/features/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:dacn1/contants/global_variables.dart';
import 'package:dacn1/router.dart';
import 'package:provider/provider.dart';
import 'package:dacn1/providers/user_providers.dart';
import 'package:dacn1/features/auth/services/auth_service.dart';
import 'package:dacn1/common/widgets/bottom_bar.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authService.getUserData(context);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Electronic sale app',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        useMaterial3: true, // can remove this line
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty

          ? const BottomBar()
          : const AuthScreen(),
    );
  }
}
