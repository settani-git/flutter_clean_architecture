import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;
import 'package:remote_mobile/core/error/exceptions.dart';
import 'package:remote_mobile/features/github_repo/data/datasources/github_repo_remote_datasource.dart';
import 'package:remote_mobile/features/github_repo/data/models/github_repo_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  GithubRepoRemoteDatasourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = GithubRepoRemoteDatasourceImpl(
      client: mockHttpClient,
    );
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('repos.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getTrendingRepos', () {
    final tRepoModel = GithubRepoModel(
      name: "Test repo",
      description: "Test description",
      starCount: 5134,
      owner: "Usertest",
    );
    final tRepos = [
      tRepoModel,
      tRepoModel,
      tRepoModel,
    ];
    final testPageNumber = 0;

    test(
      '''should perform a GET request on a GITHUB API URL with
       being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getTrendingGithubRepos(testPageNumber);
        // assert
        verify(mockHttpClient.get(
          'https://api.github.com/search/repositories?q=created:>2017-10-22&sort=stars&order=desc',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return List of Repos when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getTrendingGithubRepos(testPageNumber);
        // assert
        expect(result, equals(tRepos));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getTrendingGithubRepos;
        // assert
        expect(() => call(testPageNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
