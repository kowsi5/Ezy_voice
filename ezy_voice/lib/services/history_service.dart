import 'package:hive/hive.dart';
import '../models/history_item.dart';

class HistoryService {
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();

  final Box<HistoryItem> box = Hive.box<HistoryItem>('history');

  Future<void> add(HistoryItem item) async => await box.add(item);

  List<HistoryItem> getAll() => box.values.toList().reversed.toList();

  Future<void> clearAll() async => await box.clear();

  Future<void> deleteAt(int index) async {
    final keys = box.keys.toList();         // original order
    final reversedKeys = keys.reversed.toList();
    final key = reversedKeys[index];        // actual key in reversed view
    await box.delete(key);
  }
  Future<void> deleteKey(dynamic key) async {
    await box.delete(key);
  }
}
