import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_mobile/core/error/exceptions.dart';
import 'package:remote_mobile/features/github_repo/data/datasources/github_repo_local_datasource.dart';
import 'package:remote_mobile/features/github_repo/data/models/github_repo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  GithubRepoLocalDatasourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = GithubRepoLocalDatasourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastCachedTrendingList', () {
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

    test(
      'should return List of GithubRepo from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('repos.json'));
        // act
        final result = await dataSource.getLastCachedTrendingList();
        // assert
        verify(mockSharedPreferences.getString(CACHED_REPOS));
        expect(result, equals(tRepos));
      },
    );

    test(
      'should throw a CacheExeption when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastCachedTrendingList;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheReposList', () {
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
    final tReposMap = [];
    tRepos.forEach((repo){
      tReposMap.add(repo.toJson());
    });

    test(
      'should call SharedPreferences to cache the data',
          () async {
        // act
        dataSource.cacheReposList(tRepos);
        // assert
        final expectedJsonString = json.encode(tReposMap);
        verify(mockSharedPreferences.setString(
          CACHED_REPOS,
          expectedJsonString,
        ));
      },
    );
  });
}
