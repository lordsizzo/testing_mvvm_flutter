import 'dart:async';
import 'dart:io';

import 'package:graphql/client.dart';

import '../../model/mainview_model_online.dart';

abstract class DomainServerApi {
  factory DomainServerApi() = _DomainServerImpl;
  Future<List<GraphQLModel>>  readRepositories();
  void starRepository(String? repositoryID);
  void removeStarFromRepository(String? repositoryID);
}

class _DomainServerImpl implements DomainServerApi {

  GraphQLClient _getGithubGraphQLClient() => GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        'https://rickandmortyapi.com/graphql',
      ),
    );

  @override
  Future<List<GraphQLModel>> readRepositories() async {

    final Completer<List<GraphQLModel>> graphQLList = Completer();
    final List<GraphQLModel> charactersList = [];
    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        query {
          characters(page: 1) {
            results {
              name,
              id
            }
          }
        }
      ''',
      ),
    );
    final QueryResult result = await _getGithubGraphQLClient().query(options);
    final List<dynamic> characters = result.data!['characters']['results'] as List<dynamic>;
    characters.forEach((dynamic f) => charactersList.add(GraphQLModel(name: f['name'], id: f['id'])),
    );
    graphQLList.complete(charactersList);
    return graphQLList.future;
  }

  @override
  void removeStarFromRepository(String? repositoryID) async {
    if (repositoryID == '') {
      stderr.writeln('The ID of the Repository is Required!');
      exit(2);
    }

    final GraphQLClient _client = _getGithubGraphQLClient();

    final MutationOptions options = MutationOptions(
      document: gql(
        r'''
        mutation RemoveStar($starrableId: ID!) {
          action: removeStar(input: {starrableId: $starrableId}) {
            starrable {
              viewerHasStarred
            }
          }
        }
      ''',
      ),
      variables: <String, dynamic>{
        'starrableId': repositoryID,
      },
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      stderr.writeln(result.exception.toString());
      exit(2);
    }

    final bool isStarrred = result.data!['action']['starrable']['viewerHasStarred'] as bool;

    if (!isStarrred) {
      stdout.writeln('Sorry you changed your mind!');
    }

    exit(0);
  }

  @override
  void starRepository(String? repositoryID) async {
    if (repositoryID == '') {
      stderr.writeln('The ID of the Repository is Required!');
      exit(2);
    }

    final GraphQLClient _client = _getGithubGraphQLClient();

    final options = MutationOptions(
      document: gql(
        r'''
        mutation AddStar($starrableId: ID!) {
          action: addStar(input: {starrableId: $starrableId}) {
            starrable {
              viewerHasStarred
            }
          }
        }
      ''',
      ),
      variables: <String, dynamic>{
        'starrableId': repositoryID,
      },
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      stderr.writeln(result.exception.toString());
      exit(2);
    }

    final bool isStarrred =
    result.data!['action']['starrable']['viewerHasStarred'] as bool;

    if (isStarrred) {
      stdout.writeln('Thanks for your star!');
    }

    exit(0);
  }
}