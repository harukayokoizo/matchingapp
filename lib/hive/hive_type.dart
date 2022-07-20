import 'package:hive/hive.dart';

part 'hive_type.g.dart';

@HiveType(typeId: 1)
class MyType extends HiveObject {
  @HiveField(0)
  int type;
  MyType(this.type);
}

/// Boxを内包するクラス
/// Singletonやboxを開くのを非同期で待つのに使う
/// Boxのファイル名を間違えないようにするためにもこれを起点にアクセスすることとする
class RecordModelBox {
  Future<Box> box = Hive.openBox<MyType>('record');

  /// deleteFromDiskをした後はdatabaseが閉じてしまうため、もう一度開くための関数
  Future<void> open() async {
    Box b = await box;
    if (!b.isOpen) {
      box = Hive.openBox<MyType>('record');
    }
  }
}