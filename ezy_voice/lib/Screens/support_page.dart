import 'package:flutter/material.dart';
import '../res/AppColor.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Connect. Collaborate. Create.", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _infoTile(Icons.email, "Email", "contact@ezyvoicecalc.com"),
            _infoTile(Icons.phone, "Phone", "+91 98765 43210"),
            _infoTile(Icons.location_on, "Location", "Salem, Tamil Nadu, India"),
            const Spacer(),
            TextField(decoration: InputDecoration(hintText: "Your Message", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.deepPurple, padding: const EdgeInsets.all(15)),
              onPressed: () {}, 
              child: const Text("Send Message", style: TextStyle(color: Colors.white)),
            )),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String sub) {
    return ListTile(
      leading: Icon(icon, color: AppColor.pink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(sub),
    );
  }
}