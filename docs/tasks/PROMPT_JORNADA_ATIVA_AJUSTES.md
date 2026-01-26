# Prompt para Antigravity: Ajustes na Tela de Jornada Ativa

## Tarefa: Ajustes na Tela de Jornada Ativa (Dashboard)

### Contexto
Na tela "ZECA - Jornada Ativa" (`journey_dashboard_page.dart`), existem 4 ajustes a serem feitos:
1. **🔴 CORRIGIR contagem de abastecimentos no card de economia (BACKEND)**
2. **🔴 CORRIGIR** navegação no card "Histórico" (rota errada!)
3. Adicionar navegação no card "Veículos"
4. Remover o menu de rodapé (BottomNavigationBar)

### ⚠️ INSTRUÇÃO CRÍTICA - VALIDAÇÃO DE BACKEND
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║   🔴 BACKEND PRECISA DE ALTERAÇÃO!                                           ║
║                                                                               ║
║   O endpoint `/drivers/dashboard-summary` NÃO está filtrando corretamente:    ║
║   - Falta filtro por status = 'CONCLUIDO'                                     ║
║   - A lógica de filtro por driver_id é inconsistente com o histórico         ║
║                                                                               ║
║   ARQUIVOS A ALTERAR:                                                         ║
║   - BACKEND: drivers.service.ts → getDashboardSummary()                      ║
║   - FRONTEND: journey_dashboard_page.dart                                     ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝

---

## Git Flow

**Branch:** `fix/jornada-ativa-ajustes-navegacao`
**Base:** `develop`
**Commits:** Semânticos
**PR:** Para `develop`

---

## PROBLEMA #1 - Contagem de Abastecimentos (🔴 BACKEND)

### Análise Comparativa

| Aspecto | Histórico (`getRefuelings`) | Dashboard (`getDashboardSummary`) |
|---------|----------------------------|-----------------------------------|
| **Filtro por motorista** | ✅ `driver_id = user.userId` (linha 150) | ⚠️ Só no fallback, não como regra principal |
| **Filtro por status** | ✅ Aceita filtro `status` no DTO | ❌ NÃO filtra por CONCLUIDO |
| **Filtro por placa** | ✅ `vehicle_plate ILIKE` | ✅ Normaliza placa |
| **Consistência** | ✅ Seguro | ❌ Pode trazer dados de outros motoristas |

### Problema Identificado

**Arquivo:** `zeca_site/backend/src/drivers/drivers.service.ts`
**Método:** `getDashboardSummary()` (linhas 1173-1370)

**Problemas:**
1. **NÃO filtra por `status = 'CONCLUIDO'`** - Conta todos os abastecimentos
2. **Lógica de filtro por motorista é fallback** - Primeiro tenta CPF+placa, só usa driver_id se não encontrar nada
3. **Inconsistente com histórico** - Histórico usa `driver_id` como filtro primário de segurança

### Código Atual (problemático):

```typescript
// Linha 1222-1242 - Busca por CPF + Placa (SEM filtro de status!)
if (normalizedCpf && normalizedPlate) {
  whereConditions.push(
    { driver_cpf: normalizedCpf, vehicle_plate: normalizedPlate, refueling_datetime: MoreThanOrEqual(startOfMonth) },
    // ... outras combinações
  );
}

// Linha 1246-1250 - Busca SEM filtro de status
refuelingsThisMonth = await this.refuelingRepository.find({
  where: whereConditions,  // ❌ Não filtra por CONCLUIDO!
  relations: ['station', 'fuel_type'],
  order: { refueling_datetime: 'DESC' },
});
```

### Código Corrigido:

