/// {@template crypto_repository_source}
/// Repository for crypto related operations
/// {@endtemplate}
abstract class CryptoRepository {
  /// {@macro crypto_repository_source}
  const CryptoRepository();

  /// Generates a UUID
  ///
  /// Returns:
  /// - a [String] containing the UUID
  String generateUuid();
}
