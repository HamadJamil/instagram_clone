import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/init/dependency_injection.dart';
import 'package:instagram/features/Profile/presentation/cubits/profile_cubit.dart';
import 'package:instagram/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:instagram/features/feed/presentation/cubits/feed/feed_cubit.dart';
import 'package:instagram/features/home_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/gallery/gallery_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/post/post_cubit.dart';
import 'package:instagram/features/search/presentation/cubits/otheruser/otheruser_cubit.dart';
import 'package:instagram/features/search/presentation/cubits/search/search_cubit.dart';

class AppBlocProviders {
  AppBlocProviders._();

  static List<BlocProvider> get providers => [
    BlocProvider(create: (context) => NavigationCubit()),
    BlocProvider(
      create: (context) => OtherUserProfileCubit(
        userRepository: DependencyInjection.userRepository,
        postRepository: DependencyInjection.postRepository,
      ),
    ),
    BlocProvider(create: (context) => GalleryCubit()),
    BlocProvider(
      create: (context) =>
          AuthCubit(authRepository: DependencyInjection.authRepository),
    ),
    BlocProvider(
      create: (context) => ProfileCubit(
        DependencyInjection.authRepository,
        DependencyInjection.userRepository,
        DependencyInjection.postRepository,
        DependencyInjection.storageRepository,
        DependencyInjection.commentRepository,
      ),
    ),
    BlocProvider(
      create: (context) => SearchCubit(DependencyInjection.userRepository),
    ),
    BlocProvider(
      create: (context) => FeedCubit(
        DependencyInjection.postRepository,
        DependencyInjection.auth.currentUser?.uid ?? '',
      ),
    ),
    BlocProvider(
      create: (context) => PostCubit(
        DependencyInjection.postRepository,
        DependencyInjection.storageRepository,
        DependencyInjection.userRepository,
        DependencyInjection.commentRepository,
      ),
    ),
  ];
}
