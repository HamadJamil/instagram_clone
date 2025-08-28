import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/features/search/presentation/cubits/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository _userRepository;
  Timer? _requestTimer;

  SearchCubit(this._userRepository) : super(SearchInitial());

  void searchUsers(String query, String userId) {
    _requestTimer?.cancel();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    _requestTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final users = await _userRepository.search(query, userId);
        emit(SearchLoaded(users: users, query: query));
      } catch (e) {
        emit(SearchError(message: 'Failed to search: $e'));
      }
    });
  }

  void clearSearch() {
    _requestTimer?.cancel();
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _requestTimer?.cancel();
    return super.close();
  }
}
