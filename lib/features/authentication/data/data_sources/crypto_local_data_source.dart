/// {@template crypto_local_data_source}
/// Local data source for crypto related operations
/// {@endtemplate}
abstract class CryptoLocalDataSource {
  /// {@macro crypto_local_data_source}
  const CryptoLocalDataSource();

  /// Generates a UUID
  ///
  /// Returns:
  /// - a [String] containing the UUID
  String generateUuid();
}
