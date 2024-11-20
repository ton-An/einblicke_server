// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/curator_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/sign_in_curator.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late SignInCurator signInCurator;
  late MockCuratorAuthRepository mockCuratorAuthRepository;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockGetSignInTokens<Curator, CuratorAuthenticationRepository>
      mockGetSignInTokens;

  setUp(() {
    mockCuratorAuthRepository = MockCuratorAuthRepository();
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockGetSignInTokens = MockGetSignInTokens();

    signInCurator = SignInCurator(
      curatorAuthenticationRepository: mockCuratorAuthRepository,
      basicAuthRepository: mockBasicAuthRepository,
      getSignInTokens: mockGetSignInTokens,
    );

    registerFallbackValue(MockEncryptedToken());
    registerFallbackValue(tCurator);

    when(() => mockBasicAuthRepository.generatePasswordHash(any()))
        .thenReturn(tPasswordHash);
    when(
      () => mockCuratorAuthRepository.getCuratorFromCredentials(
        any(),
        any(),
      ),
    ).thenAnswer((_) async => const Right(tCurator));
    when(() => mockGetSignInTokens(tCurator))
        .thenAnswer((_) async => Right(tServerTokenBundle));
  });

  group("get hashed version of password", () {
    test("should get hashed version of the password", () async {
      // act
      await signInCurator(
        username: tUsername,
        password: tPassword,
      );

      // assert
      verify(() => mockBasicAuthRepository.generatePasswordHash(tPassword));
    });
  });

  group("get curator with username and hashed password", () {
    test("should get curator with the  username and hashed password", () async {
      // act
      await signInCurator(
        username: tUsername,
        password: tPassword,
      );

      // assert
      verify(
        () => mockCuratorAuthRepository.getCuratorFromCredentials(
          tUsername,
          tPasswordHash,
        ),
      );
    });

    test("should relay Failures if getting the curator fails", () async {
      // arrange
      when(
        () => mockCuratorAuthRepository.getCuratorFromCredentials(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => const Left(UserNotFoundFailure()));

      // act
      final result = await signInCurator(
        username: tUsername,
        password: tPassword,
      );

      // assert
      expect(result, const Left(UserNotFoundFailure()));
    });
  });

  group("if the curator exists", () {
    test("should handle tokens for sign in", () async {
      // act
      await signInCurator(
        username: tUsername,
        password: tPassword,
      );

      // assert
      verify(
        () => mockGetSignInTokens(tCurator),
      );
    });

    test("should relay Failures if handling tokens fails", () async {
      // arrange
      when(() => mockGetSignInTokens(any()))
          .thenAnswer((_) async => const Left(DatabaseWriteFailure()));

      // act
      final result = await signInCurator(
        username: tUsername,
        password: tPassword,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });

    test("should return ServerTokenBundle if handling tokens succeeds",
        () async {
      // act
      final result = await signInCurator(
        username: tUsername,
        password: tPassword,
      );

      // assert
      expect(result, Right(tServerTokenBundle));
    });
  });
}
