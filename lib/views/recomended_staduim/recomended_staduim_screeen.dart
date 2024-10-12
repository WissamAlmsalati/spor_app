import '../../../../app/app_packges.dart';
import '../../../controller/fetch_recomended_staduim/fetch_recomended_staduim_cubit.dart';
import '../../models/recomended_staduim.dart';
import '../Booking/booking_history_screen.dart';
import '../search_screen/staduim_screen.dart';
import '../stadium/screens/widget/favorite_staduim.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RecomendedStadiumScreen extends StatelessWidget {
  const RecomendedStadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PagingController<int, RecomendedStadium> _pagingController = PagingController(firstPageKey: 1);

    _pagingController.addPageRequestListener((pageKey) {
      context.read<FetchRecomendedStaduimCubit>().fetchRecomendedStaduims();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('افضل الملاعب', style: TextStyle(color: Colors.black, fontSize: Responsive.textSize(context, 17))),
      ),
      body: BlocProvider(
        create: (context) => FetchRecomendedStaduimCubit()..fetchRecomendedStaduims(),
        child: Padding(
          padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.05),
          child: BlocListener<FetchRecomendedStaduimCubit, FetchRecomendedStaduimState>(
            listener: (context, state) {
              if (state is FetchRecomendedStaduimLoaded) {
                final isLastPage = state.isLastPage;
                if (isLastPage) {
                  _pagingController.appendLastPage(state.staduims);
                } else {
                  final nextPageKey = _pagingController.nextPageKey! + 1;
                  _pagingController.appendPage(state.staduims, nextPageKey);
                }
              } else if (state is FetchRecomendedStaduimError) {
                _pagingController.error = state.message;
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
                    itemCount: 4, // Number of shimmer boxes
                    itemBuilder: (context, index) {
                      return const ShimmerPlaceholder();
                    },
                  );
                } else {
                  return PagedGridView<int, RecomendedStadium>(
                    pagingController: _pagingController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    builderDelegate: PagedChildBuilderDelegate<RecomendedStadium>(
                      itemBuilder: (context, item, index) {
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
                        itemCount: 4, // Number of shimmer boxes
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
          ),
        ),
      ),
    );
  }
}

class RecommendedStadiums extends StatelessWidget {
  final bool? isInHomeScreen;
  const RecommendedStadiums({super.key, this.isInHomeScreen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchRecomendedStaduimCubit, FetchRecomendedStaduimState>(
      builder: (BuildContext context, state) {
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
        } else if (state is FetchRecomendedStaduimError) {
          return Center(child: Text(state.message));
        } else if (state is FetchRecomendedStaduimLoaded) {
          if (state.staduims.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.heart_broken_outlined,
                  color: Constants.mainColor,
                  size: Responsive.screenHeight(context) * 0.2,
                ),
                Text(
                  'لا توجد ملاعب مفضلة',
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }
          return Padding(
            padding:  EdgeInsets.only(
              top:  Responsive.screenHeight(context)  * 0.01,
              bottom: Responsive.screenHeight(context) * 0.02,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: isInHomeScreen! ? 4 : state.staduims.length,

              itemBuilder: (context, index) {
                return StadiumBoxWidget(
                  imageUrl: state.staduims[index].image ?? '',
                  name: state.staduims[index].name,
                  isAvailable: state.staduims[index].isAvailable,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StadiumDetailScreen(stadiumId: state.staduims[index].stadiumId),
                      ),
                    );
                  },
                );
              },
            ),
          );
        } else if (state is FetchRecomendedStaduimSocketExceptionError){
          return SizedBox(
              height: Responsive.screenHeight(context)*0.4,
              child: const Center(child:Text("لا يوجد اتصال بالانترنت")));}
        else {
          return const Center(child: Text('حدث خطأ'));
        }
      },
    );
  }
}