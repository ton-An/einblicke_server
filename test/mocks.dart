import 'package:dispatch_pi_dart/domain/models/user.dart';
import 'package:dispatch_pi_dart/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/create_user_wrapper.dart';
import 'package:dispatch_pi_dart/domain/uscases/generate_access_token.dart';
import 'package:dispatch_pi_dart/domain/uscases/generate_encrypted_token.dart';
import 'package:dispatch_pi_dart/domain/uscases/generate_refresh_token.dart';
import 'package:dispatch_pi_dart/domain/uscases/is_password_valid.dart';
import 'package:dispatch_pi_dart/domain/uscases/is_username_valid.dart';
import 'package:mocktail/mocktail.dart';

class MockIsUsernameValid extends Mock implements IsUsernameValid {}

class MockIsPasswordValid extends Mock implements IsPasswordValid {}

class MockBasicAuthRepository extends Mock
    implements BasicAuthenticationRepository {}

class MockUserAuthRepository extends Mock
    implements UserAuthenticationRepository<User> {}

class MockUser extends Mock implements User {}

class MockCreateUserWrapper<U extends User,
        R extends UserAuthenticationRepository<U>> extends Mock
    implements CreateUserWrapper<U, R> {}

class MockGenerateEncryptedToken extends Mock
    implements GenerateEncryptedToken {}

class MockGenerateAccessToken extends Mock implements GenerateAccessToken {}

class MockGenerateRefreshToken extends Mock implements GenerateRefreshToken {}
