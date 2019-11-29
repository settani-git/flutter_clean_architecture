import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GithubRepoEvent extends Equatable {
  GithubRepoEvent([List props = const <dynamic>[]]) : super(props);
}

class GetGithubReposEvent extends GithubRepoEvent {
  final int pageNumber;

  GetGithubReposEvent({@required this.pageNumber}) : super([pageNumber]);
}

class GetGithubReposByPageNumber extends GithubRepoEvent {
  final int pageNumber;

  GetGithubReposByPageNumber({@required this.pageNumber}) : super([pageNumber]);
}
