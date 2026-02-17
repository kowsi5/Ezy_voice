import 'package:flutter/material.dart';
import '../res/AppColor.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Membership Plans")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPlanCard("Go", "₹149 - month", Icons.star_border, 
                ["Basic voice calculations", "Up to 100 per day", "Voice input access", "Community support"]),
            _buildPlanCard("Pro", "₹499 - 6 months", Icons.rocket_launch_outlined, 
                ["Unlimited calculations", "AI precision mode", "Voice feedback", "Priority email support"]),
            _buildPlanCard("Plus", "₹899 - year", Icons.workspace_premium_outlined, 
                ["AI-powered insights", "Faster response speed", "History sync", "Feature previews"]),
            _buildPlanCard("Elite", "₹1999 - lifetime", Icons.all_inclusive, 
                ["Lifetime access", "Offline mode", "Personal assistant", "24/7 premium support"]),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String price, IconData icon, List<String> features) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColor.pink),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(price, style: const TextStyle(fontSize: 18, color: AppColor.pink, fontWeight: FontWeight.bold)),
            const Divider(),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [const Icon(Icons.check_circle, size: 18, color: Colors.green), const SizedBox(width: 10), Text(f)]),
            )),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.deepPurple, shape: StadiumBorder()),
              onPressed: () {}, 
              child: const Text("Choose Plan", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}