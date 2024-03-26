import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_latest_frame_image_for_curator.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late GetLatestFrameImageForCurator getLatestFrameImageForCurator;
  late MockGetLatestImage mockGetLatestImage;
  late MockImageExchangeRepository mockImageExchangeRepository;

  setUp(() {
    mockGetLatestImage = MockGetLatestImage();
    mockImageExchangeRepository = MockImageExchangeRepository();
    getLatestFrameImageForCurator = GetLatestFrameImageForCurator(
      getLatestImage: mockGetLatestImage,
      imageExchangeRepository: mockImageExchangeRepository,
    );
  });

  setUp(() {
    when(
      () => mockImageExchangeRepository.areCuratorXFramePaired(
        curatorId: any(named: "curatorId"),
        frameId: any(named: "frameId"),
      ),
    ).thenAnswer((_) => Future.value(const Right(true)));

    when(() => mockGetLatestImage(frameId: any(named: "frameId")))
        .thenAnswer((invocation) => Future.value(const Right(tImage)));
  });

  test("should check if the [Curator] and [Frame] are paired", () async {
    // act
    await getLatestFrameImageForCurator(
      curatorId: tCuratorId,
      frameId: tPictureFrameId,
    );

    // assert
    verify(
      () => mockImageExchangeRepository.areCuratorXFramePaired(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      ),
    );
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(
      () => mockImageExchangeRepository.areCuratorXFramePaired(
        curatorId: any(named: "curatorId"),
        frameId: any(named: "frameId"),
      ),
    ).thenAnswer((_) => Future.value(const Left(DatabaseReadFailure())));

    // act
    final result = await getLatestFrameImageForCurator(
      curatorId: tCuratorId,
      frameId: tPictureFrameId,
    );

    // assert
    expect(result, const Left(DatabaseReadFailure()));
  });

  test(
      "should return a [NotPairedFailure] if the [Curator] and [Frame] "
      "are not paired", () async {
    // arrange
    when(
      () => mockImageExchangeRepository.areCuratorXFramePaired(
        curatorId: any(named: "curatorId"),
        frameId: any(named: "frameId"),
      ),
    ).thenAnswer((_) => Future.value(const Right(false)));

    // act
    final result = await getLatestFrameImageForCurator(
      curatorId: tCuratorId,
      frameId: tPictureFrameId,
    );

    // assert
    expect(result, const Left(NotPairedFailure()));
  });

  test("should get the latest [Image] of the given [Frame]  and return it",
      () async {
    // act
    final result = await getLatestFrameImageForCurator(
      curatorId: tCuratorId,
      frameId: tPictureFrameId,
    );

    // assert
    expect(result, const Right(tImage));
    verify(() => mockGetLatestImage(frameId: tPictureFrameId));
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(() => mockGetLatestImage(frameId: any(named: "frameId"))).thenAnswer(
        (invocation) => Future.value(const Left(DatabaseReadFailure())));

    // act
    final result = await getLatestFrameImageForCurator(
      curatorId: tCuratorId,
      frameId: tPictureFrameId,
    );

    // assert
    expect(result, const Left(DatabaseReadFailure()));
  });
}
