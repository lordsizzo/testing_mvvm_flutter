import 'package:flutter/material.dart';

import '../model/mainview_model.dart';
import '../repository/mainview_repository.dart';

class PersonViewModel extends ChangeNotifier {
  final _mainViewRepositoryApi = MainViewRepositoryApi();
  String _count = "";
  String get count => _count;

  void increment(Counter count) {
    _count = _mainViewRepositoryApi.returningAnInt(count);
    notifyListeners();
  }
}