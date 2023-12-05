import 'package:dispatch_pi_dart/features/authentication/domain/models/access_token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/authentication_credentials.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/refresh_token_claims.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';

import 'mocks.dart';
import 'secrets_fixture.dart';

// User
const String tUserId = "testUserId";

const String tPassword = "testPassword1-";
const String tPasswordHash = "testPasswordHash";

const String tUsername = "testUsername";
const String tInvalidUsername = "invalsadasdasd@#213idUsername";
const String tInvalidPassword =
    "invaosjdfpowjr2390jr03ofnms@li@#dasdasdPassword";

final Type tUserType = tCurator.runtimeType;

const String tAccessToken = "testAccessToken";
const String tRefreshToken = "testRefreshToken";
const String tTokenId = "testTokenId";

AuthenticationCredentials tAuthenticationCredentials =
    AuthenticationCredentials(
  accessToken: tEncryptedAccessToken,
  refreshToken: tEncryptedRefreshToken,
);

DateTime tIssuedAt = DateTime(2013, 5, 25, 17, 15);
DateTime tInvalidExpiresAt = DateTime(2013, 5, 25, 17, 45);
DateTime tCurrentTime = DateTime(2013, 5, 25, 18, 0);
DateTime tValidExpiresAt = DateTime(2013, 5, 25, 18, 15);

final AccessTokenClaims tAccessTokenClaims = AccessTokenClaims(
  userId: tUserId,
  userType: MockUser().runtimeType,
  issuedAt: tIssuedAt,
  expiresAt: tIssuedAt.add(
    tSecrets.accessTokenLifetime,
  ),
);

final AccessTokenClaims tExpiredAccessTokenClaims = AccessTokenClaims(
  userId: tUserId,
  userType: MockUser().runtimeType,
  issuedAt: tIssuedAt,
  expiresAt: tInvalidExpiresAt,
);

final RefreshTokenClaims tRefreshTokenClaims = RefreshTokenClaims(
  tokenId: tTokenId,
  userId: tUserId,
  userType: MockUser().runtimeType,
  issuedAt: tIssuedAt,
  expiresAt: tIssuedAt.add(
    tSecrets.refreshTokenLifetime,
  ),
);

const String tTokenString = "testTokenString";

EncryptedToken tEncryptedToken = EncryptedToken(
  token: tTokenString,
  expiresAt: tValidExpiresAt,
);
EncryptedToken tEncryptedAccessToken = EncryptedToken(
  token: tAccessToken,
  expiresAt: tValidExpiresAt,
);
EncryptedToken tEncryptedRefreshToken = EncryptedToken(
  token: tRefreshToken,
  expiresAt: tIssuedAt.add(
    tSecrets.refreshTokenLifetime,
  ),
);

// Curator
const String tCuratorId = "testCuratorId";

const Curator tCurator = Curator(
  userId: tCuratorId,
  username: tUsername,
  passwordHash: tPasswordHash,
);

// PictureFrame
const String tPictureFrameId = "testPictureFrameId";

const PictureFrame tPictureFrame = PictureFrame(
  userId: tPictureFrameId,
  username: tUsername,
  passwordHash: tPasswordHash,
);

// Image Exchange
const List<int> tImageBytes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

final DateTime tCreatedAt = DateTime(2013, 5, 25, 17, 15);

const String tImageId = "testImageId";

const Image tImage = Image(
  imageId: tImageId,
  imageBytes: tImageBytes,
);
