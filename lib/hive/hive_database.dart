import 'package:hive/hive.dart';

part 'hive_database.g.dart';

@HiveType(typeId: 0)
class Person extends HiveObject {
  @HiveField(0)
  String name;//名前
  @HiveField(1)
  String age;//年齢
  @HiveField(2)
  String greet;//あいさつ
  @HiveField(3)
  int sex;//性別
  Person(this.name, this.age, this.greet, this.sex);
}

/// Boxを内包するクラス
/// Singletonやboxを開くのを非同期で待つのに使う
/// Boxのファイル名を間違えないようにするためにもこれを起点にアクセスすることとする
class RecordModelBox {
  Future<Box> box = Hive.openBox<Person>('personRecord');

  /// deleteFromDiskをした後はdatabaseが閉じてしまうため、もう一度開くための関数
  Future<void> open() async {
    Box b = await box;
    if (!b.isOpen) {
      box = Hive.openBox<Person>('personRecord');
    }
  }
}