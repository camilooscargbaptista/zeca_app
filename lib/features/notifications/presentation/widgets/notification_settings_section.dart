import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/notification_settings_entity.dart';
import '../bloc/notification_bloc.dart';
import '../../../../core/config/flavor_config.dart';

class NotificationSettingsSection extends StatefulWidget {
  final NotificationSettingsEntity? settings;
  final Function(NotificationSettingsEntity)? onSettingsChanged;

  const NotificationSettingsSection({
    Key? key,
    this.settings,
    this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<NotificationSettingsSection> createState() => _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState extends State<NotificationSettingsSection> {
  late NotificationSettingsEntity _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings ?? _getDefaultSettings();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationSettingsUpdated) {
          setState(() {
            _currentSettings = state.settings;
          });
          widget.onSettingsChanged?.call(state.settings);
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configurações de Notificação',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Configurações gerais
              _buildGeneralSettings(context),
              const SizedBox(height: 24),

              // Configurações por tipo
              _buildTypeSettings(context),
              const SizedBox(height: 24),

              // Configurações de horário
              _buildTimeSettings(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configurações Gerais',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        SwitchListTile(
          title: const Text('Notificações Push'),
          subtitle: const Text('Receber notificações no dispositivo'),
          value: _currentSettings.pushEnabled,
          onChanged: (value) => _updateGeneralSetting('push', value),
          activeColor: FlavorConfig.instance.primaryColor,
        ),
        
        SwitchListTile(
          title: const Text('Notificações por Email'),
          subtitle: const Text('Receber notificações por email'),
          value: _currentSettings.emailEnabled,
          onChanged: (value) => _updateGeneralSetting('email', value),
          activeColor: FlavorConfig.instance.primaryColor,
        ),
        
        SwitchListTile(
          title: const Text('Notificações por SMS'),
          subtitle: const Text('Receber notificações por SMS'),
          value: _currentSettings.smsEnabled,
          onChanged: (value) => _updateGeneralSetting('sms', value),
          activeColor: FlavorConfig.instance.primaryColor,
        ),
      ],
    );
  }

