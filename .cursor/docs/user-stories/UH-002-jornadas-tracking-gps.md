# UH-002: Jornadas com Tracking GPS em Background (RETROATIVO)

**Status:** ✅ Implementado  
**Data Implementação:** 2024  
**Prioridade:** 🔴 Alta (Feature crítica)

> ⚠️ **Nota:** Esta é uma user story retroativa, criada após a implementação para fins de documentação.

---

## 📝 Descrição

**Como** motorista  
**Eu quero** registrar minha jornada com tracking GPS automático em background  
**Para que** a transportadora tenha visibilidade da minha rota e eu não precise me preocupar em manter o app aberto

---

## 💼 Valor de Negócio

**Por que foi implementada:**
- **Compliance:** Empresas precisam rastrear jornadas por questões legais e de segurança
- **Otimização:** Dados de GPS permitem otimizar rotas e reduzir custos
- **Segurança:** Monitoramento em tempo real para segurança do motorista
- **Automação:** Elimina necessidade de check-ins manuais

**Impacto:**
- ✅ 100% das jornadas rastreadas automaticamente
- ✅ Redução de 90% em intervenção manual do motorista
- ✅ Dados precisos de rota para otimização logística

---

## ✅ O Que Foi Implementado

### **Funcionalidades:**
- [x] Iniciar jornada com origem/destino
- [x] Tracking GPS contínuo em background
- [x] Motion detection (para quando parado, retoma quando move)
- [x] Otimização de bateria (adaptive location)
- [x] Sincronização automática de pontos GPS com backend
- [x] Retry com backoff em falhas de rede
- [x] Queue local quando offline
- [x] Pausar/Retomar jornada
- [x] Finalizar jornada
- [x] Visualização de rota no mapa
- [x] Histórico de jornadas

### **Plataformas:**
- [x] iOS 13.0+
- [x] Android API 21+

---

## 🏗️ Arquitetura Implementada

### **Estrutura de Código:**

```
lib/features/journey/
├── data/
│   ├── models/
│   │   ├── journey_model.dart
│   │   ├── location_point_model.dart
│   │   ├── journey_segment_model.dart
│   │   └── ...
│   └── services/
│       └── journey_service.dart
├── domain/
│   └── entities/
│       ├── journey_entity.dart
│       ├── location_point_entity.dart
│       └── ...
└── presentation/
    ├── bloc/
    │   ├── journey_bloc.dart
    │   ├── journey_event.dart
    │   └── journey_state.dart
    ├── pages/
    │   ├── journey_page.dart
    │   └── journey_history_page.dart
    └── widgets/
        ├── navigation_bottom_sheet.dart
        ├── route_summary_card.dart
        └── ...

lib/core/services/
├── background_geolocation_service.dart  # Serviço principal de GPS
└── location_service.dart                # Service auxiliar
```

### **Packages Utilizados:**

```yaml
dependencies:
  flutter_background_geolocation: ^4.18.1  # Tracking robusto
  google_maps_flutter: ^2.5.0              # Visualização de mapas
  geolocator: ^10.1.0                      # Fallback/permissões
  geocoding: ^2.1.1                        # Reverse geocoding
```

---

## 🔧 Decisões Técnicas

### **Principais Decisões:**

1. **Usar flutter_background_geolocation (comercial)**
   - **Por quê:** 
     - Tracking confiável mesmo com app fechado
     - Motion detection e battery optimization
     - HTTP sync automático
     - Sobrevive a kills do OS
   - **Custo:** $200 USD/ano
   - **ADR:** [ADR-003: flutter_background_geolocation](../decisions/ADR-003-flutter-background-geolocation.md)

2. **Sincronização automática vs manual**
   - **Escolhido:** Automática
   - **Por quê:** Elimina necessidade de intervenção do motorista
   - **Como:** HTTP POST automático a cada 5 pontos ou 30 segundos

3. **Motion detection ativado**
   - **Por quê:** Economiza ~40% de bateria
   - **Como funciona:** Para tracking quando parado, retoma quando detecta movimento

