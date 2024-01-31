import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:dispatch_pi_dart/core/crypto_wrapper.dart';
import 'package:dispatch_pi_dart/core/db_names.dart';
import 'package:dispatch_pi_dart/core/jwe_builder_wrapper.dart';
import 'package:dispatch_pi_dart/core/secrets.dart';
import 'package:dispatch_pi_dart/core/secrets_impl.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/basic_authentication_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/crypto_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/data/repository_implementation/basic_authentication_repository_impl.dart';
import 'package:dispatch_pi_dart/features/authentication/data/repository_implementation/crypto_repository_impl.dart';
import 'package:dispatch_pi_dart/features/authentication/data/repository_implementation/user_authentication_repository_impl.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/crypto_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/create_user/create_curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/create_user/create_picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/create_user/create_user_wrapper.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/get_user_with_type.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/is_client_id_valid.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/is_client_secret_valid.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/sign_in/sign_in_curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/sign_in/sign_in_picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/sign_in/sign_in_wrapper.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_access_token_validity.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_curator_access_token_validity.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_frame_access_token_validity.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_refresh_token_validity/check_refresh_token_validity.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/generate_encrypted_token/generate_access_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/generate_encrypted_token/generate_refresh_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/get_new_tokens.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/invalidate_all_refresh_tokens/invalidate_all_refresh_tokens.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/invalidate_refresh_tokens/invalidate_refresh_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/is_token_expired.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/save_refresh_token/save_refresh_token.dart';
import 'package:dispatch_pi_dart/features/image_exchange/data/data_sources/image_exchange_local_data_source.dart';
import 'package:dispatch_pi_dart/features/image_exchange/data/repository_implementations/image_exchange_repository_impl.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_frames_image_from_id.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_image_from_id.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_latest_image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/pair_curator_x_frame.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/receive_image_from_curator.dart';
import 'package:dispatch_pi_dart/features/image_exchange/presentation/handlers/frame_socket_handler.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

final GetIt getIt = GetIt.instance;
bool _isInitialized = false;

