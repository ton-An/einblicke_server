import 'package:dispatch_pi_dart/domain/models/curator.dart';
import 'package:dispatch_pi_dart/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/domain/models/picture_frame.dart';

const String tUsername = "testUsername";
const String tPassword = "testPassword1-";

const String tInvalidUsername = "invalsadasdasd@#213idUsername";
const String tInvalidPassword =
    "invaosjdfpowjr2390jr03ofnms@li@#dasdasdPassword";

const String tPasswordHash = "testPasswordHash";

const String tCuratorId = "testCuratorId";

const Curator tCurator = Curator(
  curatorId: tCuratorId,
  username: tUsername,
  passwordHash: tPasswordHash,
);

const String tUserId = "testUserId";

const String tPictureFrameId = "testPictureFrameId";

const PictureFrame tPictureFrame = PictureFrame(
  pictureFrameId: tPictureFrameId,
  username: tUsername,
  passwordHash: tPasswordHash,
);

const String tAccessToken = "testAccessToken";
const String tRefreshToken = "testRefreshToken";

const int tExpiresIn = 123456;
const String tToken = "testToken";
const String tPayload = "testPayload";
const String tEncryptedTokenString = "testEncryptedTokenString";
const EncryptedToken tEncryptedToken = EncryptedToken(
  token: tEncryptedTokenString,
  expiresIn: tExpiresIn,
);
