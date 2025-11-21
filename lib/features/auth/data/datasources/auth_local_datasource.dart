import 'package:injectable/injectable.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;
  
  AuthLocalDataSourceImpl(this._storageService);
  
  @override
  Future<void> cacheUser(UserModel user) async {
    await _storageService.saveUserData(user.toJson());
  }
  
  @override
  Future<UserModel?> getCachedUser() async {
    final data = _storageService.getUserData();
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }
  
  @override
  Future<void> clearCache() async {
    await _storageService.clearUserData();
  }
}
