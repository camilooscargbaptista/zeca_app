import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_settings_entity.dart';
import '../repositories/notification_repository.dart';

@injectable
class UpdateNotificationSettingsUseCase {
  final NotificationRepository repository;

  UpdateNotificationSettingsUseCase(this.repository);

  Future<Either<Failure, NotificationSettingsEntity>> call(
    NotificationSettingsEntity settings,
  ) async {
    return await repository.updateNotificationSettings(settings);
  }
}
