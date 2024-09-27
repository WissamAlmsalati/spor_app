import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart'; // Import Pinput here
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:sport/views/auth/widgets/form_decoration.dart';
import 'package:sport/views/profile/widget/coustom_dialog.dart';
import 'package:sport/views/stadium/widget/coustom_appbar.dart';
import '../../../app/app_packges.dart';
import '../../../controller/forget_password/forget_password_cubit.dart';
import '../../../utilits/responsive.dart';
import '../widgets/coustom_button.dart';
import '../widgets/coustom_text_field.dart';
import 'otp_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: Responsive.screenWidth(context) * 0.04,
              right: Responsive.screenWidth(context) * 0.04,
            ),
            child: Column(
              children: [
                CoustomAppBr(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  logo: AppPhotot.arrowBack,
                  title: 'نسيت كلمة المرور',
                  color: Constants.mainColor,
                  height: Responsive.screenHeight(context) * 0.045,
                  width: Responsive.screenHeight(context) * 0.045,
                  isHomeScreen: false,
                ),
                SizedBox(height: Responsive.screenHeight(context) * 0.03),
                SvgPicture.asset(
                  AppPhotot.changePass,
                  height: Responsive.screenHeight(context) * 0.10,
                  width: Responsive.screenWidth(context) * 0.10,
                ),
                SizedBox(height: Responsive.screenHeight(context) * 0.03),
                Text(
                  'نسيت كلمة المرور',
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 24),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Responsive.screenHeight(context) * 0.04),
                BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
                  listener: (context, state) {
                    if (state is ForgetPasswordStep1Success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtpScreen(
                            usernameController: _usernameController,
                          ),
                        ),
                      );
                    } else if (state is ForgetPasswordStep2Success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewPasswordScreen(
                            usernameController: _usernameController,
                            otpController: TextEditingController(),
                            token: state.token,
                          ),
                        ),
                      );
                    } else if (state is ForgetPasswordStep3Success) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                            title: 'نجاح',
                            content: 'تم تغيير كلمة المرور بنجاح',
                            canceText: 'موافق',
                            confirmText: null,
                            color: Constants.mainColor,
                            borderColor: Constants.mainColor,
                            onCancel: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    } else if (state is ForgetPasswordFailure) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                            title: 'خطأ',
                            content: state.error,
                            canceText: 'الغاء',
                            confirmText: 'حاول مرة اخرى',
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onConfirm: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                  },
                  child: FormDecoration(
                    height: Responsive.screenHeight(context) * 0.43,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.screenWidth(context) * 0.05,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTextField(
                              labelSize: Responsive.textSize(context, 8),
                              hintSize: Responsive.textSize(context, 8),
                              controller: _usernameController,
                              labelText: "اسم المستخدم",
                              validatorText: "اسم المستخدم مطلوب",
                            ),
                            CustomButton(
                              text: 'إرسال الخطوة 1',
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ForgetPasswordCubit>().sendStep1(
                                    _usernameController.text,
                                  );
                                }
                              },
                              textSize: Responsive.textSize(context, 14),
                              fontWeight: FontWeight.w600,
                              color: Constants.mainColor,
                              textColor: Colors.white,
                              height: Responsive.screenHeight(context) * 0.048,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  final TextEditingController usernameController;

  const OtpScreen({super.key, required this.usernameController});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _otpFocusNode = FocusNode();
  late Timer _timer;
  int _start = 120; // Start from 2 minutes (120 seconds)

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordFailure) {
              CustomSnackBar.show(context, "خطأ في رمز التحقق");
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              top: Responsive.blockHeight(context) * 20,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppPhotot.rCamIcon,
                      height: Responsive.blockHeight(context) * 3,
                      width: Responsive.screenWidth(context) * 0.3,
                    ),
                    const Text(
                      "ادخل رمز التحقق",
                      style: TextStyle(
                        fontSize: 24,
                        color: Constants.mainColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SvgPicture.asset(
                      AppPhotot.lCamIcon,
                      height: Responsive.blockHeight(context) * 3,
                      width: Responsive.screenWidth(context) * 3,
                    ),
                  ],
                ),
                SizedBox(height: Responsive.blockHeight(context) * 1),
                Text(
                  "ادخل رمز التحقق ل اتمام عمليةانشاء\nالحساب",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Constants.thirdColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: Responsive.blockHeight(context) * 5),
                Pinput(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  length: 6,
                  showCursor: true,
                  onCompleted: (pin) {
                    context.read<ForgetPasswordCubit>().sendStep2(
                      widget.usernameController.text,
                      pin,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'رمز التحقق مطلوب';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Responsive.blockHeight(context) * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ارسال رمز جديد في "),
                    Text(
                      _formatTime(_start),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.mainColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // You can add a button to resend the OTP here
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class NewPasswordScreen extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController otpController;
  final String token;
  final TextEditingController newPasswordController = TextEditingController();

  NewPasswordScreen({
    Key? key,
    required this.usernameController,
    required this.otpController,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Password'),
      ),
      body: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordStep3Success) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Password changed successfully'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else if (state is ForgetPasswordFailure) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(state.error),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: otpController,
                decoration: InputDecoration(labelText: 'OTP'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<ForgetPasswordCubit>().sendStep3(usernameController.text,

                  );
                },
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}