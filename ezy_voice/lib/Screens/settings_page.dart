import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Auto-Speak Result"),
            value: settings.autoSpeak,
            onChanged: (v) => settings.toggleAutoSpeak(v),
          ),
          ListTile(
            title: const Text("Theme Mode"),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              onChanged: (m) => settings.setTheme(m!),
              items: const [
                DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
                DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
                DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}