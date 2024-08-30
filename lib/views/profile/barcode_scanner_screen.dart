import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/recharge_balance/recharge_balance_cubit.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

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
      appBar: AppBar(
        title: Text(
          'تعبية الرصيد',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<RechargeCubit, RechargeState>(
        listener: (context, state) {
          if (state is RechargeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت عملية الشحن بنجاح')),
            );
          } else if (state is RechargeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('خطأ في الرقم السري')),
            );
          } else if (state is RechargeSocketExceptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('لا يوجد اتصال بالانترنت')),
            );
          }
        },
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300.0,
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Center(
                child: Text('Scan a code'),
              ),
            ),
          ],
        ),
      ),
    );
  }

void _onQRViewCreated(QRViewController controller) {
  setState(() {
    this.controller = controller;
  });

  controller.scannedDataStream.listen((scanData) {
    if (scanData.code != null) {
      context.read<RechargeCubit>().rechargeCard(scanData.code!, context);
    }
  });
}

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}