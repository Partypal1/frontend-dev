
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:partypal/constants/route_paths.dart';
import 'package:partypal/models/user_model.dart';
import 'package:partypal/screens/authentication/reset_password_screen.dart';
import 'package:partypal/screens/authentication/select_user_profile_screen.dart';
import 'package:partypal/screens/authentication/set_password_screen.dart';
import 'package:partypal/screens/authentication/sign_in_screen.dart';
import 'package:partypal/screens/authentication/sign_up_screen.dart';
import 'package:partypal/screens/authentication/verification_screen.dart';
import 'package:partypal/screens/home/home.dart';
import 'package:partypal/screens/onboarding/onboarding_screen.dart';
import 'package:partypal/screens/profile_setup/choose_favourite_clubs_screen.dart';
import 'package:partypal/screens/profile_setup/set_profile_screen.dart';
import 'package:partypal/screens/profile_setup/welcome_screen.dart';
import 'package:partypal/screens/splash_screen.dart';

final GoRouter routerConfig = GoRouter( // TODO: add routing animations
  initialLocation: RoutePaths.splashScreen,
  errorBuilder: (context, state) => const ErrorBuilder(),
  routes: [
    GoRoute(
      path: RoutePaths.splashScreen,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const SplashScreen(),
        key: state.pageKey,
      ),
    ),

    GoRoute(
      path: RoutePaths.onboaringScreen,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const OnboaringScreen(),
        key: state.pageKey,
      ),
    ),

    GoRoute(
      path: RoutePaths.selectUserProfileScreen,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const SelectUserProfileScreen(),
        key: state.pageKey,
      ),
    ),

    GoRoute(
      path: RoutePaths.signInScreen,
      pageBuilder: (context, state){
        if(state.extra != null){
          Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return CupertinoPage<void>(
            child: SignInScreen(
              userType: args['userType'] ?? UserType.user,
            ),
            key: state.pageKey,
          );
        }
        return CupertinoPage<void>(
          child: const ErrorBuilder(),
          key: state.pageKey
        );
      }
    ),
    
    GoRoute(
      path: RoutePaths.signUpScreen,
      pageBuilder: (context, state){
        if(state.extra != null){
          Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return CupertinoPage<void>(
            child: SignUpScreen(
              userType: args['userType'] ?? UserType.user,
            ),
            key: state.pageKey,
          );
        }
        return CupertinoPage<void>(
          child: const ErrorBuilder(),
          key: state.pageKey
        );
      }
    ),

    GoRoute(
      path: RoutePaths.verificationScreen,
      pageBuilder: (context, state){
        if (state.extra!=null){
          Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return CupertinoPage<void>(
            child: VerificationScreen(
              email: args['email'] ?? '',
              password: args['password'] ?? '',
            ),
            key: state.pageKey,
          );
        }
        return CupertinoPage<void>(
          child: const ErrorBuilder(),
          key: state.pageKey
        );
      }
    ),

    GoRoute(
      path: RoutePaths.resetPasswordScreen,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const ResetPasswordScreen(),
        key: state.pageKey,
      ),
    ),

    GoRoute(
      path: RoutePaths.setPasswordScreen,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const SetPasswordScreen(),
        key: state.pageKey,
      ),
    ),

    GoRoute(
      path: RoutePaths.welcomeScreen,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const WelcomeScreen(),
        key: state.pageKey,
      ),
    ),

    GoRoute(
      path: RoutePaths.chooseFavouriteClubsScreen,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const ChooseFavouriteClubs(),
        key: state.pageKey,
      ),
    ),

    GoRoute(
      path: RoutePaths.setProfileScreen,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const SetProfileScreen(),
        key: state.pageKey,
      ),
    ),

    GoRoute(
      path: RoutePaths.home,
      pageBuilder: (context, state) => CupertinoPage<void>(
        child: const Home(),
        key: state.pageKey,
      ),
    ),
  ]
);

class ErrorBuilder extends StatelessWidget {
  const ErrorBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Navigation error has occoured',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.error
          ),
        ),
      ),
    );
  }
}