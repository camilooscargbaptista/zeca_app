import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../domain/entities/journey_segment_entity.dart';

/// Tela que exibe os detalhes completos de todos os trechos de uma jornada
class JourneySegmentsPage extends StatefulWidget {
  final String journeyId;

  const JourneySegmentsPage({
    Key? key,
    required this.journeyId,
  }) : super(key: key);

  @override
  State<JourneySegmentsPage> createState() => _JourneySegmentsPageState();
}

class _JourneySegmentsPageState extends State<JourneySegmentsPage> {
  List<JourneySegmentEntity>? _segments;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSegments();
  }

  Future<void> _loadSegments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getJourneySegments(widget.journeyId);

      if (response['success'] == true) {
        final segmentsData = response['data']['segments'] as List?;
        
        if (segmentsData != null) {
          final segments = segmentsData.map((json) {
            return JourneySegmentEntity(
              id: json['id'] as String,
              journeyId: json['journey_id'] as String,
              segmentNumber: json['segment_number'] as int,
              startTime: DateTime.parse(json['start_time'] as String),
              endTime: json['end_time'] != null 
                  ? DateTime.parse(json['end_time'] as String) 
                  : null,
              startLatitude: (json['start_latitude'] as num).toDouble(),
              startLongitude: (json['start_longitude'] as num).toDouble(),
              endLatitude: json['end_latitude'] != null 
                  ? (json['end_latitude'] as num).toDouble() 
                  : null,
              endLongitude: json['end_longitude'] != null 
                  ? (json['end_longitude'] as num).toDouble() 
                  : null,
              distanceKm: (json['distance_km'] as num).toDouble(),
              durationSeconds: json['duration_seconds'] as int,
              avgSpeedKmh: json['avg_speed_kmh'] != null 
                  ? (json['avg_speed_kmh'] as num).toDouble() 
                  : null,
              maxSpeedKmh: json['max_speed_kmh'] != null 
                  ? (json['max_speed_kmh'] as num).toDouble() 
                  : null,
              maxSpeedLatitude: json['max_speed_latitude'] != null 
                  ? (json['max_speed_latitude'] as num).toDouble() 
                  : null,
              maxSpeedLongitude: json['max_speed_longitude'] != null 
                  ? (json['max_speed_longitude'] as num).toDouble() 
                  : null,
              locationPointsCount: json['location_points_count'] as int,
              createdAt: DateTime.parse(json['created_at'] as String),
              updatedAt: DateTime.parse(json['updated_at'] as String),
            );
          }).toList();

          setState(() {
            _segments = segments;
            _isLoading = false;
          });
        } else {
          setState(() {
            _segments = [];
            _isLoading = false;
          });
        }
      } else {
        throw Exception(response['error'] ?? 'Erro ao carregar trechos');
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar trechos: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Erro',
          message: 'Não foi possível carregar os trechos da jornada.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trechos da Jornada'),
        backgroundColor: AppColors.zecaBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.zecaBlue,
        ),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_segments == null || _segments!.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSegmentsList();
  }

  Widget _buildSegmentsList() {
    return RefreshIndicator(
      onRefresh: _loadSegments,
      color: AppColors.zecaBlue,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _segments!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final segment = _segments![index];
          return _buildSegmentCard(segment);
        },
      ),
    );
  }

  Widget _buildSegmentCard(JourneySegmentEntity segment) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: segment.isActive 
              ? AppColors.zecaBlue.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: segment.isActive ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header do trecho
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.zecaBlue,
                        AppColors.zecaBlue.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.zecaBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${segment.segmentNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trecho ${segment.segmentNumber}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${segment.formattedStartTime} - ${segment.formattedEndTime}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge de duração
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: segment.isActive 
                        ? Colors.green[50]
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: segment.isActive 
                            ? Colors.green[700]
                            : Colors.blue[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        segment.formattedDuration,
                        style: TextStyle(
                          color: segment.isActive 
                              ? Colors.green[700]
                              : Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Métricas principais
            Row(
              children: [
                Expanded(
                  child: _buildMetric(
                    icon: Icons.route,
                    label: 'Distância',
                    value: segment.formattedDistance,
                    color: AppColors.zecaBlue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetric(
                    icon: Icons.my_location,
                    label: 'Pontos GPS',
                    value: '${segment.locationPointsCount}',
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            // Velocidades (se disponíveis)
            if (segment.avgSpeedKmh != null || segment.maxSpeedKmh != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (segment.avgSpeedKmh != null)
                    Expanded(
                      child: _buildMetric(
                        icon: Icons.speed,
                        label: 'Velocidade Média',
                        value: segment.formattedAvgSpeed,
                        color: Colors.blue,
                      ),
                    ),
                  if (segment.avgSpeedKmh != null && segment.maxSpeedKmh != null)
                    const SizedBox(width: 16),
                  if (segment.maxSpeedKmh != null)
                    Expanded(
                      child: _buildMetric(
                        icon: Icons.speed,
                        label: 'Velocidade Máxima',
                        value: segment.formattedMaxSpeed,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ],

            // Badge de status ativo
            if (segment.isActive) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_car, size: 16, color: Colors.green[700]),
                    const SizedBox(width: 6),
                    Text(
                      'Trecho em andamento',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color.withOpacity(0.7)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum trecho disponível',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Os trechos serão criados durante a jornada',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Erro ao carregar trechos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Erro desconhecido',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSegments,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.zecaBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

