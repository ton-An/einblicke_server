import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/generate_user_id.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late GenerateUserId generateUserId;
  late MockUserAuthRepository mockUserAuthRepository;
  late MockCryptoRepository mockCryptoRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    mockCryptoRepository = MockCryptoRepository();

    generateUserId = GenerateUserId(
      userAuthRepository: mockUserAuthRepository,
      cryptoRepository: mockCryptoRepository,
    );

    when(() => mockCryptoRepository.generateUuid()).thenReturn(tUserId);
    when(() => mockUserAuthRepository.isUserIdTaken(any()))
        .thenAnswer((_) async => const Right(false));
  });

  group("user id generation", () {
    test("should generate a user id", () async {
      // act
      await generateUserId();

      // assert
      verify(() => mockCryptoRepository.generateUuid());
    });
  });

  group("check user id", () {
    test("should check if user id is taken", () async {
      // act
      await generateUserId();

      // assert
      verify(() => mockUserAuthRepository.isUserIdTaken(tUserId));
    });

    test("should generate another user id if the first one is taken", () async {
      // arrange
      final List<bool> isUserIdTakenAnswers = [true, false];

      when(() => mockUserAuthRepository.isUserIdTaken(any()))
          .thenAnswer((_) async => Right(isUserIdTakenAnswers.removeAt(0)));

      // act
      await generateUserId();

      // assert
      verify(() => mockCryptoRepository.generateUuid()).called(2);
    });

    test(
        "should return a [UserIdGenerationFailure] "
        "if the user id generation fails 5 times", () async {
      // arrange
      when(() => mockUserAuthRepository.isUserIdTaken(any()))
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await generateUserId();

      // assert
      expect(result, const Left<Failure, User>(UserIdGenerationFailure()));
      verify(() => mockCryptoRepository.generateUuid()).called(5);
    });
  });
}
