
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_ui_provider.dart';
import 'providers/child_ui_provider.dart';
import 'providers/parent_ui_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/parent/parent_home_screen.dart';
import 'screens/child/child_home_screen.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
return MultiProvider(
providers: [
ChangeNotifierProvider(create: (_) => AuthUIProvider()),
ChangeNotifierProvider(create: (_) => ChildUIProvider()),
ChangeNotifierProvider(create: (_) => ParentUIProvider()),
],
child: MaterialApp(
title: 'Parental Control App',
debugShowCheckedModeBanner: false,
theme: ThemeData(
primarySwatch: Colors.blue,
useMaterial3: true,
fontFamily: 'Roboto',
colorScheme: ColorScheme.fromSeed(
seedColor: Colors.blue,
brightness: Brightness.light,
),
),
home: const AuthWrapper(),
),
);
}
}

class AuthWrapper extends StatelessWidget {
const AuthWrapper({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
return Consumer<AuthUIProvider>(
builder: (context, authProvider, _) {
// Initialize auth state
if (!authProvider.isLoggedIn) {
authProvider.initialize();
}

// Show appropriate screen based on auth state
if (!authProvider.isLoggedIn) {
return const LoginScreen();
}

// Route based on user type
if (authProvider.isParent) {
return const ParentHomeScreen();
} else {
return const ChildHomeScreen();
}
},
);
}
}
