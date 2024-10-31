import 'package:card_swiper/card_swiper.dart';
import '../../app/app_packges.dart';
import '../auth/widgets/coustom_button.dart';

class OnboardingScreen extends StatelessWidget {
  final List<Map<String, String>> pages = const [
    {
      "text": "ابحث عن ملعبك\nالمفضل",
      "photoPath": "assets/photos/Rectangle.png",
      "arrow": "assets/icons/Arrow 14.svg",
      "reversArrow": "assets/icons/Arrow 18.svg",
    },
    {
      "text": "احجز من بيتك\nبكل سهولة",
      "photoPath": "assets/photos/Rectangle.png",
      "arrow": "assets/icons/Arrow 14.svg",
      "reversArrow": "assets/icons/Arrow 18.svg",
    },
    {
      "text": "تتبع حالة حجزك و\nحالة الملعب",
      "photoPath": "assets/photos/Rectangle1.png",
      "arrow": "assets/icons/Arrow 14.svg",
      "reversArrow": "assets/icons/Arrow 18.svg",
    },
  ];

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (BuildContext context) {
        return OnboardingCubit();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.mainColor,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/photos/appBackground.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: BlocBuilder<OnboardingCubit, int>(
                    builder: (context, currentPage) {
                      final cubit = context.read<OnboardingCubit>();
                      return Swiper(
                        controller: cubit.swiperController,
                        itemCount: pages.length,
                        loop: false,
                        onIndexChanged: (index) {
                          cubit.updatePage(index);
                        },
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        pages[index]["text"]!,
                                        textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                            color: Constants.secondaryColor,
                                            fontWeight: FontWeight.w700,

                                          )
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset(
                                            pages[index]["arrow"]!,
                                            height: Responsive.screenHeight(
                                                context) *
                                                0.1,
                                          ),
                                          SizedBox(
                                            width: Responsive.screenHeight(
                                                context) *
                                                0.13,
                                          ),
                                          SvgPicture.asset(
                                            pages[index]["reversArrow"]!,
                                            height: Responsive.screenHeight(
                                                context) *
                                                0.1,
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        pages[index]["photoPath"]!,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPageIndicators(context),
                        CustomButton(
                          fontWeight: FontWeight.w600,
                          textSize: Responsive.textSize(context, 16),
                          height: Responsive.screenHeight(context) * 0.06,
                          text: "انشاء حساب",
                          color: Constants.mainColor,
                          onPress: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          textColor: Constants.secondaryColor,
                          width: MediaQuery.of(context).size.width * 0.9,
                        ),
                        CustomButton(
                          width: MediaQuery.of(context).size.width * 0.9,
                          text: "تسجيل الدخول",
                          fontWeight: FontWeight.w600,
                          textSize: Responsive.textSize(context, 16),
                          color: Constants.secondaryColor,
                          borderColor: Constants.mainColor,
                          height: Responsive.screenHeight(context) * 0.060,
                          onPress: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          textColor: Constants.mainColor,
                          hasBorder: true,
                        ),
                        CustomButton(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: Responsive.screenHeight(context) * 0.06,
                          fontWeight: FontWeight.w600,
                          textSize: Responsive.textSize(context, 16),
                          text: "دخول كزائر",
                          color: Constants.secondaryColor,
                          borderColor: Constants.secondaryColor,
                          onPress: () {
                            RefreshCubit.refreshCubits(context);
                            SecureStorageData.clearData();
                            Navigator.pushNamed(context, '/visitor');
                          },
                          textColor: Constants.thirdColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, currentPage) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(pages.length, (index) {
              return Container(
                height: Responsive.screenHeight(context)*0.015,
                width: Responsive.screenWidth(context)*0.07,
                margin: const EdgeInsets.symmetric(horizontal: 5.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Responsive.screenWidth(context)*0.02),
                  color: currentPage == index
                      ? Constants.mainColor
                      : Constants.thirdColor.withOpacity(0.5),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
