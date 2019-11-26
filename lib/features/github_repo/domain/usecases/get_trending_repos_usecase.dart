import 'package:dartz/dartz.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';
import 'package:remote_mobile/features/github_repo/domain/repositories/github_repo_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetTrendingRepos implements UseCase<List<GithubRepo>, NoParams> {
  final GithubRepoRepository repository;

  GetTrendingRepos({
    this.repository,
  });

  @override
  Future<Either<Failure, List<GithubRepo>>> call(NoParams noParams) async {
    return await repository.getTrendingRepos();
  }
}
