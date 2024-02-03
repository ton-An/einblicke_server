// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_image_from_id.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late GetImageFromId getImageFromId;
  late MockImageExchangeRepository mockImageExchangeRepository;

  setUp(() {
    mockImageExchangeRepository = MockImageExchangeRepository();
    getImageFromId = GetImageFromId(
      imageExchangeRepository: mockImageExchangeRepository,
    );

    when(
      () => mockImageExchangeRepository.getImageById(
        imageId: any(named: "imageId"),
      ),
    ).thenAnswer((_) async => const Right(tImage));
  });

  test("should get an [Image] from storage and return it", () async {
    // act
    final result = await getImageFromId(imageId: tImageId);

    // assert
    expect(result, const Right(tImage));
    verify(
      () => mockImageExchangeRepository.getImageById(
        imageId: tImageId,
      ),
    );
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(
      () => mockImageExchangeRepository.getImageById(
        imageId: any(named: "imageId"),
      ),
    ).thenAnswer((_) async => const Left(StorageReadFailure()));

    // act
    final result = await getImageFromId(imageId: tImageId);

    // assert
    expect(result, const Left(StorageReadFailure()));
  });
}
