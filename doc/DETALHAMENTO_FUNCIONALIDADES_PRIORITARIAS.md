# 🎯 DETALHAMENTO - FUNCIONALIDADES PRIORITÁRIAS

Análise completa de 4 funcionalidades selecionadas para implementação.

---

## 1. 🔍 IA: DETECÇÃO DE FRAUDES

### 📊 **O PROBLEMA**

**Situação Atual:**
- Motoristas podem fraudar abastecimentos de várias formas:
  - ✂️ **"Nota meia-boca"**: Abastece 50L mas diz que foi 100L
  - 🏠 **Abastecimento fantasma**: Diz que abasteceu mas não abasteceu
  - 📍 **Fora de rota**: Abastece fora da viagem para uso pessoal
  - 🔄 **Duplicação**: Usa mesma nota fiscal 2x
  - ⏰ **Horários estranhos**: Abastece 3h da manhã sem justificativa
  - 🚗 **Troca de veículo**: Abastece outro veículo com cartão da empresa

**Impacto Financeiro:**
- Empresa média: **5-15% de fraudes** em combustível
- Frota de 50 caminhões: **R$ 50-150 mil/ano** em perdas
- Difícil de detectar manualmente

---

### 🤖 **COMO FUNCIONA A IA**

#### **Machine Learning - Modelo de Detecção**

```
DADOS DE ENTRADA (Features):
├─ 📍 Localização do abastecimento (lat/lng)
├─ 🗺️ Distância da rota planejada (km)
├─ ⛽ Litros abastecidos
├─ 🚛 Capacidade do tanque
├─ 📊 KM percorridos desde último abastecimento
├─ 📈 Consumo médio histórico (km/L)
├─ ⏰ Horário do abastecimento
├─ 💰 Valor total (R$)
├─ 💲 Preço por litro (R$/L)
├─ 📍 Preço médio da região
├─ 🔢 Frequência de abastecimentos
├─ 👤 Histórico do motorista
└─ 🚛 Histórico do veículo

PROCESSAMENTO (Algoritmos):
├─ 🎯 Anomaly Detection (Isolation Forest)
├─ 📊 Clustering (K-Means) - padrões normais
├─ 🧠 Random Forest - classificação
├─ 📈 Regressão Linear - previsão de consumo
└─ 🔍 Rules Engine - regras de negócio

SAÍDA (Score de Suspeita):
├─ 0-20: ✅ Normal
├─ 21-50: ⚠️ Atenção
├─ 51-80: 🔶 Suspeito
└─ 81-100: 🚨 Fraude Provável
```

#### **Exemplos de Detecção**

**Caso 1: Litros Impossíveis**
```
Abastecimento: 150 litros
Tanque do veículo: 120 litros
KM desde último: 80 km
Consumo médio: 2.5 km/L

Análise IA:
- 80 km ÷ 2.5 = 32L consumidos
- Tanque: 120L - 32L = 88L disponíveis
- Abasteceu 150L mas só cabia 32L
- SCORE: 95 🚨 FRAUDE PROVÁVEL
```

**Caso 2: Fora de Rota**
```
Rota planejada: SP → RJ (BR-116)
Local abastecimento: MG (200 km fora)
Horário: 23:45 (noite)
Histórico: 3 abastecimentos fora em 1 mês

Análise IA:
- 200 km de desvio injustificado
- Horário atípico (sem entregas à noite)
- Padrão recorrente
- SCORE: 78 🔶 SUSPEITO
```

**Caso 3: Preço Anormal**
```
Abastecimento: 100L a R$ 7.50/L
Preço médio região: R$ 5.89/L
Diferença: +27%
Posto: desconhecido no sistema

Análise IA:
- Preço 27% acima da média
- Posto não cadastrado
- Sem notas anteriores neste posto
- SCORE: 65 🔶 SUSPEITO
```

**Caso 4: Frequência Anormal**
```
Motorista: João Silva
Abastecimentos última semana: 8x
Média frota: 2-3x por semana
KM percorridos: 1.200 km
Consumo esperado: ~480L (2.5km/L)
Abastecido: 750L

Análise IA:
- 56% mais abastecimentos que média
- 270L a mais que esperado
- Possível "sangria" de combustível
- SCORE: 82 🚨 FRAUDE PROVÁVEL
```

---

### 📱 **FLUXO DE TELAS - APP MOTORISTA**

```
┌─────────────────────────────────────┐
│  REGISTRO DE ABASTECIMENTO          │
├─────────────────────────────────────┤
│                                     │
│  [Foto do Comprovante]              │
│  📸 Tirar Foto                      │
│                                     │
│  Litros: [____100____] L            │
│  Valor: [R$ 589,00]                 │
│  Preço/L: R$ 5.89 (auto)            │
│                                     │
│  📍 Localização: Detectada          │
│  Posto Shell - BR-116, km 245       │
│                                     │
│  ⏰ Horário: 14:35                  │
│                                     │
│  [  Confirmar Abastecimento  ]      │
│                                     │
└─────────────────────────────────────┘

          ↓ (IA analisa em background)

┌─────────────────────────────────────┐
│  ✅ Abastecimento Registrado        │
├─────────────────────────────────────┤
│                                     │
│  100L - R$ 589,00                   │
│  Posto Shell - BR-116               │
│                                     │
│  Status: ✅ Aprovado                │
│                                     │
│  [    OK    ]                       │
│                                     │
└─────────────────────────────────────┘
```

**SE DETECTAR SUSPEITA:**

```
┌─────────────────────────────────────┐
│  ⚠️ Verificação Necessária          │
├─────────────────────────────────────┤
│                                     │
│  Detectamos uma inconsistência:     │
│                                     │
│  🔍 Litros informados (100L)        │
│     parecem acima do esperado       │
│     para seu consumo recente.       │
│                                     │
│  Por favor, confirme:               │
│                                     │
│  ☐ Litros estão corretos            │
│  ☐ Tanque estava quase vazio        │
│  ☐ Houve problema no último abast.  │
│                                     │
│  Observações (opcional):            │
│  [____________________________]     │
│                                     │
│  [ Cancelar ]  [  Confirmar  ]      │
│                                     │
└─────────────────────────────────────┘
```

---

### 🖥️ **DASHBOARD WEB - GESTOR**

