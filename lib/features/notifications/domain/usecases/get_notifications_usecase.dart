import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

@injectable
class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call({
    int page = 1,
    int limit = 20,
    String? tipo,
    NotificationStatus? status,
    bool? naoLidas,
  }) async {
    return await repository.getNotifications(
      page: page,
      limit: limit,
      tipo: tipo,
      status: status,
      naoLidas: naoLidas,
    );
  }
}
