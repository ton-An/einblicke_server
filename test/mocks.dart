import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/crypto_wrapper.dart';
import 'package:dispatch_pi_dart/core/data/data_sources/crypto_local_data_source.dart';
import 'package:dispatch_pi_dart/core/domain/crypto_repository.dart';
import 'package:dispatch_pi_dart/core/jwe_builder_wrapper.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/basic_authentication_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims/token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/create_user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/get_user_with_type.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/sign_in/sign_in_wrapper.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_refresh_token_validity/check_refresh_token_validity.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/generate_encrypted_token/generate_access_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/generate_encrypted_token/generate_refresh_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/invalidate_all_refresh_tokens/invalidate_all_refresh_tokens.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/invalidate_refresh_tokens/invalidate_refresh_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/is_token_expired.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/save_refresh_token/save_refresh_token.dart';
import 'package:dispatch_pi_dart/features/image_exchange/data/data_sources/image_exchange_local_data_source.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_image_from_id.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_latest_image.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:jose/jose.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

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

class MockImageExchangeRepository extends Mock
    implements ImageExchangeRepository {}

class MockCuratorAuthRepository extends Mock
    implements CuratorAuthenticationRepository {}

class MockFrameAuthRepository extends Mock
    implements FrameAuthenticationRepository {}

class MockImageStreamController extends Mock
    implements StreamController<Either<Failure, Image>> {}

class MockGetLatestImage extends Mock implements GetLatestImage {}

class MockStreamSink extends Mock implements StreamSink {}

class MockGetImageFromId extends Mock implements GetImageFromId {}

class MockGetUserWithType extends Mock
    implements GetUserWithType<MockUser, MockUserAuthRepository> {}

class MockImageExchangeLocalDataSource extends Mock
    implements ImageExchangeLocalDataSource {}

class MockBasicAuthLocalDataSource extends Mock
    implements BasicAuthLocalDataSource {}

class MockIOException extends Mock implements IOException {}

class MockFile extends Mock implements File {}

class MockCryptoRepository extends Mock implements CryptoRepository {}

class MockCryptoLocalDataSource extends Mock implements CryptoLocalDataSource {}

class MockUuid extends Mock implements Uuid {}

class MockUserAuthenticationLocalDataSource extends Mock
    implements UserAuthenticationLocalDataSource {}

class MockCryptoWrapper extends Mock implements CryptoWrapper {}

class MockJsonWebEncryptionBuilder extends Mock
    implements JsonWebEncryptionBuilder {}

class MockJWEBBuilderWrapper extends Mock implements JWEBuilderWrapper {}

class MockJsonWebEncryption extends Mock implements JsonWebEncryption {}

class MockDatabaseException extends Mock implements DatabaseException {}
