import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import 'package:sport/views/onBoarding/on_boarding.dart';
import 'package:sport/views/naviggation/home_navigation.dart';
import '../controller/ads_controler/ads_photos_cubit.dart';
import '../controller/region_search_controler/region_search_cubit.dart';
import '../controller/reverse_request/reverse_requestt_dart__cubit.dart';
import '../repostry/staduim_repostry.dart';
import 'app_packges.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorageData.getIsSign();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FetchCommentsCubit()),
        BlocProvider(create: (context) => AuthenticationCubit()..checkAuthentication()),
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
        BlocProvider(create: (context) => StadiumDetailCubit(StadiumRepository())),
        BlocProvider(create: (context) => ReverseRequestCubit(StadiumRepository())),
        BlocProvider(create: (context) => ReverseRequestCubit(StadiumRepository())),
        BlocProvider(create: (context) => StadiumDetailCubit(StadiumRepository())),
        BlocProvider(create: (context) => ReverseRequestCubit(StadiumRepository())),
        BlocProvider(create: (context) => RegionSearchCubit()),
        BlocProvider(create: (context) => AdsPhotosCubit()),
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
                  '/': (context) => AuthenticationWrapper(),
                  '/homeNavigation': (context) => HomeNavigation(),
                  '/onboarding': (context) => OnboardingScreen(),
                },
                onGenerateRoute: RouteGenerator.generateRoute,
                builder: (context, child) {
                  return AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: state is AppModeSwicherDarkMood
                          ? Brightness.light
                          : Brightness.dark,
                      systemNavigationBarColor: state is AppModeSwicherDarkMood
                          ? Colors.black
                          : Colors.white,
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

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return HomeNavigation();
        } else if (state is AuthenticationUnauthenticated) {
          return const OnboardingScreen();
        } else {
          return Container(); // Return an empty container or another widget as needed
        }
      },
    );
  }
}