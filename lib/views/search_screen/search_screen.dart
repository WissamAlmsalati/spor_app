import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/views/search_screen/staduim_screen.dart';
import 'package:sport/views/search_screen/widget/buttom_sheet_filter.dart';
import 'package:sport/views/search_screen/widget/staduim_search_result.dart';
import 'package:sport/views/stadium/screens/widget/search_field_widget.dart';
import '../../app/status_bar_color.dart';
import '../../controller/region_search_controler/region_search_cubit.dart';
import '../../controller/steduim_search_cubit/stidum_search_cubit.dart';

class StadiumSearchScreen extends StatefulWidget {
  @override
  _StadiumSearchScreenState createState() => _StadiumSearchScreenState();
}

class _StadiumSearchScreenState extends State<StadiumSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String? selectedRegion;
  DateTime? selectedDate;
  int? selectedSessionId;

  @override
  void initState() {
    super.initState();
    searchController.clear();
    context.read<StadiumSearchCubit>().resetSearch();
  }

  void _closeScreen(BuildContext context) {
    context.read<StadiumSearchCubit>().resetSearch();
    searchController.clear();
    selectedRegion = null;
    context.read<RegionSearchCubit>().resetSearch();
    Navigator.pop(context);
  }

  void _showBottomSheet(BuildContext context) {
    showCustomBottomSheet(context, searchController.text, (date) {
      setState(() {
        selectedDate = date;
      });
    }, (hour) {
      setState(() {
        selectedSessionId = hour;
      });
    });
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      selectedRegion = query;
    });
    context.read<StadiumSearchCubit>().searchStadiums(name: query);
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backGroundColor,
        body: Column(
          children: [
            _buildSearchBar(context),
            if (selectedRegion == null) _buildRegionSearchResult(),
            if (selectedRegion != null)
              Expanded(child: _buildStadiumSearchResult()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: EdgeInsets.all(0),
        child: SizedBox(
          height: Responsive.blockHeight(context) * 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _showBottomSheet(context),
                icon: Icon(Icons.menu),
              ),
              Expanded(
                child: Center(
                  child: SearchFieldWidget(
                    controller: searchController,
                    onChanged: (text) {
                      if (text.isEmpty) {
                        setState(() {
                          selectedRegion = null;
                        });
                      } else {
                        context.read<RegionSearchCubit>().searchRegions(text);
                      }
                    },
                    onSubmitted: _onSearchSubmitted,
                    enabled: true,
                    initialValue: selectedRegion,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _closeScreen(context),
                icon: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionSearchResult() {
    return BlocBuilder<RegionSearchCubit, RegionSearchState>(
      builder: (context, state) {
        if (state is RegionSearchLoading) {
          return Center(child: LoadingAnimation(size: MediaQuery.sizeOf(context).height*0.04));
        } else if (state is RegionSearchLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.regions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRegion = state.regions[index];
                    searchController.text = selectedRegion!;
                  });
                  context
                      .read<StadiumSearchCubit>()
                      .searchStadiums(name: searchController.text);
                },
                child: Container(
                  height: Responsive.screenHeight(context) * 0.05,
                  margin: EdgeInsets.symmetric(
                      horizontal: Responsive.screenWidth(context) * 0.035),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/location.svg'),
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
    );
  }

  Widget _buildStadiumSearchResult() {
    return BlocBuilder<StadiumSearchCubit, StadiumSearchState>(
      builder: (context, state) {
        if (state is StadiumSearchLoading) {
          return Center(child: LoadingAnimation(size: 50));
        } else if (state is StadiumSearchLoaded) {
          if (state.stadiums.isEmpty) {
            return Center(
              child: SizedBox(
                height: Responsive.screenHeight(context) * 0.4,
                width: Responsive.screenWidth(context) * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset('assets/icons/no_result.svg'),
                    const Text(
                      'لاتوجد ملاعب متاحةً',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.stadiums.length,
            itemBuilder: (context, index) {
              final stadium = state.stadiums[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StadiumDetailScreen(stadiumId: stadium.id),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.02,
                      left: Responsive.screenWidth(context) * 0.02,
                      right: Responsive.screenWidth(context) * 0.02),
                  child: StaduimSearchResult(stadium: stadium),
                ),
              );
            },
          );
        } else if (state is StadiumSearchError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }
}
