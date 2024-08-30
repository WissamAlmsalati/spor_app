import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import 'package:sport/views/onBoarding/on_boarding.dart';
import 'package:sport/views/naviggation/home_navigation.dart';
import 'package:sport/utilits/secure_data.dart';
import 'controller/reverse_request/reverse_requestt_dart__cubit.dart';
import 'repostry/staduim_repostry.dart';
import 'app/app_packges.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? isSignedUpString = await SecureStorageData.getIsSign();
  final bool isSignedUp = isSignedUpString == 'true';
  runApp(MyApp(isSignedUp: isSignedUp));
}


class MyApp extends StatelessWidget {
  final bool isSignedUp;
  const MyApp({
    super.key,
    required this.isSignedUp,
  });


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FetchCommentsCubit()),
        BlocProvider(create: (context) => AuthenticationCubit()..checkUserStatus()),
        BlocProvider(create: (context) => AuthenticationCubit()),
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
        BlocProvider(
          create: (context) => StadiumDetailCubit(StadiumRepository()),
        ),
        BlocProvider(
          create: (context) => ReverseRequestCubit(StadiumRepository()),
        ),
        BlocProvider(create: (context) => ReverseRequestCubit(StadiumRepository())),
        BlocProvider(
          create: (context) => StadiumDetailCubit(StadiumRepository()),
        ),
        BlocProvider(
          create: (context) => ReverseRequestCubit(StadiumRepository()),
        ),
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
                  '/': (context) =>  OnboardingScreen(),
                  '/homeNavigation': (context) => HomeNavigation(),
                  '/onboarding': (context) =>  OnboardingScreen(),
                },
                onGenerateRoute: RouteGenerator.generateRoute,
                builder: (context, child) {
                  return AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: state is AppModeSwicherDarkMood
                          ? Brightness.light
                          : Brightness.dark,
                    ),
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}