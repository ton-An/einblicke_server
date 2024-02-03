import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> setUpMockCuratorXFrameTable(Database database) async {
  await database.execute(
    "CREATE TABLE curator_x_frame ("
    "curator_id TEXT, "
    "frame_id TEXT, "
    "PRIMARY KEY (curator_id, frame_id)"
    ")",
  );
}

Future<void> setUpMockImagesTable(Database database) async {
  await database.execute(
    "CREATE TABLE images ("
    "curator_id TEXT, "
    "frame_id TEXT, "
    "image_id TEXT, "
    "created_at TEXT, "
    "PRIMARY KEY (curator_id, frame_id, image_id)"
    ")",
  );
}

Future<void> setUpMockCuratorsTable(Database database) async {
  await database.execute(
    """
      CREATE TABLE curators (
      curator_id VARCHAR(255) PRIMARY KEY,
      username VARCHAR(255) NOT NULL,
      password_hash VARCHAR(255) NOT NULL)
      """,
  );
}

Future<void> setUpMockUserRefreshTokenTable(Database database) async {
  await database.execute(
    """
      CREATE TABLE curator_refresh_tokens (
      curator_id VARCHAR(255) NOT NULL,
      refresh_token VARCHAR(255) NOT NULL,
      FOREIGN KEY (curator_id) REFERENCES curators (curator_id))
      """,
  );
}
