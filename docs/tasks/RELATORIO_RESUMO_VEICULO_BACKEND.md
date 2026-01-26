# Relatório: Alterações Necessárias no Backend para Resumo do Veículo

## Status: 🟡 BACKEND PRECISA DE ALTERAÇÕES (MAS PARCIALMENTE FUNCIONAL)

**Data:** 2026-01-26
**Tarefa:** Corrigir Resumo do Veículo (Km/L Médio e Abastecimentos)
**Branch:** `fix/resumo-veiculo-calculo-kml`

---

## 1. Análise da Situação Atual

### 1.1 No App (zeca_app)

**Localização do Card:** `lib/features/journey_start/presentation/pages/journey_start_page.dart`
- Método: `_buildVehicleStatsCard()` (linhas 626-683)
- Exibido quando veículo é selecionado/pesquisado

**Como dados são obtidos:**
```dart
// Método _fetchVehicleStats() - linhas 297-330
final response = await apiService.get('/vehicles/$cleanPlate/stats');

_vehicleStats = {
  'last_odometer': response['last_odometer'],
  'average_consumption': response['average_consumption'],
  'refuelings_this_month': response['refuelings_this_month'],
};
```

**Conclusão App:** ✅ O app apenas CONSOME os dados do backend. Não faz cálculos locais.

---

### 1.2 No Backend (zeca_site)

**Endpoint:** `GET /vehicles/:plate/stats`
- Controller: `vehicles.controller.ts` (linhas 94-104)
- Service: `vehicles.service.ts` método `getVehicleStats()` (linhas 839-926)

**Lógica Atual de Cálculo:**

```sql
WITH vehicle_refuelings AS (
  SELECT
    odometer_reading,
    quantity_liters,
    created_at,
    LAG(odometer_reading) OVER (ORDER BY created_at) as prev_odometer
  FROM refuelings
  WHERE vehicle_plate = $1
    AND status NOT IN ('CANCELADO')
    AND odometer_reading IS NOT NULL
  ORDER BY created_at DESC
)
SELECT
  -- Último KM
  (SELECT odometer_reading FROM vehicle_refuelings LIMIT 1) as last_odometer,

  -- Consumo médio (últimos 10 abastecimentos)
  (
    SELECT AVG(km_per_liter)
    FROM (
      SELECT
        (odometer_reading - prev_odometer) / NULLIF(quantity_liters, 0) as km_per_liter
      FROM vehicle_refuelings
      WHERE prev_odometer IS NOT NULL
        AND odometer_reading > prev_odometer  -- ✅ JÁ FILTRA INCONSISTENTES!
        AND quantity_liters > 0
      LIMIT 10
    ) as consumption_data
    WHERE km_per_liter BETWEEN 1 AND 30  -- ✅ RANGE DE SANIDADE!
  ) as average_consumption,

  -- Abastecimentos do mês
  (
    SELECT COUNT(*)
    FROM refuelings
    WHERE vehicle_plate = $1
      AND status NOT IN ('CANCELADO')
      AND DATE_TRUNC('month', created_at) = DATE_TRUNC('month', CURRENT_DATE)
  ) as refuelings_this_month
```

---

## 2. O que ESTÁ Funcionando Corretamente ✅

| Item | Status | Descrição |
|------|--------|-----------|
| Endpoint `/vehicles/:plate/stats` | ✅ Existe | Retorna last_odometer, average_consumption, refuelings_this_month |
| Filtro de odômetro inconsistente | ✅ Implementado | `WHERE odometer_reading > prev_odometer` |
| Range de sanidade Km/L | ✅ Implementado | `WHERE km_per_liter BETWEEN 1 AND 30` |
| Exclusão de cancelados | ✅ Implementado | `WHERE status NOT IN ('CANCELADO')` |
| Filtro por motorista (APP) | ✅ Implementado | Se `profile = 'APP_MOTORISTA'`, filtra por `driver_id` |
| Tabela VehicleOdometerHistory | ✅ Existe | Estrutura para histórico de odômetro |

---

## 3. O que PRECISA de Ajustes ⚠️

### 3.1 Problemas Identificados

| # | Problema | Impacto | Prioridade |
|---|----------|---------|------------|
| 1 | **Período do cálculo é HISTÓRICO, não MÊS ATUAL** | Km/L mostra média de todos os tempos, não do mês | ALTA |
| 2 | **Último KM pode estar incorreto** | Pega primeiro registro do CTE (mais recente), mas CTE está `ORDER BY created_at DESC` dentro do window function | MÉDIA |
| 3 | **Não há validação no INPUT de odômetro** | Usuário pode cadastrar odômetro menor que anterior | ALTA |
| 4 | **VehicleOdometerHistory não é populada** | Tabela existe mas não é usada nos abastecimentos | BAIXA |

