import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_access_token_validity.dart';

/// {@macro check_access_token_validity_wrapper}
class CheckCuratorAccessTokenValidity extends CheckAccessTokenValidityWrapper<
    Curator, CuratorAuthenticationRepository> {
  /// {@macro check_access_token_validity_wrapper}
  const CheckCuratorAccessTokenValidity({
    required super.basicAuthRepository,
    required super.isTokenExpiredUseCase,
    required super.getUserWithType,
    required CuratorAuthenticationRepository curatorAuthenticationRepository,
  }) : super(
          userAuthenticationRepository: curatorAuthenticationRepository,
        );
}
