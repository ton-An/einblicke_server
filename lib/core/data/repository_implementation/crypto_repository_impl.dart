import 'package:einblicke_server/core/data/data_sources/crypto_local_data_source.dart';
import 'package:einblicke_server/core/domain/crypto_repository.dart';

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
