import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_mobile/core/usecases/usecase.dart';
import 'package:remote_mobile/features/github_repo/data/models/github_repo_model.dart';
import 'package:remote_mobile/features/github_repo/domain/repositories/github_repo_repository.dart';
import 'package:remote_mobile/features/github_repo/domain/usecases/get_trending_repos_usecase.dart';

class MockGithubRepoRepository extends Mock implements GithubRepoRepository {}

void main() {
  GetTrendingRepos useCase;
  MockGithubRepoRepository mockGithubRepoRepository;

  setUp(() {
    mockGithubRepoRepository = MockGithubRepoRepository();
    useCase = GetTrendingRepos(
      repository: mockGithubRepoRepository,
    );
  });

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
    'should get list of trending repos from the repository',
    () async {
      // arrange
      when(mockGithubRepoRepository.getTrendingRepos())
          .thenAnswer((_) async => Right(tRepos));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, Right(tRepos));
      verify(mockGithubRepoRepository.getTrendingRepos());
      verifyNoMoreInteractions(mockGithubRepoRepository);
    },
  );
}
