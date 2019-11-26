import 'package:meta/meta.dart';
import 'package:remote_mobile/core/error/exceptions.dart';
import 'dart:convert';
import 'package:remote_mobile/features/github_repo/data/models/github_repo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GithubRepoLocalDatasource {
  /// Gets the cached list of [GithubRepoModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<GithubRepoModel>> getLastCachedTrendingList();

  Future<void> cacheReposList(List<GithubRepoModel> repos);
}

const CACHED_REPOS = 'CACHED_REPOS';

class GithubRepoLocalDatasourceImpl implements GithubRepoLocalDatasource {
  final SharedPreferences sharedPreferences;

  GithubRepoLocalDatasourceImpl({
    @required this.sharedPreferences,
  });

  @override
  Future<void> cacheReposList(List<GithubRepoModel> repos) {
    List<Map<String, dynamic>> jsonMaps = [];
    repos.forEach((repo) {
      jsonMaps.add(repo.toJson());
    });
    return sharedPreferences.setString(
      CACHED_REPOS,
      json.encode(jsonMaps),
    );
  }

  @override
  Future<List<GithubRepoModel>> getLastCachedTrendingList() {
    final jsonString = sharedPreferences.getString(CACHED_REPOS);
    if (jsonString != null) {
      List<GithubRepoModel> repos = [];
      List<dynamic> items = json.decode(jsonString);
      items.forEach((item) {
        repos.add(GithubRepoModel.fromJson(item));
      });
      return Future.value(repos);
    } else {
      throw CacheException();
    }
  }
}
