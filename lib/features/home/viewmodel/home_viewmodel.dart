import 'package:flutter/foundation.dart';
import '../../../data/repositories/user_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repo) {
    _load();
  }

  final UserRepository _repo;

  String _username = '';
  int _coins = 0;

  String get username => _username;
  int get coins => _coins;

  void _load() {
    _username = _repo.getUsername() ?? 'Oyuncu';
    _coins = _repo.getCoins();
    notifyListeners();
  }

  void refresh() => _load();
}
