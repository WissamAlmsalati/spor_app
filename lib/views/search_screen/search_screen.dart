import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/search_screen/staduim_screen.dart';
import 'package:sport/views/search_screen/widget/staduim_search_result.dart';
import 'package:sport/views/stadium/screens/widget/search_field_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/region_search_controler/region_search_cubit.dart';
import '../../controller/steduim_search_cubit/stidum_search_cubit.dart';

class StadiumSearchScreen extends StatefulWidget {
  StadiumSearchScreen({super.key});

  @override
  _StadiumSearchScreenState createState() => _StadiumSearchScreenState();
}

class _StadiumSearchScreenState extends State<StadiumSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String? selectedRegion;

  void _closeScreen(BuildContext context) {
    context.read<StadiumSearchCubit>().resetSearch();
    Navigator.pop(context);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Constants.backGroundColor,
      context: context,
      builder: (BuildContext context) {
        int selectedHourFrom = 2; // Initial value, can be changed
        int selectedHourTo = 4; // Initial value, can be changed

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: Responsive.screenHeight(context) * 0.5,
              child: const Column(
                children: [
                  // Your bottom sheet content here
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero)
                ),
                margin: const EdgeInsets.all(0),
                child: SizedBox(
                  height: Responsive.blockHeight(context) * 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showBottomSheet(context);
                        },
                        icon: SvgPicture.asset(
                          AppPhotot.optionlogo,
                          width: 32,
                          height: 32,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: selectedRegion == null
                              ? SearchFieldWidget(
                                  controller: searchController,
                                  onChanged: (String text) {
                                    context.read<RegionSearchCubit>().searchRegions(text);
                                  },
                                  onSubmitted: (String text) {
                                    context.read<StadiumSearchCubit>().searchStadiums(name: text);
                                  },
                                  enabled: true,
                                  onTap: () {
                                    setState(() {
                                      selectedRegion = null;
                                    });
                                  },
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedRegion = null;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(selectedRegion!),
                                        Icon(Icons.close),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      IconButton(
                        color: Colors.black,
                        onPressed: () {
                          _closeScreen(context);
                        },
                        icon: SvgPicture.asset(AppPhotot.backArrow),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<RegionSearchCubit, RegionSearchState>(
              builder: (context, state) {
                if (state is RegionSearchLoading) {
                  return Center(child: Container());
                } else if (state is RegionSearchLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.regions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRegion = state.regions[index];
                          });
                          context.read<StadiumSearchCubit>().searchStadiums( name: searchController.text);
                        },
                        child: Container(
                          height: Responsive.screenHeight(context) * 0.05,
                          margin: EdgeInsets.symmetric(horizontal: Responsive.screenWidth(context) * 0.035),
                          child: Row(
                            children: [
                              SvgPicture.asset(AppPhotot.locationIco),
                              SizedBox(width: Responsive.screenWidth(context) * 0.02),
                              Text(state.regions[index]),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is RegionSearchError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<StadiumSearchCubit, StadiumSearchState>(
                builder: (context, state) {
                  if (state is StadiumSearchLoading) {
                    return Center(child: LoadingAnimation(size: Responsive.screenHeight(context) * 0.08));
                  } else if (state is StadiumSearchLoaded) {
                    if (state.stadiums.isEmpty) {
                      return Center(
                        child: SizedBox(
                          height: Responsive.screenHeight(context) * 0.4,
                          width: Responsive.screenWidth(context) * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset(AppPhotot.noSearchResult),
                              const Text(
                                'لاتوجد ملاعب متاحة في هاذه المنطقة حالياً',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: Responsive.screenWidth(context) * 0.02,
                          right: Responsive.screenWidth(context) * 0.02,
                        ),
                        child: ListView.builder(
                          itemCount: state.stadiums.length,
                          itemBuilder: (context, index) {
                            final stadium = state.stadiums[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StadiumDetailScreen(stadiumId: stadium.id),
                                    ),
                                  );
                                },
                                child: StaduimSearchResult(stadium: stadium));
                          },
                        ),
                      );
                    }
                  } else if (state is StadiumSearchErrorSocketException) {
                    return Center(
                      child: SizedBox(
                        height: Responsive.screenHeight(context) * 0.4,
                        width: Responsive.screenWidth(context) * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(AppPhotot.noSearchResult),
                            const Text(
                              'تاكد من اتصالك بالانترنت',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}