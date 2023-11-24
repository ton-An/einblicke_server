import 'package:dispatch_pi_dart/domain/repositories/authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/is_password_valid.dart';
import 'package:dispatch_pi_dart/domain/uscases/is_username_valid.dart';
import 'package:mocktail/mocktail.dart';

class MockIsUsernameValid extends Mock implements IsUsernameValid {}

class MockIsPasswordValid extends Mock implements IsPasswordValid {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}