```
┌───────────────────────────────────────────────────────────────┐
│  🔍 CENTRAL DE DETECÇÃO DE FRAUDES                            │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  📊 RESUMO DO MÊS                                             │
│  ┌─────────────┬─────────────┬─────────────┬─────────────┐   │
│  │ 🚨 Alertas  │ 🔶 Suspeitos│ ✅ Normais  │ 💰 Economia │   │
│  │     12      │     28      │    450      │  R$ 8.750   │   │
│  └─────────────┴─────────────┴─────────────┴─────────────┘   │
│                                                               │
│  🚨 ALERTAS CRÍTICOS (Score > 80)                             │
│  ┌───────────────────────────────────────────────────────┐   │
│  │ 🚨 João Silva - ABC-1234                               │   │
│  │ Score: 95 | Abast: 150L | Tanque: 120L               │   │
│  │ 📍 Posto XYZ - 18/11 às 14:35                         │   │
│  │ 💡 Litros impossível: tanque só comporta 120L         │   │
│  │                                                        │   │
│  │ [ 👁️ Ver Detalhes ] [ ✅ Aprovar ] [ ❌ Bloquear ]    │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                               │
│  │ 🚨 Maria Santos - XYZ-5678                             │   │
│  │ Score: 82 | Fora de rota: 200 km                      │   │
│  │ 📍 Posto ABC - 18/11 às 23:45                         │   │
│  │ 💡 Abastecimento noturno fora da rota planejada       │   │
│  │                                                        │   │
│  │ [ 👁️ Ver Detalhes ] [ ✅ Aprovar ] [ ❌ Bloquear ]    │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                               │
│  🔶 CASOS SUSPEITOS (Score 51-80)                             │
│  ┌───────────────────────────────────────────────────────┐   │
│  │ ⚠️ Pedro Costa - DEF-9012 | Score: 65                 │   │
│  │ ⚠️ Ana Lima - GHI-3456 | Score: 58                    │   │
│  │ ... (26 mais)                                          │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                               │
│  📈 GRÁFICO DE FRAUDES                                        │
│  [Gráfico de linha mostrando evolução mês a mês]             │
│                                                               │
│  🏆 TOP 5 MOTORISTAS MAIS CONFIÁVEIS                          │
│  🏆 TOP 5 MOTORISTAS COM MAIS ALERTAS                         │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

**TELA DE DETALHES DO ALERTA:**

```
┌───────────────────────────────────────────────────────────────┐
│  🚨 ALERTA DE FRAUDE - DETALHES                               │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  👤 MOTORISTA                                                 │
│  Nome: João Silva                                             │
│  CPF: 123.456.789-00                                          │
│  Veículo: ABC-1234 (Volvo FH 540)                            │
│                                                               │
│  ⛽ ABASTECIMENTO                                              │
│  Data/Hora: 18/11/2025 às 14:35                              │
│  Local: Posto XYZ - BR-116, km 245                            │
│  Litros: 150L                                                 │
│  Valor: R$ 885,00 (R$ 5.90/L)                                │
│                                                               │
│  🔍 ANÁLISE DA IA                                             │
│  Score de Fraude: 95/100 🚨                                   │
│                                                               │
│  ❌ PROBLEMAS DETECTADOS:                                     │
│  • Litros (150L) excedem capacidade do tanque (120L)         │
│  • KM desde último abastecimento: 80 km                       │
│  • Consumo esperado: 32L (2.5 km/L)                           │
│  • Espaço disponível no tanque: ~32L                          │
│  • IMPOSSÍVEL abastecer 150L                                  │
│                                                               │
│  📊 HISTÓRICO DO MOTORISTA (últimos 30 dias)                  │
│  • Abastecimentos: 12                                         │
│  • Alertas gerados: 3 (25%)                                   │
│  • Fraudes confirmadas: 1                                     │
│  • Economia gerada bloqueando fraudes: R$ 1.250               │
│                                                               │
│  📸 COMPROVANTE                                               │
│  [Imagem da nota fiscal]                                      │
│                                                               │
│  🗺️ MAPA                                                       │
│  [Mapa mostrando localização do abastecimento vs rota]       │
│                                                               │
│  💬 JUSTIFICATIVA DO MOTORISTA                                │
│  "Tanque estava vazio, precisei completar"                    │
│                                                               │
│  ⚙️ AÇÕES                                                      │
│  [ ✅ Aprovar (ignorar alerta) ]                              │
│  [ ❌ Reprovar (bloquear pagamento) ]                         │
│  [ 📞 Contatar motorista ]                                    │
│  [ 🔒 Suspender cartão temporariamente ]                      │
│  [ 📝 Registrar como fraude confirmada ]                      │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

---

### 🛠️ **REQUISITOS TÉCNICOS**

#### **Backend - Machine Learning**

```python
# Estrutura sugerida (Python)

# 1. Coleta de Dados
class FraudDetectionService:
    def collect_features(self, abastecimento_id):
        """
        Coleta features para análise
        """
        return {
            'litros': self.get_litros(abastecimento_id),
            'capacidade_tanque': self.get_capacidade_tanque(),
            'km_desde_ultimo': self.get_km_desde_ultimo(),
            'consumo_medio': self.get_consumo_medio_veiculo(),
            'lat_lng': self.get_localizacao(),
            'distancia_rota': self.calcular_distancia_rota(),
            'horario': self.get_horario(),
            'preco_litro': self.get_preco(),
            'preco_medio_regiao': self.get_preco_medio_regiao(),
            'frequencia_mensal': self.get_frequencia_abastecimentos(),
            'historico_motorista': self.get_historico_alertas()
        }
    
    def calculate_fraud_score(self, features):
        """
        Calcula score de fraude (0-100)
        """
        score = 0
        
        # Regra 1: Litros impossíveis
        if features['litros'] > features['capacidade_tanque']:
            score += 50
        
        # Regra 2: Consumo anormal
        consumo_esperado = features['km_desde_ultimo'] / features['consumo_medio']
        diferenca = abs(features['litros'] - consumo_esperado) / consumo_esperado
        if diferenca > 0.5:  # 50% diferença
            score += 30
        
        # Regra 3: Fora de rota
        if features['distancia_rota'] > 50:  # > 50 km
            score += 20
        
        # Regra 4: Preço anormal
        dif_preco = (features['preco_litro'] - features['preco_medio_regiao']) / features['preco_medio_regiao']
        if dif_preco > 0.15:  # > 15%
            score += 15
        
        # Regra 5: Histórico
        if features['historico_motorista']['fraudes_confirmadas'] > 0:
            score += 25
        
        # ML Model (exemplo com Random Forest)
        ml_score = self.ml_model.predict_proba([features])[0][1] * 100
        
        # Score final (média ponderada)
        final_score = (score * 0.6) + (ml_score * 0.4)
        
        return min(final_score, 100)
```

#### **Frontend - Flutter**

```dart
// Service para enviar dados para análise

class FraudDetectionService {
  final ApiService _apiService;
  
  Future<FraudAnalysisResult> analyzeRefueling({
    required String journeyId,
    required double liters,
    required double value,
    required LatLng location,
    required String photoPath,
  }) async {
    try {
      // Enviar dados para backend
      final response = await _apiService.post(
        '/api/v1/fraud-detection/analyze',
        data: {
          'journey_id': journeyId,
          'liters': liters,
          'value': value,
          'latitude': location.latitude,
          'longitude': location.longitude,
          'timestamp': DateTime.now().toIso8601String(),
          'photo': await _uploadPhoto(photoPath),
        },
      );
      
      if (response['success']) {
        final data = response['data'];
        return FraudAnalysisResult(
          score: data['fraud_score'],
          status: _getStatusFromScore(data['fraud_score']),
          reasons: List<String>.from(data['reasons'] ?? []),
          requiresConfirmation: data['requires_confirmation'],
        );
      }
      
      return FraudAnalysisResult.normal();
    } catch (e) {
      debugPrint('Erro ao analisar fraude: $e');
      return FraudAnalysisResult.normal(); // Em caso de erro, permite
    }
  }
  
  FraudStatus _getStatusFromScore(int score) {
    if (score >= 81) return FraudStatus.critical;
    if (score >= 51) return FraudStatus.suspicious;
    if (score >= 21) return FraudStatus.attention;
    return FraudStatus.normal;
  }
}
```

#### **Banco de Dados**

