import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/constants/app_images.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().startListeningToAuthChanges();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirectToNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80.0,
              width: 80.0,
              child: Image(image: AssetImage(AppImages.logo)),
            ),
          ],
        ),
      ),
    );
  }

  void _redirectToNextPage() {
    final authState = context.read<AuthCubit>().state;
    Future.delayed(
      const Duration(seconds: 2),
      () => _handleAuthState(authState),
    );
  }

  void _handleAuthState(AuthState authState) {
    if (authState is AuthSuccess && authState.isEmailVerified) {
      final String? userId = authState.userId;
      return context.goNamed(
        AppRouteName.home,
        pathParameters: {'userId': userId!},
      );
    } else if (authState is AuthSuccess && !authState.isEmailVerified) {
      return context.goNamed(AppRouteName.emailVerification);
    } else if (authState is AuthInitial) {
      return context.goNamed(AppRouteName.login);
    }
  }
}
