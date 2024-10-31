import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/app_packges.dart';
import '../../controller/recharge_balance/recharge_balance_cubit.dart';
import '../../utilits/permissions.dart';
import '../../utilits/constants.dart';
import '../../utilits/responsive.dart';
import '../auth/widgets/coustom_button.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = false;
  StreamSubscription? scanSubscription;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<RechargeCubit, RechargeState>(
          listener: (context, state) {
            if (state is RechargeSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تمت عملية الشحن بنجاح')),
              );
              _stopScanning();
            } else if (state is RechargeFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('خطأ في الرقم السري')),
              );
              _resumeScanning();
            } else if (state is RechargeSocketExceptionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('لا يوجد اتصال بالانترنت')),
              );
              _resumeScanning();
            }
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(Responsive.screenHeight(context) * 0.02),
                child: Column(
                  children: [
                    SizedBox(height: Responsive.screenHeight(context) * 0.01),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Constants.txtColor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Column(
                          children: [
                            Text(
                              'مسح رمز الاستجابة السريعة',
                              style: TextStyle(
                                fontSize: Responsive.textSize(context, 16),
                                fontWeight: FontWeight.bold,
                                color: Constants.txtColor,
                                fontFamily: GoogleFonts.cairo().fontFamily,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: Responsive.screenHeight(context) * 0.01),
                            Text(
                              'يرجى توجيه الكاميرا نحو رمز الاستجابة السريعة لمسحه',
                              style: TextStyle(
                                fontSize: Responsive.textSize(context, 12),
                                color: Constants.txtColor,
                                fontFamily: GoogleFonts.cairo().fontFamily,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Constants.mainColor,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Responsive.screenHeight(context) * 0.02),
                child: Column(
                  children: [
                    CustomButton(
                      text: 'مسح الرمز',
                      hasBorder: true,
                      borderColor: Constants.mainColor,
                      onPress: _startScanning,
                      color: Colors.white,
                      textColor: Constants.mainColor,
                      brWidth: 3,
                      textSize: Responsive.textSize(context, 12),
                      height: Responsive.screenHeight(context) * 0.053,
                      width: double.infinity,
                    ),
                    SizedBox(height: Responsive.screenHeight(context) * 0.02),
                    CustomButton(
                      text: 'إدخال الرمز يدوياً',
                      onPress: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                      },
                      color: Constants.mainColor,
                      textColor: Colors.white,
                      textSize: Responsive.textSize(context, 12),
                      height: Responsive.screenHeight(context) * 0.053,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.pauseCamera();
  }

  void _startScanning() {
    if (!isScanning) {
      setState(() {
        isScanning = true;
      });
      controller?.resumeCamera();
      scanSubscription = controller?.scannedDataStream.listen((scanData) {
        if (scanData.code != null) {
          context.read<RechargeCubit>().rechargeCard(scanData.code!, context);
          controller?.pauseCamera();
          scanSubscription?.cancel();
        }
      });
    }
  }

  void _stopScanning() {
    setState(() {
      isScanning = false;
    });
    controller?.pauseCamera();
    scanSubscription?.cancel();
  }

  void _resumeScanning() {
    setState(() {
      isScanning = true;
    });
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    scanSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await checkCameraPermission();
  }
}