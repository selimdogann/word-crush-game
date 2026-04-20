import '../../core/constants/app_constants.dart';
import '../models/inventory_model.dart';
import '../models/joker.dart';
import '../services/preferences_service.dart';

class InventoryRepository {
  InventoryRepository(this._prefs);

  final PreferencesService _prefs;

  InventoryModel get current {
    final raw = _prefs.getString(AppConstants.prefInventory);
    if (raw == null || raw.isEmpty) return const InventoryModel();
    try {
      return InventoryModel.decode(raw);
    } catch (_) {
      return const InventoryModel();
    }
  }

  Future<InventoryModel> add(Joker joker) async {
    final updated = current.add(joker);
    await _prefs.setString(AppConstants.prefInventory, updated.encode());
    return updated;
  }

  Future<InventoryModel> consume(Joker joker) async {
    final updated = current.consume(joker);
    await _prefs.setString(AppConstants.prefInventory, updated.encode());
    return updated;
  }
}
