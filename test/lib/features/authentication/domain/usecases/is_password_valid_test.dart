import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';

void main() {
  late IsPasswordValid isPasswordValid;

  setUp(() {
    isPasswordValid = const IsPasswordValid();
  });

  test("should return true if the password is valid", () {
    // act
    final result = isPasswordValid(tPassword);

    // assert
    expect(result, true);
  });

  test("should return false if the password is invalid", () {
    // act
    final result = isPasswordValid(tInvalidPassword);

    // assert
    expect(result, false);
  });
}
