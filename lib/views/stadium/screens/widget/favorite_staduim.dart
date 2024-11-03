import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/app_packges.dart';
import '../../../../models/stedum_model.dart';
import '../../../search_screen/staduim_screen.dart';

class FavoriteStadium extends StatelessWidget {
  const FavoriteStadium({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchFavoriteCubit(),
      child: BlocListener<AddToFavoriteCubit, AddToFavoriteState>(
        listener: (context, state) {
          if (state is AdedToFavorite) {
            context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Responsive.screenHeight(context) * 0.01,
            horizontal: Responsive.screenWidth(context) * 0.05,
          ),
          child: BlocBuilder<FetchFavoriteCubit, FetchFavoriteState>(
            builder: (BuildContext context, state) {
              if (state is FetchFavoriteLoading) {
                print('Loading favorite stadiums...');
              } else if (state is FetchFavoriteLoaded) {
                print('Favorite stadiums loaded: ${state.stadiums}');
              } else if (state is FetchFavoriteError) {
                print('Error loading favorite stadiums: ${state.message}');
              } else if (state is UnAuthorizedError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    
                      Text(
                        'يرجى إنشاء حساب',
                        style: TextStyle(
                          fontSize: Responsive.textSize(context, 14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text('إنشاء حساب'),
                      ),
                    ],
                  ),
                );
              }

              return PagedGridView<int, Stadium>(
                pagingController: context.read<FetchFavoriteCubit>().pagingController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                builderDelegate: PagedChildBuilderDelegate<Stadium>(
                  itemBuilder: (context, item, index) {
                    return StadiumBoxWidget(
                      isFavoriteWidget: true,
                      imageUrl: item.image,
                      name: item.name,
                      isAvailable: item.isAvailable,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StadiumDetailScreen(stadiumId: item.id),
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
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Column(
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
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Responsive.screenHeight(context) * 0.12,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Responsive.screenHeight(context) * 0.01,
                right: Responsive.screenWidth(context) * 0.018,
              ),
              child: Container(
                width: Responsive.screenWidth(context) * 0.3,
                height: Responsive.screenHeight(context) * 0.02,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Responsive.screenHeight(context) * 0.01,
                right: Responsive.screenWidth(context) * 0.018,
              ),
              child: Container(
                width: Responsive.screenWidth(context) * 0.2,
                height: Responsive.screenHeight(context) * 0.02,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StadiumBoxWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool isAvailable;
  final VoidCallback onTap;
  final bool isFavoriteWidget;

  const StadiumBoxWidget({
    required this.imageUrl,
    required this.name,
    required this.isAvailable,
    required this.onTap,
    super.key,
    this.isFavoriteWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(0),
        child: Card(
          margin: const EdgeInsets.all(0),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.04),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: Responsive.screenHeight(context) * 0.12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Responsive.screenWidth(context) * 0.04),
                        topRight: Radius.circular(Responsive.screenWidth(context) * 0.04),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isFavoriteWidget)
                    Positioned(
                      right: Responsive.screenWidth(context) * 0.04,
                      top: Responsive.screenHeight(context) * 0.02,
                      child: SvgPicture.asset(
                        AppPhotot.fillFav,
                        color: Colors.red,
                        width: Responsive.screenWidth(context) * 0.025,
                        height: Responsive.screenHeight(context) * 0.020,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: Responsive.screenHeight(context) * 0.01,
                  right: Responsive.screenWidth(context) * 0.018,
                ),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: Responsive.screenHeight(context) * 0.015,
                  right: Responsive.screenWidth(context) * 0.018,
                ),
                child: Text(
                  isAvailable ? 'متوفر للحجز' : 'غير متوفر للحجز',
                  style: isAvailable
                      ? Theme.of(context).textTheme.bodySmall?.copyWith(color: Constants.mainColor)
                      : Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}