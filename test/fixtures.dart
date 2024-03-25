import 'package:einblicke_server/core/db_names.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/encrypted_token.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_claims/access_token_claims.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_claims/refresh_token_claims.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/paired_frame_info.dart';
import 'package:jose/jose.dart';

import 'mocks.dart';
import 'secrets_fixture.dart';

// User
const String tUserId = "testUserId";

const String tPassword = "testPassword1-";
const String tPasswordHash = "testPasswordHash";
const String tAnotherPasswordHash = "testAnotherPasswordHash";

const String tUsername = "testUsername";
const String tAnotherUsername = "testAnotherUsername";
const String tInvalidUsername = "invalsadasdasd@#213idUsername";
const String tInvalidPassword =
    "invaosjdfpowjr2390jr03ofnms@li@#dasdasdPassword";

final Type tUserType = tCurator.runtimeType;

const String tAccessToken = "testAccessToken";
const String tRefreshToken = "testRefreshToken";
const String tAnotherRefreshToken = "testRefreshToken";
const String tTokenId = "testTokenId";

TokenBundle tAuthenticationCredentials = TokenBundle(
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

typedef InvalidUserType = String;

final AccessTokenClaims tInvalidUserTypeAccessTokenClaims = AccessTokenClaims(
  userId: tUserId,
  userType: InvalidUserType,
  issuedAt: tIssuedAt,
  expiresAt: tValidExpiresAt,
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

final JsonWebKey tJsonWebKey = JsonWebKey.fromJson(tSecrets.jsonWebKey);

final Map<String, String> tAccessTokenClaimsMap = {
  "user_id": tUserId,
  "user_type": "MockUser",
  "issued_at": tIssuedAt.toIso8601String(),
  "expires_at": tValidExpiresAt.toIso8601String(),
};

final Map<String, String> tRefreshTokenClaimsMap = {
  "token_id": tTokenId,
  "user_id": tUserId,
  "user_type": "MockUser",
  "issued_at": tIssuedAt.toIso8601String(),
  "expires_at": tIssuedAt
      .add(
        tSecrets.refreshTokenLifetime,
      )
      .toIso8601String(),
};

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
const String tAnotherCuratorId = "testAnotherCuratorId";

const Curator tCurator = Curator(
  userId: tCuratorId,
  username: tUsername,
  passwordHash: tPasswordHash,
);

// PictureFrame
const String tPictureFrameId = "testPictureFrameId";
const String tPictureFrameId2 = "testPictureFrameId2";

const Frame tPictureFrame = Frame(
  userId: tPictureFrameId,
  username: tUsername,
  passwordHash: tPasswordHash,
);

const Frame tPictureFrame2 = Frame(
  userId: tPictureFrameId2,
  username: tAnotherUsername,
  passwordHash: tPasswordHash,
);

// Image Exchange
const List<int> tImageBytes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

final DateTime tCreatedAt = DateTime(2013, 5, 25, 17, 15);

const String tImageId = "testImageId";
const String tSecondImageId = "testSecondImageId";
const String tThirdImageId = "testThirdImageId";

const Image tImage = Image(
  imageId: tImageId,
  imageBytes: tImageBytes,
);

const Image tSecondImage = Image(
  imageId: tSecondImageId,
  imageBytes: tImageBytes,
);

const Image tThirdImage = Image(
  imageId: tThirdImageId,
  imageBytes: tImageBytes,
);

const String tUuidString = "testUuidString";

const String tImageFileExtension = "jpg";
const String tImageDirectoryPath = "testImageDirectoryPath";
const String tImageFilePath =
    "$tImageDirectoryPath/$tImageId.$tImageFileExtension";

final List<Map<String, Object?>> tMockResultSet = [];

const CuratorTable tCuratorTable = CuratorTable();

final List<Map<String, Object?>> tDbCuratorRow = [];
//  Row(
//   ResultSet(
//     [
//       tCuratorTable.userId,
//       tCuratorTable.username,
//       tCuratorTable.passwordHash,
//     ],
//     [tCuratorTable.tableName],
//     [
//       [
//         tCurator.userId,
//         tCurator.username,
//         tCurator.passwordHash,
//       ],
//     ],
//   ),
//   [
//     tCurator.userId,
//     tCurator.username,
//     tCurator.passwordHash,
//   ],
// );

final List<Map<String, Object?>> tEmptyDbRow = [];

// Image Exchange
const List<String> tPairedFrameIds = [tPictureFrameId, tPictureFrameId2];
final List<PairedFrameInfo> tPairedFrameInfos = [
  PairedFrameInfo(
    id: tPictureFrameId,
    name: tUsername,
  ),
  PairedFrameInfo(
    id: tPictureFrameId2,
    name: tAnotherUsername,
  ),
];