```sql
-- Tabela de análises de fraude
CREATE TABLE fraud_analyses (
  id UUID PRIMARY KEY,
  refueling_id UUID REFERENCES refuelings(id),
  journey_id UUID REFERENCES journeys(id),
  driver_id UUID REFERENCES drivers(id),
  vehicle_id UUID REFERENCES vehicles(id),
  
  -- Score
  fraud_score INTEGER CHECK (fraud_score >= 0 AND fraud_score <= 100),
  status VARCHAR(20), -- 'normal', 'attention', 'suspicious', 'critical'
  
  -- Features usadas
  features JSONB,
  
  -- Razões
  reasons TEXT[],
  
  -- Ação tomada
  action VARCHAR(20), -- 'approved', 'blocked', 'pending'
  action_by UUID REFERENCES users(id),
  action_at TIMESTAMP,
  action_notes TEXT,
  
  -- Confirmação de fraude
  is_fraud_confirmed BOOLEAN DEFAULT FALSE,
  confirmed_by UUID REFERENCES users(id),
  confirmed_at TIMESTAMP,
  
  created_at TIMESTAMP DEFAULT NOW(),
  
  INDEX idx_fraud_score (fraud_score DESC),
  INDEX idx_status (status),
  INDEX idx_driver (driver_id),
  INDEX idx_created_at (created_at DESC)
);

-- View para dashboard
CREATE VIEW fraud_dashboard AS
SELECT 
  DATE(created_at) as date,
  COUNT(*) as total_analyses,
  COUNT(*) FILTER (WHERE status = 'critical') as critical_count,
  COUNT(*) FILTER (WHERE status = 'suspicious') as suspicious_count,
  COUNT(*) FILTER (WHERE is_fraud_confirmed = TRUE) as confirmed_frauds,
  SUM(CASE WHEN is_fraud_confirmed = TRUE THEN features->>'value' ELSE 0 END) as blocked_amount
FROM fraud_analyses
GROUP BY DATE(created_at)
ORDER BY date DESC;
```

---

### ⏱️ **ESTIMATIVA DE DESENVOLVIMENTO**

#### **Fase 1: MVP Básico (2-3 semanas)**
- ✅ Backend: Rules Engine (regras simples) - 1 semana
- ✅ Frontend: Integração no app - 3 dias
- ✅ Dashboard Web: Tela de alertas - 1 semana
- ✅ Testes: Validação com dados reais - 2 dias

#### **Fase 2: Machine Learning (3-4 semanas)**
- 🤖 Coleta de dados históricos - 3 dias
- 🤖 Treinamento de modelos - 1 semana
- 🤖 Integração ML no backend - 1 semana
- 🤖 Otimização e ajustes - 1 semana

#### **Fase 3: Refinamento (2 semanas)**
- 📊 Análises avançadas - 1 semana
- 🎨 UX melhorada - 3 dias
- 🔧 Performance - 2 dias
- 📚 Documentação - 2 dias

**TOTAL: 7-9 semanas (2-2.5 meses)**

---

### 💰 **ROI ESPERADO**

#### **Economia Anual Estimada**

```
FROTA: 50 caminhões
GASTOS COM COMBUSTÍVEL: R$ 2.000.000/ano
TAXA DE FRAUDE SEM IA: 10%
TAXA DE FRAUDE COM IA: 2%

ECONOMIA:
- Perdas antes: R$ 200.000/ano (10%)
- Perdas depois: R$ 40.000/ano (2%)
- ECONOMIA: R$ 160.000/ano

ROI:
- Investimento desenvolvimento: R$ 80.000
- Economia ano 1: R$ 160.000
- ROI: 200% no primeiro ano
- Payback: 6 meses
```

#### **Benefícios Adicionais**

- 📉 Redução de 80% em fraudes
- ⚡ Detecção em tempo real (< 5 segundos)
- 📊 Visibilidade total de gastos
- 🔒 Segurança jurídica (provas)
- 👥 Motoristas honestos protegidos de suspeitas injustas

---

### 🚨 **RISCOS E DESAFIOS**

#### **Técnicos**
- ❌ **Falsos positivos**: IA pode acusar erroneamente
  - **Solução**: Gestor sempre pode aprovar manualmente
- ❌ **Qualidade dos dados**: Dados ruins = IA ruim
  - **Solução**: Validação na entrada + histórico
- ❌ **Performance**: Análise deve ser rápida
  - **Solução**: Cache, processamento assíncrono

#### **Operacionais**
- ❌ **Resistência dos motoristas**: "Big Brother"
  - **Solução**: Comunicação transparente sobre objetivo
- ❌ **Carga de trabalho gestor**: Muitos alertas
  - **Solução**: Priorização automática, ações em lote

#### **Jurídicos**
- ❌ **Privacidade (LGPD)**: Monitoramento de pessoas
  - **Solução**: Termo de consentimento, anonimização

---

## 2. 💳 VALE-PEDÁGIO DIGITAL

### 📊 **O PROBLEMA**

**Situação Atual com Vale-Pedágio Físico:**
- 💰 **Roubo/Perda**: R$ 500-2000 perdidos por roubo
- 📝 **Burocracia**: Solicitação por telefone/papel
- ⏰ **Demora**: 2-3 dias para receber vale físico
- 🔢 **Difícil controlar**: Não sabe saldo em tempo real
- 🚫 **Fraude**: Vale pode ser vendido/trocado
- 📊 **Sem rastreabilidade**: Não sabe onde foi usado

**Impacto:**
- Empresa média perde **R$ 20-50 mil/ano** com vales
- Motorista fica parado esperando vale
- Gestor não tem controle de gastos

---

### 💡 **SOLUÇÃO: VALE-PEDÁGIO DIGITAL**

#### **Como Funciona**

```
EMPRESA
├─ Compra créditos em lote (ConectCar, Veloe, SemParar)
├─ Distribui créditos aos motoristas via app
└─ Monitora uso em tempo real

MOTORISTA
├─ Recebe créditos no app instantaneamente
├─ Usa no pedágio:
│  ├─ QR Code (pedágios modernos)
│  ├─ NFC (aproximação)
│  └─ Código numérico (pedágios antigos)
└─ Vê saldo atualizado

GESTOR
├─ Dashboard de gastos por motorista
├─ Aprovar/rejeitar solicitações
└─ Relatórios automáticos
```

---

### 📱 **FLUXO DE TELAS - APP MOTORISTA**

**TELA 1: HOME - Card de Vale-Pedágio**

```
┌─────────────────────────────────────┐
│  🏠 ZECA - Jornada Ativa            │
├─────────────────────────────────────┤
│                                     │
│  [Card Veículo]                     │
│  ABC-1234                           │
│                                     │
│  💳 Vale-Pedágio                    │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │  Saldo Disponível           │   │
│  │  R$ 450,00                  │   │
│  │                             │   │
│  │  [  Ver Detalhes  ]         │   │
│  │  [ Solicitar Mais ]         │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Abastecimento] [Viagem] [Check]  │
│                                     │
└─────────────────────────────────────┘
```

**TELA 2: Detalhes do Vale**

```
┌─────────────────────────────────────┐
│  💳 Vale-Pedágio                    │
├─────────────────────────────────────┤
│                                     │
│  💰 SALDO ATUAL                     │
│  R$ 450,00                          │
│                                     │
│  📊 Consumido nesta viagem: R$ 120  │
│  📈 Média por viagem: R$ 180        │
│  ⏰ Última atualização: Agora       │
│                                     │
│  ──────────────────────────────     │
│                                     │
│  📋 HISTÓRICO (últimos 7 dias)      │
│                                     │
│  18/11 | 14:30 | Pedágio BR-116    │
│  💰 -R$ 45,00 | Saldo: R$ 450      │
│                                     │
│  17/11 | 09:15 | Pedágio BR-101    │
│  💰 -R$ 38,00 | Saldo: R$ 495      │
│                                     │
│  16/11 | 16:45 | Pedágio Régis B.  │
│  💰 -R$ 37,00 | Saldo: R$ 533      │
│                                     │
│  15/11 | 11:00 | Recarga            │
│  💰 +R$ 500,00 | Saldo: R$ 570     │
│                                     │
│  ──────────────────────────────     │
│                                     │
│  [  Solicitar Recarga  ]            │
│  [  Relatório Completo  ]           │
│                                     │
└─────────────────────────────────────┘
```

**TELA 3: Solicitar Recarga**

