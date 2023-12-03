import 'package:clock/clock.dart';
import 'package:dispatch_pi_dart/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/domain/models/token_claims.dart';
import 'package:dispatch_pi_dart/domain/models/user.dart';
import 'package:dispatch_pi_dart/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/create_user/create_user_wrapper.dart';
import 'package:dispatch_pi_dart/domain/uscases/is_password_valid.dart';
import 'package:dispatch_pi_dart/domain/uscases/is_username_valid.dart';
import 'package:dispatch_pi_dart/domain/uscases/sign_in/sign_in_wrapper.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/check_refresh_token_validity/check_refresh_token_validity.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/generate_encrypted_token/generate_access_token.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/generate_encrypted_token/generate_refresh_token.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/invalidate_all_refresh_tokens/invalidate_all_refresh_tokens.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/invalidate_refresh_tokens/invalidate_refresh_token.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/is_token_expired.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/save_refresh_token/save_refresh_token.dart';
import 'package:mocktail/mocktail.dart';

class MockIsUsernameValid extends Mock implements IsUsernameValid {}

class MockIsPasswordValid extends Mock implements IsPasswordValid {}

class MockBasicAuthRepository extends Mock
    implements BasicAuthenticationRepository {}

class MockUserAuthRepository extends Mock
    implements UserAuthenticationRepository<MockUser> {}

class MockUser extends Mock implements User {}

class MockCreateUserWrapper<U extends User,
        R extends UserAuthenticationRepository<U>> extends Mock
    implements CreateUserWrapper<U, R> {}

class MockGenerateAccessToken extends Mock implements GenerateAccessToken {}

class MockGenerateRefreshToken extends Mock implements GenerateRefreshToken {}

class MockSignInWrapper<U extends User,
        R extends UserAuthenticationRepository<U>> extends Mock
    implements SignInWrapper<U, R> {}

class MockIsTokenExpired extends Mock implements IsTokenExpired {}

class MockClock extends Mock implements Clock {}

class MockTokenClaims extends Mock implements TokenClaims {}

class MockSaveRefreshToken<U extends User,
        R extends UserAuthenticationRepository<U>> extends Mock
    implements SaveRefreshToken<U, R> {}

class MockEncryptedToken extends Mock implements EncryptedToken {}

class MockCheckRefreshTokenValidityWrapper<U extends User,
        R extends UserAuthenticationRepository<U>> extends Mock
    implements CheckRefreshTokenValidityWrapper<U, R> {}

class MockInvalidateRefreshToken<U extends User,
        R extends UserAuthenticationRepository<U>> extends Mock
    implements InvalidateRefreshToken<U, R> {}

class MockInvalidateAllRefreshTokens<U extends User,
        R extends UserAuthenticationRepository<U>> extends Mock
    implements InvalidateAllRefreshTokens<U, R> {}
