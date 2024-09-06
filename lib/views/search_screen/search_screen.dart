import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/app/app_packges.dart';
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
import 'package:intl/intl.dart';

class StadiumSearchScreen extends StatefulWidget {
  StadiumSearchScreen({super.key});

  @override
  _StadiumSearchScreenState createState() => _StadiumSearchScreenState();
}

class _StadiumSearchScreenState extends State<StadiumSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String? selectedRegion;
  DateTime? selectedDate; // Declare selectedDate
  int? selectedSessionId; // Declare selectedSessionId

  @override
  void initState() {
    super.initState();
    // Clear previous search data when screen is opened
    searchController.clear();
    selectedRegion = null;
    context.read<StadiumSearchCubit>().resetSearch(); // Reset the search state
  }

  void _closeScreen(BuildContext context) {
    // Reset search state when closing the screen
    context.read<StadiumSearchCubit>().resetSearch();
    searchController.clear(); // Clear the search field
    selectedRegion = null; // Reset the selected region
    Navigator.pop(context); // Close the screen
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Constants.backGroundColor,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: Responsive.screenHeight(context) * 0.02),
                  Text("اختيار التاريخ", style: TextStyle(fontSize: Responsive.textSize(context, 16), fontWeight: FontWeight.w600)),
                  SizedBox(height: Responsive.screenHeight(context) * 0.02),
                  Container(
                    height: Responsive.screenHeight(context) * 0.13,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 30, // Assuming 30 days for a month
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index));
                        final formattedDate = DateFormat('dd/MM').format(date);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                          child: Container(
                            height: Responsive.screenHeight(context) * 0.13,
                            width: Responsive.screenWidth(context) * 0.3,
                            margin: EdgeInsets.symmetric(
                              horizontal: Responsive.screenWidth(context) * 0.02,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedDate == date ? Colors.blue : Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Responsive.screenHeight(context) * 0.02),
                  Text("اختيار التوقيت", style: TextStyle(fontSize: Responsive.textSize(context, 16), fontWeight: FontWeight.w600)),
                  SizedBox(height: Responsive.screenHeight(context) * 0.02),
                  Container(
                    height: Responsive.screenHeight(context) * 0.13,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 24,
                      itemBuilder: (context, index) {
                        final hour = index < 12 ? '${index + 1} ص' : '${index - 11} م';
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSessionId = index;
                            });
                          },
                          child: Container(
                            height: Responsive.screenHeight(context) * 0.13,
                            width: Responsive.screenWidth(context) * 0.3,
                            margin: EdgeInsets.symmetric(
                              horizontal: Responsive.screenWidth(context) * 0.02,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedSessionId == index ? Colors.blue : Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                hour,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Responsive.screenHeight(context) * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _searchByHour(String hour) {
    // Implement search logic based on the selected hour
    // This function should trigger the search with the selected hour and date
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
                    borderRadius: BorderRadius.all(Radius.zero)),
                margin: const EdgeInsets.all(0),
                child: SizedBox(
                  height: Responsive.blockHeight(context) * 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showFilterBottomSheet(context);
                        },
                        icon: SvgPicture.asset(
                          AppPhotot.optionlogo,
                          width: 32,
                          height: 32,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SearchFieldWidget(
                            controller: searchController,
                            onChanged: (String text) {
                              context
                                  .read<RegionSearchCubit>()
                                  .searchRegions(text);
                            },
                            onSubmitted: (String text) {
                              context
                                  .read<StadiumSearchCubit>()
                                  .searchStadiums(name: text);
                            },
                            enabled: true,
                            onTap: () {
                              setState(() {
                                selectedRegion = null;
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        color: Colors.black,
                        onPressed: () {
                          _closeScreen(context); // Close and reset the screen
                        },
                        icon: SvgPicture.asset(AppPhotot.backArrow),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (selectedRegion == null)
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
                            context
                                .read<StadiumSearchCubit>()
                                .searchStadiums(name: searchController.text);
                          },
                          child: Container(
                            height: Responsive.screenHeight(context) * 0.05,
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    Responsive.screenWidth(context) * 0.035),
                            child: Row(
                              children: [
                                SvgPicture.asset(AppPhotot.locationIco),
                                SizedBox(
                                    width:
                                        Responsive.screenWidth(context) * 0.02),
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
            if (selectedRegion != null)
              Expanded(
                child: BlocBuilder<StadiumSearchCubit, StadiumSearchState>(
                  builder: (context, state) {
                    if (state is StadiumSearchLoading) {
                      return Center(
                          child: LoadingAnimation(
                              size: Responsive.screenHeight(context) * 0.08));
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
                                        builder: (context) =>
                                            StadiumDetailScreen(
                                                stadiumId: stadium.id),
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