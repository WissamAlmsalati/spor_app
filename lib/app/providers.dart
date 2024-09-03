import '../controller/reverse_request/reverse_requestt_dart__cubit.dart';
import '../controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import '../repostry/staduim_repostry.dart';
import 'app_packges.dart';
import '../../services/apis.dart';

class ProvidersWidget extends StatelessWidget {
  final Widget child;

  const ProvidersWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StadiumDetailCubit(StadiumRepository()),
        ),
        BlocProvider(
          create: (context) => ReverseRequestCubit(),
        ),

        BlocProvider(create: (context) => FetchCommentsCubit()),
        BlocProvider(create: (context) => AuthenticationCubit()..checkUserStatus()),
        BlocProvider(create: (context) => AuthenticationCubit()),
        BlocProvider(create: (context) => ThemeCubit(context)),
        BlocProvider(create: (context) => AppModeSwicherCubit()),
        BlocProvider(create: (context) => StadiumSearchCubit()),
        BlocProvider(create: (_) => AppModeSwicherCubit()),
        BlocProvider(create: (context) => AddToFavoriteCubit()),
        BlocProvider(create: (context) => FetchProfileCubit()..fetchProfileInfo()),
        BlocProvider(create: (context) => ReservationCubit()..fetchReservations()),
        BlocProvider(create: (context) => OldReservationFetchCubit()..fetchOldReservations()),
        BlocProvider(create: (context) => FetchFavoriteCubit()..fetchFavoriteStadiums()),
        BlocProvider(create: (context) => CheckboxCubit()),
        BlocProvider(create: (context) => RechargeCubit()),
        BlocProvider(create: (context) => OnboardingCubit()),
      ],
      child: child,
    );
  }
}