import 'package:flutter/material.dart';
import '../res/AppColor.dart';
import 'app_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Dashboard"), backgroundColor: Colors.white, foregroundColor: AppColor.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello, User!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Ready to calculate with your voice?", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            _buildQuickStartCard(context, "Voice Calculator", "Speak your math expressions", Icons.mic, () => Navigator.pushNamed(context, '/home')),
            _buildQuickStartCard(context, "Recent History", "Check your past totals", Icons.history, () => Navigator.pushNamed(context, '/history')),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStartCard(BuildContext context, String title, String sub, IconData icon, VoidCallback tap) {
    return Card(
      elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(backgroundColor: AppColor.pink, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: tap,
      ),
    );
  }
}