// fetch_comments_state.dart
part of 'fetch_comments_cubit.dart';

@immutable
abstract class FetchCommentsState {}

class FetchCommentsInitial extends FetchCommentsState {}

class FetchCommentsLoading extends FetchCommentsState {}

class FetchCommentsLoaded extends FetchCommentsState {
  final List<Comment> comments;

  FetchCommentsLoaded(this.comments);
}

class FetchCommentsError extends FetchCommentsState {
  final String message;

  FetchCommentsError(this.message);
}