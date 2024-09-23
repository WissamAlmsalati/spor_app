import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/app_packges.dart';
import '../../../controller/fetch_recomended_staduim/fetch_recomended_staduim_cubit.dart';
import '../../../models/recomended_staduim.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';
import '../search_screen/staduim_screen.dart';
import '../stadium/screens/widget/favorite_staduim.dart';

class RecomendedStadiumScreen extends StatelessWidget {
  const RecomendedStadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('افضل الملاعب', style: TextStyle(color: Colors.black, fontSize: Responsive.textSize(context, 17))),
      ),
      body: BlocProvider(
        create: (context) => FetchRecomendedStaduimCubit()..fetchRecomendedStaduims(),
        child: Padding(
          padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.05),
          child: BlocBuilder<FetchRecomendedStaduimCubit, FetchRecomendedStaduimState>(
            builder: (BuildContext context, state) {
              if (state is FetchRecomendedStaduimLoading) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: 4, // Placeholder item count
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
                      Icon(Icons.heart_broken_outlined, color: Constants.mainColor, size: Responsive.screenHeight(context) * 0.2),
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
                return SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: state.staduims.length,
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
              } else {
                return const Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class RecommendedStadiums extends StatelessWidget {
  const RecommendedStadiums({super.key});

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
          return GridView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: state.staduims.length,
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
          );
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }
}