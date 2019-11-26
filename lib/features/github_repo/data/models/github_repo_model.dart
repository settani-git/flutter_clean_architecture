import 'package:meta/meta.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';

class GithubRepoModel extends GithubRepo {
  GithubRepoModel({
    @required String name,
    @required String description,
    @required int starCount,
    @required String owner,
  }) : super(
          name: name,
          description: description,
          starCount: starCount,
          owner: owner,
        );

  factory GithubRepoModel.fromJson(Map<String, dynamic> jsonMap) {
    return GithubRepoModel(
      name: jsonMap['name'],
      description: jsonMap['description'],
      starCount: (jsonMap['stargazers_count'] as num).toInt(),
      owner: jsonMap['owner']['login'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'stargazers_count': starCount,
      'owner': {
        'login': owner,
      },
    };
  }
}
