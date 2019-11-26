import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:remote_mobile/core/error/exceptions.dart';
import 'package:remote_mobile/features/github_repo/data/models/github_repo_model.dart';

abstract class GithubRepoRemoteDatasource {
  /// Calls the https://api.github.com/search/repositories?q=created:>2017-10-22&sort=stars&order=desc
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<GithubRepoModel>> getTrendingGithubRepos();
}

// Since it's a small repository we put the implementation in same file as the contract
class GithubRepoRemoteDatasourceImpl implements GithubRepoRemoteDatasource {
  static const String ReposApiEndpoint =
      "https://api.github.com/search/repositories";
  final http.Client client;

  GithubRepoRemoteDatasourceImpl({
    @required this.client,
  });

  @override
  Future<List<GithubRepoModel>> getTrendingGithubRepos() async {
    String params = '?q=created:>2017-10-22&sort=stars&order=desc';
    String url = ReposApiEndpoint + params;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await client.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<GithubRepoModel> repos = [];
      String responseBody = response.body;
      List<dynamic> responseArray = json.decode(responseBody);
      responseArray.forEach((value) {
        repos.add(GithubRepoModel.fromJson(value));
      });
      return repos;
    } else {
      throw ServerException();
    }
  }
}