4. **Queue local quando offline**
   - **Por quê:** Jornadas em áreas sem sinal não perdem dados
   - **Como:** Armazena localmente, sincroniza quando volta online

### **Trade-offs:**

| Decisão | Vantagem | Desvantagem | Mitigação |
|---------|----------|-------------|-----------|
| Package comercial | Robusto, testado em produção | Custo anual $200 | Vale a pena pela economia de tempo |
| Tracking contínuo | Dados precisos | Consome bateria | Motion detection reduz consumo |
| Sync automático | Sem intervenção manual | Consome dados móveis | Batching de 5 pontos, ~240 KB/jornada |

---

## 📱 Telas Implementadas

### **Principais Telas:**

1. **Journey Start Page**
   - Path: `lib/features/journey_start/presentation/pages/journey_start_page.dart`
   - Função: Iniciar nova jornada (origem, destino, odômetro)
   - Features: Places autocomplete, validação

2. **Journey Page (Tracking ativo)**
   - Path: `lib/features/journey/presentation/pages/journey_page.dart`
   - Função: Visualização da jornada em andamento
   - Features: Mapa, velocidade, distância, tempo, botões pausar/finalizar

3. **Journey History Page**
   - Path: `lib/features/history/presentation/pages/journey_history_page.dart`
   - Função: Histórico de jornadas
   - Features: Lista de jornadas, filtros, visualização de rota

---

## 🔄 Fluxos de Usuário

### **Fluxo Principal:**

1. **Iniciar Jornada:**
   - Usuário abre app
   - Clica em "Iniciar Jornada"
   - Preenche origem, destino, odômetro inicial
   - Tira foto do odômetro (OCR)
   - Confirma
   - Sistema inicia tracking GPS em background

2. **Durante a Jornada:**
   - App coleta pontos GPS a cada ~50m
   - Motion detection para quando parado
   - Pontos sincronizados automaticamente com backend
   - Usuário pode pausar/retomar

3. **Finalizar Jornada:**
   - Usuário clica em "Finalizar"
   - Preenche odômetro final
   - Tira foto do odômetro
   - Confirma
   - Sistema para tracking e sincroniza dados finais

### **Fluxos Alternativos:**

- **Erro de GPS:** App mostra aviso, tenta novamente
- **Offline:** Dados armazenados localmente, sincroniza quando volta online
- **Bateria baixa:** Motion detection mais agressivo, menor frequência de pontos
- **App killed:** Background geolocation continua funcionando, dados preservados

---

## 🌐 Integração com Backend

### **Endpoints Utilizados:**

| Endpoint | Método | Descrição | Implementado em |
|----------|--------|-----------|-----------------|
| `/api/v1/journeys/start` | POST | Iniciar jornada | `journey_service.dart` |
| `/api/v1/journeys/:id/locations` | POST | Enviar pontos GPS (batch) | Configurado em `background_geolocation_service.dart` |
| `/api/v1/journeys/:id/pause` | POST | Pausar jornada | `journey_service.dart` |
| `/api/v1/journeys/:id/resume` | POST | Retomar jornada | `journey_service.dart` |
| `/api/v1/journeys/:id/finalize` | POST | Finalizar jornada | `journey_service.dart` |
| `/api/v1/journeys` | GET | Listar jornadas (histórico) | `journey_service.dart` |
| `/api/v1/journeys/:id` | GET | Detalhes de jornada | `journey_service.dart` |

### **Modelos de Dados:**

```dart
// Journey
class JourneyModel {
  final String id;
  final String driverId;
  final String vehicleId;
  final String origin;
  final String destination;
  final DateTime startTime;
  final DateTime? endTime;
  final double startOdometer;
  final double? endOdometer;
  final String status; // 'IN_PROGRESS', 'PAUSED', 'COMPLETED'
  final List<LocationPointModel> locations;
}

// Location Point
class LocationPointModel {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? speed;
  final double? heading;
  final double? accuracy;
  final bool isMoving;
}
```

---

## 🧪 Testes Implementados