```
┌─────────────────────────────────────┐
│  💸 Solicitar Recarga               │
├─────────────────────────────────────┤
│                                     │
│  Saldo atual: R$ 450,00             │
│                                     │
│  Valor solicitado:                  │
│  ┌───────────────────────────┐     │
│  │  R$ [  500  ]             │     │
│  └───────────────────────────┘     │
│                                     │
│  Valores sugeridos:                 │
│  [ R$ 200 ] [ R$ 500 ] [ R$ 1000 ] │
│                                     │
│  ──────────────────────────────     │
│                                     │
│  Justificativa:                     │
│  ┌───────────────────────────┐     │
│  │ Viagem longa SP-BA        │     │
│  │ Estimativa: 8 pedágios    │     │
│  └───────────────────────────┘     │
│                                     │
│  💡 Previsão de consumo:            │
│  Rota SP-BA: ~R$ 420 em pedágios   │
│                                     │
│  ──────────────────────────────     │
│                                     │
│  📝 Seu pedido será analisado       │
│  em até 30 minutos pelo gestor.     │
│                                     │
│  [ Cancelar ]  [  Enviar  ]         │
│                                     │
└─────────────────────────────────────┘
```

**TELA 4: Pagamento no Pedágio**

```
┌─────────────────────────────────────┐
│  🚛 Passando por Pedágio            │
├─────────────────────────────────────┤
│                                     │
│  📍 Detectamos um pedágio próximo:  │
│                                     │
│  🏢 Pedágio Régis Bittencourt       │
│  📍 BR-116, km 245                  │
│  💰 Valor: R$ 37,50                 │
│                                     │
│  ──────────────────────────────     │
│                                     │
│  PAGAR COM:                         │
│                                     │
│  💳 Vale-Pedágio ZECA               │
│  Saldo: R$ 450,00                   │
│                                     │
│  [ 📱 Mostrar QR Code ]             │
│  [ 📲 Pagar por NFC ]               │
│  [ 🔢 Código Numérico ]             │
│                                     │
│  ──────────────────────────────     │
│                                     │
│  Ou pague manualmente e registre:   │
│  [  Registrar Pagamento Manual  ]   │
│                                     │
└─────────────────────────────────────┘
```

**TELA 5: QR Code para Pagamento**

```
┌─────────────────────────────────────┐
│  💳 Vale-Pedágio ZECA               │
├─────────────────────────────────────┤
│                                     │
│  Mostre este QR Code no pedágio:    │
│                                     │
│         ┌─────────────┐             │
│         │   █▀▀█▀█   │             │
│         │   ██▀██    │             │
│         │   █▀▀██    │             │
│         │   QR CODE  │             │
│         └─────────────┘             │
│                                     │
│  Pedágio: Régis Bittencourt         │
│  Valor: R$ 37,50                    │
│                                     │
│  Saldo antes: R$ 450,00             │
│  Saldo após: R$ 412,50              │
│                                     │
│  ⏰ Válido por 5 minutos             │
│  Tempo restante: 04:45              │
│                                     │
│  ──────────────────────────────     │
│                                     │
│  Não conseguiu usar?                │
│  [  Registrar Problema  ]           │
│                                     │
└─────────────────────────────────────┘
```

**TELA 6: Pagamento Confirmado**

```
┌─────────────────────────────────────┐
│  ✅ Pagamento Realizado             │
├─────────────────────────────────────┤
│                                     │
│  🎉 Sucesso!                        │
│                                     │
│  💰 R$ 37,50                        │
│  Pedágio Régis Bittencourt          │
│  BR-116, km 245                     │
│                                     │
│  📅 18/11/2025 às 14:35             │
│                                     │
│  ──────────────────────────────     │
│                                     │
│  💳 Saldo atualizado:               │
│  R$ 412,50                          │
│                                     │
│  📊 Gastos nesta viagem:            │
│  R$ 157,50 em pedágios              │
│                                     │
│  [    OK    ]                       │
│                                     │
└─────────────────────────────────────┘
```

---

### 🖥️ **DASHBOARD WEB - GESTOR**

```
┌───────────────────────────────────────────────────────────────┐
│  💳 GESTÃO DE VALE-PEDÁGIO                                    │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  📊 RESUMO                                                    │
│  ┌──────────────┬──────────────┬──────────────┬────────────┐ │
│  │ 💰 Total     │ 🚛 Em Uso    │ 📥 Pendente  │ 📈 Mês    │ │
│  │ R$ 45.000    │ R$ 22.500    │ R$ 3.500     │ +12%      │ │
│  └──────────────┴──────────────┴──────────────┴────────────┘ │
│                                                               │
│  🔔 SOLICITAÇÕES PENDENTES (3)                                │
│  ┌───────────────────────────────────────────────────────┐   │
│  │ João Silva - ABC-1234                                 │   │
│  │ Valor: R$ 500 | Saldo atual: R$ 45                   │   │
│  │ Justificativa: "Viagem longa SP-BA, 8 pedágios"      │   │
│  │ Solicitado: há 10 minutos                             │   │
│  │                                                        │   │
│  │ [ ✅ Aprovar ] [ ❌ Negar ] [ 💬 Pedir mais info ]    │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                               │
│  📋 MOTORISTAS - SALDO BAIXO (alerta < R$ 100)               │
│  ┌───────────────────────────────────────────────────────┐   │
│  │ ⚠️ Maria Santos - XYZ-5678 | Saldo: R$ 45            │   │
│  │ ⚠️ Pedro Costa - DEF-9012 | Saldo: R$ 78             │   │
│  │ [ Recarregar Todos ] [ Ver Detalhes ]                 │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                               │
│  🚛 TODOS OS MOTORISTAS                                       │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐   │
│  │ Motorista│ Veículo  │  Saldo   │ Usado Mês│  Ações   │   │
│  ├──────────┼──────────┼──────────┼──────────┼──────────┤   │
│  │ João S.  │ ABC-1234 │ R$ 450   │ R$ 1.250 │[Recarr] │   │
│  │ Maria S. │ XYZ-5678 │ R$ 45 ⚠️ │ R$ 980   │[Recarr] │   │
│  │ Pedro C. │ DEF-9012 │ R$ 780   │ R$ 1.100 │[Recarr] │   │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘   │
│                                                               │
│  📈 GRÁFICOS                                                  │
│  [Gráfico de gastos por mês]                                 │
│  [Gráfico de uso por motorista]                              │
│  [Gráfico de pedágios mais usados]                           │
│                                                               │
│  [💰 Comprar Créditos] [📊 Relatório Completo] [⚙️ Config]  │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

---

### 🛠️ **REQUISITOS TÉCNICOS**

#### **Integrações Necessárias**

**1. Provedor de Vale-Pedágio:**
- 🔗 **ConectCar** (API)
- 🔗 **Veloe** (API)
- 🔗 **Sem Parar** (API)
- 🔗 **Green Card** (API alternativa)

**2. Pagamento:**
- 💳 QR Code (padrão PIX)
- 📱 NFC (Android Pay / Apple Pay)
- 🔢 Código numérico (6 dígitos)

**3. Geolocalização:**
- 📍 Detectar proximidade de pedágios
- 🗺️ Base de dados de pedágios (lat/lng)

#### **Backend - API Endpoints**

```javascript
// Exemplos de endpoints necessários

// 1. Obter saldo do motorista
GET /api/v1/toll-pass/balance
Response: {
  balance: 450.00,
  currency: "BRL",
  last_updated: "2025-11-18T14:35:00Z"
}

// 2. Solicitar recarga
POST /api/v1/toll-pass/request-recharge
Body: {
  amount: 500.00,
  reason: "Viagem longa SP-BA"
}
Response: {
  request_id: "req_123",
  status: "pending",
  estimated_approval: "30 minutes"
}

// 3. Aprovar recarga (gestor)
POST /api/v1/toll-pass/approve-recharge
Body: {
  request_id: "req_123",
  approved: true
}
Response: {
  success: true,
  new_balance: 950.00
}

