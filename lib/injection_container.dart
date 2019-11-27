import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:remote_mobile/features/github_repo/domain/usecases/get_trending_repos_usecase.dart';
import 'package:remote_mobile/features/github_repo/presentation/bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'features/github_repo/data/datasources/github_repo_local_datasource.dart';
import 'features/github_repo/data/datasources/github_repo_remote_datasource.dart';
import 'features/github_repo/data/repositories/github_repo_repository_impl.dart';
import 'features/github_repo/domain/repositories/github_repo_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Trending Repos
  // Bloc
  // -> GithubRepo
  sl.registerFactory(
    () => GithubRepoBloc(
      getTrendingRepos: sl(),
    ),
  );

  /// Use cases
  // -> User use cases
  sl.registerLazySingleton(() => GetTrendingRepos(repository: sl()));

  /// Repositories
  sl.registerLazySingleton<GithubRepoRepository>(
    () => GithubRepoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  /// Data sources
  // -> GithubRepo datasource
  sl.registerLazySingleton<GithubRepoRemoteDatasource>(
    () => GithubRepoRemoteDatasourceImpl(client: sl()),
  );
  sl.registerLazySingleton<GithubRepoLocalDatasource>(
    () => GithubRepoLocalDatasourceImpl(sharedPreferences: sl()),
  );

  ///! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  ///! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