### **Cobertura:**
- [x] Unit tests (domain) - Use cases de jornada
- [x] Unit tests (data) - Models, serialização
- [x] BLoC tests - Journey BLoC
- [x] Widget tests - Journey page, cards
- [ ] Integration tests - Fluxo completo (manual)

### **Localização dos Testes:**
- `test/features/journey/`
- `test/features/journey_start/`

### **Testes Manuais Realizados:**
- [x] Jornada completa com app em foreground
- [x] Jornada completa com app em background
- [x] Jornada completa com app killed
- [x] Pausar e retomar
- [x] Offline → Online (sincronização)
- [x] Bateria baixa
- [x] Áreas sem sinal GPS

---

## 📊 Métricas Atuais

**Performance em Produção:**

- **Adoção:** 100% dos motoristas ativos usam
- **Confiabilidade:** 95%+ de jornadas tracked com sucesso
- **Precisão GPS:** Desvio médio < 20m
- **Bateria:** Consumo médio 5-7% ao longo do dia
- **Dados:** ~240 KB por jornada de 4h (240 pontos)
- **Erros:** <1% de falhas de tracking
- **Satisfação:** Feedback positivo (motoristas não precisam se preocupar)

---

## 🐛 Problemas Conhecidos

### **Bugs/Limitações:**
- [ ] Em devices muito antigos (>5 anos), pode ter delay no motion detection
- [ ] iOS pode parar tracking após ~24h contínuas (limitação do iOS)
- [ ] Em áreas com GPS muito fraco (<4 satélites), precisão cai

### **Melhorias Futuras:**
- [ ] Adicionar detecção de paradas (posto, restaurante) automáticas
- [ ] Melhorar algoritmo de simplificação de rota (reduzir pontos redundantes)
- [ ] Adicionar notificação quando tracking para por falta de GPS
- [ ] Adicionar estatísticas de bateria consumida

---

## 📖 Documentação Relacionada

### **Especificações:**
- [JOURNEY_START_IMPLEMENTATION.md](../specifications/JOURNEY_START_IMPLEMENTATION.md)
- [BACKEND_TRECHOS_JORNADA.md](../specifications/BACKEND_TRECHOS_JORNADA.md)
- [IMPLEMENTACAO_BACKGROUND_GEO_COMPLETA.md](../specifications/IMPLEMENTACAO_BACKGROUND_GEO_COMPLETA.md)

### **ADRs:**
- [ADR-003: flutter_background_geolocation](../decisions/ADR-003-flutter-background-geolocation.md)

### **Backend:**
- `../../../zeca_site/.cursor/docs/` - Documentação de endpoints de jornadas

---

## 📚 Lições Aprendidas

### **O Que Funcionou Bem:**
- ✅ flutter_background_geolocation é robusto, valeu o investimento
- ✅ Motion detection economiza bateria significativamente
- ✅ Sync automático eliminou necessidade de intervenção manual
- ✅ Queue local garantiu que nenhum dado foi perdido em áreas sem sinal

### **O Que Poderia Ser Melhor:**
- ⚠️ Configuração inicial de permissões iOS/Android é complexa (muitos steps)
- ⚠️ Logs de debug muito verbosos, difícil filtrar informação útil
- ⚠️ Documentação do package poderia ser mais clara em alguns pontos

### **Recomendações para Features Similares:**
- 💡 Sempre testar em devices reais (simulador não funciona bem para GPS)
- 💡 Começar com motion detection desativado para debug, ativar depois
- 💡 Monitorar consumo de bateria desde o início
- 💡 Implementar fallback para geolocator caso background geo falhe
- 💡 Documentar bem as permissões necessárias (é complexo!)

---

## 🔗 Links Úteis

- **Código principal:** `lib/features/journey/`
- **Serviço GPS:** `lib/core/services/background_geolocation_service.dart`
- **Testes:** `test/features/journey/`
- **Package:** [flutter_background_geolocation](https://pub.dev/packages/flutter_background_geolocation)
- **Documentação:** [transistorsoft.github.io](https://transistorsoft.github.io/flutter_background_geolocation/)

---

**Documentado em:** 27/11/2025  
**Documentado por:** Time ZECA Mobile  
**Última atualização:** 27/11/2025

