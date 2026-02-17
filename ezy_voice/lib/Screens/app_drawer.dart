import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../res/AppColor.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false, // ❗ clear full stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColor.gradient,
            ),
            child: Center(
              child: Text(
                'EZY Voice',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.person, color: AppColor.pink),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.credit_card, color: AppColor.pink),
            title: const Text('Plans & Billing'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/plans');
            },
          ),

          ListTile(
            leading: const Icon(Icons.support_agent, color: AppColor.pink),
            title: const Text('Support'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/support');
            },
          ),

          ListTile(
            leading: const Icon(Icons.history, color: AppColor.pink),
            title: const Text('History'),
            onTap: () {
              Navigator.pushNamed(context, '/history');
            },
          ),

          const Spacer(),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _logout(context),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
