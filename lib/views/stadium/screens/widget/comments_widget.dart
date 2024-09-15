import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/utilits/responsive.dart';
import '../../../../controller/fetch_comments/fetch_comments_cubit.dart';
import 'package:intl/intl.dart';
import '../../../../models/comments_model.dart';

class CommentsWidget extends StatefulWidget {
  final int stadiumId;
  final bool isScrollable;

  const CommentsWidget({super.key, required this.stadiumId, required this.isScrollable});

  @override
  _CommentsWidgetState createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  int get _pageSize => widget.isScrollable ? 10 : 4;
  final PagingController<int, Comment> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      context.read<FetchCommentsCubit>().fetchComments(widget.stadiumId, pageKey, _pagingController, _pageSize);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchCommentsCubit, FetchCommentsState>(
      builder: (context, state) {
        if (state is FetchCommentsLoading) {
          return CommentsShimmer();
        } else {
          return PagedListView<int, Comment>(
            physics: widget.isScrollable ? const FixedExtentScrollPhysics() : const NeverScrollableScrollPhysics(),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Comment>(
              itemBuilder: (context, comment, index) => CommentWidget(comment: comment),
              firstPageErrorIndicatorBuilder: (context) => const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(child: Text('حدث خطا اثناء تحميل التعليقات')),
                ],
              ),
              noItemsFoundIndicatorBuilder: (context) => const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(child: Text('لاتوجد تعليقات علي هاذا الملعب')),
                ],
              ),
              newPageErrorIndicatorBuilder: (context) => const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(child: Text('حدث خطأ')),
                ],
              ),
              newPageProgressIndicatorBuilder: (context) => CommentsShimmer(),
            ),
          );
        }
      },
    );
  }
}
class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (comment.playerImage != null)
              CircleAvatar(
                radius: Responsive.screenWidth(context) * 0.04,
                backgroundImage: NetworkImage(comment.playerImage!),
              )
            else
              CircleAvatar(
                radius: Responsive.screenWidth(context) * 0.05,
                backgroundImage: const AssetImage(AppPhotot.userAvatar),
              ),
            SizedBox(
              width: Responsive.screenWidth(context) * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.playerName,
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatCommentDate(DateTime.parse(comment.timestamp)),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Responsive.textSize(context, 6),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: Responsive.screenHeight(context) * 0.01,
        ),
        Text(
          comment.content,
          style: TextStyle(
            fontSize: Responsive.textSize(context, 10),
          ),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        const Divider(),
      ],
    );
  }

  String formatCommentDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays == 1) {
      return 'منذ يوم';
    } else if (difference.inDays == 2) {
      return 'منذ يومين';
    } else if (difference.inDays <= 7) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inDays <= 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks أسابيع';
    } else if (difference.inDays <= 365) {
      final months = (difference.inDays / 30).floor();
      if (months == 1) {
        return 'منذ شهر';
      } else if (months == 2) {
        return 'منذ شهرين';
      } else {
        return 'منذ $months أشهر';
      }
    } else {
      final years = (difference.inDays / 365).floor();
      if (years == 1) {
        return 'منذ سنة';
      } else if (years == 2) {
        return 'منذ سنتين';
      } else {
        return 'منذ $years سنوات';
      }
    }
  }
}

class CommentsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(2, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: Responsive.screenHeight(context) * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Responsive.screenWidth(context) * 0.1,
                  height: Responsive.screenWidth(context) * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.1),
                  ),
                ),
                SizedBox(width: Responsive.screenWidth(context) * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: Responsive.screenHeight(context) * 0.01,
                        color: Colors.white,
                      ),
                      SizedBox(height: Responsive.screenHeight(context) * 0.01),
                      Container(
                        width: double.infinity,
                        height: Responsive.screenHeight(context) * 0.01,
                        color: Colors.white,
                      ),
                      SizedBox(height: Responsive.screenHeight(context) * 0.01),
                      Container(
                        width: double.infinity,
                        height: Responsive.screenHeight(context) * 0.01,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}