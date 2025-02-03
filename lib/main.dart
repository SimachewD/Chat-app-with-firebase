import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/data/providers/chat_provider.dart';
import 'package:chatter_hive/data/providers/comment_provider.dart';
import 'package:chatter_hive/data/providers/post_provider.dart';
import 'package:chatter_hive/data/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'theme/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authProvider = AuthProvider();
  await authProvider.checkLoginState();
  runApp(MyApp(authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
        create: (context) => ChatProvider(Provider.of<AuthProvider>(context, listen: false)),
        update: (context, authProvider, previous) => ChatProvider(authProvider),
      ),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add ThemeProvider
      ],
      child: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, _) {
          return MaterialApp(
            title: 'Social Media App',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode, // Use the theme mode from ThemeProvider
            initialRoute: authProvider.user == null ? AppRoutes.login : AppRoutes.feed,
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
