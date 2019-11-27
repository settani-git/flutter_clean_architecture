import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GithubRepoEvent extends Equatable {
  GithubRepoEvent([List props = const <dynamic>[]]) : super(props);
}

class GetGithubReposEvent extends GithubRepoEvent {}
