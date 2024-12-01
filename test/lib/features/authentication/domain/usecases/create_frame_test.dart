import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/create_frame.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late CreateFrame createFrame;
  late MockFrameAuthRepository frameAuthRepository;
  late MockGenerateUserId generateUserId;

  setUp(() {
    frameAuthRepository = MockFrameAuthRepository();
    generateUserId = MockGenerateUserId();
    createFrame = CreateFrame(
      frameAuthRepository: frameAuthRepository,
      generateUserId: generateUserId,
    );

    when(() => generateUserId()).thenAnswer((_) async => const Right(tUserId));
    when(
      () => frameAuthRepository.createFrame(
        userId: any(named: "userId"),
        name: any(named: "name"),
        ownerId: any(named: "ownerId"),
      ),
    ).thenAnswer((_) async => const Right(tPictureFrame));
  });

  test("should generate a user id", () async {
    // act
    await createFrame(ownerId: tCuratorId, name: tFrameName);

    // assert
    verify(() => generateUserId());
  });

  test("should relay the [Failure] if the user id generation fails", () async {
    // arrange
    when(() => generateUserId())
        .thenAnswer((_) async => const Left(DatabaseReadFailure()));

    // act
    final result = await createFrame(ownerId: tCuratorId, name: tFrameName);

    // assert
    expect(result, const Left(DatabaseReadFailure()));
  });

  test("should return a [Frame] if the frame was created successfully",
      () async {
    // act
    final result = await createFrame(ownerId: tCuratorId, name: tFrameName);

    // assert
    expect(result, const Right(tPictureFrame));
  });
}
