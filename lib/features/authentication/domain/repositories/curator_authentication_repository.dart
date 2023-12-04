import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';

/// {@template curator_authentication_repository}
/// Repository for curator authentication
/// {@endtemplate}
abstract class CuratorAuthenticationRepository
    extends UserAuthenticationRepository<Curator> {
  /// {@macro curator_authentication_repository}
  const CuratorAuthenticationRepository();
}
