// should check if the curator exists
// should check if the frame exists
// should check if the curator is already paired with the frame
// should pair the curator with the frame
// should return None

// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/pair_curator_x_frame.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late PairCuratorXFrame pairCuratorXFrame;
  late MockImageExchangeRepository mockImageExchangeRepository;
  late MockCuratorAuthRepository mockCuratorAuthRepository;
  late MockFrameAuthRepository mockFrameAuthRepository;

  setUp(() {
    mockImageExchangeRepository = MockImageExchangeRepository();
    mockCuratorAuthRepository = MockCuratorAuthRepository();
    mockFrameAuthRepository = MockFrameAuthRepository();
    pairCuratorXFrame = PairCuratorXFrame(
      imageExchangeRepository: mockImageExchangeRepository,
      curatorAuthenticationRepository: mockCuratorAuthRepository,
      frameAuthenticationRepository: mockFrameAuthRepository,
    );

    when(
      () => mockCuratorAuthRepository.isUserIdTaken(
        any(),
      ),
    ).thenAnswer((_) async => const Right(true));

    when(
      () => mockFrameAuthRepository.isUserIdTaken(
        any(),
      ),
    ).thenAnswer((_) async => const Right(true));

    when(
      () => mockImageExchangeRepository.areCuratorXFramePaired(
        curatorId: any(named: "curatorId"),
        frameId: any(named: "frameId"),
      ),
    ).thenAnswer((_) async => const Right(false));

    when(
      () => mockImageExchangeRepository.pairCuratorXFrame(
        curatorId: any(named: "curatorId"),
        frameId: any(named: "frameId"),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  group("check if curator exists", () {
    test("should check if a curator with the given id exists", () async {
      // act
      await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      verify(() => mockCuratorAuthRepository.isUserIdTaken(tCuratorId));
    });

    test("should return [CuratorNotFoundFailure] if curator does not exist",
        () async {
      // arrange
      when(
        () => mockCuratorAuthRepository.isUserIdTaken(
          any(),
        ),
      ).thenAnswer((_) async => const Right(false));

      // act
      final result = await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(CuratorNotFoundFailure()));
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockCuratorAuthRepository.isRefreshTokenInUserDb(any(), any()),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });
  group("check if frame exists", () {
    test("should check if a frame with the given id exists", () async {
      // act
      await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      verify(() => mockFrameAuthRepository.isUserIdTaken(tPictureFrameId));
    });

    test("should return [FrameNotFoundFailure] if curator does not exist",
        () async {
      // arrange
      when(
        () => mockFrameAuthRepository.isUserIdTaken(
          any(),
        ),
      ).thenAnswer((invocation) async => const Right(false));

      // act
      final result = await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(FrameNotFoundFailure()));
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockFrameAuthRepository.isUserIdTaken(
          any(),
        ),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("check if the curator and frame are already paired", () {
    test("should check if the curator and frame are already paired", () async {
      // act
      await pairCuratorXFrame(
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

    test(
        "should return [CuratorXFrameAlreadyPairedFailure] if curator and frame"
        " are already paired", () async {
      // arrange
      when(
        () => mockImageExchangeRepository.areCuratorXFramePaired(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenAnswer((_) async => const Right(true));

      // act
      final result = await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(AlreadyPairedFailure()));
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockImageExchangeRepository.areCuratorXFramePaired(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("pair curator with frame", () {
    test("should pair the curator with the frame", () async {
      // act
      await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      verify(
        () => mockImageExchangeRepository.pairCuratorXFrame(
          curatorId: tCuratorId,
          frameId: tPictureFrameId,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockImageExchangeRepository.pairCuratorXFrame(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  test("return [None]", () async {
    // act
    final result = await pairCuratorXFrame(
      curatorId: tCuratorId,
      frameId: tPictureFrameId,
    );

    // assert
    expect(result, equals(const Right(None())));
  });
}
