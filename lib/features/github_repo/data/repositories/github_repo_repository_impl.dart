import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:remote_mobile/core/error/exceptions.dart';
import 'package:remote_mobile/core/error/failures.dart';
import 'package:remote_mobile/core/network/network_info.dart';
import 'package:remote_mobile/features/github_repo/data/datasources/github_repo_local_datasource.dart';
import 'package:remote_mobile/features/github_repo/data/datasources/github_repo_remote_datasource.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';
import 'package:remote_mobile/features/github_repo/domain/repositories/github_repo_repository.dart';

class GithubRepoRepositoryImpl implements GithubRepoRepository {
  final GithubRepoRemoteDatasource remoteDataSource;
  final GithubRepoLocalDatasource localDataSource;
  final NetworkInfo networkInfo;

  GithubRepoRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GithubRepo>>> getTrendingRepos() async {
    if (await networkInfo.isConnected) {
      try {
        final repos = await remoteDataSource.getTrendingGithubRepos();
        localDataSource.cacheReposList(repos);
        return Right(repos);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localRepos = await localDataSource.getLastCachedTrendingList();
        return Right(localRepos);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
