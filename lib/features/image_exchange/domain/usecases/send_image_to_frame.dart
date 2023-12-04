import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';

// ToDo: implement
class SendImageToFrame {
  const SendImageToFrame();

  Future<Either<Failure, None>> call({
    required String frameId,
    required String imageId,
  }) async {
    throw UnimplementedError();
  }
}
