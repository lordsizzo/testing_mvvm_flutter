import '../domain/server/domain_server.dart';
import '../model/mainview_model.dart';
import '../model/mainview_model_online.dart';

abstract class MainViewRepositoryOnlineApi {
  factory MainViewRepositoryOnlineApi() = _MainViewRepositoryOnlineImpl;
  Future<List<GraphQLModel>> getRepositories();
}

class _MainViewRepositoryOnlineImpl implements MainViewRepositoryOnlineApi {
  final domainServerApi = DomainServerApi();
  @override
  Future<List<GraphQLModel>> getRepositories() => domainServerApi.readRepositories();
}