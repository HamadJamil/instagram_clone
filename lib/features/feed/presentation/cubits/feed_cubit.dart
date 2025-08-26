import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/feed/domain/repositories/feed_repository.dart';
import 'package:instagram/features/feed/presentation/cubits/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(this._feedRepository) : super(FeedInitial());
  final FeedRepository _feedRepository;

  Future<void> fetchPosts(String userId) async {
    emit(FeedLoading());
    try {
      final posts = await _feedRepository.fetchPosts(userId);
      emit(FeedLoaded(posts));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }
}
