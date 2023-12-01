import 'package:dispatch_pi_dart/domain/models/authentication_credentials.dart';
import 'package:dispatch_pi_dart/domain/models/curator.dart';
import 'package:dispatch_pi_dart/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/domain/models/token_payload.dart';

import 'mocks.dart';

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

const AuthenticationCredentials tAuthenticationCredentials =
    AuthenticationCredentials(
  accessToken: tEncryptedAccessToken,
  refreshToken: tEncryptedRefreshToken,
);

const int tIssuedAt = 1701460426;
const int tExpiresAt = 1701464026;
DateTime tIssuedAtDatetime = DateTime(2013, 5, 25, 17, 0);
DateTime tValidExpiresAt = DateTime(2013, 5, 25, 17, 45);
DateTime tInvalidExpiresAt = DateTime(2013, 5, 25, 18, 15);
DateTime tCurrentTime = DateTime(2013, 5, 25, 18, 0);

final TokenPayload tTokenPayload = TokenPayload(
  userId: tUserId,
  issuedAt: tIssuedAtDatetime,
  expiresAt: tValidExpiresAt,
);

final TokenPayload tExpiredTokenPayload = TokenPayload(
  userId: tUserId,
  issuedAt: tIssuedAtDatetime,
  expiresAt: tInvalidExpiresAt,
);

const String tTokenString = "testTokenString";
final Map tPayload = {
  'id': tUserId,
  'iat': tIssuedAt,
  'exp': tExpiresAt,
  'type': MockUser,
};

const EncryptedToken tEncryptedToken = EncryptedToken(
  token: tTokenString,
  expiresIn: tExpiresAt,
);
const EncryptedToken tEncryptedAccessToken = EncryptedToken(
  token: tAccessToken,
  expiresIn: tExpiresAt,
);
const EncryptedToken tEncryptedRefreshToken = EncryptedToken(
  token: tRefreshToken,
  expiresIn: tExpiresAt,
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
