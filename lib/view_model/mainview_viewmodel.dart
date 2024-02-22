import 'package:flutter/material.dart';

import '../model/mainview_model.dart';
import '../repository/mainview_repository.dart';


// StateNotifier<String>

class CounterViewModel extends ChangeNotifier {
  final _mainViewRepositoryApi = MainViewRepositoryApi();
  String _count = "";
  String get count => _count;

  void increment(Counter countValue) {
    _count = _mainViewRepositoryApi.returningAnInt(countValue);
    notifyListeners();
  }
}