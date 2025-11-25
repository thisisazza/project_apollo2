import 'package:flutter/material.dart';

class EconomyRepository extends ChangeNotifier {
  // Singleton
  static final EconomyRepository _instance = EconomyRepository._internal();
  factory EconomyRepository() => _instance;
  EconomyRepository._internal();

  int _credits = 500; // Starting bonus
  bool _isPremium = false;

  int get credits => _credits;
  bool get isPremium => _isPremium;

  void addCredits(int amount) {
    _credits += amount;
    notifyListeners();
  }

  bool spendCredits(int amount) {
    if (_credits >= amount) {
      _credits -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setPremium(bool status) {
    _isPremium = status;
    notifyListeners();
  }
}