### 3.2 Especificação do Problema #1 - Período

**Atual:** Calcula média dos últimos 10 abastecimentos (qualquer período)
**Esperado:** Calcular apenas no MÊS ATUAL (1º dia até hoje)

**Impacto:** Se usuário não abasteceu no mês, `Km/L Médio` deveria ser `--`, mas mostra valor de meses anteriores.

### 3.3 Especificação do Problema #3 - Validação de Input

**Atual:** `SimpleRefuelingDto` aceita qualquer `odometer_reading >= 0`
```typescript
@Min(0)
odometer_reading: number;
```

**Esperado:** Validar no momento do registro:
- Buscar último odômetro válido do veículo
- Rejeitar se `novo_odometro < ultimo_odometro_valido`
- Ou: aceitar e marcar como `odometer_valid = false`

---

## 4. Alterações NECESSÁRIAS no Backend

### 4.1 Alteração 1: Filtrar por MÊS ATUAL no cálculo de Km/L

**Arquivo:** `backend/src/vehicles/vehicles.service.ts`
**Método:** `getVehicleStats()`

**De:**
```sql
FROM refuelings
WHERE vehicle_plate = $1
  AND status NOT IN ('CANCELADO')
  AND odometer_reading IS NOT NULL
```

**Para:**
```sql
FROM refuelings
WHERE vehicle_plate = $1
  AND status NOT IN ('CANCELADO')
  AND odometer_reading IS NOT NULL
  AND DATE_TRUNC('month', created_at) = DATE_TRUNC('month', CURRENT_DATE)
```

**Impacto:** Km/L será calculado apenas com dados do mês atual.

---

### 4.2 Alteração 2: Validação de Odômetro no Registro

**Arquivo:** `backend/src/refueling/refueling.service.ts`
**Método:** `registerSimpleRefueling()`

**Adicionar antes de salvar (linha ~620):**
```typescript
// Buscar último odômetro válido do veículo
const lastValidOdometer = await this.refuelingRepository
  .createQueryBuilder('r')
  .select('r.odometer_reading')
  .where('r.vehicle_plate = :plate', { plate: vehiclePlate })
  .andWhere('r.status NOT IN (:...excludedStatus)', { excludedStatus: ['CANCELADO'] })
  .andWhere('r.odometer_reading IS NOT NULL')
  .orderBy('r.created_at', 'DESC')
  .getOne();

// Validar consistência
const isOdometerValid = !lastValidOdometer ||
  simpleDto.odometer_reading > Number(lastValidOdometer.odometer_reading);

if (!isOdometerValid) {
  this.logger.warn(
    `⚠️ Odômetro inconsistente: ${simpleDto.odometer_reading} < ${lastValidOdometer.odometer_reading} para ${vehiclePlate}`
  );
}
```

**Opções de tratamento:**
1. **Rejeitar:** Retornar erro `BadRequestException('Odômetro deve ser maior que o anterior')`
2. **Aceitar com flag:** Adicionar campo `odometer_valid: boolean` na entity e setar como `false`
3. **Aceitar com log:** Apenas logar warning (atual - implícito)

**Recomendação:** Opção 2 (aceitar com flag) - menos disruptivo para usuário.

---

### 4.3 Alteração 3 (Opcional): Campo `odometer_valid` na Entity

**Arquivo:** `backend/src/entities/Refueling.entity.ts`

**Adicionar:**
```typescript
@Column({ type: 'boolean', default: true })
odometer_valid: boolean;
```

**Migration necessária:**
```sql
ALTER TABLE refuelings ADD COLUMN odometer_valid BOOLEAN DEFAULT true;
```

**Atualizar query de stats para usar este campo.**

---

## 5. Estrutura do Banco de Dados

### 5.1 Tabela `refuelings` (campos relevantes)

| Campo | Tipo | Nullable | Descrição |
|-------|------|----------|-----------|
| id | UUID | NO | PK |
| refueling_code | VARCHAR(20) | NO | Código único |
| vehicle_plate | VARCHAR(10) | NO | Placa do veículo |
| odometer_reading | DECIMAL(10,3) | YES | Leitura do odômetro |
| quantity_liters | DECIMAL(10,3) | NO | Litros abastecidos |
| status | ENUM | NO | Status do abastecimento |
| created_at | TIMESTAMP | NO | Data de criação |

