import '../../../app/app_packges.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
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
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
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
              SizedBox(
                height: Responsive.blockHeight(context) * 1,
              ),
              Text(
                "ادخل رمز التحقق ل اتمام عمليةانشاء\nالحساب",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Constants.thirdColor.withOpacity(0.6),
                ),
              ),
              SizedBox(
                height: Responsive.blockHeight(context) * 5,
              ),
              Pinput(
                controller: _pinPutController,
                focusNode: _pinPutFocusNode,
                length: 6,
                onChanged: (pin) {
                  // Handle pin change
                },
                onCompleted: (pin) {
                  // Handle pin completion
                },
                defaultPinTheme: PinTheme(
                  width: 44,
                  height: 44,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Constants.mainColor,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(

                    border: Border.all(
                      color: Constants.thirdColor,
                      width: 2, // Set the border width to 2
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Responsive.blockHeight(context) * 5,
              ),
              Text(
                _formatTime(_start),
                style: const TextStyle(
                  fontSize: 14,
                  color: Constants.thirdColor,
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    "اعادة ارسال الرمز",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Constants.thirdColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
