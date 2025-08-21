import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/routes/app_route_configuration.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/Profile/data/repositories/profile_repository_implementation.dart';
import 'package:instagram/features/Profile/presentation/cubits/profile_cubit.dart';
import 'package:instagram/features/auth/data/datasources/firebase_auth_service.dart';
import 'package:instagram/features/auth/data/datasources/firestore_user_service.dart';
import 'package:instagram/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:instagram/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:instagram/features/profile/data/datasources/firebase_user_service.dart';
import 'package:instagram/features/profile/data/datasources/firestore_profile_service.dart';
import 'package:instagram/features/profile/domain/repositories/profile_repository.dart';
import 'package:instagram/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final FirebaseAuthService authService = FirebaseAuthService();
    final FireStoreUserService userService = FireStoreUserService();
    final FirestoreProfileService profileService = FirestoreProfileService();
    final FirebaseUserService firebaseUserService = FirebaseUserService();
    final AuthRepository authRepository = AuthRepositoryImplementation(
      authService,
      userService,
    );
    final ProfileRepository profileRepository = ProfileRepositoryImpl(
      profileService: profileService,
      firebaseUserService: firebaseUserService,
    );

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(authRepository: authRepository),
          ),
          BlocProvider(
            create: (context) =>
                ProfileCubit(profileRepository: profileRepository),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Failed to initialize app: $e')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: AppRouteConfiguration.route,
    );
  }
}
