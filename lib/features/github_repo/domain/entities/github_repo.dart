import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GithubRepo extends Equatable {
  final String name;
  final String description;
  final int starCount;
  final String owner;

  GithubRepo({
    @required this.name,
    @required this.description,
    @required this.starCount,
    @required this.owner,
  }) : super([
          name,
          description,
          starCount,
          owner,
        ]);
}