// 4. Gerar QR Code para pagamento
POST /api/v1/toll-pass/generate-payment-code
Body: {
  toll_id: "toll_regis_bittencourt",
  amount: 37.50
}
Response: {
  qr_code: "PIX_QR_CODE_STRING",
  numeric_code: "123456",
  expires_at: "2025-11-18T14:40:00Z"
}

// 5. Confirmar pagamento
POST /api/v1/toll-pass/confirm-payment
Body: {
  payment_code: "123456",
  toll_id: "toll_regis_bittencourt",
  amount: 37.50,
  latitude: -23.550520,
  longitude: -46.633308
}
Response: {
  success: true,
  new_balance: 412.50,
  transaction_id: "txn_789"
}

// 6. Histórico
GET /api/v1/toll-pass/history?days=7
Response: {
  transactions: [
    {
      id: "txn_789",
      type: "payment",
      amount: -37.50,
      toll_name: "Pedágio Régis Bittencourt",
      location: "BR-116, km 245",
      timestamp: "2025-11-18T14:35:00Z",
      balance_after: 412.50
    },
    ...
  ]
}
```

#### **Frontend - Flutter**

```dart
// Service para gerenciar vale-pedágio

class TollPassService {
  final ApiService _apiService;
  
  // Obter saldo
  Future<TollPassBalance> getBalance() async {
    final response = await _apiService.get('/api/v1/toll-pass/balance');
    return TollPassBalance.fromJson(response['data']);
  }
  
  // Solicitar recarga
  Future<RechargeRequest> requestRecharge({
    required double amount,
    required String reason,
  }) async {
    final response = await _apiService.post(
      '/api/v1/toll-pass/request-recharge',
      data: {
        'amount': amount,
        'reason': reason,
      },
    );
    return RechargeRequest.fromJson(response['data']);
  }
  
  // Gerar código de pagamento
  Future<PaymentCode> generatePaymentCode({
    required String tollId,
    required double amount,
  }) async {
    final response = await _apiService.post(
      '/api/v1/toll-pass/generate-payment-code',
      data: {
        'toll_id': tollId,
        'amount': amount,
      },
    );
    return PaymentCode.fromJson(response['data']);
  }
  
