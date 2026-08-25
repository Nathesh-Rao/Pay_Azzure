import 'package:flutter/material.dart';

class OfflineNoUserPage extends StatelessWidget {
  const OfflineNoUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "You are offline",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Please connect to the internet and login at least once to use the app offline.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
