---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Contexto GLOSSARY.md"
---

# 📖 Glossário - ZECA App

> **Definições de termos do domínio ZECA para consistência na comunicação.**

---

## 🎯 Atores

| Termo | Definição | No App |
|-------|-----------|--------|
| **Driver** | Motorista que usa o app para abastecer | Usuário principal |
| **Driver Frota** | Motorista vinculado a uma transportadora | Login com CPF, fatura para empresa |
| **Driver Autônomo** | Motorista independente | Login com CPF, paga via PIX |
| **Fleet** | Gestor de frota (transportadora) | Não usa o app mobile |
| **Station** | Posto de combustível parceiro | Exibido na busca |
| **Attendant** | Frentista do posto | Valida código, abastece |

---

## 🚗 Veículos

| Termo | Definição | Validação |
|-------|-----------|-----------|
| **Vehicle** | Veículo cadastrado no sistema | Pertence a Driver |
| **Plate** | Placa do veículo | Formato brasileiro |
| **Odometer** | Hodômetro do veículo | Registrado no abastecimento |
| **Tank Capacity** | Capacidade do tanque (litros) | Valida litros máximos |
| **Fuel Type** | Tipo de combustível aceito | GASOLINE, ETHANOL, DIESEL, FLEX |

### Tipos de Combustível

| Código | Nome | Veículos |
|--------|------|----------|
| GASOLINE | Gasolina Comum | Gasolina, Flex |
| ETHANOL | Etanol | Etanol, Flex |
| DIESEL | Diesel S10/S500 | Diesel |
| FLEX | Flex | Gasolina e Etanol |

---

## ⛽ Abastecimento

| Termo | Definição | Estados |
|-------|-----------|---------|
| **Refueling** | Evento de abastecimento | Ver estados abaixo |
| **Refueling Code** | Código de 16 caracteres para validar | ZECA2025XXXXXXXX |
| **Liters** | Quantidade abastecida | > 0, ≤ tank capacity |
| **Unit Price** | Preço por litro (ZECA) | Sempre menor que bomba |
| **Pump Price** | Preço de bomba (normal) | Referência para economia |
| **Total Price** | Valor total pago | liters × unit price |
| **Savings** | Economia total | (pump - zeca) × liters |

### Estados do Abastecimento

| Estado | Descrição | Próximo Estado |
|--------|-----------|----------------|
| `PENDING` | Código gerado, aguardando | VALIDATED, CANCELLED, EXPIRED |
| `VALIDATED` | Posto validou código | IN_PROGRESS, CANCELLED |
| `IN_PROGRESS` | Abastecimento em andamento | AWAITING_PAYMENT, COMPLETED |
| `AWAITING_PAYMENT` | Aguardando PIX (autônomo) | COMPLETED, EXPIRED |
| `COMPLETED` | Finalizado com sucesso | - (final) |
| `CANCELLED` | Cancelado pelo usuário/posto | - (final) |
| `EXPIRED` | Tempo expirado | - (final) |

---

## 🛣️ Jornada

| Termo | Definição | Regra |
|-------|-----------|-------|
| **Journey** | Período de trabalho do motorista | Uma ativa por vez |
| **Start Journey** | Iniciar jornada de trabalho | Requer checklist |
| **End Journey** | Encerrar jornada de trabalho | Registra km final |
| **Checklist** | Verificação pré-jornada | Obrigatório para iniciar |
| **Route** | Rota planejada | Origem → Destino |

### Estados da Jornada

| Estado | Descrição | Ações Permitidas |
|--------|-----------|------------------|
| `NOT_STARTED` | Sem jornada ativa | Iniciar jornada |
| `ACTIVE` | Jornada em andamento | Abastecer, pausar, encerrar |
| `PAUSED` | Jornada pausada | Retomar, encerrar |
| `COMPLETED` | Jornada encerrada | Ver histórico |

---

## 💳 Pagamento

| Termo | Definição | Uso |
|-------|-----------|-----|
| **PIX** | Pagamento instantâneo | Motorista autônomo |
| **PIX QR Code** | Código para pagamento | Gerado após abastecimento |
| **Invoice** | Fatura consolidada | Motorista de frota (mensal) |
| **Payment Status** | Estado do pagamento | PENDING, PROCESSING, COMPLETED, FAILED |

### Fluxo de Pagamento

| Tipo Motorista | Método | Confirmação |
|----------------|--------|-------------|
| Frota | Fatura mensal | Automática |
| Autônomo | PIX | Webhook ou polling |

