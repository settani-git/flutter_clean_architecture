import 'package:dartz/dartz.dart';
import 'package:remote_mobile/core/error/failures.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';

abstract class GithubRepoRepository {
  Future<Either<Failure, List<GithubRepo>>> getTrendingRepos();
}
