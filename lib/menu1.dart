
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  final int initialSelectedIndex;
  final int initialSelectedCategoryIndex;

  const MenuScreen({
    super.key,
    this.initialSelectedIndex = 0,
    this.initialSelectedCategoryIndex = -1,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: Center(
        child: Text("welcome"),
      ),
    );
  }
}