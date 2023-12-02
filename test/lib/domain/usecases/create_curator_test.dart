// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_password_failure.dart';
import 'package:dispatch_pi_dart/domain/models/curator.dart';
import 'package:dispatch_pi_dart/domain/repositories/curator_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/create_user/create_curator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  late CreateCurator createCurator;
  late MockCreateUserWrapper<Curator, CuratorAuthenticationRepository>
      mockCreateCurator;

  setUp(() {
    mockCreateCurator = MockCreateUserWrapper();
    createCurator = CreateCurator(createCurator: mockCreateCurator);
  });

  test("should call [MockCreateUserWrapper] and return a [Curator]", () async {
    // arrange
    when(() => mockCreateCurator(any(), any()))
        .thenAnswer((_) async => const Right(tCurator));

    // act
    final result = await createCurator(tUsername, tPassword);

    // assert
    expect(result, const Right(tCurator));
    verify(() => mockCreateCurator(tUsername, tPassword));
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(() => mockCreateCurator(any(), any()))
        .thenAnswer((_) async => const Left(InvalidPasswordFailure()));

    // act
    final result = await createCurator(tUsername, tPassword);

    // assert
    expect(result, const Left(InvalidPasswordFailure()));
  });
}
