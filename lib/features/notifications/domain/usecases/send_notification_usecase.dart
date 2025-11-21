import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

@injectable
class SendNotificationUseCase {
  final NotificationRepository repository;

  SendNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String titulo,
    required String mensagem,
    required String tipo,
    required NotificationPriority prioridade,
    String? userId,
    String? refuelingId,
    String? vehicleId,
    NotificationAction? acao,
    Map<String, dynamic>? dadosExtras,
    String? imagemUrl,
  }) async {
    return await repository.sendNotification(
      titulo: titulo,
      mensagem: mensagem,
      tipo: tipo,
      prioridade: prioridade,
      userId: userId,
      refuelingId: refuelingId,
      vehicleId: vehicleId,
      acao: acao,
      dadosExtras: dadosExtras,
      imagemUrl: imagemUrl,
    );
  }
}
