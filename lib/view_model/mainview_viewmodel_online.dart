import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/mainview_model_online.dart';
import '../repository/mainview_repository_online.dart';

final apiServiceProvider = Provider<ServerViewModel>((ref) => ServerViewModel());

class ServerViewModel {
  final _mainViewRepositoryOnlineApi = MainViewRepositoryOnlineApi();
  Future<List<GraphQLModel>> getRepositories() async => await _mainViewRepositoryOnlineApi.getRepositories();
}