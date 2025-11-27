# UH-003: Navegação em Tempo Real com Destino Obrigatório

**Data de Criação:** 27/11/2024  
**Status:** 📋 Planejamento  
**Prioridade:** 🔴 Alta  
**Complexidade:** 🟡 Média (4 story points - REDUZIDO após análise)

---

## 🔍 Análise do Existente

> **Análise realizada em:** 27/11/2024

### ✅ O Que JÁ Existe:

#### Backend (100% pronto):
- ✅ `POST /journeys/start` - aceita `destino` e `previsao_km`
- ✅ `POST /journeys/toggle-rest` - gerencia trechos automaticamente
- ✅ `POST /journeys/finish` - retorna `segments_summary` e `rest_periods`
- ✅ `GET /journeys/:id` - inclui `rest_periods` para contagem
- ✅ Entidades: `JourneySegment`, `JourneyRestPeriod`, `Journey`
- ✅ **Status Backend:** 100% implementado

#### App Flutter (70% pronto):
- ✅ **Tela de Início** (`journey_page.dart`):
  - Autocomplete de destino funcionando (`PlacesAutocompleteField`)
  - Cálculo de rota com banner verde mostrando "Rota calculada: 8.3 km (20 min)"
  - OCR do odômetro inicial
  
- ✅ **Tela de Viagem Ativa** (`journey_page.dart`):
  - Mapa com rota azul traçada (`RouteMapView`)
  - Card verde no topo (`NavigationInfoCard`) mostrando rua atual
  - Card de odômetro (KM percorridos + odômetro atual)
  - 3 botões: Finalizar (vermelho), Parar (verde), Descanso (laranja)
  - Velocidade em tempo real (`SpeedCard`)
  - Bottom sheet ZECA (tempo, distância, chegada, botão sair)
  
- ✅ **Serviços**:
  - `DirectionsService` - calcula rota (distância, tempo, polyline)
  - `PlacesService` - autocomplete
  - `BackgroundGeolocationService` - tracking GPS
  - `NavigationBottomSheet` widget
  - `SpeedCard` widget
  - `RouteMapView` - suporta modo navegação/overview
  
- ✅ **BLoC**:
  - `JourneyBloc` com eventos: `StartJourney`, `ToggleRest`, `FinishJourney`
  - Estados: `JourneyLoaded` com `emDescanso`, `tempoDecorridoSegundos`, etc.

- ✅ **Status App:** 70% implementado

### ❌ O Que Precisa Ser Implementado:

1. **Destino Obrigatório (0.5h)**
   - Tornar campo obrigatório (hoje é opcional)
   - Validação no form

2. **Animação Inicial 5s (1h)**
   - Zoom out por 5 segundos ao iniciar
   - Card overlay com info da rota
   - Transição automática para modo navegação

3. **FAB "Visualizar Rota" (0.5h)**
   - Botão flutuante topo-direito
   - Alternar entre zoom in/out

4. **Instruções Turn-by-Turn Dinâmicas (5h)**
   - Expandir `DirectionsService` para retornar `steps`
   - Criar `NavigationService` para processar steps
   - Atualizar `NavigationInfoCard` com:
     - "Em X metros, vire à direita"
     - Ícones de manobra dinâmicos
     - Distância em tempo real

5. **Tela de Resumo Completa (2h)**
   - Criar `JourneySummaryPage`
   - Mostrar número de descansos
   - Lista completa de trechos
   - Todas as métricas

6. **Odômetro Final com Validação (1h)**
   - OCR + edição manual
   - Validação (final > inicial)

### 📊 Completude Geral:
**70%** da funcionalidade já existe

