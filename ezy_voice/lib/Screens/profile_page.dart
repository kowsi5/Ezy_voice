import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../res/AppColor.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(radius: 50, backgroundColor: AppColor.violet, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 20),
            Text(user?.email ?? "Guest User", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Joined: ${user?.metadata.creationTime.toString().split(' ')[0] ?? 'N/A'}"),
            const Divider(height: 40),
            ListTile(leading: const Icon(Icons.workspace_premium, color: Colors.amber), title: const Text("Current Plan: Free")),
          ],
        ),
      ),
    );
  }
}