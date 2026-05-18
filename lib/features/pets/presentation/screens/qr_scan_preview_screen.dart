import 'package:flutter/material.dart';

import '../../../../shared/models/pet.dart';
import 'secure_qr_scan_screen.dart';

class QrScanPreviewScreen extends StatelessWidget {
  const QrScanPreviewScreen({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return SecureQrScanScreen(qrId: pet.qrCodeLabel, initialPet: pet);
  }
}
