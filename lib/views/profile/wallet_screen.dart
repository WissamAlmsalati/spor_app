import 'package:flutter/material.dart';
import 'package:sport/controller/profile/fetch_profile_cubit.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/views/auth/widgets/form_decoration.dart';
import 'package:sport/views/stadium/widget/coustom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/recharge_balance/recharge_balance_cubit.dart';
import '../../utilits/constants.dart';
import '../../utilits/loading_animation.dart';
import '../../utilits/responsive.dart';
import '../auth/widgets/coustom_button.dart';
import 'barcode_scanner_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Responsive.screenWidth(context) * 0.02,
                    right: Responsive.screenWidth(context) * 0.02,
                  ),
                  child: Column(
                    children: [
                      CoustomAppBr(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        logo: AppPhotot.backArrow,
                        title: "المحفظة",
                        color: Constants.mainColor,
                        height: Responsive.screenHeight(context) * 0.045,
                        width: Responsive.screenHeight(context) * 0.045, isHomeScreen: false,
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                          top: Responsive.screenHeight(context) * 0.04,
                          left: Responsive.screenWidth(context) * 0.02,
                          right: Responsive.screenWidth(context) * 0.02,
                        ),
                        child: FormDecoration(
                          height: Responsive.screenHeight(context) * 0.44,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/icons/Vector (8).png"),
                              BlocBuilder<FetchProfileCubit, FetchProfileState>(
                                builder: (BuildContext context, state) {
                                  if (state is FetchProfileLoading) {
                                    return Center(
                                      child: LoadingAnimation(
                                        size: Responsive.screenWidth(context) *
                                            0.09,
                                      ),
                                    );
                                  } else if (state is FetchProfileLoaded) {
                                    return Text(
                                      '${state.userInfo.balance} LYD',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            Responsive.textSize(context, 30),
                                        color: Colors.black,
                                      ),
                                    );
                                  } else if (state
                                      is ProfileSocketExceptionError) {
                                    return const Center(
                                      child: Text('لا يوجد اتصال بالانترنت'),
                                    );
                                  } else if (state is FetchProfileEmpty) {
                                    return const Center(
                                        child: Text("Create An Acount"));
                                  } else if (state is FetchProfileError) {
                                    return Center(child: Text(state.message));
                                  } else {
                                    return const Center(
                                      child: Text('Unknown state'),
                                    );
                                  }
                                },
                              ),
                              Text(
                                "الرصيد الحالي",
                                style: TextStyle(
                                  fontSize: Responsive.textSize(context, 24),
                                  color: Constants.txtColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: Responsive.screenHeight(context) * 0.17,
        width: double.infinity,
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              right: Responsive.screenWidth(context) * 0.04,
              left: Responsive.screenWidth(context) * 0.04,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  text: 'شحن الرصيد',
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        height: Responsive.screenHeight(context) * 0.3,
                        width: Responsive.screenWidth(context) * 0.8,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        child: const Center(
                          child: Text('Custom Dialog Content'),
                        ),
                      ),
                    );
                  },
                  color: Constants.mainColor,
                  textColor: Colors.white,
                  textSize: Responsive.textSize(context, 12),
                  height: Responsive.screenHeight(context) * 0.053,
                  width: double.infinity,
                ),
                CustomButton(
  text: 'قراءة الكود',
  onPress: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerScreen(),
      ),
    );
  },

                  color: Colors.white,
                  textColor: Constants.txtColor,
                  textSize: Responsive.textSize(context, 12),
                  height: Responsive.screenHeight(context) * 0.053,
                  width: double.infinity,
                  hasBorder: true,
                  borderColor: Constants.txtColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final BorderRadius borderRadius;
  final Widget child;
  final TextEditingController cardNumberController = TextEditingController();

  CustomDialog({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cardNumberController.clear();
        return true;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        child: BlocConsumer<RechargeCubit, RechargeState>(
          listener: (context, state) {
            if (state is CloseRechargeDialog) {
              cardNumberController.clear();
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: color,
                borderRadius: borderRadius,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: Responsive.screenWidth(context) * 0.05,
                  right: Responsive.screenWidth(context) * 0.05,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocBuilder<RechargeCubit, RechargeState>(
                      builder: (context, state) {
                        if (state is RechargeLoading) {
                          return LoadingAnimation(
                            size: Responsive.screenWidth(context) * 0.09,
                          );
                        } else if (state is RechargeSuccess) {
                          return Text(
                            'تمت عملية الشحن بنجاح',
                            style: TextStyle(
                              color: Constants.mainColor,
                              fontSize: Responsive.textSize(context, 12),
                              fontFamily: GoogleFonts.cairo().fontFamily,
                            ),

                          );
                        } else if (state is RechargeFailure) {
                          return Text(
                            state.error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: Responsive.textSize(context, 12),
                              fontFamily: GoogleFonts.cairo().fontFamily,
                            ),
                          );
                        } else if (state is RechargeSocketExceptionError) {
                          return const Text('لا يوجد اتصال بالانترنت');
                        } else if (state is RechargeEmpty) {
                          return Text(
                            'يرجى ادخال الرقم السري',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: Responsive.textSize(context, 12),
                              fontFamily: GoogleFonts.cairo().fontFamily,
                            ),
                          );
                        } else {
                          return Center(
                              child: Text(
                            'ادخل الرقم السري',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Responsive.textSize(context, 12),
                              fontFamily: GoogleFonts.cairo().fontFamily,
                            ),
                          ));
                        }
                      },
                    ),
                    SizedBox(
                      height: Responsive.screenHeight(context) * 0.053,
                      child: TextField(
                        controller: cardNumberController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF5F6F8),
                          hintText: 'ادخل الرقم السري',
                          hintStyle: TextStyle(
                            color: Constants.txtColor,
                            fontSize: Responsive.textSize(context, 12),
                            fontFamily: GoogleFonts.cairo().fontFamily,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    CustomButton(
                      text: 'تأكيد',
                      onPress: () {
                        context
                            .read<RechargeCubit>()
                            .rechargeCard(cardNumberController.text, context);
                      },
                      color: Constants.mainColor,
                      textColor: Colors.white,
                      textSize: Responsive.textSize(context, 12),
                      height: Responsive.screenHeight(context) * 0.053,
                      width: double.infinity,
                    ),
                    CustomButton(
                      text: 'إلغاء',
                      onPress: () {
                        context.read<RechargeCubit>().closeDialog(context);
                      },
                      color: Colors.white,
                      textColor: Constants.txtColor,
                      textSize: Responsive.textSize(context, 12),
                      height: Responsive.screenHeight(context) * 0.053,
                      width: double.infinity,
                      hasBorder: true,
                      borderColor: Constants.txtColor,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
