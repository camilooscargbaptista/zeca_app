import 'package:mocktail/mocktail.dart';
import 'package:zeca_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:zeca_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:zeca_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:zeca_app/core/services/api_service.dart';
import 'package:zeca_app/core/services/location_service.dart';
import 'package:zeca_app/core/services/storage_service.dart';
import 'package:zeca_app/core/services/token_manager_service.dart';
import 'package:zeca_app/core/network/dio_client.dart';
import 'package:zeca_app/features/journey/data/services/journey_storage_service.dart';

// ============================================================
// REPOSITORIES MOCKS
// ============================================================

class MockAuthRepository extends Mock implements AuthRepository {}

// ============================================================
// USE CASES MOCKS
// ============================================================

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

// ============================================================
// SERVICES MOCKS
// ============================================================

class MockApiService extends Mock implements ApiService {}
class MockLocationService extends Mock implements LocationService {}
class MockStorageService extends Mock implements StorageService {}
class MockTokenManagerService extends Mock implements TokenManagerService {}
class MockJourneyStorageService extends Mock implements JourneyStorageService {}

// ============================================================
// NETWORK MOCKS
// ============================================================

class MockDioClient extends Mock implements DioClient {}
