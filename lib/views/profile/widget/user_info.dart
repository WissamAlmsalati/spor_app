import 'package:flutter/material.dart';
import 'package:sport/utilits/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controller/profile/fetch_profile_cubit.dart';
import '../../../utilits/images.dart';
import '../../../utilits/loading_animation.dart';
import '../../../utilits/responsive.dart';
import '../../auth/widgets/coustom_button.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: Responsive.blockHeight(context) * 5,
          backgroundImage: const AssetImage(AppPhotot.userAvatar),
        ),
        SizedBox(
          height: Responsive.blockHeight(context) * 2,
        ),
        BlocBuilder<FetchProfileCubit, FetchProfileState>(
            builder: (context, state) {
          if (state is FetchProfileLoading) {
            return Center(
                child: LoadingAnimation(
              size: Responsive.screenWidth(context) * 0.1,
            ));
          } else if (state is FetchProfileLoaded) {
            return Column(
              children: [
                Text(
                  state.userInfo.firstName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.textSize(context, 30),
                  ),
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.3),
                  thickness: Responsive.screenHeight(context) * 0.002,
                ),
                Text(
                  state.userInfo.phone,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Responsive.textSize(context, 20),
                    color: Colors.grey.withOpacity(0.9),
                  ),
                ),
              ],
            );
          } else if (state is ProfileSocketExceptionError) {
            return Center(
                child: Text(
              'لا يوجد اتصال بالانترنت',
              style: TextStyle(
                fontSize: Responsive.textSize(context, 12),
                fontWeight: FontWeight.bold,
              ),
            ));
          } else if (state is FetchProfileEmpty) {
            return Center(
                child: CustomButton(
              height: Responsive.screenWidth(context) * 0.1,
              color: Constants.mainColor,
              onPress: () {
                Navigator.pushNamed(context, '/signup');
              },
              text: "انشئ حساب",
              textColor: Colors.white,
              textSize: Responsive.textSize(context, 8),
              width: Responsive.screenWidth(context) * 0.31,
            ));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        }),
        SizedBox(
          height: Responsive.blockHeight(context) * 1,
        ),
        SizedBox(
          height: Responsive.blockHeight(context) * 1,
        ),
      ],
    );
  }
}
