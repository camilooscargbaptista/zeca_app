import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_settings_entity.dart';
import '../repositories/notification_repository.dart';

@injectable
class GetNotificationSettingsUseCase {
  final NotificationRepository repository;

  GetNotificationSettingsUseCase(this.repository);

  Future<Either<Failure, NotificationSettingsEntity>> call() async {
    return await repository.getNotificationSettings();
  }
}
