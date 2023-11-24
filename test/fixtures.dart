import 'package:dispatch_pi_dart/domain/models/curator.dart';

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
