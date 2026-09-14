import 'package:flutter/material.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBasic(title: 'Syarat & Ketentuan'),
      body: const Center(child: Text('ini Syarat & Ketentuan page')),
    );
  }
}
