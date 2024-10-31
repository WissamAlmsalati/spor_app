import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controller/swicher/app_mode_swicher_cubit.dart';
import '../../../utilits/responsive.dart';

class IOSSwitchButton extends StatelessWidget {
  final Color activeColor;
  final VoidCallback? onToggle;

  const IOSSwitchButton({
    super.key,
    this.activeColor = CupertinoColors.activeGreen,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppModeSwicherCubit, AppModeSwicherState>(
      builder: (context, state) {
        final isDarkTheme = state is AppModeSwicherDarkMood;

        return SizedBox(
          height: Responsive.screenWidth(context) * 0.3,
          width: Responsive.screenWidth(context) * 0.5,
          child: CupertinoSwitch(
            value: isDarkTheme,
            onChanged: (value) {
              if (value) {
                BlocProvider.of<AppModeSwicherCubit>(context).changeToDarkMode();
              } else {
                try {
                  BlocProvider.of<AppModeSwicherCubit>(context).changeToLightMode();
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
              }
              if (onToggle != null) {
                onToggle!();
              }
            },
            activeColor: activeColor,
          ),
        );
      },
    );
  }
}
