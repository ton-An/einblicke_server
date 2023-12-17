import 'package:dispatch_pi_dart/features/authentication/data/data_sources/crypto_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/crypto_repository.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoLocalDataSource localDataSource;

  const CryptoRepositoryImpl({
    required this.localDataSource,
  });

  @override
  String generateUuid() {
    return localDataSource.generateUuid();
  }
}
