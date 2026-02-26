import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/usage_provider.dart';
import '../res/AppColor.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usage = Provider.of<UsageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white, iconTheme: IconThemeData(color: Colors.black)),
      drawer: Drawer(), // Your AppDrawer
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome to EZY Voice,", style: TextStyle(fontSize: 16, color: Colors.grey)),
              const Text("Calculate with Ease", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),

              // 1. Dashboard Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColor.deepPurple, Colors.deepPurpleAccent]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text("\"Math is the language of the universe.\"", style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColor.deepPurple, shape: StadiumBorder()),
                      onPressed: () => _handleMicAccess(context, usage),
                      icon: const Icon(Icons.mic),
                      label: const Text("Start Voice Mode"),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Text("Math Instructions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // 2. Instructions Grid
              _buildInstructionTile("Basic", "Say '5 plus 10' or '20 minus 5'"),
              _buildInstructionTile("Regional", "Say 'ஐந்து கூட்டல் பத்து' (Tamil)"),
              _buildInstructionTile("Complex", "Say '100 divided by 4 times 2'"),

              const SizedBox(height: 30),
              
              // 3. Usage Indicator
              if (!usage.isPremium)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.amber)),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.amber),
                    const SizedBox(width: 10),
                    Text("Daily Free Limit: ${usage.remaining} left today", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMicAccess(BuildContext context, UsageProvider usage) {
    // 1. Check Login
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }
    // 2. Check Daily Limit
    if (!usage.isPremium && usage.dailyUsage >= usage.maxFreeLimit) {
      Navigator.pushNamed(context, '/plans');
    } else {
      Navigator.pushNamed(context, '/voice_mode');
    }
  }

  Widget _buildInstructionTile(String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: AppColor.pink.withOpacity(0.1), child: Icon(Icons.lightbulb, color: AppColor.pink, size: 20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
      ),
    );
  }
}