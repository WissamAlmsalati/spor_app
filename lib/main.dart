import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/services/notification_service.dart';
import 'package:sport/services/spor_deep_link.dart';
import 'package:sport/views/search_screen/staduim_screen.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/views/onBoarding/on_boarding.dart';
import 'package:sport/views/naviggation/home_navigation.dart';
import 'app/authintication_wrapper.dart';
import 'controller/ads_controler/ads_photos_cubit.dart';
import 'controller/cancel_reservation/cancekl_reserv_cubit.dart';
import 'controller/change_pass_controler/change_password_cubit.dart';
import 'controller/fetch_recomended_staduim/fetch_recomended_staduim_cubit.dart';
import 'controller/forget_password/forget_password_cubit.dart';
import 'controller/profile_picture/profile_picture_cubit.dart';
import 'controller/region_search_controler/region_search_cubit.dart';
import 'controller/reverse_request/reverse_requestt_dart__cubit.dart';
import 'controller/review_comment_controller/comment_review_cubit.dart';
import 'controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import 'controller/update_profile/update_profile_cubit.dart';
import 'firebase_options.dart';
import 'models/recomended_staduim.dart';
import 'repostry/staduim_repostry.dart';
import 'app/app_packges.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// This function must be a top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  NotificationService.showLocalNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.initialize(navigatorKey);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        BlocProvider(create: (context) => AddToFavoriteCubit(context)),
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
        BlocProvider(create: (context) => FetchRecomendedStaduimCubit()),
        BlocProvider(create: (context) => ForgetPasswordCubit()),
        BlocProvider(create: (context) => ProfilePictureCubit()),
        BlocProvider(create: (context) => UpdateProfileCubit()),
      ],
      child: Builder(
        builder: (context) {
          Future.microtask(() => RefreshCubit.checkNetworkAndRefreshOnDisconnect(() {
            RefreshCubit.refreshCubits(context);
          }));

          return BlocBuilder<AppModeSwicherCubit, AppModeSwicherState>(
            builder: (context, state) {
              final ThemeData customThemeData = state is AppModeSwicherDarkMood
                  ? CustomThemeData.getDarkThemeData(context)
                  : CustomThemeData.getThemeData(context);

              return ResponsiveInfoProvider(
                context: context,
                child: MaterialApp(
                  navigatorKey: navigatorKey,
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}