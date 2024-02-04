import 'package:dispatch_pi_dart/core/data/data_sources/crypto_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late CryptoLocalDataSource dataSource;
  late Uuid uuid;

  setUp(() {
    uuid = MockUuid();
    dataSource = CryptoLocalDataSourceImpl(uuid: uuid);
  });

  group('generateUuid', () {
    setUp(() {
      when(() => uuid.v4()).thenReturn(tUuidString);
    });
    test(
      'should return a valid uuid',
      () async {
        // act
        final result = dataSource.generateUuid();

        // assert
        expect(result, tUuidString);
        verify(() => uuid.v4());
      },
    );
  });
}