### 5.2 Tabela `vehicle_odometer_history` (existe mas não usada)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | UUID | PK |
| vehicle_id | UUID | FK para vehicles |
| odometer_value | DECIMAL(10,3) | Valor do odômetro |
| source_type | ENUM | JOURNEY_START, JOURNEY_END, REFUELING, etc. |
| source_id | UUID | ID da origem |
| recorded_at | TIMESTAMP | Data do registro |

---

## 6. Dados Legados

**Para verificar quantidade de dados inconsistentes, executar no banco:**

```sql
-- Registros com odômetro NULL
SELECT COUNT(*) as total_null_odometer
FROM refuelings
WHERE odometer_reading IS NULL;

-- Registros com odômetro inconsistente (menor que anterior)
WITH ordered_refuelings AS (
  SELECT
    id,
    vehicle_plate,
    odometer_reading,
    LAG(odometer_reading) OVER (PARTITION BY vehicle_plate ORDER BY created_at) as prev_odometer,
    created_at
  FROM refuelings
  WHERE status NOT IN ('CANCELADO')
    AND odometer_reading IS NOT NULL
)
SELECT COUNT(*) as total_inconsistent
FROM ordered_refuelings
WHERE prev_odometer IS NOT NULL
  AND odometer_reading < prev_odometer;
```

**Sugestão de tratamento:**
- Marcar registros existentes como `odometer_valid = false` se inconsistentes
- Não alterar dados históricos (preservar integridade)

---

## 7. Dependências e Ordem de Implementação

```
┌─────────────────────────────────────────────────────────────────┐
│  ORDEM DE IMPLEMENTAÇÃO                                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. [BACKEND] Ajustar query para filtrar MÊS ATUAL              │
│     └─ vehicles.service.ts → getVehicleStats()                  │
│                                                                  │
│  2. [BACKEND] Adicionar campo odometer_valid (opcional)         │
│     └─ Migration + Entity                                        │
│                                                                  │
│  3. [BACKEND] Adicionar validação no registro                   │
│     └─ refueling.service.ts → registerSimpleRefueling()         │
│                                                                  │
│  4. [BACKEND] Script para marcar dados legados                  │
│     └─ Migration de dados                                        │
│                                                                  │
│  5. [APP] Ajustar exibição se necessário                        │
│     └─ Tratamento de "--" quando não há dados                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 8. Decisão

### 🟡 BACKEND PRECISA DE ALTERAÇÕES, MAS SÃO PEQUENAS

**Situação:**
- O endpoint já existe e funciona
- A lógica de cálculo está 80% correta
- Falta apenas filtrar por MÊS ATUAL
- Validação de input é nice-to-have, não bloqueante

**Recomendação:**

| Opção | Descrição | Recomendado? |
|-------|-----------|--------------|
| A | Fazer alteração mínima no backend (só filtro de mês) e ajustar app | ✅ SIM |
| B | Implementar tudo (flag, validação, histórico) antes do app | ❌ Muito escopo |
| C | Não mexer no backend, ajustar só no app | ❌ Cálculo incorreto |

**Decisão: OPÇÃO A**

1. Alterar query no backend para filtrar por mês atual
2. Ajustar app para tratar corretamente quando não há dados
3. Criar issue para implementar validação de odômetro posteriormente

---

## 9. Estimativas

| Item | Tempo Estimado |
|------|----------------|
| Alteração na query (backend) | 30 min |
| Testes da alteração | 30 min |
| Ajustes no app (se necessário) | 1 hora |
| **Total** | **2 horas** |

---

## 10. Próximos Passos

- [ ] Aprovar este relatório
- [ ] Alterar `vehicles.service.ts` para filtrar por mês atual
- [ ] Testar endpoint via Postman/curl
- [ ] Verificar se app precisa de ajustes
- [ ] Criar issue para validação de odômetro (futuro)

---

## 11. Conclusão

⚠️ **O BACKEND PRECISA DE UMA ALTERAÇÃO PEQUENA MAS CRÍTICA:**
- Adicionar filtro de período (mês atual) na query de stats

✅ **APÓS ESSA ALTERAÇÃO, PODE-SE PROSSEGUIR COM O APP**

O restante das melhorias (validação de input, flag de validade, histórico) pode ser implementado em uma segunda fase.

---

**Aguardando aprovação para prosseguir com a implementação.**
