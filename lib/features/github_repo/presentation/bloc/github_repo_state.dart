import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';

@immutable
abstract class GithubRepoState extends Equatable {
  GithubRepoState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends GithubRepoState {}

class Loading extends GithubRepoState {}

class Loaded extends GithubRepoState {
  final List<GithubRepo> repos;

  Loaded({
    @required this.repos,
  }) : super([repos]);
}

class Error extends GithubRepoState {
  final String message;

  Error({@required this.message}) : super([message]);
}
