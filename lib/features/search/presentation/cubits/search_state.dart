import 'package:equatable/equatable.dart';
import 'package:instagram/core/models/user_model.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<UserModel> users;
  final String query;

  SearchLoaded({required this.users, required this.query});

  @override
  List<Object?> get props => [users, query];
}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
