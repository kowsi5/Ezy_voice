import 'package:hive/hive.dart';
part 'history_item.g.dart';

@HiveType(typeId: 1)
class HistoryItem extends HiveObject {
  @HiveField(0)
  String inputText;

  @HiveField(1)
  String englishInput;

  @HiveField(2)
  String resultEnglish;

  @HiveField(3)
  String resultLocal;

  @HiveField(4)
  String lang;

  @HiveField(5)
  String timestamp;

  @HiveField(6, defaultValue: false)
  bool synced;

  HistoryItem({
  required this.inputText,
  required this.englishInput,
  required this.resultEnglish,
  required this.resultLocal,
  required this.lang,
  required this.timestamp,
  this.synced = false,
});

}
