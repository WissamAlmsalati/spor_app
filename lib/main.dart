import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/views/onBoarding/on_boarding.dart';
import 'package:sport/views/naviggation/home_navigation.dart';
import 'controller/ads_controler/ads_photos_cubit.dart';
import 'controller/cancel_reservation/cancekl_reserv_cubit.dart';
import 'controller/change_pass_controler/change_password_cubit.dart';
import 'controller/fetch_recomended_staduim/fetch_recomended_staduim_cubit.dart';
import 'controller/forget_password/forget_password_cubit.dart';
import 'controller/region_search_controler/region_search_cubit.dart';
import 'controller/reverse_request/reverse_requestt_dart__cubit.dart';
import 'controller/review_comment_controller/comment_review_cubit.dart';
import 'repostry/staduim_repostry.dart';
import 'app/app_packges.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorageData.getIsSign();

  // Lock the orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OnboardingCubit()),
        BlocProvider(create: (context) => FetchCommentsCubit()),
        BlocProvider(create: (context) => AuthenticationCubit()..checkAuthentication()),
        BlocProvider(create: (context) => ThemeCubit(context)),
        BlocProvider(create: (context) => AppModeSwicherCubit()),
        BlocProvider(create: (context) => StadiumSearchCubit()),
        BlocProvider(create: (context) => AddToFavoriteCubit()),
        BlocProvider(create: (context) => FetchProfileCubit()..fetchProfileInfo()),
        BlocProvider(create: (context) => ReservationCubit()..fetchReservations()),
        BlocProvider(create: (context) => OldReservationFetchCubit()..fetchOldReservations()),
        BlocProvider(create: (context) => FetchFavoriteCubit()..fetchFavoriteStadiums()),
        BlocProvider(create: (context) => CheckboxCubit()),
        BlocProvider(create: (context) => RechargeCubit()),
        BlocProvider(create: (context) => OnboardingCubit()),
        BlocProvider(create: (context) => StadiumDetailCubit(StadiumRepository())),
        BlocProvider(create: (context) => ReverseRequestCubit()),
        BlocProvider(create: (context) => RegionSearchCubit()),
        BlocProvider(create: (context) => FetchAdsImagesCubit()),
        BlocProvider(create: (context) => ChangePasswordCubit()),
        BlocProvider(create: (context) => CommentReviewCubit()),
        BlocProvider(create: (context) => CanceklReservCubit()),
        BlocProvider(create: (context) => FetchRecomendedStaduimCubit()..fetchRecomendedStaduims(),),
        BlocProvider(create: (context) => ForgetPasswordCubit()),
      ],
      child: Builder(
        builder: (context) {
          Future.microtask(() => RefreshCubit.checkNetworkAndRefreshOnDisconnect(context));

          return BlocBuilder<AppModeSwicherCubit, AppModeSwicherState>(
            builder: (context, state) {
              final ThemeData customThemeData = state is AppModeSwicherDarkMood
                  ? CustomThemeData.getDarkThemeData(context)
                  : CustomThemeData.getThemeData(context);

              return MaterialApp(
                supportedLocales: const [
                  Locale('en', ''), // English
                  Locale('ar', ''), // Arabic
                ],
                locale: const Locale('ar', ''),
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                theme: customThemeData,
                initialRoute: '/',
                routes: {
                  '/': (context) => const AuthenticationWrapper(),
                  '/homeNavigation': (context) => HomeNavigation(),
                  '/onboarding': (context) => const OnboardingScreen(),
                },
                onGenerateRoute: RouteGenerator.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          Navigator.pushReplacementNamed(context, '/homeNavigation');
        } else if (state is AuthenticationUnauthenticated || state is AuthenticationPhoneNotVirefy) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      },
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return Center(child: LoadingAnimation(size: Responsive.screenWidth(context) * 0.2));
        } else {
          return Container(
            color: Colors.white,
          );
        }
      },
    );
  }
}