import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_paired_frames_info.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late GetPairedFramesInfo getPairedFramesInfo;
  late MockImageExchangeRepository mockImageExchangeRepository;
  late MockFrameAuthRepository mockFrameAuthRepository;

  setUp(() {
    mockImageExchangeRepository = MockImageExchangeRepository();
    mockFrameAuthRepository = MockFrameAuthRepository();
    getPairedFramesInfo = GetPairedFramesInfo(
      imageExchangeRepository: mockImageExchangeRepository,
      frameAuthRepository: mockFrameAuthRepository,
    );

    when(
      () => mockImageExchangeRepository.getPairedFramesOfCurator(
        curatorId: any(named: "curatorId"),
      ),
    ).thenAnswer((invocation) => Future.value(const Right(tPairedFrameIds)));

    when(
      () => mockFrameAuthRepository.getUserFromId(tPictureFrameId),
    ).thenAnswer((invocation) => Future.value(const Right(tPictureFrame)));
    when(
      () => mockFrameAuthRepository.getUserFromId(tPictureFrameId2),
    ).thenAnswer((invocation) => Future.value(const Right(tPictureFrame2)));
  });

  test('should get a [List] of the paired [Frame]s', () async {
    // act
    await getPairedFramesInfo(curatorId: tCuratorId);

    // assert
    verify(
      () => mockImageExchangeRepository.getPairedFramesOfCurator(
        curatorId: tCuratorId,
      ),
    );
  });

  test('should relay [Failures]', () async {
    // arrange
    when(
      () => mockImageExchangeRepository.getPairedFramesOfCurator(
        curatorId: any(named: "curatorId"),
      ),
    ).thenAnswer(
      (invocation) => Future.value(const Left(DatabaseReadFailure())),
    );

    // act
    final result = await getPairedFramesInfo(curatorId: tCuratorId);

    // assert
    expect(result, const Left(DatabaseReadFailure()));
  });

  test('should get the names of the paired [Frame]s', () async {
    // act
    await getPairedFramesInfo(curatorId: tCuratorId);

    // assert
    verify(
      () => mockFrameAuthRepository.getUserFromId(
        tPairedFrameIds[0],
      ),
    );
    verify(
      () => mockFrameAuthRepository.getUserFromId(
        tPairedFrameIds[1],
      ),
    );
  });

  test('should relay [Failures]', () async {
    // arrange
    when(
      () => mockFrameAuthRepository.getUserFromId(any()),
    ).thenAnswer(
      (invocation) => Future.value(const Left(DatabaseReadFailure())),
    );

    // act
    final result = await getPairedFramesInfo(curatorId: tCuratorId);
    print(result.hashCode);
    print(Left(DatabaseReadFailure().hashCode));
    // assert
    expect(result, const Left(DatabaseReadFailure()));
  });

  test("should return a [List] of [PairedFrameInfo]s", () async {
    // act
    final result = await getPairedFramesInfo(curatorId: tCuratorId);

    result.fold(
      (l) => fail("Expected an instance [Right] but got [Left]"),
      (r) => expect(r, tPairedFrameInfos),
    );
  });

  // should get a [List] of the paired [Frame]s
  // should relay [Failures]
  // should get the names of the paired [Frame]s
  // should relay [Failures]
}
