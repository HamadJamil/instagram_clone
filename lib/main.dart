import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/core/repository/strorage_repository.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/core/routes/app_route_configuration.dart';
import 'package:instagram/core/theme/app_theme.dart';

import 'package:instagram/features/Profile/presentation/cubits/profile_cubit.dart';
import 'package:instagram/features/auth/data/datasources/firebase_auth_service.dart';
import 'package:instagram/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:instagram/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:instagram/features/feed/presentation/cubits/feed_cubit.dart';
import 'package:instagram/features/search/presentation/cubits/search_cubit.dart';
import 'package:instagram/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;

    final UserRepository userRepository = UserRepository(firestore);
    final PostRepository postRepository = PostRepository(firestore);
    final StorageRepository storageRepository = StorageRepository(storage);

    final FirebaseAuthService authService = FirebaseAuthService(auth);

    final AuthRepository authRepository = AuthRepositoryImplementation(
      authService,
      userRepository,
    );
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(authRepository: authRepository),
          ),
          BlocProvider(
            create: (context) =>
                ProfileCubit(userRepository, postRepository, storageRepository),
          ),
          BlocProvider(create: (context) => SearchCubit(userRepository)),
          BlocProvider(create: (context) => FeedCubit(postRepository)),
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
