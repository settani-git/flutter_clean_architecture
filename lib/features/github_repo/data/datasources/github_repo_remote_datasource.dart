import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:remote_mobile/features/github_repo/data/models/github_repo_model.dart';

abstract class GithubRepoRemoteDatasource {
  /// Calls the https://api.github.com/search/repositories?q=created:>2017-10-22&sort=stars&order=desc
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<GithubRepoModel>> getTrendingGithubRepos();
}

// Since it's a small repository we put the implementation in same file as the contract
class GithubRepoRemoteDatasourceImpl implements GithubRepoRemoteDatasource {
  static const String ReposApiEndpoint = "https://api.github.com/search/repositories";
  final http.Client client;

  GithubRepoRemoteDatasourceImpl({
    @required this.client,
  });

  @override
  Future<List<GithubRepoModel>> getTrendingGithubRepos() {
    return null;
  }
}