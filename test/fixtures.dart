import 'package:dispatch_pi_dart/domain/models/authentication_credentials.dart';
import 'package:dispatch_pi_dart/domain/models/curator.dart';
import 'package:dispatch_pi_dart/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/domain/models/picture_frame.dart';

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

const int tExpiresIn = 123456;
const String tTokenString = "testTokenString";
const String tEncryptedTokenString = "testEncryptedTokenString";
final Map tPayload = {
  'id': tUserId,
  'type': MockUser,
};

const EncryptedToken tEncryptedToken = EncryptedToken(
  token: tEncryptedTokenString,
  expiresIn: tExpiresIn,
);
const EncryptedToken tEncryptedAccessToken = EncryptedToken(
  token: tAccessToken,
  expiresIn: tExpiresIn,
);
const EncryptedToken tEncryptedRefreshToken = EncryptedToken(
  token: tRefreshToken,
  expiresIn: tExpiresIn,
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
