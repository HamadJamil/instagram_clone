import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/features/auth/presentation/pages/email_verification_page.dart';
import 'package:instagram/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:instagram/features/auth/presentation/pages/log_in_page.dart';
import 'package:instagram/features/auth/presentation/pages/sign_up_page.dart';
import 'package:instagram/features/auth/presentation/pages/splash_screen.dart';
import 'package:instagram/features/post/presentation/pages/post_page.dart';
import 'package:instagram/features/profile/home_screen.dart';

class AppRouteConfiguration {
  static final GoRouter route = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: AppRouteName.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRouteName.login,
        builder: (_, __) => const LogInPage(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRouteName.signup,
        builder: (_, __) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgotPassword',
        name: AppRouteName.forgotPassword,
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/emailVerification',
        name: AppRouteName.emailVerification,
        builder: (_, __) => const EmailVerificationPage(),
      ),
      GoRoute(
        path: '/home',
        name: AppRouteName.home,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/createPost',
        name: AppRouteName.createPost,
        builder: (_, __) => const PostPage(),
      ),
    ],
  );
}
