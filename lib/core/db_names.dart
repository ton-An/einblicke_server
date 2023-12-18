/// {@template user_table}
/// Abstract class for the names of the user table
/// {@endtemplate}
abstract class UserTable {
  /// {@macro user_table}
  const UserTable({
    required this.tableName,
    required this.userId,
    required this.username,
    required this.passwordHash,
  });

  /// Name of the user table
  final String tableName;

  /// Name of the user id column
  final String userId;

  /// Name of the username column
  final String username;

  /// Name of the password hash column
  final String passwordHash;
}

/// {@template user_refresh_token_table}
/// Abstract class for the names of the user refresh token table
/// {@endtemplate}
abstract class UserRefreshTokenTable {
  /// {@macro user_refresh_token_table}
  const UserRefreshTokenTable({
    required this.tableName,
    required this.userId,
    required this.refreshToken,
  });

  /// Name of the user refresh token table
  final String tableName;

  /// Name of the user id column
  final String userId;

  /// Name of the refresh token column
  final String refreshToken;
}

/// {@template user_table}
/// Wrapper for the names of the curator user table
/// {@endtemplate}
class CuratorTable extends UserTable {
  /// {@macro user_table}
  const CuratorTable()
      : super(
          tableName: "curators",
          userId: "curator_id",
          username: "username",
          passwordHash: "password_hash",
        );
}

/// {@template user_refresh_token_table}
/// Wrapper for the names of the curator refresh token table
/// {@endtemplate}
class CuratorRefreshTokenTable extends UserRefreshTokenTable {
  /// {@macro user_refresh_token_table}
  const CuratorRefreshTokenTable()
      : super(
          tableName: "curator_refresh_tokens",
          userId: "curator_id",
          refreshToken: "refresh_token",
        );
}

/// {@template picture_frame_table}
/// Wrapper for the names of the picture frame user table
/// {@endtemplate}
class PictureFrameTable extends UserTable {
  /// {@macro picture_frame_table}
  const PictureFrameTable()
      : super(
          tableName: "picture_frames",
          userId: "frame_id",
          username: "username",
          passwordHash: "password_hash",
        );
}

/// {@template frame_refresh_token_table}
/// Wrapper for the names of the picture frame refresh token table
/// {@endtemplate}
class FrameRefreshTokenTable extends UserRefreshTokenTable {
  /// {@macro frame_refresh_token_table}
  const FrameRefreshTokenTable()
      : super(
          tableName: "picture_frame_refresh_tokens",
          userId: "frame_id",
          refreshToken: "refresh_token",
        );
}
