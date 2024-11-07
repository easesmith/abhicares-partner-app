import 'package:flutter/material.dart';

class paymentScreen extends StatefulWidget {
  const paymentScreen({super.key});

  @override
  State<paymentScreen> createState() => _paymentScreenState();
}

class _paymentScreenState extends State<paymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payments"),
      ),
    );
  }
}
