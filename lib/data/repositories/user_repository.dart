import '../../core/constants/app_constants.dart';
import '../services/preferences_service.dart';

class UserRepository {
  UserRepository(this._prefs);

  final PreferencesService _prefs;

  String? getUsername() => _prefs.getString(AppConstants.prefUsername);

  Future<void> saveUsername(String username) async {
    await _prefs.setString(AppConstants.prefUsername, username.trim());
    if (!_prefs.hasKey(AppConstants.prefCoins)) {
      await _prefs.setInt(AppConstants.prefCoins, AppConstants.initialCoins);
    }
  }

  int getCoins() =>
      _prefs.getInt(AppConstants.prefCoins) ?? AppConstants.initialCoins;

  Future<void> setCoins(int value) =>
      _prefs.setInt(AppConstants.prefCoins, value < 0 ? 0 : value);

  bool hasUsername() {
    final name = getUsername();
    return name != null && name.isNotEmpty;
  }
}
