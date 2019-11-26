import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_mobile/core/error/exceptions.dart';
import 'package:remote_mobile/core/error/failures.dart';
import 'package:remote_mobile/core/network/network_info.dart';
import 'package:remote_mobile/features/github_repo/data/datasources/github_repo_local_datasource.dart';
import 'package:remote_mobile/features/github_repo/data/datasources/github_repo_remote_datasource.dart';
import 'package:remote_mobile/features/github_repo/data/models/github_repo_model.dart';
import 'package:remote_mobile/features/github_repo/data/repositories/github_repo_repository_impl.dart';
import 'package:remote_mobile/features/github_repo/domain/entities/github_repo.dart';

class MockRemoteDataSource extends Mock implements GithubRepoRemoteDatasource {}

class MockLocalDataSource extends Mock implements GithubRepoLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  GithubRepoRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = GithubRepoRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tRepoModel = GithubRepoModel(
      name: "Test repo",
      description: "Test description",
      starCount: 5134,
      owner: "Usertest",
    );
    final GithubRepo tNumberTrivia = tRepoModel;
    final tRepos = [
      tRepoModel,
      tRepoModel,
      tRepoModel,
    ];

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getTrendingRepos();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getTrendingGithubRepos())
              .thenAnswer((_) async => tRepos);
          // act
          final result = await repository.getTrendingRepos();
          // assert
          verify(mockRemoteDataSource.getTrendingGithubRepos());
          expect(result, equals(Right(tRepos)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getTrendingGithubRepos())
              .thenAnswer((_) async => tRepos);
          // act
          await repository.getTrendingRepos();
          // assert
          verify(mockRemoteDataSource.getTrendingGithubRepos());
          verify(mockLocalDataSource.cacheReposList(tRepos));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getTrendingGithubRepos())
              .thenThrow(ServerException());
          // act
          final result = await repository.getTrendingRepos();
          // assert
          verify(mockRemoteDataSource.getTrendingGithubRepos());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastCachedTrendingList())
              .thenAnswer((_) async => tRepos);
          // act
          final result = await repository.getTrendingRepos();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastCachedTrendingList());
          expect(result, equals(Right(tRepos)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastCachedTrendingList())
              .thenThrow(CacheException());
          // act
          final result = await repository.getTrendingRepos();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastCachedTrendingList());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
