import 'package:flutter/material.dart';

class ShopApproveSuccess extends StatelessWidget {
  const ShopApproveSuccess({super.key, required this.message});
  final String message;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80.0,
            ),
            SizedBox(height: 16.0),
            Text(
              message,
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
               Navigator.pushNamedAndRemoveUntil(context, '/admin_dashboard', (route) => false);

              },
              child: Text('Continue'),
            ),
          ],
        ),
    ),
    );
  }
}