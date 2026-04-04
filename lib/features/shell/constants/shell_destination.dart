
import 'package:flutter/material.dart';

enum ShellDestination {
  home('Home', Icons.home_outlined, Icons.home_rounded),
  transactions(
    'Transactions',
    Icons.receipt_long_outlined,
    Icons.receipt_long_rounded,
  ),
  goals('Goals', Icons.flag_outlined, Icons.flag_rounded),
  insights('Insights', Icons.insights_outlined, Icons.insights_rounded),
  settings('Settings', Icons.settings_outlined, Icons.settings_rounded);

  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const ShellDestination(this.label, this.icon, this.selectedIcon);
}