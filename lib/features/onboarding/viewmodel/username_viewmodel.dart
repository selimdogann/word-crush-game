import 'package:flutter/foundation.dart';
import '../../../data/repositories/user_repository.dart';

class UsernameViewModel extends ChangeNotifier {
  UsernameViewModel(this._repo);

  final UserRepository _repo;

  String _input = '';
  String? _error;
  bool _loading = false;

  String get input => _input;
  String? get error => _error;
  bool get loading => _loading;
  bool get canSubmit => _input.trim().length >= 2 && !_loading;

  void onChanged(String value) {
    _input = value;
    if (_error != null) _error = null;
    notifyListeners();
  }

  String? validate() {
    final v = _input.trim();
    if (v.length < 2) return 'Kullanici adi en az 2 karakter olmali';
    if (v.length > 20) return 'Kullanici adi en fazla 20 karakter olabilir';
    if (!RegExp(r'^[a-zA-Z0-9ğĞüÜşŞıİöÖçÇ _.-]+$').hasMatch(v)) {
      return 'Sadece harf, rakam ve . _ - kullanabilirsin';
    }
    return null;
  }

  Future<bool> submit() async {
    final err = validate();
    if (err != null) {
      _error = err;
      notifyListeners();
      return false;
    }
    _loading = true;
    notifyListeners();
    await _repo.saveUsername(_input);
    _loading = false;
    notifyListeners();
    return true;
  }
}
