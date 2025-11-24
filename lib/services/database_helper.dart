import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utspam_b_0030_film/models/user.dart';
import 'package:utspam_b_0030_film/models/transaction.dart';

class StorageService {
  static Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userStrings = users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('users', userStrings);
  }

  static Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? userStrings = prefs.getStringList('users');
    if (userStrings == null) return [];
    return userStrings.map((str) => User.fromJson(jsonDecode(str))).toList();
  }

  static Future<void> saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', jsonEncode(user.toJson()));
  }

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('currentUser');
    if (userString == null) return null;
    return User.fromJson(jsonDecode(userString));
  }

  static Future<void> removeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }

  static Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactionStrings = transactions.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList('transactions', transactionStrings);
  }

  static Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? transactionStrings = prefs.getStringList('transactions');
    if (transactionStrings == null) return [];
    return transactionStrings.map((str) => Transaction.fromJson(jsonDecode(str))).toList();
  }
}