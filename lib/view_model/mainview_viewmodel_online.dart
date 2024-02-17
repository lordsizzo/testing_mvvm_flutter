import 'package:flutter/material.dart';

import '../model/mainview_model_online.dart';
import '../repository/mainview_repository_online.dart';

class ServerViewModel extends ChangeNotifier {
  final _mainViewRepositoryOnlineApi = MainViewRepositoryOnlineApi();
  List<GraphQLModel> _graphQLList = [];
  List<GraphQLModel> get graphQLList => _graphQLList;

  void getRepositories() async {
    _graphQLList = await _mainViewRepositoryOnlineApi.getRepositories();
    notifyListeners();
  }
}