  Widget _buildTypeSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipos de Notificação',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        _buildTypeSetting(
          context,
          'Abastecimento',
          Icons.local_gas_station,
          _currentSettings.refueling,
          (settings) => _updateTypeSetting('refueling', settings),
        ),
        _buildTypeSetting(
          context,
          'Veículo',
          Icons.directions_car,
          _currentSettings.vehicle,
          (settings) => _updateTypeSetting('vehicle', settings),
        ),
        _buildTypeSetting(
          context,
          'Sistema',
          Icons.settings,
          _currentSettings.system,
          (settings) => _updateTypeSetting('system', settings),
        ),
        _buildTypeSetting(
          context,
          'Promoções',
          Icons.local_offer,
          _currentSettings.promotion,
          (settings) => _updateTypeSetting('promotion', settings),
        ),
        _buildTypeSetting(
          context,
          'Manutenção',
          Icons.build,
          _currentSettings.maintenance,
          (settings) => _updateTypeSetting('maintenance', settings),
        ),
        _buildTypeSetting(
          context,
          'Segurança',
          Icons.security,
          _currentSettings.security,
          (settings) => _updateTypeSetting('security', settings),
        ),
        _buildTypeSetting(
          context,
          'Pagamento',
          Icons.payment,
          _currentSettings.payment,
          (settings) => _updateTypeSetting('payment', settings),
        ),
        _buildTypeSetting(
          context,
          'Lembretes',
          Icons.schedule,
          _currentSettings.reminder,
          (settings) => _updateTypeSetting('reminder', settings),
        ),
      ],
    );
  }

  Widget _buildTypeSetting(
    BuildContext context,
    String title,
    IconData icon,
    NotificationTypeSettings settings,
    Function(NotificationTypeSettings) onChanged,
  ) {
    return ExpansionTile(
      leading: Icon(icon, color: FlavorConfig.instance.primaryColor),
      title: Text(title),
      trailing: Switch(
        value: settings.enabled,
        onChanged: (value) => onChanged(settings.copyWith(enabled: value)),
        activeColor: FlavorConfig.instance.primaryColor,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              if (settings.enabled) ...[
                SwitchListTile(
                  title: const Text('Push'),
                  value: settings.push,
                  onChanged: (value) => onChanged(settings.copyWith(push: value)),
                  activeColor: FlavorConfig.instance.primaryColor,
                ),
                SwitchListTile(
                  title: const Text('Email'),
                  value: settings.email,
                  onChanged: (value) => onChanged(settings.copyWith(email: value)),
                  activeColor: FlavorConfig.instance.primaryColor,
                ),
                SwitchListTile(
                  title: const Text('SMS'),
                  value: settings.sms,
                  onChanged: (value) => onChanged(settings.copyWith(sms: value)),
                  activeColor: FlavorConfig.instance.primaryColor,
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('Prioridade Mínima'),
                  subtitle: Text(_getPriorityLabel(settings.minPriority)),
                  trailing: DropdownButton<NotificationPriority>(
                    value: settings.minPriority,
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(settings.copyWith(minPriority: value));
                      }
                    },
                    items: NotificationPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.label),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configurações de Horário',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        SwitchListTile(
          title: const Text('Respeitar Horário Comercial'),
          subtitle: const Text('Só enviar notificações em horário comercial'),
          value: _currentSettings.horarios.respeitarHorarioComercial,
          onChanged: (value) => _updateTimeSetting('respeitarHorarioComercial', value),
          activeColor: FlavorConfig.instance.primaryColor,
        ),
        
        if (_currentSettings.horarios.respeitarHorarioComercial) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Início'),
                  subtitle: Text('${_currentSettings.horarios.horaInicio.toString().padLeft(2, '0')}:${_currentSettings.horarios.minutoInicio.toString().padLeft(2, '0')}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _selectTime(context, true),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('Fim'),
                  subtitle: Text('${_currentSettings.horarios.horaFim.toString().padLeft(2, '0')}:${_currentSettings.horarios.minutoFim.toString().padLeft(2, '0')}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _selectTime(context, false),
                  ),
                ),
              ),
            ],
          ),
        ],
        
        SwitchListTile(
          title: const Text('Pausar Notificações'),
          subtitle: const Text('Pausar temporariamente todas as notificações'),
          value: _currentSettings.horarios.pausarNotificacoes,
          onChanged: (value) => _updateTimeSetting('pausarNotificacoes', value),
          activeColor: FlavorConfig.instance.primaryColor,
        ),
      ],
    );
  }

  void _updateGeneralSetting(String type, bool value) {
    setState(() {
      switch (type) {
        case 'push':
          _currentSettings = _currentSettings.copyWith(pushEnabled: value);
          break;
        case 'email':
          _currentSettings = _currentSettings.copyWith(emailEnabled: value);
          break;
        case 'sms':
          _currentSettings = _currentSettings.copyWith(smsEnabled: value);
          break;
      }
    });
    _saveSettings();
  }

  void _updateTypeSetting(String type, NotificationTypeSettings settings) {
    setState(() {
      switch (type) {
        case 'refueling':
          _currentSettings = _currentSettings.copyWith(refueling: settings);
          break;
        case 'vehicle':
          _currentSettings = _currentSettings.copyWith(vehicle: settings);
          break;
        case 'system':
          _currentSettings = _currentSettings.copyWith(system: settings);
          break;
        case 'promotion':
          _currentSettings = _currentSettings.copyWith(promotion: settings);
          break;
        case 'maintenance':
          _currentSettings = _currentSettings.copyWith(maintenance: settings);
          break;
        case 'security':
          _currentSettings = _currentSettings.copyWith(security: settings);
          break;
        case 'payment':
          _currentSettings = _currentSettings.copyWith(payment: settings);
          break;
        case 'reminder':
          _currentSettings = _currentSettings.copyWith(reminder: settings);
          break;
      }
    });
    _saveSettings();
  }

  void _updateTimeSetting(String type, dynamic value) {
    setState(() {
      switch (type) {
        case 'respeitarHorarioComercial':
          _currentSettings = _currentSettings.copyWith(
            horarios: _currentSettings.horarios.copyWith(
              respeitarHorarioComercial: value,
            ),
          );
          break;
        case 'pausarNotificacoes':
          _currentSettings = _currentSettings.copyWith(
            horarios: _currentSettings.horarios.copyWith(
              pausarNotificacoes: value,
            ),
          );
          break;
      }
    });
    _saveSettings();
  }

  void _saveSettings() {
    context.read<NotificationBloc>().add(UpdateNotificationSettings(_currentSettings));
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStart
          ? TimeOfDay(
              hour: _currentSettings.horarios.horaInicio,
              minute: _currentSettings.horarios.minutoInicio,
            )
          : TimeOfDay(
              hour: _currentSettings.horarios.horaFim,
              minute: _currentSettings.horarios.minutoFim,
            ),
    );

    if (time != null) {
      setState(() {
        if (isStart) {
          _currentSettings = _currentSettings.copyWith(
            horarios: _currentSettings.horarios.copyWith(
              horaInicio: time.hour,
              minutoInicio: time.minute,
            ),
          );
        } else {
          _currentSettings = _currentSettings.copyWith(
            horarios: _currentSettings.horarios.copyWith(
              horaFim: time.hour,
              minutoFim: time.minute,
            ),
          );
        }
      });
      _saveSettings();
    }
  }

  String _getPriorityLabel(NotificationPriority priority) {
    return priority.label;
  }

  NotificationSettingsEntity _getDefaultSettings() {
    return NotificationSettingsEntity(
      userId: '',
      pushEnabled: true,
      emailEnabled: false,
      smsEnabled: false,
      refueling: const NotificationTypeSettings(
        enabled: true,
        push: true,
        email: false,
        sms: false,
        minPriority: NotificationPriority.media,
      ),
      vehicle: const NotificationTypeSettings(
        enabled: true,
        push: true,
        email: false,
        sms: false,
        minPriority: NotificationPriority.media,
      ),
      system: const NotificationTypeSettings(
        enabled: true,
        push: true,
        email: true,
        sms: false,
        minPriority: NotificationPriority.baixa,
      ),
      promotion: const NotificationTypeSettings(
        enabled: true,
        push: true,
        email: false,
        sms: false,
        minPriority: NotificationPriority.baixa,
      ),
      maintenance: const NotificationTypeSettings(
        enabled: true,
        push: true,
        email: true,
        sms: false,
        minPriority: NotificationPriority.media,
      ),
      security: const NotificationTypeSettings(
        enabled: true,
        push: true,
        email: true,
        sms: true,
        minPriority: NotificationPriority.alta,
      ),
      payment: const NotificationTypeSettings(
        enabled: true,
        push: true,
        email: true,
        sms: false,
        minPriority: NotificationPriority.media,
      ),
      reminder: const NotificationTypeSettings(
        enabled: true,
        push: true,
        email: false,
        sms: false,
        minPriority: NotificationPriority.baixa,
      ),
      horarios: const NotificationTimeSettings(
        respeitarHorarioComercial: true,
        horaInicio: 8,
        minutoInicio: 0,
        horaFim: 18,
        minutoFim: 0,
        diasSemana: [1, 2, 3, 4, 5], // Segunda a sexta
        pausarNotificacoes: false,
      ),
      atualizadoEm: DateTime.now(),
    );
  }
}

