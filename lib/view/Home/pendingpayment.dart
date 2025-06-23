import 'package:flutter/material.dart';

class Pendingpayment extends StatelessWidget {
  const Pendingpayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pending_actions, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Your payment is pending.',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please wait for confirmation.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
