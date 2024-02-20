import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';

void main() {
  late IsUsernameValid isUsernameValid;

  setUp(() {
    isUsernameValid = const IsUsernameValid();
  });

  test("should return true if the username is valid", () {
    // act
    final result = isUsernameValid(tUsername);

    // assert
    expect(result, true);
  });

  test("should return false if the username is invalid", () {
    // act
    final result = isUsernameValid(tInvalidUsername);

    // assert
    expect(result, false);
  });
}
