import 'package:flutter/material.dart';
import 'history_screen.dart';

/// Legacy adapter for HistoryTab, forwarding to the dedicated HistoryScreen.
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HistoryScreen();
  }
}

