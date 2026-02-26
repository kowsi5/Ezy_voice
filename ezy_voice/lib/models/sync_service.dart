import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/history_item.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final String baseUrl = "https://voicecalc-uc7u.onrender.com"; // your backend
  late Box<HistoryItem> box;

  Future<void> init() async {
    box = Hive.box<HistoryItem>('history');
  }

  Future<void> syncAllUnsynced() async {
    for (var key in box.keys) {
      HistoryItem item = box.get(key)!;

      if (!item.synced) {
        bool ok = await _sendToBackend(item);
        if (ok) {
          item.synced = true;
          item.save();
        }
      }
    }
  }

  Future<bool> _sendToBackend(HistoryItem item) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/save_history"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "inputText": item.inputText,
          "englishInput": item.englishInput,
          "resultEnglish": item.resultEnglish,
          "resultLocal": item.resultLocal,
          "lang": item.lang,
          "timestamp": item.timestamp,
        }),
      );

      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> syncNow() async {
    await syncAllUnsynced();
  }
}
