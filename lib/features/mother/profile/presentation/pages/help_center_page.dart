import 'package:flutter/material.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBasic(title: 'Pusat Bantuan'),
      body: const Center(child: Text('ini Pusat Bantuan page')),
    );
  }
}
