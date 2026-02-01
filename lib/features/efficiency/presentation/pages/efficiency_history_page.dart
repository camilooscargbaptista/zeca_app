import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/efficiency_repository.dart';
import '../bloc/efficiency_bloc.dart';
import '../bloc/efficiency_event.dart';
import '../bloc/efficiency_state.dart';
import '../widgets/efficiency_history_item.dart';
import '../widgets/efficiency_period_filter.dart';

/// Tela de Histórico Completo de Eficiência
class EfficiencyHistoryPage extends StatelessWidget {
  const EfficiencyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EfficiencyBloc(
        repository: EfficiencyRepository(),
      )..add(const LoadRefuelingHistory()),
      child: const _EfficiencyHistoryContent(),
    );
  }
}

class _EfficiencyHistoryContent extends StatelessWidget {
  const _EfficiencyHistoryContent();

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
          'Histórico',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Period Filter
          BlocBuilder<EfficiencyBloc, EfficiencyState>(
            builder: (context, state) {
              final selectedPeriod = state is EfficiencyHistoryLoaded
                  ? state.selectedPeriod
                  : 'month';
              return EfficiencyPeriodFilter(
                selectedPeriod: selectedPeriod,
                onPeriodChanged: (period) {
                  context.read<EfficiencyBloc>().add(FilterHistoryByPeriod(period));
                },
              );
            },
          ),

          // History List
          Expanded(
            child: BlocBuilder<EfficiencyBloc, EfficiencyState>(
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
                        const Text('Erro ao carregar histórico'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.read<EfficiencyBloc>().add(
                              const LoadRefuelingHistory(refresh: true),
                            );
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is EfficiencyHistoryLoaded) {
                  if (state.items.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum abastecimento no período',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scroll) {
                      if (scroll.metrics.pixels >=
                              scroll.metrics.maxScrollExtent - 100 &&
                          state.hasMore &&
                          !state.isLoadingMore) {
                        context.read<EfficiencyBloc>().add(const LoadMoreHistory());
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.zecaBlue,
                              ),
                            ),
                          );
                        }

                        return EfficiencyHistoryItem(
                          item: state.items[index],
                          useL100km: state.useL100km,
                          showDivider: index < state.items.length - 1,
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
