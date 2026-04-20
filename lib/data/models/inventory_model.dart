import 'dart:convert';
import 'joker.dart';

class InventoryModel {
  final Map<Joker, int> counts;

  const InventoryModel({this.counts = const {}});

  int countOf(Joker j) => counts[j] ?? 0;

  InventoryModel add(Joker joker, {int amount = 1}) {
    final updated = Map<Joker, int>.from(counts);
    updated[joker] = (updated[joker] ?? 0) + amount;
    return InventoryModel(counts: updated);
  }

  InventoryModel consume(Joker joker) {
    final current = counts[joker] ?? 0;
    if (current <= 0) return this;
    final updated = Map<Joker, int>.from(counts);
    if (current - 1 == 0) {
      updated.remove(joker);
    } else {
      updated[joker] = current - 1;
    }
    return InventoryModel(counts: updated);
  }

  String encode() {
    final map = <String, int>{};
    counts.forEach((k, v) => map[k.id] = v);
    return jsonEncode(map);
  }

  static InventoryModel decode(String raw) {
    if (raw.isEmpty) return const InventoryModel();
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final counts = <Joker, int>{};
    map.forEach((key, value) {
      final j = Joker.byId(key);
      if (j != null) counts[j] = value as int;
    });
    return InventoryModel(counts: counts);
  }
}
