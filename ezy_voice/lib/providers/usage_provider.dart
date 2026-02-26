import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsageProvider with ChangeNotifier {
  int _dailyUsage = 0;
  bool _isPremium = false;
  final int maxFreeLimit = 7;

  final Box _box = Hive.box('usageBox');

  int get dailyUsage => _dailyUsage;
  bool get isPremium => _isPremium;
  int get remaining => maxFreeLimit - _dailyUsage;

  UsageProvider() {
    _initUsage();
  }

  Future<void> _initUsage() async {
    String? lastDate = _box.get('lastDate');
    String today = DateTime.now().toString().split(' ')[0];

    if (lastDate != today) {
      // New day → reset usage
      _dailyUsage = 0;
      await _box.put('dailyUsage', 0);
      await _box.put('lastDate', today);
    } else {
      _dailyUsage = _box.get('dailyUsage', defaultValue: 0);
    }
    notifyListeners();
  }

  Future<void> incrementUsage() async {
    if (!_isPremium) {
      _dailyUsage++;
      await _box.put('dailyUsage', _dailyUsage);
      notifyListeners();
    }
  }

  void setPremium(bool status) {
    _isPremium = status;
    notifyListeners();
  }
}