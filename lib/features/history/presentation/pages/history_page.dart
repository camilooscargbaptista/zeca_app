import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/refueling_history_entity.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/refueling_card_widget.dart';
import '../widgets/history_summary_widget.dart';
import '../widgets/history_filters_widget.dart';

/// Página de histórico de abastecimentos refatorada com BLoC
class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HistoryBloc>()..add(const HistoryEvent.loadHistory()),
      child: const _HistoryPageContent(),
    );
  }
}

class _HistoryPageContent extends StatefulWidget {
  const _HistoryPageContent({Key? key}) : super(key: key);

  @override
  State<_HistoryPageContent> createState() => _HistoryPageContentState();
}

class _HistoryPageContentState extends State<_HistoryPageContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HistoryBloc>().add(const HistoryEvent.loadMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Abastecimentos'),
        backgroundColor: AppColors.zecaBlue,
        foregroundColor: AppColors.zecaWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (refuelings, summary, filters, page, total, hasMore, isLoadingMore) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HistoryBloc>().add(const HistoryEvent.refresh());
                  // Aguardar um pouco para o refresh visual
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Filtros
                    SliverToBoxAdapter(
                      child: HistoryFiltersWidget(
                        currentFilters: filters,
                        availablePlates: _extractPlates(refuelings),
                        onApply: (newFilters) {
                          context.read<HistoryBloc>().add(HistoryEvent.applyFilters(newFilters));
                        },
                        onClear: () {
                          context.read<HistoryBloc>().add(const HistoryEvent.clearFilters());
                        },
                      ),
                    ),
                    
                    // Resumo
                    SliverToBoxAdapter(
                      child: HistorySummaryWidget(summary: summary),
                    ),
                    
                    // Lista ou Empty State
                    if (refuelings.isEmpty)
                      SliverFillRemaining(
                        child: _buildEmptyState(filters),
                      )
                    else ...[
                      // Lista de abastecimentos
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final refueling = refuelings[index];
                              return RefuelingCardWidget(
                                refueling: refueling,
                                onTap: () => _navigateToDetails(context, refueling.id),
                              );
                            },
                            childCount: refuelings.length,
                          ),
                        ),
                      ),
                      
                      // Loading indicator para paginação
                      if (isLoadingMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      
                      // Espacamento final
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 16),
                      ),
                    ],
                  ],
                ),
              );
            },
            error: (message, filters) => _buildErrorState(message),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(HistoryFiltersEntity filters) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_gas_station_outlined,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum abastecimento encontrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          if (filters.hasFilters)
            Text(
              'Tente ajustar os filtros',
              style: TextStyle(
                color: AppColors.grey500,
              ),
            )
          else
            Text(
              'Seus abastecimentos aparecerão aqui',
              style: TextStyle(
                color: AppColors.grey500,
              ),
            ),
          if (filters.hasFilters) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<HistoryBloc>().add(const HistoryEvent.clearFilters());
              },
              child: Text(
                'Limpar filtros',
                style: TextStyle(color: AppColors.zecaBlue),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar histórico',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<HistoryBloc>().add(const HistoryEvent.loadHistory());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zecaBlue,
            ),
            child: const Text(
              'Tentar novamente',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context, String refuelingId) {
    context.push('/history/$refuelingId');
  }

  List<String> _extractPlates(List<RefuelingHistoryEntity> refuelings) {
    final plates = refuelings.map((r) => r.vehiclePlate).toSet().toList();
    plates.sort();
    return plates;
  }
}