extension NotificationSettingsEntityExtension on NotificationSettingsEntity {
  NotificationSettingsEntity copyWith({
    String? userId,
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    NotificationTypeSettings? refueling,
    NotificationTypeSettings? vehicle,
    NotificationTypeSettings? system,
    NotificationTypeSettings? promotion,
    NotificationTypeSettings? maintenance,
    NotificationTypeSettings? security,
    NotificationTypeSettings? payment,
    NotificationTypeSettings? reminder,
    NotificationTimeSettings? horarios,
    DateTime? atualizadoEm,
  }) {
    return NotificationSettingsEntity(
      userId: userId ?? this.userId,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      refueling: refueling ?? this.refueling,
      vehicle: vehicle ?? this.vehicle,
      system: system ?? this.system,
      promotion: promotion ?? this.promotion,
      maintenance: maintenance ?? this.maintenance,
      security: security ?? this.security,
      payment: payment ?? this.payment,
      reminder: reminder ?? this.reminder,
      horarios: horarios ?? this.horarios,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}

extension NotificationTypeSettingsExtension on NotificationTypeSettings {
  NotificationTypeSettings copyWith({
    bool? enabled,
    bool? push,
    bool? email,
    bool? sms,
    NotificationPriority? minPriority,
  }) {
    return NotificationTypeSettings(
      enabled: enabled ?? this.enabled,
      push: push ?? this.push,
      email: email ?? this.email,
      sms: sms ?? this.sms,
      minPriority: minPriority ?? this.minPriority,
    );
  }
}

extension NotificationTimeSettingsExtension on NotificationTimeSettings {
  NotificationTimeSettings copyWith({
    bool? respeitarHorarioComercial,
    int? horaInicio,
    int? minutoInicio,
    int? horaFim,
    int? minutoFim,
    List<int>? diasSemana,
    bool? pausarNotificacoes,
    DateTime? pausarAte,
  }) {
    return NotificationTimeSettings(
      respeitarHorarioComercial: respeitarHorarioComercial ?? this.respeitarHorarioComercial,
      horaInicio: horaInicio ?? this.horaInicio,
      minutoInicio: minutoInicio ?? this.minutoInicio,
      horaFim: horaFim ?? this.horaFim,
      minutoFim: minutoFim ?? this.minutoFim,
      diasSemana: diasSemana ?? this.diasSemana,
      pausarNotificacoes: pausarNotificacoes ?? this.pausarNotificacoes,
      pausarAte: pausarAte ?? this.pausarAte,
    );
  }
}
