import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/search/domain/repositories/search_repository.dart';
import 'package:instagram/features/search/presentation/cubits/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;
  Timer? _requestTimer;

  SearchCubit({required this.searchRepository}) : super(SearchInitial());

  void searchUsers(String query, String userId) {
    _requestTimer?.cancel();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    _requestTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final users = await searchRepository.searchUsers(query, userId);
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
