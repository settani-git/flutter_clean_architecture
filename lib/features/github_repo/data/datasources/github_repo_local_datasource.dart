import 'package:meta/meta.dart';
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

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class GithubRepoLocalDatasourceImpl implements GithubRepoLocalDatasource {
  final SharedPreferences sharedPreferences;

  GithubRepoLocalDatasourceImpl({
    @required this.sharedPreferences,
  });

  @override
  Future<void> cacheReposList(List<GithubRepoModel> repos) {
    return null;
  }

  @override
  Future<List<GithubRepoModel>> getLastCachedTrendingList() {
    return null;
  }
}
