import 'dart:async';
import 'dart:io';

import 'package:graphql/client.dart';

import '../../model/mainview_model_online.dart';

abstract class DomainServerApi {
  factory DomainServerApi() = _DomainServerImpl;
  Future<List<GraphQLModel>> readRepositories();
  void starRepository(String repositoryID);
  Future<String> removeStarFromRepository(String repositoryID);
}

class _DomainServerImpl implements DomainServerApi {
  GraphQLClient _getGithubGraphQLClient() => GraphQLClient(
        cache: GraphQLCache(),
        link: HttpLink(
          'https://graphql.anilist.co',
        ),
      );

  @override
  Future<List<GraphQLModel>> readRepositories() async {
    final Completer<List<GraphQLModel>> graphQLList = Completer();
    // try {
      final List<GraphQLModel> charactersList = [];
      final QueryResult result = await _getGithubGraphQLClient().query(
        QueryOptions(
          document: gql(
            r'''
            query Page {
              Page {
                pageInfo {
                  total
                  perPage
                }
                media {
                  id
                  title {
                    english
                    native
                  }
                  type
                  genres
                }
              }
            }
          ''',
          ),
        ),
      );
      if (result.data != null) {
        List<dynamic> _characters =
            result.data!['Page']['media'] as List<dynamic>;
        if (_characters.isNotEmpty) {
          _characters.forEach(
            (dynamic f) => charactersList.add(GraphQLModel(
                title: f['title']['english'].toString(),
                id: f['id'].toString(),
                type: f['type'].toString(),
                genres: f['genres'])),
          );

          graphQLList.complete(charactersList);
        } else {
          graphQLList.completeError(throw Exception("Results empty: ${result.exception?.linkException}"));
        }
      }
    // } catch (err, stack) {
    //   graphQLList.complete(throw Exception("${err}"));
    // }

    return graphQLList.future;
  }

  @override
  Future<String> removeStarFromRepository(String repositoryID) async {
    final Completer<String> graphQLResult = Completer();
    final GraphQLClient _client = _getGithubGraphQLClient();
    final QueryResult result = await _client.mutate(MutationOptions(
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
    ));

    if (result.hasException) {
      graphQLResult.complete(result.exception.toString());
    }

    final bool isStarrred =
        result.data!['action']['starrable']['viewerHasStarred'] as bool;
    if (!isStarrred) {
      graphQLResult.complete('Sorry you changed your mind!');
    }

    return graphQLResult.future;
  }

  @override
  void starRepository(String repositoryID) async {
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
