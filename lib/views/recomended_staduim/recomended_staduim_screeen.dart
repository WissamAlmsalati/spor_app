import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/utilits/responsive.dart';
import '../../../../controller/fetch_recomended_staduim/fetch_recomended_staduim_cubit.dart';
import '../../../../models/recomended_staduim.dart';
import '../search_screen/staduim_screen.dart';
import '../stadium/screens/widget/favorite_staduim.dart';

class RecomendedStadiumScreen extends StatelessWidget {
  const RecomendedStadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('افضل الملاعب',
            style: TextStyle(
                color: Colors.black,
                fontSize: Responsive.textSize(context, 17))),
      ),
      body: BlocProvider(
        create: (context) => FetchRecomendedStaduimCubit(),
        child: Padding(
          padding: EdgeInsets.only(
            right: Responsive.screenWidth(context) * 0.03,
            left: Responsive.screenWidth(context) * 0.03,
            top: Responsive.screenHeight(context) * 0.010,
          ),
          child: const RecomendedStaduimsList(isInHomeScreen: false),
        ),
      ),
    );
  }
}

class RecomendedStaduimsList extends StatelessWidget {
  final bool isInHomeScreen;

  const RecomendedStaduimsList({super.key, required this.isInHomeScreen});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchRecomendedStaduimCubit, FetchRecomendedStaduimState>(
      listener: (context, state) {
        if (state is FetchRecomendedStaduimError) {
          context.read<FetchRecomendedStaduimCubit>().pagingController.error = state.message;
        }
      },
      child: BlocBuilder<FetchRecomendedStaduimCubit, FetchRecomendedStaduimState>(
        builder: (context, state) {
          if (state is FetchRecomendedStaduimLoading) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return const ShimmerPlaceholder();
              },
            );
          } else {
            return PagedGridView<int, RecomendedStadium>(
              physics: isInHomeScreen ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
              pagingController: context.read<FetchRecomendedStaduimCubit>().pagingController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              builderDelegate: PagedChildBuilderDelegate<RecomendedStadium>(
                itemBuilder: (context, item, index) {
                  // Limit items to 4 if it's in the home screen
                  if (isInHomeScreen && index >= 4) return const SizedBox();
                  return StadiumBoxWidget(
                    imageUrl: item.image ?? '',
                    name: item.name,
                    isAvailable: item.isAvailable,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StadiumDetailScreen(stadiumId: item.stadiumId),
                        ),
                      );
                    },
                  );
                },
                firstPageProgressIndicatorBuilder: (context) => GridView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return const ShimmerPlaceholder();
                  },
                ),
                newPageProgressIndicatorBuilder: (context) => const Center(child: ShimmerPlaceholder()),
                noMoreItemsIndicatorBuilder: (context) => Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.01,
                      bottom: Responsive.screenHeight(context) * 0.02,
                    ),
                    child: Text(
                      'لا توجد ملاعب اخرى',
                      style: TextStyle(fontSize: Responsive.textSize(context, 12)),
                    ),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                    'لا توجد ملاعب مفضلة',
                    style: TextStyle(fontSize: Responsive.textSize(context, 12)),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}