import 'package:flutter/material.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBasic(title: 'Bahasa'),
      body: const Center(child: Text('ini Bahasa page')),
    );
  }
}
