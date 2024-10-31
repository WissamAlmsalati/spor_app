part of 'fetch_comments_cubit.dart';

abstract class FetchCommentsState extends Equatable {
  const FetchCommentsState();
  @override
  List<Object?> get props => [];
}

class FetchCommentsInitial extends FetchCommentsState {}

class FetchCommentsLoading extends FetchCommentsState {
  final List<Comment> comments;
  final bool isLoadingMore;

  const FetchCommentsLoading({required this.comments, this.isLoadingMore = false});

  @override
  List<Object?> get props => [comments, isLoadingMore];
}

class FetchCommentsEmpty extends FetchCommentsState {}

class FetchCommentsLoaded extends FetchCommentsState {
  final List<Comment> comments;
  final bool hasNextPage;

  const FetchCommentsLoaded({required this.comments, required this.hasNextPage});

  @override
  List<Object?> get props => [comments, hasNextPage];
}

class FetchCommentsError extends FetchCommentsState {
  final String message;

  const FetchCommentsError({required this.message});

  @override
  List<Object?> get props => [message];
}