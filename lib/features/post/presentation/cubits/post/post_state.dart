import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostCreated extends PostState {}

class PostDeleted extends PostState {}

class PostUpdated extends PostState {}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}
