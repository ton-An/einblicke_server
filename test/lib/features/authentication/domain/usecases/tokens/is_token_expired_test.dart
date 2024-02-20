import 'package:einblicke_server/features/authentication/domain/uscases/tokens/is_token_expired.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../fixtures.dart';
import '../../../../../../mocks.dart';

void main() {
  late IsTokenExpired isTokenExpired;
  late MockClock mockClock;

  setUp(() {
    mockClock = MockClock();
    isTokenExpired = IsTokenExpired(clock: mockClock);

    when(() => mockClock.now()).thenReturn(tCurrentTime);
  });

  test("should call clock.now()", () {
    // act
    isTokenExpired(expiresAt: tValidExpiresAt);

    // assert
    verify(() => mockClock.now());
  });

  test("return false if the token is not expired", () {
    // act
    final bool result = isTokenExpired(expiresAt: tValidExpiresAt);

    // assert
    expect(result, false);
  });

  test("return true if the token is expired", () {
    // act
    final bool result = isTokenExpired(expiresAt: tInvalidExpiresAt);

    // assert
    expect(result, true);
  });
}
