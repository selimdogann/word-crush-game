import 'package:flutter/foundation.dart';
import '../../../data/models/inventory_model.dart';
import '../../../data/models/joker.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/repositories/user_repository.dart';

class MarketViewModel extends ChangeNotifier {
  MarketViewModel({
    required UserRepository userRepo,
    required InventoryRepository inventoryRepo,
  })  : _userRepo = userRepo,
        _inventory = inventoryRepo {
    _refresh();
  }

  final UserRepository _userRepo;
  final InventoryRepository _inventory;

  int _coins = 0;
  InventoryModel _inventoryModel = const InventoryModel();
  String? _lastMessage;

  int get coins => _coins;
  InventoryModel get inventory => _inventoryModel;
  String? get lastMessage => _lastMessage;

  void _refresh() {
    _coins = _userRepo.getCoins();
    _inventoryModel = _inventory.current;
    notifyListeners();
  }

  Future<bool> buy(Joker joker) async {
    if (_coins < joker.price) {
      _lastMessage = 'Yeterli coin yok (${joker.price} gerekli)';
      notifyListeners();
      return false;
    }
    final remaining = _coins - joker.price;
    await _userRepo.setCoins(remaining);
    _inventoryModel = await _inventory.add(joker);
    _coins = remaining;
    _lastMessage = '${joker.label} satin alindi';
    notifyListeners();
    return true;
  }

  void clearMessage() {
    if (_lastMessage == null) return;
    _lastMessage = null;
    notifyListeners();
  }
}
