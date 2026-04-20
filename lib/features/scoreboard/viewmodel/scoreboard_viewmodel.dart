import 'package:flutter/foundation.dart';
import '../../../data/models/stats_model.dart';
import '../../../data/repositories/stats_repository.dart';

class ScoreboardViewModel extends ChangeNotifier {
  ScoreboardViewModel(this._repo) {
    _load();
  }

  final StatsRepository _repo;
  StatsModel _stats = const StatsModel();

  StatsModel get stats => _stats;

  void _load() {
    _stats = _repo.getStats();
    notifyListeners();
  }

  void refresh() => _load();
}
