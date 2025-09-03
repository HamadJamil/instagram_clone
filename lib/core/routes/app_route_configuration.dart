import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/features/auth/presentation/pages/email_verification_page.dart';
import 'package:instagram/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:instagram/features/auth/presentation/pages/log_in_page.dart';
import 'package:instagram/features/auth/presentation/pages/sign_up_page.dart';
import 'package:instagram/features/auth/presentation/pages/splash_screen.dart';
import 'package:instagram/features/post/presentation/pages/post_caption_page.dart';
import 'package:instagram/features/home_screen.dart';
import 'package:instagram/features/profile/presentation/pages/edit_profile.dart';
import 'package:instagram/features/profile/presentation/pages/editpost_page.dart';
import 'package:instagram/features/profile/presentation/pages/post_detail_screen.dart';
import 'package:instagram/features/search/presentation/pages/other_user_page.dart';

class AppRouteConfiguration {
  AppRouteConfiguration._();
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
        path: '/home/:userId',
        name: AppRouteName.home,
        builder: (_, state) {
          final String id = state.pathParameters['userId']!;
          return HomeScreen(userId: id);
        },
      ),
      GoRoute(
        path: '/otherUserProfile',
        name: AppRouteName.otherUserProfile,
        builder: (_, state) {
          final data = state.extra as Map<String, dynamic>;
          return OtherUserProfilePage(
            currentUserId: data['currentUserId'],
            targetUserId: data['targetUserId'],
          );
        },
      ),
      GoRoute(
        path: '/editProfilePage',
        name: AppRouteName.editProfilePage,
        builder: (_, state) {
          final user = state.extra as UserModel;
          return EditProfilePage(user: user);
        },
      ),
      GoRoute(
        path: '/editPostPage',
        name: AppRouteName.editPostPage,
        builder: (_, state) {
          final post = state.extra as PostModel;
          return EditPostPage(post: post);
        },
      ),
      GoRoute(
        path: '/postDetailScreen',
        name: AppRouteName.postDetailScreen,
        builder: (_, state) {
          final data = state.extra as Map<String, dynamic>;
          return PostDetailScreen(
            posts: data['posts'],
            currentUserId: data['currentUserId'],
            initialIndex: data['initialIndex'],
          );
        },
      ),
      GoRoute(
        path: '/postCaptionPage',
        name: AppRouteName.postCaptionPage,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return PostCaptionPage(
            selectedImages: data['selectedImages'] as List<File>,
            user: data['userId'],
          );
        },
      ),
    ],
  );
}