  // Confirmar pagamento
  Future<PaymentConfirmation> confirmPayment({
    required String paymentCode,
    required String tollId,
    required double amount,
    required LatLng location,
  }) async {
    final response = await _apiService.post(
      '/api/v1/toll-pass/confirm-payment',
      data: {
        'payment_code': paymentCode,
        'toll_id': tollId,
        'amount': amount,
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
    );
    return PaymentConfirmation.fromJson(response['data']);
  }
  
  // Detectar pedágio próximo
  Future<Toll?> detectNearbyToll(LatLng currentLocation) async {
    // Buscar pedágios em raio de 5km
    final tolls = await _getTollsNearby(currentLocation, radiusKm: 5);
    
    if (tolls.isEmpty) return null;
    
    // Retornar pedágio mais próximo
    return tolls.first;
  }
}
```

#### **Banco de Dados**

```sql
-- Tabela de saldo de vale-pedágio
CREATE TABLE toll_pass_balances (
  id UUID PRIMARY KEY,
  driver_id UUID REFERENCES drivers(id),
  balance DECIMAL(10, 2) DEFAULT 0.00,
  last_updated TIMESTAMP DEFAULT NOW(),
  
  INDEX idx_driver (driver_id)
);

-- Tabela de transações
CREATE TABLE toll_pass_transactions (
  id UUID PRIMARY KEY,
  driver_id UUID REFERENCES drivers(id),
  journey_id UUID REFERENCES journeys(id),
  
  type VARCHAR(20), -- 'recharge', 'payment', 'refund'
  amount DECIMAL(10, 2), -- negativo para pagamento
  balance_before DECIMAL(10, 2),
  balance_after DECIMAL(10, 2),
  
  -- Dados do pedágio (se payment)
  toll_id VARCHAR(100),
  toll_name VARCHAR(255),
  toll_location VARCHAR(255),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  
  -- Dados da recarga (se recharge)
  request_id UUID REFERENCES recharge_requests(id),
  
  created_at TIMESTAMP DEFAULT NOW(),
  
  INDEX idx_driver_date (driver_id, created_at DESC),
  INDEX idx_type (type)
);

-- Tabela de solicitações de recarga
CREATE TABLE recharge_requests (
  id UUID PRIMARY KEY,
  driver_id UUID REFERENCES drivers(id),
  amount DECIMAL(10, 2),
  reason TEXT,
  
  status VARCHAR(20), -- 'pending', 'approved', 'rejected'
  
  requested_at TIMESTAMP DEFAULT NOW(),
  reviewed_by UUID REFERENCES users(id),
  reviewed_at TIMESTAMP,
  review_notes TEXT,
  
  INDEX idx_status (status),
  INDEX idx_driver (driver_id)
);

-- Base de dados de pedágios
CREATE TABLE tolls (
  id VARCHAR(100) PRIMARY KEY,
  name VARCHAR(255),
  highway VARCHAR(50),
  km_marker DECIMAL(6, 2),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  
  price_light DECIMAL(6, 2),
  price_heavy DECIMAL(6, 2),
  
  accepts_qr_code BOOLEAN DEFAULT FALSE,
  accepts_nfc BOOLEAN DEFAULT FALSE,
  accepts_numeric BOOLEAN DEFAULT TRUE,
  
  operator VARCHAR(100),
  
  INDEX idx_location (latitude, longitude)
);
```

---

### ⏱️ **ESTIMATIVA DE DESENVOLVIMENTO**

#### **Fase 1: MVP (3-4 semanas)**
- ✅ Backend: Sistema de saldo - 1 semana
- ✅ Frontend: Telas básicas - 1 semana
- ✅ Integração: ConectCar API - 1 semana
- ✅ Testes: Piloto com 5 motoristas - 3 dias

#### **Fase 2: Pagamentos (2 semanas)**
- 💳 QR Code geração - 3 dias
- 📱 NFC integração - 4 dias
- 🔢 Código numérico - 2 dias
- 🧪 Testes em pedágios reais - 3 dias

#### **Fase 3: Dashboard (1-2 semanas)**
- 🖥️ Dashboard gestor - 1 semana
- 📊 Relatórios - 3 dias
- 🔔 Notificações - 2 dias

**TOTAL: 6-8 semanas (1.5-2 meses)**

---

### 💰 **ROI ESPERADO**

```
FROTA: 50 motoristas
GASTOS COM PEDÁGIO: R$ 500.000/ano
PERDAS COM VALE FÍSICO: 5%

ECONOMIA:
- Perdas antes: R$ 25.000/ano (roubos, fraudes)
- Perdas depois: R$ 2.500/ano (1%)
- ECONOMIA: R$ 22.500/ano

BENEFÍCIOS ADICIONAIS:
- Sem espera por vale físico: +2h/mês por motorista = R$ 30.000/ano
- Melhor controle de gastos: -10% desperdícios = R$ 50.000/ano
- ECONOMIA TOTAL: R$ 102.500/ano

ROI:
- Investimento: R$ 60.000
- Economia ano 1: R$ 102.500
- ROI: 170%
- Payback: 7 meses
```

---

### 🚨 **RISCOS E DESAFIOS**

- ❌ **Nem todo pedágio aceita digital**: Ter opção manual
- ❌ **Sinal de internet**: Gerar código com antecedência
- ❌ **Resistência inicial**: Treinamento e suporte
- ❌ **Custos de integração**: APIs podem ser caras
- ❌ **Segurança**: Proteger contra clonagem de códigos

---

## 3. 📴 MODO OFFLINE 100%

### 📊 **O PROBLEMA**

**Regiões Sem Sinal:**
- 🗺️ Interior do Brasil: muitas áreas sem 3G/4G
- 🏔️ Serras, túneis, áreas rurais
- 📶 Sinal intermitente em rodovias

**Impacto Atual:**
- ❌ **Não consegue iniciar jornada** se offline
- ❌ **Não consegue registrar abastecimento**
- ❌ **Não consegue fazer checklist**
- ❌ **Perde dados** se app fechar sem sync
- ❌ **Motorista frustrado** e improdutivo

**Prejuízo:**
- 🕒 Perda de tempo: ~2-4h/semana
- 📊 Dados perdidos: ~10% dos registros
- 😤 Baixa satisfação do motorista

---

### 💡 **SOLUÇÃO: OFFLINE-FIRST ARCHITECTURE**

#### **Arquitetura**

```
┌──────────────────────────────────────────────────┐
│                                                  │
│              APP FLUTTER                         │
│                                                  │
│  ┌────────────────────────────────────────┐     │
│  │                                        │     │
│  │         UI (TELAS)                     │     │
│  │                                        │     │
│  └────────────────────────────────────────┘     │
│                    ▼                             │
│  ┌────────────────────────────────────────┐     │
│  │                                        │     │
│  │         BLoC (LÓGICA)                  │     │
│  │                                        │     │
│  └────────────────────────────────────────┘     │
│                    ▼                             │
│  ┌────────────────────────────────────────┐     │
│  │                                        │     │
│  │    LOCAL DATABASE (SQLite/Hive)       │     │
│  │    - Journeys                          │     │
│  │    - Refuelings                        │     │
│  │    - Checklists                        │     │
│  │    - Location Points                   │     │
│  │                                        │     │
│  │    SEMPRE ESCREVE LOCAL PRIMEIRO! ✅   │     │
│  │                                        │     │
│  └────────────────────────────────────────┘     │
│                    ▼                             │
│  ┌────────────────────────────────────────┐     │
│  │                                        │     │
│  │    SYNC SERVICE                        │     │
│  │    - Monitora conexão                  │     │
│  │    - Sincroniza quando online          │     │
│  │    - Retry automático                  │     │
│  │    - Conflitos resolvidos              │     │
│  │                                        │     │
│  └────────────────────────────────────────┘     │
│                    ▼                             │
│  ┌────────────────────────────────────────┐     │
│  │                                        │     │
│  │    API SERVICE                         │     │
│  │    - POST quando online                │     │
│  │    - Queue se offline                  │     │
│  │                                        │     │
│  └────────────────────────────────────────┘     │
│                    ▼                             │
└──────────────────────────────────────────────────┘
                     ▼
            ┌──────────────┐
            │   BACKEND    │
            │   (ONLINE)   │
            └──────────────┘
```

**Princípio Fundamental:**
```
1. ESCREVER SEMPRE LOCAL
2. MOSTRAR SEMPRE LOCAL
3. SINCRONIZAR QUANDO POSSÍVEL
```

---

### 📱 **FUNCIONALIDADES OFFLINE**

#### **✅ O QUE FUNCIONA SEM INTERNET:**

**1. Jornadas**
- ✅ Iniciar jornada
- ✅ Finalizar jornada
- ✅ Pausar/Retomar
- ✅ Ver histórico
- ✅ Ver tempo/KM

**2. Abastecimentos**
- ✅ Registrar abastecimento
- ✅ Tirar foto do comprovante
- ✅ Ver histórico
- ✅ Validar placa

**3. Checklist**
- ✅ Fazer checklist completo
- ✅ Responder perguntas
- ✅ Tirar fotos
- ✅ Assinar digitalmente

**4. Localização**
- ✅ Capturar pontos GPS
- ✅ Calcular KM
- ✅ Salvar rota

**5. Perfil**
- ✅ Ver dados pessoais
- ✅ Ver documentos
- ✅ Ver estatísticas

#### **❌ O QUE NÃO FUNCIONA (requer internet):**

- ❌ Login (primeira vez)
- ❌ Buscar novo checklist
- ❌ Chat em tempo real
- ❌ Ver mapa online
- ❌ Notificações push

---

### 📱 **UX/UI - INDICADORES DE STATUS**

```
┌─────────────────────────────────────┐
│  🌐 ONLINE                          │ ← Verde
│  ZECA - Jornada Ativa               │
├─────────────────────────────────────┤

ou

┌─────────────────────────────────────┐
│  📴 OFFLINE (3 pendentes)           │ ← Laranja
│  ZECA - Jornada Ativa               │
├─────────────────────────────────────┤

ou

┌─────────────────────────────────────┐
│  🔄 SINCRONIZANDO... (2/5)          │ ← Azul
│  ZECA - Jornada Ativa               │
├─────────────────────────────────────┤
```

**Banner de Offline:**
```
┌─────────────────────────────────────┐
│  📴 MODO OFFLINE                    │
│                                     │
│  Você está sem internet, mas pode  │
│  continuar usando o app normalmente.│
│                                     │
│  ✅ Seus dados serão sincronizados  │
│  automaticamente quando voltar      │
│  online.                            │
│                                     │
│  📊 3 itens aguardando sync:        │
│  • 1 abastecimento                  │
│  • 1 checklist                      │
│  • 245 pontos GPS                   │
│                                     │
│  [    Entendi    ]                  │
│                                     │
└─────────────────────────────────────┘
```

**Sincronização Automática:**
```
┌─────────────────────────────────────┐
│  🎉 Voltou Online!                  │
│                                     │
│  🔄 Sincronizando seus dados...     │
│                                     │
│  [████████░░░░░░░░] 50%             │
│                                     │
│  • Abastecimento ✅ Enviado         │
│  • Checklist 🔄 Enviando...         │
│  • Pontos GPS ⏳ Na fila            │
│                                     │
└─────────────────────────────────────┘
```

---

### 🛠️ **IMPLEMENTAÇÃO TÉCNICA**

#### **1. Banco de Dados Local (SQLite + Hive)**

```dart
// Hive para configurações simples
@HiveType(typeId: 0)
class LocalSettings {
  @HiveField(0)
  bool isDarkMode;
  
  @HiveField(1)
  String? lastSyncTimestamp;
  
  @HiveField(2)
  bool autoSyncEnabled;
}

// SQLite para dados estruturados
class LocalDatabase {
  Database? _database;
  
  // Tabelas
  static const String TABLE_JOURNEYS = 'journeys';
  static const String TABLE_REFUELINGS = 'refuelings';
  static const String TABLE_CHECKLISTS = 'checklists';
  static const String TABLE_LOCATIONS = 'location_points';
  static const String TABLE_SYNC_QUEUE = 'sync_queue';
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'zeca_offline.db'),
      onCreate: (db, version) async {
        // Criar tabelas
        await db.execute('''
          CREATE TABLE $TABLE_JOURNEYS (
            id TEXT PRIMARY KEY,
            plate TEXT,
            start_odometer INTEGER,
            start_timestamp TEXT,
            status TEXT,
            synced INTEGER DEFAULT 0,
            created_at TEXT
          )
        ''');
        
        await db.execute('''
          CREATE TABLE $TABLE_REFUELINGS (
            id TEXT PRIMARY KEY,
            journey_id TEXT,
            liters REAL,
            value REAL,
            photo_path TEXT,
            latitude REAL,
            longitude REAL,
            timestamp TEXT,
            synced INTEGER DEFAULT 0,
            created_at TEXT
          )
        ''');
        
        await db.execute('''
          CREATE TABLE $TABLE_SYNC_QUEUE (
            id TEXT PRIMARY KEY,
            entity_type TEXT,
            entity_id TEXT,
            data TEXT,
            retry_count INTEGER DEFAULT 0,
            created_at TEXT
          )
        ''');
      },
      version: 1,
    );
  }
}
```

#### **2. Offline-First Repository Pattern**

```dart
class JourneyRepository {
  final LocalDatabase _localDb;
  final ApiService _apiService;
  final ConnectivityService _connectivity;
  
