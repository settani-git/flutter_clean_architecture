import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:remote_mobile/core/error/failures.dart';
import 'package:remote_mobile/core/usecases/usecase.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';
import 'package:remote_mobile/features/github_repo/domain/usecases/get_trending_repos_usecase.dart';
import './bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class GithubRepoBloc extends Bloc<GithubRepoEvent, GithubRepoState> {
  final GetTrendingRepos getTrendingRepos;

  GithubRepoBloc({
    @required GetTrendingRepos getTrendingRepos,
  })  : assert(getTrendingRepos != null),
        getTrendingRepos = getTrendingRepos;

  @override
  GithubRepoState get initialState => Empty();

  @override
  Stream<GithubRepoState> mapEventToState(
    GithubRepoEvent event,
  ) async* {
    if (event is GetTrendingRepos) {
      yield Loading();
      final failureOrTrivia = await getTrendingRepos(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<GithubRepoState> _eitherLoadedOrErrorState(
    Either<Failure, List<GithubRepo>> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (repos) => Loaded(repos: repos),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
