import 'package:flutter_test/flutter_test.dart';
import 'package:remote_mobile/features/github_repo/data/models/github_repo_model.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'dart:convert';

void main() {
  final repoModel = GithubRepoModel(
    name: "Test repo",
    description: "Test description",
    starCount: 5134,
    owner: "Usertest",
  );

  test(
    'should be a subclass of GithubRepo entity',
    () async {
      // assert
      expect(repoModel, isA<GithubRepo>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('repo.json'));
        // act
        final result = GithubRepoModel.fromJson(jsonMap);
        // assert
        expect(result, repoModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = repoModel.toJson();
        // assert
        final expectedMap = {
          "name": "Test repo",
          "description": "Test description",
          "stargazers_count": 5134,
          "owner": {
            "login": "Usertest"
          }
        };
        expect(result, expectedMap);
      },
    );
  });
}
