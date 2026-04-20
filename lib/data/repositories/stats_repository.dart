import '../../core/constants/app_constants.dart';
import '../models/stats_model.dart';
import '../services/preferences_service.dart';

class StatsRepository {
  StatsRepository(this._prefs);

  final PreferencesService _prefs;

  StatsModel getStats() {
    final raw = _prefs.getString(AppConstants.prefStats);
    if (raw == null || raw.isEmpty) return const StatsModel();
    try {
      return StatsModel.decode(raw);
    } catch (_) {
      return const StatsModel();
    }
  }

  Future<StatsModel> recordGame(GameResult result) async {
    final updated = getStats().mergedWith(result);
    await _prefs.setString(AppConstants.prefStats, updated.encode());
    return updated;
  }
}
