import 'package:flutter/material.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({super.key});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TimeSheet"),
      ),
    );
  }
}
