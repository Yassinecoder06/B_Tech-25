import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardCoinsProvider with ChangeNotifier {
  int _coins = 0;

  int get coins => _coins;

  RewardCoinsProvider() {
    fetchCoins();
  }

  void setCoins(int coins) {
    _coins = coins;
    notifyListeners();
  }

  Future<void> fetchCoins() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      _coins = userSnap.data()!['coins'];
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> spendCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      notifyListeners();
      await updateCoinsInDatabase();
    }
  }

  Future<void> addCoins(int amount) async {
    _coins += amount;
    notifyListeners();
    await updateCoinsInDatabase();
  }

  Future<void> updateCoinsInDatabase() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'coins': _coins});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addPurchasedItem(String itemName, String itemType, int cost) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('purchases')
          .add({
        'itemName': itemName,
        'itemType': itemType,
        'cost': cost,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}