### 📸 Evidências:
![Tela de Viagem Ativa](https://user-provided-screenshots/viagem-ativa.png)
- Card verde com navegação
- Mapa com rota
- Botões funcionais
- Velocidade e odômetro

![Tela de Início](https://user-provided-screenshots/inicio-viagem.png)
- Autocomplete
- Banner "Rota calculada: 8.3 km (20 min)"

---

## 📝 Descrição

Como **motorista**, eu quero poder **navegar até meu destino com instruções em tempo real estilo Waze/Google Maps**, para que eu possa **conduzir o veículo de forma segura e eficiente, visualizando informações da rota, gerenciando períodos de descanso e registrando toda a jornada**.

---

## 🎯 Objetivos de Negócio

- Melhorar a experiência do motorista durante a viagem
- Aumentar a segurança com navegação visual clara
- Facilitar o controle de descansos obrigatórios
- Garantir registro completo de todas as etapas da jornada
- Reduzir erros de navegação e otimizar rotas

---

## 👤 Persona

**João, Motorista de Caminhão**
- 38 anos, 12 anos de experiência
- Faz viagens de longa distância (500-1200km)
- Precisa respeitar intervalos de descanso obrigatórios
- Quer visualizar claramente as instruções de navegação sem tirar os olhos da estrada por muito tempo
- Necessita registrar odômetro inicial e final com precisão

---

## ✅ Critérios de Aceitação

### 1. Destino Obrigatório
- [ ] O campo "Destino" deve ser **obrigatório** na tela de início de jornada
- [ ] Autocomplete deve funcionar ao digitar (Google Places API)
- [ ] Ao selecionar destino, deve calcular e mostrar:
  - Distância em KM
  - Tempo estimado de viagem
- [ ] Não deve ser possível iniciar viagem sem destino

### 2. Animação Inicial (Overview da Rota)
- [ ] Ao clicar "Iniciar Viagem", deve mostrar:
  - Mapa em **zoom out** (visão geral)
  - Rota completa traçada em azul
  - Marcadores de origem e destino
  - Card sobreposto com: distância total e tempo estimado
- [ ] Animação deve durar **5 segundos fixos** (não pode pular)
- [ ] Após 5s, entrar automaticamente em modo navegação

### 3. Modo Navegação (Turn-by-Turn)
- [ ] Câmera deve seguir posição do motorista (bearing rotacionado)
- [ ] Zoom aproximado para ver ruas ao redor (estilo Waze)
- [ ] Seta/ícone do veículo em movimento
- [ ] Card de navegação no **topo da tela** com:
  - Ícone da próxima manobra (virar direita, esquerda, seguir reto, etc.)
  - Nome da via atual
  - Instrução: "Em X metros, [ação]"
  - Exemplo: "Em 350m, vire à direita na Rua ABC"
- [ ] Instruções devem atualizar conforme motorista avança
- [ ] Velocidade atual visível (km/h)
- [ ] Odômetro atualizado em tempo real (`inicial + km_percorridos_GPS`)

### 4. Botão "Visualizar Rota"
- [ ] **FAB flutuante** no topo-direito (ícone: mapa/fullscreen)
- [ ] Ao clicar, alterna entre:
  - **Modo Navegação:** Zoom in, seguindo veículo
  - **Modo Overview:** Zoom out, mostrando rota completa
- [ ] Deve manter estado enquanto viagem está ativa

### 5. Botão "Descanso"
- [ ] Posicionado de forma acessível (bottom bar ou FAB)
- [ ] **Durante viagem ativa:**
  - Texto: "Descanso"
  - Ícone: Pause
  - Cor: Laranja
- [ ] **Durante descanso:**
  - Texto: "Retornar Viagem"
  - Ícone: Play
  - Cor: Azul ZECA
- [ ] Ao iniciar descanso:
  - Parar contador de tempo de viagem
  - Iniciar contador de tempo de descanso
  - Parar tracking GPS
  - Backend registra fim do trecho atual
- [ ] Ao retornar viagem:
  - Parar contador de descanso
  - Retomar contador de viagem
  - Retomar tracking GPS
  - Backend cria novo trecho

### 6. Botão "Finalizar Viagem"
- [ ] Posicionado de forma acessível (bottom bar ou FAB)
- [ ] Ao clicar, mostrar **modal de confirmação**:
  - Título: "Finalizar Viagem?"
  - Mensagem: Avisar que será registrado odômetro final
  - Botões: "Cancelar" e "Confirmar"
- [ ] Ao confirmar:
  - Abrir câmera para foto do hodômetro
  - Realizar OCR automático
  - Mostrar valor detectado + permitir edição manual
  - Validar que odômetro final > odômetro inicial
- [ ] **NÃO** validar proximidade do destino (pode finalizar em qualquer lugar)
- [ ] Após salvar, ir para **tela de resumo**

### 7. Tela de Resumo da Viagem
- [ ] Mostrar após finalização bem-sucedida
- [ ] Informações exibidas:
  - **Origem e Destino**
  - **Distância Total:** X.X km
  - **Tempo em Viagem:** Xh XXmin
  - **Tempo em Descanso:** Xh XXmin
  - **Número de Descansos:** X
  - **Velocidade Média:** XX km/h
  - **Velocidade Máxima:** XX km/h
  - **Odômetro Inicial:** XXXXXX
  - **Odômetro Final:** XXXXXX
  - **Lista de Trechos** (resumida):
    - Trecho 1: X.X km, XXmin, média XX km/h
    - Trecho 2: ...
- [ ] Botão "Ver Detalhes dos Trechos" (navega para `JourneySegmentsPage`)
- [ ] Botão "Voltar para Home"

### 8. Persistência e Recuperação
- [ ] Se o app fechar durante viagem, ao reabrir:
  - Perguntar se quer continuar viagem ativa
  - Restaurar estado (modo navegação, rota, contadores)
- [ ] Dados da rota salvos no storage local

---

## 🔧 Implementação Técnica

### Backend (ZECA Site)
**Status:** ✅ **Já Implementado**
- Endpoint `POST /journeys/start` (aceita `destino` e `previsao_km`)
- Endpoint `POST /journeys/toggle-rest` (gerencia trechos automaticamente)
- Endpoint `POST /journeys/finish` (retorna `segments_summary` e `rest_periods`)
- Endpoint `GET /journeys/:id` (retorna `rest_periods` para contagem)
- Entidades `JourneySegment` e `JourneyRestPeriod` já existem

### App Flutter (Camadas)

#### **Domain Layer**
- Não precisa de grandes mudanças (entidades já existem)
- Considerar adicionar:
  - `NavigationStep` entity (instruções turn-by-turn)
  - Métodos utilitários para calcular distância até próximo step

#### **Data Layer**
- Expandir `DirectionsService` para retornar `steps` detalhados:
  - `html_instructions`
  - `maneuver` (turn-left, turn-right, etc.)
  - `distance` e `duration`
  - Coordenadas de cada step
- Criar `NavigationService` para processar steps em tempo real

#### **Presentation Layer**
- **JourneyPage:**
  - Tornar campo destino obrigatório (validação)
  - Adicionar animação inicial (5s overview)
  - Adicionar FAB "Visualizar Rota"
  - Melhorar posicionamento dos botões (Descanso, Finalizar, Visualizar Rota)
  - Integrar `NavigationService` para atualizar instruções
  
- **NavigationInfoCard (melhorar):**
  - Adicionar suporte a ícones de manobra
  - Atualizar texto dinamicamente: "Em X metros, vire à direita"
  - Posicionar no topo da tela
  
- **RouteMapView:**
  - Já suporta modos navegação/overview (manter)
  
- **JourneyFinishFlow:**
  - Criar nova página `JourneySummaryPage` para resumo
  - Integrar OCR + validação manual do odômetro final
  - Buscar e exibir contagem de descansos (`rest_periods.length`)

---

## 🧪 Casos de Teste

### Teste 1: Destino Obrigatório
1. Tentar iniciar viagem sem preencher destino
2. **Resultado Esperado:** Erro de validação, não permite iniciar

### Teste 2: Autocomplete e Cálculo de Rota
1. Digitar "São Paulo" no campo destino
2. Selecionar um resultado do autocomplete
3. **Resultado Esperado:** 
   - Campo destino preenchido
   - Campo "Previsão KM" atualizado automaticamente
   - Tempo estimado visível

### Teste 3: Animação Inicial
1. Iniciar viagem com destino preenchido
2. **Resultado Esperado:**
   - Mapa em zoom out mostrando rota completa
   - Card com distância e tempo
   - Após 5s, entrar em modo navegação

### Teste 4: Navegação em Tempo Real
1. Com viagem ativa, dirigir alguns metros
2. **Resultado Esperado:**
   - Card no topo atualiza: "Em X metros, vire à direita"
   - Velocidade atualiza em tempo real
   - Odômetro aumenta conforme GPS

### Teste 5: Botão Descanso
1. Clicar em "Descanso" durante viagem
2. Aguardar 2 minutos
3. Clicar em "Retornar Viagem"
4. **Resultado Esperado:**
   - Contador de viagem pausa durante descanso
   - Contador de descanso registra 2 minutos
   - GPS para e retoma corretamente
   - Novo trecho é criado

### Teste 6: Botão Visualizar Rota
1. Durante navegação, clicar no FAB "Visualizar Rota"
2. **Resultado Esperado:** Mapa faz zoom out mostrando rota completa
3. Clicar novamente
4. **Resultado Esperado:** Volta para modo navegação (zoom in)

### Teste 7: Finalizar Viagem
1. Clicar em "Finalizar Viagem"
2. Confirmar no modal
3. Tirar foto do hodômetro
4. Validar OCR e salvar
5. **Resultado Esperado:**
   - Câmera abre
   - OCR detecta valor
   - Pode editar manualmente
   - Vai para tela de resumo com todos os dados

### Teste 8: Tela de Resumo
1. Após finalizar viagem
2. **Resultado Esperado:**
   - Mostra distância, tempos, velocidades
   - Mostra número de descansos (ex: "3 descansos")
   - Lista trechos resumidos
   - Botão "Ver Detalhes" funciona

### Teste 9: Recuperação de Viagem
1. Iniciar viagem
2. Forçar fechamento do app (kill)
3. Reabrir app
4. **Resultado Esperado:**
   - Dialog pergunta se quer continuar
   - Ao confirmar, restaura estado completo (rota, contadores, modo navegação)

---

## 📊 Métricas de Sucesso

- **Adoção:** 90%+ dos motoristas usam navegação integrada
- **Precisão:** 95%+ de rotas calculadas corretamente
- **Usabilidade:** Tempo médio de início de viagem < 30 segundos
- **Descansos:** 100% dos descansos registrados corretamente
- **Satisfação:** NPS > 8.0 para navegação

---

## 🔗 Dependências

### APIs Externas
- ✅ Google Places API (autocomplete) - **Já configurado**
- ✅ Google Directions API (calcular rota + steps) - **Já configurado**
- ✅ Google ML Kit OCR (odômetro final) - **Já configurado**

### Backend
- ✅ Endpoints de jornada - **Já implementados**
- ✅ Entidades de trechos e descansos - **Já implementadas**

### App
- ✅ Background GPS tracking - **Já implementado**
- ✅ Mapa com rota - **Já implementado (RouteMapView)**
- ⚠️ Instruções turn-by-turn - **Precisa expandir DirectionsService**
- ⚠️ Tela de resumo - **Precisa criar**

---

## 📋 Tasks de Implementação

### FASE 1: Backend (0 tasks - já existe tudo)
✅ Nenhuma mudança necessária

---

### FASE 2: Domain Layer (2 tasks)

#### Task 2.1: Criar Entidade NavigationStep
**Arquivo:** `lib/features/journey/domain/entities/navigation_step_entity.dart`

```dart
class NavigationStep {
  final String instruction; // "Vire à direita na Av. Paulista"
  final String maneuver; // "turn-right", "turn-left", etc.
  final double distanceMeters;
  final int durationSeconds;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
}
```

#### Task 2.2: Adicionar Métodos Utilitários
**Arquivo:** `lib/core/utils/navigation_utils.dart`

Criar funções:
- `calculateDistanceBetweenPoints(LatLng a, LatLng b)` → double (metros)
- `getManeuverIcon(String maneuver)` → IconData
- `formatDistanceToNextStep(double meters)` → String ("Em 350m", "Em 50m", "Agora")

---

### FASE 3: Data Layer (3 tasks)

#### Task 3.1: Expandir DirectionsService
**Arquivo:** `lib/core/services/directions_service.dart`

- Modificar `calculateRoute()` para retornar também `List<NavigationStep>`
- Processar `steps` de cada `leg` da resposta do Google
- Parsear `html_instructions` (remover tags HTML)
- Mapear `maneuver` para enum

#### Task 3.2: Criar NavigationService
**Arquivo:** `lib/core/services/navigation_service.dart`

Responsabilidades:
- Armazenar lista de `NavigationStep`
- Rastrear `currentStepIndex`
- Método `updateCurrentPosition(LatLng position)`:
  - Calcular distância até próximo step
  - Se passou do step, avançar para próximo
  - Retornar step atual + distância restante
- Stream de mudanças de step

#### Task 3.3: Registrar NavigationService no DI
**Arquivo:** `lib/core/di/injection.dart`

```dart
@injectable
class NavigationService { ... }
```

---

### FASE 4: Presentation Layer (9 tasks)

#### Task 4.1: Tornar Destino Obrigatório
**Arquivo:** `lib/features/journey/presentation/pages/journey_page.dart`

- Adicionar validação no `_formKey`:
  ```dart
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Destino é obrigatório';
    }
    return null;
  }
  ```
- Desabilitar botão "Iniciar Viagem" se destino vazio

#### Task 4.2: Implementar Animação Inicial (5s Overview)
**Arquivo:** `lib/features/journey/presentation/pages/journey_page.dart`

Lógica:
1. Ao iniciar viagem, setar flag `_showingInitialOverview = true`
2. Passar `isNavigationMode: false` para `RouteMapView` (zoom out)
3. Mostrar `OverlayCard` com distância e tempo estimado
4. Após 5 segundos:
   ```dart
   Future.delayed(Duration(seconds: 5), () {
     setState(() {
       _showingInitialOverview = false;
       _isNavigationMode = true;
     });
   });
   ```

#### Task 4.3: Criar Widget OverlayCard
**Arquivo:** `lib/features/journey/widgets/route_overview_card.dart`

Card semitransparente centralizado mostrando:
- "Rota calculada!"
- Distância: X.X km
- Tempo estimado: Xh XXmin
- Ícone de loading ou animação

#### Task 4.4: Adicionar FAB "Visualizar Rota"
**Arquivo:** `lib/features/journey/presentation/pages/journey_page.dart`

```dart
Positioned(
  top: 100,
  right: 16,
  child: FloatingActionButton(
    mini: true,
    onPressed: () {
      setState(() {
        _isNavigationMode = !_isNavigationMode;
      });
    },
    child: Icon(_isNavigationMode ? Icons.map : Icons.navigation),
  ),
)
```

#### Task 4.5: Melhorar NavigationInfoCard
**Arquivo:** `lib/features/journey/widgets/navigation_info_card.dart`

Adicionar parâmetros:
- `String? maneuverType` (turn-right, turn-left, etc.)
- `double? distanceToNextMeters`
- `String? nextAction` ("vire à direita")

Lógica:
- Usar `NavigationUtils.getManeuverIcon(maneuverType)` para ícone
- Formatar: "Em ${NavigationUtils.formatDistance(distanceToNextMeters)}, $nextAction"
- Posicionar no topo: `margin: EdgeInsets.only(top: 60)`

#### Task 4.6: Integrar NavigationService na JourneyPage
**Arquivo:** `lib/features/journey/presentation/pages/journey_page.dart`

1. Injetar `NavigationService`
2. Ao calcular rota, obter `steps`:
   ```dart
   final routeWithSteps = await _directionsService.calculateRouteWithSteps(...);
   _navigationService.setSteps(routeWithSteps.steps);
   ```
3. No listener de GPS, atualizar posição:
   ```dart
   final currentStep = _navigationService.updateCurrentPosition(currentLatLng);
   setState(() {
     _currentNavigationStep = currentStep;
     _distanceToNext = currentStep.distanceRemaining;
   });
   ```
4. Passar para `NavigationInfoCard`

#### Task 4.7: Atualizar Odômetro em Tempo Real
**Arquivo:** `lib/features/journey/presentation/pages/journey_page.dart`

- Já está implementado: `odometroFinal = odometroInicial + kmPercorridos`
- Garantir que está visível no card de informações

#### Task 4.8: Criar JourneySummaryPage
**Arquivo:** `lib/features/journey/presentation/pages/journey_summary_page.dart`

Estrutura:
- Recebe `JourneyEntity journey` via parâmetro
- Busca `rest_periods` de `journey` (já vem no objeto)
- Mostra todos os campos especificados nos critérios
- Card destacado para cada métrica
- Lista de trechos (resumida)
- Botão "Ver Detalhes dos Trechos" → `JourneySegmentsPage`
- Botão "Voltar para Home" → `context.go('/home')`

#### Task 4.9: Integrar OCR + Validação Manual no Finalizar
**Arquivo:** `lib/features/journey/presentation/pages/journey_page.dart`

Fluxo ao clicar "Finalizar Viagem":
1. Mostrar modal de confirmação
2. Ao confirmar, navegar para `OdometerCameraPage`:
   ```dart
   final result = await context.push('/odometer-camera');
   ```
3. Após OCR, mostrar dialog de validação:
   ```dart
   TextFormField(
     initialValue: ocrValue,
     decoration: InputDecoration(
       labelText: 'Odômetro Final',
       helperText: 'Automático: $ocrValue | Edite se necessário',
     ),
     validator: (value) {
       final odometerFinal = int.tryParse(value);
       if (odometerFinal == null || odometerFinal <= journey.odometroInicial) {
         return 'Odômetro final deve ser maior que inicial';
       }
       return null;
     },
   )
   ```
4. Enviar para backend e ir para `JourneySummaryPage`

---

### FASE 5: Ajustes Finais e Testes (3 tasks)

#### Task 5.1: Ajustar Layout dos Botões
**Arquivo:** `lib/features/journey/presentation/pages/journey_page.dart`

Organizar bottom bar com:
- Botão "Descanso/Retomar" (laranja/azul)
- Botão "Finalizar Viagem" (vermelho)
- Ambos acessíveis e bem posicionados

#### Task 5.2: Garantir Persistência da Rota
**Arquivo:** `lib/features/journey/data/services/journey_storage_service.dart`

- Já existe `saveRouteData()` e `getRouteData()`
- Validar que `steps` também são salvos (se necessário)

#### Task 5.3: Testar Todos os Casos de Teste
- Executar manualmente cada caso de teste da seção "Casos de Teste"
- Corrigir bugs encontrados

---

## 🚧 Riscos e Mitigações

| Risco | Impacto | Mitigação |
|-------|---------|-----------|
| Google Directions API retornar steps incompletos | Alto | Implementar fallback: usar apenas distância e ETA no card |
| OCR do odômetro final falhar | Médio | Permitir edição manual obrigatória (já planejado) |
| GPS impreciso em túneis/áreas urbanas | Médio | Usar última posição conhecida + interpolação |
| Consumo de bateria alto | Médio | Background geo já otimizado (BackgroundGeolocationService) |
| Animação inicial de 5s ser frustrante | Baixo | Monitorar feedback dos usuários, considerar reduzir para 3s |

---

## 📅 Estimativa de Esforço

### ❌ Estimativa Original (SEM análise do existente):
- ~~22 horas~~ ❌ **SUPERESTIMADO!**

### ✅ Estimativa Real (APÓS análise):
- **Backend:** 0 horas (✅ 100% existe)
- **Domain Layer:** 1 hora (criar apenas `NavigationStep` entity)
- **Data Layer:** 2 horas (expandir `DirectionsService`, criar `NavigationService`)
- **Presentation Layer:** 5 horas (ajustes em componentes existentes)
- **Testes e Ajustes:** 2 horas
- **TOTAL:** **10 horas** (~1.5 dias de desenvolvimento)

### 💰 Economia:
- **12 horas economizadas** por validar o que existe antes! 
- Redução de **54%** no esforço estimado

---

## 📚 Referências

- [Google Directions API - Steps](https://developers.google.com/maps/documentation/directions/get-directions#DirectionsLeg)
- [Flutter Background Geolocation](https://github.com/transistorsoft/flutter_background_geolocation)
- [Google ML Kit OCR](https://pub.dev/packages/google_mlkit_text_recognition)
- ADR-003: Flutter Background Geolocation
- ADR-004: Google ML Kit OCR
- Especificação: `BACKEND_TRECHOS_JORNADA.md` (backend)
- Especificação: `IMPLEMENTACAO_BACKGROUND_GEO_COMPLETA.md`

---

## 🔄 Histórico de Mudanças

| Data | Versão | Mudança | Autor |
|------|--------|---------|-------|
| 27/11/2024 | 1.0 | Criação inicial da User Story | AI Assistant |

---

## 💬 Notas Adicionais

### Sobre Maneuvers do Google Directions
Os tipos de `maneuver` retornados pela API incluem:
- `turn-left`, `turn-right`
- `turn-slight-left`, `turn-slight-right`
- `turn-sharp-left`, `turn-sharp-right`
- `keep-left`, `keep-right`
- `uturn-left`, `uturn-right`
- `roundabout-left`, `roundabout-right`
- `straight`, `ramp-left`, `ramp-right`
- `merge`, `fork-left`, `fork-right`
- `ferry`, `ferry-train`

Mapear cada um para ícone apropriado.

### Priorização de Implementação
Se houver limitação de tempo, priorizar nesta ordem:
1. Destino obrigatório (crítico)
2. Animação inicial (UX importante)
3. Botão visualizar rota (UX importante)
4. Tela de resumo com contagem de descansos (crítico)
5. OCR + validação manual odômetro (crítico)
6. Instruções turn-by-turn completas (nice-to-have, pode ser simplificado)

---

**Status Atual:** 📋 Aguardando aprovação para iniciar implementação