  // SEMPRE escreve local primeiro
  Future<Journey> startJourney({
    required String plate,
    required int odometer,
  }) async {
    // 1. Criar journey localmente
    final journey = Journey(
      id: Uuid().v4(),
      plate: plate,
      startOdometer: odometer,
      startTimestamp: DateTime.now(),
      status: 'active',
      synced: false,
    );
    
    // 2. Salvar no banco local
    await _localDb.insertJourney(journey);
    
    // 3. Adicionar à fila de sync
    await _localDb.addToSyncQueue(
      entityType: 'journey',
      entityId: journey.id,
      data: journey.toJson(),
    );
    
    // 4. Tentar sincronizar agora (se online)
    if (await _connectivity.isConnected) {
      _syncJourneyInBackground(journey);
    }
    
    // 5. Retornar journey local imediatamente
    return journey;
  }
  
  Future<void> _syncJourneyInBackground(Journey journey) async {
    try {
      // Enviar para API
      final response = await _apiService.post(
        '/api/v1/journeys',
        data: journey.toJson(),
      );
      
      if (response['success']) {
        // Marcar como sincronizado
        await _localDb.markAsSynced(
          entityType: 'journey',
          entityId: journey.id,
        );
        
        // Remover da fila
        await _localDb.removeFromSyncQueue(journey.id);
      }
    } catch (e) {
      debugPrint('Erro ao sincronizar: $e');
      // Não faz nada - ficará na fila para retry
    }
  }
}
```

#### **3. Sync Service (Background)**

```dart
class SyncService {
  final LocalDatabase _localDb;
  final ApiService _apiService;
  final ConnectivityService _connectivity;
  
  Timer? _syncTimer;
  bool _isSyncing = false;
  
  // Iniciar monitoramento
  void startMonitoring() {
    // Tentar sincronizar a cada 30 segundos
    _syncTimer = Timer.periodic(
      Duration(seconds: 30),
      (_) => syncPendingItems(),
    );
    
    // Escutar mudanças de conectividade
    _connectivity.onConnectivityChanged.listen((isConnected) {
      if (isConnected && !_isSyncing) {
        syncPendingItems();
      }
    });
  }
  