Future<void> initGetIt() async {
  if (_isInitialized) return;
  _isInitialized = true;
  const String imageDirectoryPath = "images/";
  await _registerDatabase();
  // Other
  getIt.registerLazySingleton<Secrets>(
    () => const SecretsImpl(),
  );

  // Presentation
  getIt.registerLazySingleton(
    () => GetFramesImageFromId(
      getImageFromId: getIt(),
      imageExchangeRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => FrameSocketHandler(
      getImageFromId: getIt(),
      getLatestImage: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => CheckAccessTokenValidityWrapper<Curator,
        CuratorAuthenticationRepository>(
      basicAuthRepository: getIt(),
      isTokenExpiredUseCase: getIt(),
      getUserWithType: getIt(),
      userAuthenticationRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => CheckAccessTokenValidityWrapper<PictureFrame,
        FrameAuthenticationRepository>(
      basicAuthRepository: getIt(),
      isTokenExpiredUseCase: getIt(),
      getUserWithType: getIt(),
      userAuthenticationRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => IsClientIdValid(secrets: getIt()),
  );
  getIt.registerLazySingleton(() => IsClientSecretValid(secrets: getIt()));
  getIt.registerLazySingleton(
    () => GetNewTokens<Curator, CuratorAuthenticationRepository>(
      checkRefreshTokenValidityWrapper: getIt(),
      generateAccessToken: getIt(),
      generateRefreshToken: getIt(),
      invalidateRefreshToken: getIt(),
      invalidateAllRefreshTokens: getIt(),
      saveRefreshTokenUsecase: getIt(),
      userAuthRepository: getIt(),
      basicAuthRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetNewTokens<PictureFrame, FrameAuthenticationRepository>(
      checkRefreshTokenValidityWrapper: getIt(),
      generateAccessToken: getIt(),
      generateRefreshToken: getIt(),
      invalidateRefreshToken: getIt(),
      invalidateAllRefreshTokens: getIt(),
      saveRefreshTokenUsecase: getIt(),
      userAuthRepository: getIt(),
      basicAuthRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => InvalidateRefreshToken<Curator, CuratorAuthenticationRepository>(
      userAuthenticationRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => InvalidateRefreshToken<PictureFrame, FrameAuthenticationRepository>(
      userAuthenticationRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => InvalidateAllRefreshTokens<Curator, CuratorAuthenticationRepository>(
      userAuthenticationRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () =>
        InvalidateAllRefreshTokens<PictureFrame, FrameAuthenticationRepository>(
      userAuthenticationRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => CheckRefreshTokenValidityWrapper<Curator,
        CuratorAuthenticationRepository>(
      userAuthRepository: getIt(),
      basicAuthRepository: getIt(),
      isTokenExpiredUseCase: getIt(),
      getUserWithType: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => CheckRefreshTokenValidityWrapper<PictureFrame,
        FrameAuthenticationRepository>(
      userAuthRepository: getIt(),
      basicAuthRepository: getIt(),
      isTokenExpiredUseCase: getIt(),
      getUserWithType: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => CreateCurator(createCurator: getIt()));
  getIt.registerLazySingleton(
      () => CreatePictureFrame(creaPictureFrame: getIt()));
  getIt.registerLazySingleton(
    () => PairCuratorXFrame(
        imageExchangeRepository: getIt(),
        curatorAuthenticationRepository: getIt(),
        frameAuthenticationRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => IsTokenExpired(
      clock: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => CreateUserWrapper<Curator, CuratorAuthenticationRepository>(
      isUsernameValid: getIt(),
      isPasswordValid: getIt(),
      userAuthRepository: getIt(),
      basicAuthRepository: getIt(),
      cryptoRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => CreateUserWrapper<PictureFrame, FrameAuthenticationRepository>(
      isUsernameValid: getIt(),
      isPasswordValid: getIt(),
      userAuthRepository: getIt(),
      basicAuthRepository: getIt(),
      cryptoRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => const IsUsernameValid());
  getIt.registerLazySingleton(() => const IsPasswordValid());

  getIt.registerLazySingleton(
      () => GetUserWithType<Curator, CuratorAuthenticationRepository>(
            userAuthenticationRepository: getIt(),
          ));
  getIt.registerLazySingleton(
    () => GetUserWithType<PictureFrame, FrameAuthenticationRepository>(
      userAuthenticationRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => CheckFrameAccessTokenValidity(
      basicAuthRepository: getIt(),
      isTokenExpiredUseCase: getIt(),
      getUserWithType: getIt(),
      frameAuthenticationRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => CheckCuratorAccessTokenValidity(
      basicAuthRepository: getIt(),
      isTokenExpiredUseCase: getIt(),
      getUserWithType: getIt(),
      curatorAuthenticationRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => ReceiveImageFromCurator(
      imageExchangeRepository: getIt(),
      cryptoRepository: getIt(),
      clock: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignInWrapper<PictureFrame, FrameAuthenticationRepository>(
      userAuthRepository: getIt(),
      basicAuthRepository: getIt(),
      generateAccessToken: getIt(),
      generateRefreshToken: getIt(),
      saveRefreshTokenUsecase: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignInWrapper<Curator, CuratorAuthenticationRepository>(
      userAuthRepository: getIt(),
      basicAuthRepository: getIt(),
      generateAccessToken: getIt(),
      generateRefreshToken: getIt(),
      saveRefreshTokenUsecase: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => SaveRefreshToken<Curator, UserAuthenticationRepository<Curator>>(
      userAuthenticationRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => SaveRefreshToken<PictureFrame, FrameAuthenticationRepository>(
      userAuthenticationRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => SignInPictureFrame(signInPictureFrame: getIt()),
  );
  getIt.registerLazySingleton(
    () => SignInCurator(
      signInCurator: getIt(),
    ),
  );
  getIt.registerFactory(
    () => GenerateAccessToken(
      basicAuthRepository: getIt(),
      secrets: getIt(),
      clock: getIt(),
    ),
  );
  getIt.registerFactory(
    () => GenerateRefreshToken(
      basicAuthRepository: getIt(),
      cryptoRepository: getIt(),
      secrets: getIt(),
      clock: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetLatestImage(imageExchangeRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetImageFromId(imageExchangeRepository: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<BasicAuthenticationRepository>(
    () => BasicAuthenticationRepositoryImpl(
      basicAuthLocalDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<ImageExchangeRepository>(
    () => ImageExchangeRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton<CryptoRepository>(
    () => CryptoRepositoryImpl(
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<CuratorAuthenticationRepository>(
    () => UserAuthenticationRepositoryImpl<Curator>(
      userAuthLocalDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<FrameAuthenticationRepository>(
    () => UserAuthenticationRepositoryImpl<PictureFrame>(
      userAuthLocalDataSource: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<BasicAuthLocalDataSource>(
    () => BasicAuthLocalDataSourceImpl(
      cryptoWrapper: getIt(),
      utf8Encoder: getIt(),
      jweBuilderWrapper: getIt(),
      secrets: getIt(),
    ),
  );
  getIt.registerLazySingleton<CryptoLocalDataSource>(
    () => CryptoLocalDataSourceImpl(uuid: getIt()),
  );
  getIt.registerLazySingleton<ImageExchangeLocalDataSource>(
    () => ImageExchangeLocalDataSourceImpl(
      sqliteDatabase: getIt(),
      imageDirectoryPath: imageDirectoryPath,
    ),
  );
  getIt.registerLazySingleton<CuratorAuthLocalDataSource>(
    () => UserAuthLocalDataSourceImpl<Curator>(
      sqliteDatabase: getIt(),
      userTableNames: getIt(),
      refreshTokenTableNames: getIt(),
    ),
  );
  getIt.registerLazySingleton<FrameAuthLocalDataSource>(
    () => UserAuthLocalDataSourceImpl<PictureFrame>(
      sqliteDatabase: getIt(),
      userTableNames: getIt(),
      refreshTokenTableNames: getIt(),
    ),
  );

  // Table names
  getIt.registerLazySingleton<UserTable<Curator>>(
    () => const CuratorTable(),
  );
  getIt.registerLazySingleton<UserRefreshTokenTable<Curator>>(
    () => const CuratorRefreshTokenTable(),
  );
  getIt.registerLazySingleton<UserTable<PictureFrame>>(
    () => const PictureFrameTable(),
  );
  getIt.registerLazySingleton<UserRefreshTokenTable<PictureFrame>>(
    () => const FrameRefreshTokenTable(),
  );
  // External
  // await _registerDatabase();
  getIt.registerLazySingleton<Clock>(Clock.new);
  getIt.registerLazySingleton(CryptoWrapper.new);
  getIt.registerLazySingleton(Uuid.new);
  getIt.registerLazySingleton(Utf8Encoder.new);
  getIt.registerLazySingleton(JWEBuilderWrapper.new);
}

Future<void> _registerDatabase() async {
  final Database database =
      await databaseFactoryFfi.openDatabase("dispatch_pi.db");

  print(database.path);

  await database.execute(
    """
      CREATE TABLE IF NOT EXISTS curators (
      curator_id VARCHAR(255) PRIMARY KEY,
      username VARCHAR(255) NOT NULL,
      password_hash VARCHAR(255) NOT NULL)
      """,
  );

  await database.execute(
    """
      CREATE TABLE IF NOT EXISTS picture_frames (
      frame_id VARCHAR(255) PRIMARY KEY,
      username VARCHAR(255) NOT NULL,
      password_hash VARCHAR(255) NOT NULL)
      """,
  );

  await database.execute(
    """
      CREATE TABLE IF NOT EXISTS images (
      image_id VARCHAR(255) PRIMARY KEY,
      frame_id VARCHAR(255) NOT NULL,
      curator_id VARCHAR(255) NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (frame_id) REFERENCES frames (frame_id),
      FOREIGN KEY (curator_id) REFERENCES curators (curator_id))
      """,
  );

  await database.execute(
    """
      CREATE TABLE IF NOT EXISTS curator_x_frame (
      curator_id VARCHAR(255) NOT NULL,
      frame_id VARCHAR(255) NOT NULL,
      FOREIGN KEY (curator_id) REFERENCES curators (curator_id),
      FOREIGN KEY (frame_id) REFERENCES frames (frame_id))
      """,
  );

  //curator_refresh_tokens
  await database.execute(
    """
      CREATE TABLE IF NOT EXISTS curator_refresh_tokens (
      curator_id VARCHAR(255) NOT NULL,
      refresh_token VARCHAR(255) NOT NULL,
      FOREIGN KEY (curator_id) REFERENCES curators (curator_id))
      """,
  );

  //frame_refresh_tokens
  await database.execute(
    """
      CREATE TABLE IF NOT EXISTS picture_frame_refresh_tokens (
      frame_id VARCHAR(255) NOT NULL,
      refresh_token VARCHAR(255) NOT NULL,
      FOREIGN KEY (frame_id) REFERENCES frames (frame_id))
      """,
  );

  getIt.registerSingleton<Database>(database);
}
