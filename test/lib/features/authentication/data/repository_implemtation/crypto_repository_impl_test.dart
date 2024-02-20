import 'package:einblicke_server/core/data/repository_implementation/crypto_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late CryptoRepositoryImpl cryptoRepositoryImpl;
  late MockCryptoLocalDataSource mockCryptoLocalDataSource;

  setUp(() {
    mockCryptoLocalDataSource = MockCryptoLocalDataSource();
    cryptoRepositoryImpl = CryptoRepositoryImpl(
      localDataSource: mockCryptoLocalDataSource,
    );
  });

  group("generateUuid", () {
    setUp(() {
      when(() => mockCryptoLocalDataSource.generateUuid()).thenReturn(tUserId);
    });

    test(
        "should call generateUuid on the local data source and return the result",
        () {
      // act
      final result = cryptoRepositoryImpl.generateUuid();

      // assert
      verify(() => mockCryptoLocalDataSource.generateUuid());
      expect(result, tUserId);
    });
  });
}
