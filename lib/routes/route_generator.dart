// lib/routes/route_generator.dart

import 'package:chatter_hive/core/widgets/auth_guard.dart';
import 'package:chatter_hive/core/widgets/main_screen.dart';
import 'package:chatter_hive/features/auth/screens/login_screen.dart';
import 'package:chatter_hive/features/auth/screens/signup_screen.dart';
import 'package:chatter_hive/features/chat/screens/chat_screen.dart';
import 'package:chatter_hive/features/profile/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.feed:
        return MaterialPageRoute(builder: (_) => const AuthGuard(child: MainScreen())); // MainScreen as a wrapper
      case AppRoutes.chatList:
        return MaterialPageRoute(builder: (_) => const AuthGuard(child: MainScreen())); // MainScreen as a wrapper
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const AuthGuard(child: MainScreen())); // MainScreen as a wrapper
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const AuthGuard(child: EditProfileScreen()));
      case AppRoutes.chat:
        final args = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => AuthGuard(child: ChatScreen(chatId: args)));
      default:
        return MaterialPageRoute(
          builder: (_) => AuthGuard(child: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          )),
        );
    }
  }
}

