// comments_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/utilits/responsive.dart';
import '../../../../controller/fetch_comments/fetch_comments_cubit.dart';
import 'package:intl/intl.dart';

class CommentsWidget extends StatelessWidget {
  final int stadiumId;

  const CommentsWidget({super.key, required this.stadiumId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      FetchCommentsCubit()
        ..fetchComments(stadiumId, (comments) {}),
      child: Scaffold(
        body: BlocBuilder<FetchCommentsCubit, FetchCommentsState>(
          builder: (context, state) {
            if (state is FetchCommentsLoading) {
              return Center(child: CommentsShimmer());
            } else if (state is FetchCommentsLoaded) {
              return ListView.builder(
                itemCount: state.comments.length,
                itemBuilder: (context, index) {
                  final comment = state.comments[index];
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (comment.playerImage != null)
                              CircleAvatar(
                                radius: Responsive.screenWidth(context) * 0.04,
                                backgroundImage: NetworkImage(
                                    comment.playerImage!),
                              )
                            else
                              CircleAvatar(
                                radius: Responsive.screenWidth(context) * 0.05,
                                backgroundImage: const AssetImage(
                                    AppPhotot.userAvatar),
                              ),
                            SizedBox(
                              width: Responsive.screenWidth(context) * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.playerName,style: TextStyle(
                                  fontSize: Responsive.textSize(context, 10),
                                  fontWeight: FontWeight.bold
                                ),),
                                Text(formatCommentDate(
                                    DateTime.parse(comment.timestamp)),style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Responsive.textSize(context, 6),

                                ),),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Responsive.screenHeight(context) * 0.01,
                        ),

                        Text(
                          comment.content,
                          style:  TextStyle(
                            fontSize: Responsive.textSize(context, 10),
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              );
            } else if (state is FetchCommentsError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

// date_formatter.dart

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
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        width: double.infinity,
                        height: 8.0,
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