  Future<void> syncPendingItems() async {
    if (_isSyncing) return;
    if (!await _connectivity.isConnected) return;
    
    _isSyncing = true;
    
    try {
      // Obter itens pendentes
      final queue = await _localDb.getSyncQueue();
      
      debugPrint('🔄 Sync: ${queue.length} itens pendentes');
      
      for (final item in queue) {
        try {
          // Enviar para API
          await _syncItem(item);
          
          // Marcar como sincronizado
          await _localDb.markAsSynced(
            entityType: item.entityType,
            entityId: item.entityId,
          );
          
          // Remover da fila
          await _localDb.removeFromSyncQueue(item.id);
          
          debugPrint('✅ Sync: ${item.entityType} ${item.entityId}');
        } catch (e) {
          debugPrint('❌ Sync falhou: ${item.entityType} ${item.entityId}');
          
          // Incrementar retry count
          await _localDb.incrementRetryCount(item.id);
          
          // Se passou de 5 tentativas, notificar usuário
          if (item.retryCount >= 5) {
            _notifyUserSyncFailed(item);
          }
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
  
  Future<void> _syncItem(SyncQueueItem item) async {
    switch (item.entityType) {
      case 'journey':
        await _apiService.post('/api/v1/journeys', data: item.data);
        break;
      case 'refueling':
        await _apiService.post('/api/v1/refuelings', data: item.data);
        break;
      case 'checklist':
        await _apiService.post('/api/v1/checklists', data: item.data);
        break;
      case 'location_points':
        await _apiService.post('/api/v1/locations/batch', data: item.data);
        break;
    }
  }
}
```

#### **4. Conectividade Service**

```dart
class ConnectivityService {
  final StreamController<bool> _connectivityController = 
      StreamController<bool>.broadcast();
  
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;
  
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  
  void startMonitoring() {
    Timer.periodic(Duration(seconds: 5), (_) async {
      final connected = await isConnected;
      _connectivityController.add(connected);
    });
  }
}
```

---

### ⏱️ **ESTIMATIVA DE DESENVOLVIMENTO**

#### **Fase 1: Banco Local (2 semanas)**
- 💾 SQLite schema - 3 dias
- 💾 Hive config - 2 dias
- 💾 Repository pattern - 4 dias
- 🧪 Testes - 3 dias

#### **Fase 2: Sync Service (2 semanas)**
- 🔄 Fila de sincronização - 4 dias
- 🔄 Retry logic - 3 dias
- 🔄 Conflitos - 3 dias
- 🧪 Testes - 4 dias

#### **Fase 3: UI/UX (1 semana)**
- 🎨 Indicadores de status - 2 dias
- 🎨 Banners informativos - 2 dias
- 🎨 Animações - 1 dia
- 🧪 Testes UX - 2 dias

**TOTAL: 5 semanas (1.25 meses)**

---

### 💰 **ROI ESPERADO**

```
FROTA: 50 motoristas
TEMPO OFFLINE POR SEMANA: 2-4h por motorista

ECONOMIA:
- Perda de produtividade antes: 150h/mês (50 × 3h)
- Custo hora/motorista: R$ 50
- Perda mensal: R$ 7.500
- Perda anual: R$ 90.000

APÓS OFFLINE MODE:
- Perda de produtividade: 0h
- ECONOMIA: R$ 90.000/ano

BENEFÍCIOS ADICIONAIS:
- Dados não perdidos: ~10% mais precisão
- Satisfação do motorista: ↑ 50%
- Menos suporte: -30% chamados

ROI:
- Investimento: R$ 50.000
- Economia ano 1: R$ 90.000
- ROI: 180%
- Payback: 7 meses
```

---

### 🚨 **RISCOS E DESAFIOS**

- ❌ **Armazenamento**: Limite de espaço no celular
  - **Solução**: Limpar dados antigos após sync (> 30 dias)
- ❌ **Conflitos**: Mesmo dado editado offline e online
  - **Solução**: Timestamp + "último ganha"
- ❌ **Performance**: Banco local pode ficar lento
  - **Solução**: Índices, limpeza periódica
- ❌ **Sincronização**: Pode demorar com muitos dados
  - **Solução**: Batch, priorização, progress bar

---

## 4. 🏎️ ALERTA DE VELOCIDADE

### 📊 **O PROBLEMA**

**Excesso de Velocidade:**
- 🚨 Principal causa de acidentes graves
- 💰 Multas pesadas (R$ 1.900 + 7 pontos CNH)
- ⛽ Aumenta consumo de combustível em até 30%
- 🚛 Desgaste maior do veículo

**Números:**
- 40% dos acidentes envolvem velocidade
- Frota média: 5-10 multas/mês
- Custo anual: R$ 50-100 mil

---

### 💡 **SOLUÇÃO: ALERTA INTELIGENTE**

#### **Funcionalidades**

**1. Alerta em Tempo Real**
- 📱 Vibração + som quando exceder limite
- 🚨 Alerta visual (tela pisca vermelha)
- 🔔 Notificação persistente

**2. Limites Dinâmicos**
- 🗺️ Detectar tipo de via automaticamente:
  - Rodovia federal: 110 km/h
  - Rodovia estadual: 100 km/h
  - Via urbana: 60 km/h
  - Zona escolar: 40 km/h
- 📍 Integrar com base de dados de limites
- ⚙️ Gestor pode customizar por frota

**3. Níveis de Alerta**
```
VELOCIDADE vs LIMITE:
├─ < 100%: ✅ Normal (verde)
├─ 100-110%: ⚠️ Atenção (amarelo)
├─ 110-120%: 🔶 Alerta (laranja)
└─ > 120%: 🚨 Crítico (vermelho)
```

---

### 📱 **FLUXO DE TELAS**

**Tela Normal (Dentro do Limite):**
```
┌─────────────────────────────────────┐
│  🚛 Jornada Ativa                   │
├─────────────────────────────────────┤
│                                     │
│  ⚡ VELOCIDADE                      │
│                                     │
│       85 km/h   ✅                  │
│                                     │
│  Limite da via: 110 km/h            │
│  BR-116, km 245                     │
│                                     │
│  ────────────────────────────       │
│                                     │
│  🕒 Tempo: 2h 15min                 │
│  📍 KM: 185 km                      │
│                                     │
└─────────────────────────────────────┘
```

**Alerta Atenção (110% do limite):**
```
┌─────────────────────────────────────┐
│  🚛 Jornada Ativa                   │
├─────────────────────────────────────┤
│                                     │
│  ⚠️ VELOCIDADE ELEVADA ⚠️           │
│                                     │
│      🟡 121 km/h 🟡                │
│                                     │
│  Limite da via: 110 km/h            │
│  Você está 10% acima                │
│                                     │
│  💡 Reduza para 110 km/h            │
│                                     │
└─────────────────────────────────────┘
  (Fundo amarelo piscando)
  (Vibração curta)
```

**Alerta Crítico (> 120%):**
```
┌─────────────────────────────────────┐
│  🚨 ATENÇÃO! REDUZA A VELOCIDADE! 🚨│
├─────────────────────────────────────┤
│                                     │
│  ⛔ VELOCIDADE PERIGOSA ⛔          │
│                                     │
│      🔴 145 km/h 🔴                │
│                                     │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━        │
│  Limite: 110 km/h                   │
│  Excesso: 35 km/h (+32%)            │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━        │
│                                     │
│  🚨 RISCO DE MULTA                  │
│  🚨 RISCO DE ACIDENTE               │
│                                     │
│  REDUZA IMEDIATAMENTE!              │
│                                     │
└─────────────────────────────────────┘
  (Fundo vermelho piscando)
  (Vibração contínua)
  (Som de alarme)
  (Tela cheia - não pode fechar)
```

**Histórico de Infrações:**
```
┌─────────────────────────────────────┐
│  📊 Relatório de Velocidade         │
├─────────────────────────────────────┤
│                                     │
│  🏆 SEU SCORE: 87/100               │
│  ⭐⭐⭐⭐☆                           │
│                                     │
│  📅 ÚLTIMOS 30 DIAS                 │
│                                     │
│  ✅ Dentro do limite: 92%           │
│  ⚠️ Acima do limite: 8%             │
│  🚨 Infrações graves: 3             │
│                                     │
│  ────────────────────────────       │
│                                     │
│  📍 INFRAÇÕES RECENTES              │
│                                     │
│  🚨 18/11 | BR-116 | 145 km/h      │
│     Limite: 110 km/h (+32%)        │
│                                     │
│  ⚠️ 15/11 | BR-101 | 125 km/h      │
│     Limite: 110 km/h (+14%)        │
│                                     │
│  ⚠️ 12/11 | SP-330 | 118 km/h      │
│     Limite: 100 km/h (+18%)        │
│                                     │
│  ────────────────────────────       │
│                                     │
│  💡 DICA                            │
│  Manter velocidade constante        │
│  economiza até 20% de combustível!  │
│                                     │
│  [ Ver Relatório Completo ]         │
│                                     │
└─────────────────────────────────────┘
```

---

### 🛠️ **IMPLEMENTAÇÃO TÉCNICA**

```dart
class SpeedAlertService {
  final StreamController<SpeedAlert> _alertController = 
      StreamController<SpeedAlert>.broadcast();
  
  Stream<SpeedAlert> get onSpeedAlert => _alertController.stream;
  
  // Limites por tipo de via
  final Map<RoadType, int> _speedLimits = {
    RoadType.highway: 110,
    RoadType.stateRoad: 100,
    RoadType.urban: 60,
    RoadType.schoolZone: 40,
  };
  
  void checkSpeed({
    required double currentSpeed, // km/h
    required RoadType roadType,
    required LatLng location,
  }) {
    final limit = _speedLimits[roadType] ?? 110;
    final percentage = (currentSpeed / limit);
    
    SpeedAlertLevel level;
    
    if (percentage < 1.0) {
      level = SpeedAlertLevel.normal;
    } else if (percentage < 1.1) {
      level = SpeedAlertLevel.attention;
    } else if (percentage < 1.2) {
      level = SpeedAlertLevel.warning;
    } else {
      level = SpeedAlertLevel.critical;
    }
    
    // Se não é normal, disparar alerta
    if (level != SpeedAlertLevel.normal) {
      final alert = SpeedAlert(
        currentSpeed: currentSpeed,
        speedLimit: limit.toDouble(),
        percentage: percentage,
        level: level,
        location: location,
        timestamp: DateTime.now(),
      );
      
      _alertController.add(alert);
      
      // Vibrar e tocar som
      if (level == SpeedAlertLevel.critical) {
        _triggerCriticalAlert();
      } else {
        _triggerWarningAlert();
      }
      
      // Registrar no banco para relatório
      _saveSpeedViolation(alert);
    }
  }
  
  void _triggerCriticalAlert() {
    // Vibração contínua
    Vibration.vibrate(pattern: [500, 200, 500, 200], repeat: 0);
    
    // Som de alarme
    AudioPlayer().play(AssetSource('sounds/speed_alert_critical.mp3'));
    
    // Notificação
    NotificationService().show(
      title: '🚨 VELOCIDADE PERIGOSA',
      body: 'Reduza imediatamente!',
      priority: Priority.max,
    );
  }
  
  void _triggerWarningAlert() {
    // Vibração curta
    Vibration.vibrate(duration: 500);
    
    // Som suave
    AudioPlayer().play(AssetSource('sounds/speed_alert_warning.mp3'));
  }
  
  Future<void> _saveSpeedViolation(SpeedAlert alert) async {
    await database.insert('speed_violations', {
      'current_speed': alert.currentSpeed,
      'speed_limit': alert.speedLimit,
      'percentage': alert.percentage,
      'level': alert.level.toString(),
      'latitude': alert.location.latitude,
      'longitude': alert.location.longitude,
      'timestamp': alert.timestamp.toIso8601String(),
    });
  }
}
```

---

### ⏱️ **ESTIMATIVA: 2-3 DIAS**

- ✅ Service de alerta - 1 dia
- ✅ UI/UX - 1 dia
- ✅ Testes - meio dia

---

### 💰 **ROI: R$ 50.000/ano**

- Redução de multas: 70%
- Economia de combustível: 10%
- Menos acidentes: priceless

---

## 📊 **COMPARAÇÃO FINAL**

| Funcionalidade | Esforço | ROI Ano 1 | Prioridade |
|----------------|---------|-----------|------------|
| 🔍 IA Fraudes | 2-3 meses | R$ 160k | 🔥🔥🔥 |
| 💳 Vale Digital | 1.5-2 meses | R$ 102k | 🔥🔥🔥 |
| 📴 Offline 100% | 1.25 meses | R$ 90k | 🔥🔥 |
| 🏎️ Alerta Velocidade | 2-3 dias | R$ 50k | 🔥🔥🔥 |

---

## 🎯 **MINHA RECOMENDAÇÃO**

**FASE 1 (Próximos 3 meses):**
1. 🏎️ **Alerta de Velocidade** (2-3 dias) - Quick win!
2. 📴 **Modo Offline** (1.25 meses) - Base sólida
3. 💳 **Vale-Pedágio Digital** (1.5-2 meses) - Alto impacto

**FASE 2 (6 meses depois):**
4. 🔍 **IA: Detecção de Fraudes** (2-3 meses) - Máximo ROI

---

**Qual você quer começar primeiro?** 🚀