```typescript
// ADICIONAR import no topo do arquivo (se não existir)
import { RefuelingStatus } from '../entities/Refueling.entity';

// Linha 1222-1242 - Busca por CPF + Placa COM filtro de status
if (normalizedCpf && normalizedPlate) {
  whereConditions.push(
    {
      driver_cpf: normalizedCpf,
      vehicle_plate: normalizedPlate,
      refueling_datetime: MoreThanOrEqual(startOfMonth),
      status: RefuelingStatus.CONCLUIDO  // ✅ ADICIONAR
    },
    {
      driver_cpf: normalizedCpf,
      vehicle_plate: formattedPlate,
      refueling_datetime: MoreThanOrEqual(startOfMonth),
      status: RefuelingStatus.CONCLUIDO  // ✅ ADICIONAR
    },
    {
      driver_cpf: formattedCpf,
      vehicle_plate: normalizedPlate,
      refueling_datetime: MoreThanOrEqual(startOfMonth),
      status: RefuelingStatus.CONCLUIDO  // ✅ ADICIONAR
    },
    {
      driver_cpf: formattedCpf,
      vehicle_plate: formattedPlate,
      refueling_datetime: MoreThanOrEqual(startOfMonth),
      status: RefuelingStatus.CONCLUIDO  // ✅ ADICIONAR
    }
  );
} else if (normalizedPlate) {
  whereConditions.push(
    {
      vehicle_plate: normalizedPlate,
      refueling_datetime: MoreThanOrEqual(startOfMonth),
      status: RefuelingStatus.CONCLUIDO  // ✅ ADICIONAR
    },
    {
      vehicle_plate: formattedPlate,
      refueling_datetime: MoreThanOrEqual(startOfMonth),
      status: RefuelingStatus.CONCLUIDO  // ✅ ADICIONAR
    }
  );
} else if (normalizedCpf) {
  whereConditions.push(
    {
      driver_cpf: normalizedCpf,
      refueling_datetime: MoreThanOrEqual(startOfMonth),
      status: RefuelingStatus.CONCLUIDO  // ✅ ADICIONAR
    },
    {
      driver_cpf: formattedCpf,
      refueling_datetime: MoreThanOrEqual(startOfMonth),
      status: RefuelingStatus.CONCLUIDO  // ✅ ADICIONAR
    }
  );
}

// Linha 1253-1270 - Fallback por driver_id COM filtro de status
if (refuelingsThisMonth.length === 0 && userId) {
  console.log(`🔍 [getDashboardSummary] Buscando por driver_id: ${userId}`);
  const where: any = {
    driver_id: userId,
    refueling_datetime: MoreThanOrEqual(startOfMonth),
    status: RefuelingStatus.CONCLUIDO,  // ✅ ADICIONAR
  };

  if (normalizedPlate) {
    where.vehicle_plate = normalizedPlate;
  }

  refuelingsThisMonth = await this.refuelingRepository.find({
    where,
    relations: ['station', 'fuel_type'],
    order: { refueling_datetime: 'DESC' },
  });
}
```

### Regra de Negócio:
- **Contar apenas** abastecimentos com `status = 'CONCLUIDO'`
- **Período:** mês atual (1º dia até hoje) - ✅ já implementado
- **Filtros:** CPF + Placa do motorista/veículo da jornada ativa
- **Mesmo critério** usado na tela de histórico

---

## PROBLEMA #2 - Rota do Histórico (🔴 FRONTEND)

### Análise do Router (app_router.dart)

**Rotas Disponíveis:**
| Rota | Nome | Página |
|------|------|--------|
| `/history` | history | HistoryPage |
| `/history/:id` | refueling-details | RefuelingDetailsPage |
| `/autonomous/vehicles` | autonomous-vehicles | AutonomousVehiclesPage |

### ⚠️ PROBLEMA IDENTIFICADO:
O código atual usa `/refueling-history` que **NÃO EXISTE** no router!
A rota correta é `/history`.

**Arquivo:** `lib/features/journey_start/presentation/pages/journey_dashboard_page.dart`
**Localização:** Método `_buildQuickActions()` (linha ~572)

**Código ERRADO Atual:**
```dart
Expanded(child: _buildActionItem(Icons.receipt_long, 'Histórico', _zecaPurple, onTap: () => context.push('/refueling-history'))),
```

**Código CORRETO:**
```dart
Expanded(child: _buildActionItem(Icons.receipt_long, 'Histórico', _zecaPurple, onTap: () => context.push('/history'))),
```

---

## PROBLEMA #3 - Navegação Veículos (FRONTEND)

**Arquivo:** `lib/features/journey_start/presentation/pages/journey_dashboard_page.dart`
**Localização:** Método `_buildQuickActions()` (linha ~576)

**Código Atual (sem navegação):**
```dart
Expanded(child: _buildActionItem(Icons.directions_car, 'Veículos', _zecaBlue)),
```

**Código Novo:**
```dart
Expanded(child: _buildActionItem(Icons.directions_car, 'Veículos', _zecaBlue, onTap: () => context.push('/autonomous/vehicles'))),
```

---

## PROBLEMA #4 - Remover Menu Rodapé (FRONTEND)

**Arquivo:** `lib/features/journey_start/presentation/pages/journey_dashboard_page.dart`

**Alteração 1:** Remover propriedade `bottomNavigationBar` do Scaffold (linha ~262)

**Alteração 2:** Remover métodos (linhas 880-922):
- `_buildBottomNav()`
- `_buildNavItem()`

---

## Resumo das Alterações

