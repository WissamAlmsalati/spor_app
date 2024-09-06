part of 'comment_review_cubit.dart';



@immutable
abstract class CommentReviewState {}

class CommentReviewInitial extends CommentReviewState {} // الحالة المبدئية

class CommentReviewLoading extends CommentReviewState {} // حالة التحميل

class CommentReviewSuccess extends CommentReviewState {} // حالة النجاح

class CommentReviewError extends CommentReviewState {
  final String message; // الرسالة التي تعرض الخطأ

  CommentReviewError(this.message); // تمرير رسالة الخطأ
}
