import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/efficiency_repository.dart';
import '../bloc/efficiency_bloc.dart';
import '../bloc/efficiency_event.dart';
import '../bloc/efficiency_state.dart';
import '../widgets/efficiency_history_item.dart';
import '../widgets/efficiency_summary_card.dart';
import '../widgets/efficiency_vehicle_card.dart';
import '../widgets/efficiency_unit_toggle.dart';

/// Tela principal de Eficiência de Combustível
class EfficiencyPage extends StatelessWidget {
  const EfficiencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EfficiencyBloc(
        repository: EfficiencyRepository(),
      )..add(const LoadVehicleEfficiency()),
      child: const _EfficiencyPageContent(),
    );
  }
}

class _EfficiencyPageContent extends StatelessWidget {
  const _EfficiencyPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.zecaBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Eficiência',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          BlocBuilder<EfficiencyBloc, EfficiencyState>(
            builder: (context, state) {
              final useL100km = state is EfficiencyLoaded ? state.useL100km : false;
              return EfficiencyUnitToggle(
                useL100km: useL100km,
                onToggle: () {
                  context.read<EfficiencyBloc>().add(const ToggleEfficiencyUnit());
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<EfficiencyBloc, EfficiencyState>(
        builder: (context, state) {
          if (state is EfficiencyLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.zecaBlue),
            );
          }

          if (state is EfficiencyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar dados',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EfficiencyBloc>().add(const LoadVehicleEfficiency());
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (state is EfficiencyLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<EfficiencyBloc>().add(const LoadVehicleEfficiency());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Card
                    EfficiencySummaryCard(
                      summary: state.summary,
                      useL100km: state.useL100km,
                    ),
                    const SizedBox(height: 12),

                    // Vehicle Card
                    if (state.vehicle != null) ...[
                      EfficiencyVehicleCard(
                        vehicle: state.vehicle!,
                        useL100km: state.useL100km,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Recent History Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Histórico Recente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.push('/efficiency/history');
                          },
                          child: const Text('Ver todos →'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Recent History List
                    if (state.recentHistory.isEmpty)
                      _buildEmptyHistory()
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: state.recentHistory.map((item) {
                            return EfficiencyHistoryItem(
                              item: item,
                              useL100km: state.useL100km,
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'Nenhum abastecimento registrado',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