| # | Alteração | Arquivo | Tipo | Prioridade |
|---|-----------|---------|------|------------|
| 1 | **Filtrar por CONCLUIDO** | `drivers.service.ts` | 🔴 BACKEND | **CRÍTICA** |
| 2 | **Corrigir rota Histórico** | `journey_dashboard_page.dart` | FRONTEND | **ALTA** |
| 3 | Adicionar link Veículos | `journey_dashboard_page.dart` | FRONTEND | MÉDIA |
| 4 | Remover bottomNavigationBar | `journey_dashboard_page.dart` | FRONTEND | BAIXA |

---

## Método `_buildQuickActions()` - Código Final

```dart
Widget _buildQuickActions() {
  return Row(
    children: [
      Expanded(child: _buildActionItem(Icons.assignment, 'Checklist', _zecaOrange, badge: 3)),
      const SizedBox(width: 10),
      Expanded(child: _buildActionItem(Icons.receipt_long, 'Histórico', _zecaPurple, onTap: () => context.push('/history'))),  // CORRIGIDO
      const SizedBox(width: 10),
      Expanded(child: _buildActionItem(Icons.location_on, 'Postos', _zecaGreen, onTap: () => context.push('/nearby-stations'))),
      const SizedBox(width: 10),
      Expanded(child: _buildActionItem(Icons.directions_car, 'Veículos', _zecaBlue, onTap: () => context.push('/autonomous/vehicles'))),  // ADICIONADO
    ],
  );
}
```

---

## Critérios de Aceite (BDD)

```gherkin
Feature: Tela de Jornada Ativa - Ajustes

  Scenario: Card de Economia mostra apenas abastecimentos CONCLUÍDOS
    Given motorista está na tela de Jornada Ativa
    And existem 15 abastecimentos no banco para o veículo
    And apenas 3 têm status CONCLUIDO no mês atual
    When a tela é carregada
    Then o campo "Abast." deve mostrar "3"
    And NÃO deve mostrar "15"

  Scenario: Contagem filtra por motorista e veículo
    Given motorista "João" está na tela de Jornada Ativa
    And veículo ABC1234 está selecionado
    And existem abastecimentos de outros motoristas para ABC1234
    When a tela é carregada
    Then o campo "Abast." deve mostrar APENAS os abastecimentos do João com ABC1234

  Scenario: Navegar para Histórico via Acesso Rápido
    Given motorista está na tela de Jornada Ativa
    When clica no card "Histórico"
    Then deve navegar para rota /history
    And NÃO deve mostrar erro "Página não encontrada"

  Scenario: Navegar para Veículos via Acesso Rápido
    Given motorista está na tela de Jornada Ativa
    When clica no card "Veículos"
    Then deve navegar para rota /autonomous/vehicles

  Scenario: Menu de rodapé removido
    Given motorista está na tela de Jornada Ativa
    When a tela é carregada
    Then NÃO deve exibir menu no rodapé
```

---

## Checklist de Implementação

### Backend (zeca_site)
- [ ] Criar branch `fix/jornada-ativa-ajustes-navegacao`
- [ ] Editar `src/drivers/drivers.service.ts`
- [ ] Adicionar `status: RefuelingStatus.CONCLUIDO` em TODOS os whereConditions
- [ ] Adicionar filtro no fallback por driver_id também
- [ ] Testar endpoint via curl/Postman
- [ ] Verificar que retorna contagem correta

### Frontend (zeca_app)
- [ ] Corrigir rota `/refueling-history` → `/history`
- [ ] Adicionar `onTap` no card "Veículos"
- [ ] Remover `bottomNavigationBar` do Scaffold
- [ ] Remover métodos `_buildBottomNav()` e `_buildNavItem()`
- [ ] Testar navegações

### Geral
- [ ] Commit semântico
- [ ] PR para develop

---

## Commits Sugeridos

```bash
# Commit 1 - Backend fix (CRÍTICO)
git commit -m "fix(drivers): filter dashboard refuelings by CONCLUIDO status

- Add status filter to getDashboardSummary query conditions
- Ensures economy card only counts completed refuelings
- Aligns with history page counting logic"

# Commit 2 - Frontend route fix
git commit -m "fix(journey): correct history route from /refueling-history to /history

- Route /refueling-history does not exist in app_router.dart
- Changed to /history which maps to HistoryPage
- Fixes 'no routes for location' error"

# Commit 3 - Frontend navigation
git commit -m "feat(journey): add vehicle list navigation in quick access

- Add onTap to Veículos card navigating to /autonomous/vehicles"

# Commit 4 - Frontend cleanup
git commit -m "refactor(journey): remove redundant bottom navigation bar

- Remove bottomNavigationBar from Scaffold
- Remove _buildBottomNav() and _buildNavItem() methods
- App uses lateral drawer menu instead"
```

---

**Prioridade:** CRÍTICA
**Estimativa:** 1 hora (30min backend + 30min frontend)
**Impacto:** Dados incorretos no dashboard / bugs de navegação
