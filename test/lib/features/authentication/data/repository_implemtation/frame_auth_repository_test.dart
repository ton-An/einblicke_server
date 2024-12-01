import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/data/repository_implementation/frame_auth_repository_impl.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late FrameAuthenticationRepositoryImpl frameAuthRepositoryImpl;
  late MockFrameAuthLocalDataSource mockFrameAuthLocalDataSource;

  setUp(() {
    mockFrameAuthLocalDataSource = MockFrameAuthLocalDataSource();
    frameAuthRepositoryImpl = FrameAuthenticationRepositoryImpl(
      userAuthLocalDataSource: mockFrameAuthLocalDataSource,
    );
  });

  group("createFrame", () {
    setUp(() {
      when(
        () => mockFrameAuthLocalDataSource.createFrame(
          userId: any(named: "userId"),
          ownerId: any(named: "ownerId"),
          name: any(named: "name"),
        ),
      ).thenAnswer((_) async => tPictureFrame);
    });

    test("should get a [Curator] from the local data source and return it",
        () async {
      // act
      final result = await frameAuthRepositoryImpl.createFrame(
        userId: tUserId,
        ownerId: tCuratorId,
        name: tFrameName,
      );

      // assert
      verify(
        () => mockFrameAuthLocalDataSource.createFrame(
          userId: tUserId,
          ownerId: tCuratorId,
          name: tFrameName,
        ),
      );
      expect(result, const Right(tPictureFrame));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source throws a [DatabaseException]",
        () async {
      // arrange
      when(
        () => mockFrameAuthLocalDataSource.createFrame(
          userId: any(named: "userId"),
          ownerId: any(named: "ownerId"),
          name: any(named: "name"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await frameAuthRepositoryImpl.createFrame(
        userId: tUserId,
        ownerId: tCuratorId,
        name: tFrameName,
      );

      // assert
      expect(result, equals(const Left(DatabaseWriteFailure())));
    });
  });
}
