import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  final String screenName;
  const ComingSoon({required this.screenName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(screenName)),
      body: Center(
        child: Text("$screenName is comming soon.."),
      ),
    );
  }
}
