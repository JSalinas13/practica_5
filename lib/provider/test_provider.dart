import 'package:flutter/material.dart';

class TestProvider extends ChangeNotifier {
  String _name = 'Jesus Trinidad Salinas León';

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }
}
