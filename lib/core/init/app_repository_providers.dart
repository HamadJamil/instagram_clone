import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/init/dependency_injection.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/core/repository/strorage_repository.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/features/auth/domain/repositories/auth_repository.dart';

class AppRepoProviders {
  AppRepoProviders._();

  static List<RepositoryProvider> get providers => [
    RepositoryProvider<UserRepository>(
      create: (context) => DependencyInjection.userRepository,
    ),
    RepositoryProvider<PostRepository>(
      create: (context) => DependencyInjection.postRepository,
    ),
    RepositoryProvider<StorageRepository>(
      create: (context) => DependencyInjection.storageRepository,
    ),
    RepositoryProvider<AuthRepository>(
      create: (context) => DependencyInjection.authRepository,
    ),
  ];
}
