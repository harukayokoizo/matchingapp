import 'package:hive/hive.dart';

part 'hive_swipe.g.dart';

@HiveType(typeId: 2)
class Swipe extends HiveObject {
  @HiveField(0)
  List<String> uidList = [];//名前
  Swipe(this.uidList);
}

/// Boxを内包するクラス
/// Singletonやboxを開くのを非同期で待つのに使う
/// Boxのファイル名を間違えないようにするためにもこれを起点にアクセスすることとする
class RecordModelBox {
  Future<Box> box = Hive.openBox<Swipe>('swipeRecord');

  /// deleteFromDiskをした後はdatabaseが閉じてしまうため、もう一度開くための関数
  Future<void> open() async {
    Box b = await box;
    if (!b.isOpen) {
      box = Hive.openBox<Swipe>('swipeRecord');
    }
  }
}