---

## 📍 Localização

| Termo | Definição | Uso |
|-------|-----------|-----|
| **Station** | Posto de combustível | Ponto de abastecimento |
| **Geolocation** | Coordenadas GPS | Busca de postos próximos |
| **Distance** | Distância até o posto | Ordenação na busca |
| **Address** | Endereço completo | Exibição e navegação |

---

## 🔔 Notificações

| Termo | Definição | Trigger |
|-------|-----------|---------|
| **Push Notification** | Notificação do sistema | Mudança de estado |
| **WebSocket** | Conexão em tempo real | Atualizações instantâneas |
| **Event** | Evento recebido via WS | refueling_*, payment_* |

### Eventos WebSocket

| Evento | Quando | Ação no App |
|--------|--------|-------------|
| `refueling_validated` | Posto validou código | Atualizar status |
| `refueling_completed` | Abastecimento concluído | Mostrar PIX ou sucesso |
| `payment_confirmed` | PIX confirmado | Tela de sucesso |
| `journey_alert` | Alerta de jornada | Notificar usuário |

---

## 🏢 Organizacional

| Termo | Definição | Relação |
|-------|-----------|---------|
| **Transporter** | Transportadora (empresa) | Tem muitos Drivers |
| **Fleet Manager** | Gestor da frota | Administra Drivers |
| **Contract** | Contrato com posto | Define preços |
| **Limit** | Limite de abastecimento | Por dia/mês |

---

## 📱 Técnico (App)

| Termo | Definição | Onde |
|-------|-----------|------|
| **BLoC** | Business Logic Component | Estado da tela |
| **Entity** | Objeto de domínio | domain/entities/ |
| **Model** | DTO com JSON | data/models/ |
| **UseCase** | Caso de uso | domain/usecases/ |
| **Repository** | Acesso a dados | domain/ (interface), data/ (impl) |
| **DataSource** | Fonte de dados | data/datasources/ |
| **State** | Estado do BLoC | presentation/bloc/ |
| **Event** | Ação do usuário | presentation/bloc/ |

---

## 🔤 Convenções de Nomenclatura

### Arquivos

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Model | `{nome}_model.dart` | `refueling_model.dart` |
| Entity | `{nome}.dart` | `refueling.dart` |
| BLoC | `{nome}_bloc.dart` | `refueling_bloc.dart` |
| State | `{nome}_state.dart` | `refueling_state.dart` |
| Event | `{nome}_event.dart` | `refueling_event.dart` |
| Page | `{nome}_page.dart` | `refueling_page.dart` |
| Widget | `{nome}_widget.dart` | `refueling_card.dart` |
| UseCase | `{acao}_{nome}_usecase.dart` | `get_refuelings_usecase.dart` |

### Classes

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Model | `{Nome}Model` | `RefuelingModel` |
| Entity | `{Nome}` | `Refueling` |
| BLoC | `{Nome}Bloc` | `RefuelingBloc` |
| State | `{Nome}State` | `RefuelingState` |
| Event | `{Nome}Event` | `RefuelingEvent` |
| UseCase | `{Acao}{Nome}UseCase` | `GetRefuelingsUseCase` |
| Repository | `{Nome}Repository` | `RefuelingRepository` |
| Repository Impl | `{Nome}RepositoryImpl` | `RefuelingRepositoryImpl` |

---

## 📊 Métricas

| Termo | Definição | Meta |
|-------|-----------|------|
| **Coverage** | Cobertura de testes | ≥ 60% |
| **Analyze** | Análise estática | 0 issues |
| **Build Time** | Tempo de compilação | < 2 min |
| **App Size** | Tamanho do APK | < 50 MB |

---

## 🔗 Siglas

| Sigla | Significado |
|-------|-------------|
| **ZECA** | Sistema de abastecimento com desconto |
| **DI** | Dependency Injection |
| **BLoC** | Business Logic Component |
| **DTO** | Data Transfer Object |
| **API** | Application Programming Interface |
| **JWT** | JSON Web Token |
| **WS** | WebSocket |
| **GPS** | Global Positioning System |
| **OCR** | Optical Character Recognition |
| **PIX** | Pagamento Instantâneo |
| **RN** | Regra de Negócio |
| **QG** | Quality Gate |
| **EP** | Error Pattern |
| **PR** | Pull Request |
| **CI** | Continuous Integration |

---

*Glossário v2.0.0 - Janeiro 2026*
