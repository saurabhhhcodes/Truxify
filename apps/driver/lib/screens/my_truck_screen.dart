import 'package:flutter/material.dart';

class MyTruckScreen extends StatelessWidget {
  const MyTruckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Truck')),
      body: const Center(child: Text('My Truck details will appear here')),
    );
  }
}
