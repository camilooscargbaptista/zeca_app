# 📱 ZECA APP - Funcionalidades Implementadas

> **App Mobile do Motorista - Flutter**
>
> Última atualização: 12/12/2025

---

## 📋 Resumo

O ZECA App é o aplicativo mobile para **motoristas de frotas**. Permite gerenciar jornadas, abastecimentos, checklists e comunicação com a frota.

---

## 1. Funcionalidades Implementadas

### 1.1 Autenticação (`features/auth/`)
| Funcionalidade | Status |
|----------------|--------|
| Login com email/senha | ✅ |
| Logout | ✅ |
| Seleção de empresa (multi-empresa) | ✅ |
| Persistência de sessão | ✅ |

### 1.2 Jornadas (`features/journey/`, `features/journey_start/`)
| Funcionalidade | Status |
|----------------|--------|
| Iniciar jornada | ✅ |
| Selecionar veículo | ✅ |
| Definir origem/destino | ✅ |
| Navegação integrada (Google Maps/Waze) | ✅ |
| Pausar/retomar jornada | ⚠️ Parcial |
| Finalizar jornada | ✅ |
| Trechos/segmentos de jornada | ⚠️ Parcial |
| Tracking GPS em background | ❌ Removido (incompatibilidade Play Store) |

### 1.3 Abastecimento (`features/refueling/`)
| Funcionalidade | Status |
|----------------|--------|
| Gerar código de abastecimento | ✅ |
| QR Code para posto escanear | ✅ |
| Validação tripla (placa + CNPJ + token) | ✅ |
| Expiração de token (10 min) | ✅ |
| Histórico de abastecimentos | ✅ |
| Selecionar parceria/posto | ✅ |

### 1.4 Checklists (`features/checklist/`)
| Funcionalidade | Status |
|----------------|--------|
| Checklist de entrada do veículo | ❌ Removido (incompatibilidade) |
| Checklist de saída do veículo | ❌ Removido (incompatibilidade) |
| Fotos anexadas | ❌ Removido |
| Registro de avarias | ❌ Removido |

### 1.5 Odômetro (`features/odometer/`)
| Funcionalidade | Status |
|----------------|--------|
| Leitura manual de KM | ✅ |
| OCR para leitura automática | ❌ Removido (permissão Google) |
| Histórico de odômetro | ✅ |

### 1.6 Notificações (`features/notifications/`)
| Funcionalidade | Status |
|----------------|--------|
| Push notifications (Firebase) | ⚠️ Parcial |
| Central de notificações | ⚠️ Parcial |
| Notificações de ciclo/faturamento | ❌ Não implementado |

### 1.7 Home (`features/home/`)
| Funcionalidade | Status |
|----------------|--------|
| Dashboard do motorista | ✅ |
| Cards de jornada ativa | ✅ |
| Acesso rápido às funcionalidades | ✅ |

### 1.8 Histórico (`features/history/`)
| Funcionalidade | Status |
|----------------|--------|
| Histórico de jornadas | ✅ |
| Histórico de abastecimentos | ✅ |

---

## 2. Arquitetura Técnica

### 2.1 Stack
- **Framework:** Flutter (Dart)
- **State Management:** Provider / Riverpod
- **DI:** GetIt
- **HTTP:** Dio
- **Storage:** SharedPreferences, Hive
- **Maps:** Google Maps, Mapbox
- **Push:** Firebase Cloud Messaging

### 2.2 Estrutura
```
lib/
├── core/           # Infraestrutura
│   ├── config/     # Configurações (API, ambiente)
│   ├── constants/  # Constantes
│   ├── di/         # Injeção de dependência
│   ├── errors/     # Tratamento de erros
│   ├── network/    # HTTP client
│   ├── services/   # Services compartilhados
│   ├── theme/      # Tema visual
│   └── utils/      # Utilitários
│
├── features/       # Módulos de negócio
│   ├── auth/       # Autenticação
│   ├── checklist/  # Checklists
│   ├── history/    # Histórico
│   ├── home/       # Tela principal
│   ├── journey/    # Jornadas
│   ├── notifications/
│   ├── odometer/   # Odômetro/OCR
│   ├── refueling/  # Abastecimento
│   └── splash/     # Tela inicial
│
├── routes/         # Navegação
├── shared/         # Componentes compartilhados
└── main.dart       # Entry point
```

---

## 3. Integrações

| Serviço | Uso |
|---------|-----|
| **ZECA Backend** | API principal |
| **Google Maps** | Navegação, geocoding |
| **Firebase** | Push notifications, analytics |
| **OCR (ML Kit)** | Leitura de odômetro |

---

## 4. Funcionalidades Planejadas (Roadmap)

### Alta Prioridade
- [ ] Fadiga do motorista (Lei 13.103)
- [ ] Alerta de velocidade
- [ ] SOS / Emergência
- [ ] Chat com central
- [ ] Upload de documentos (CNH, CRLV)

### Média Prioridade
- [ ] Vale-pedágio digital
- [ ] Preço de combustível próximo
- [ ] Score de direção segura
- [ ] Ranking/gamificação

### Baixa Prioridade
- [ ] IA: Detecção de fraudes
- [ ] Relatório de viagem PDF
- [ ] Modo offline completo

---

## 5. Plataformas

| Plataforma | Status |
|------------|--------|
| iOS | ✅ (TestFlight) |
| Android | ✅ (Play Store interno) |

---

**ZECA App — O companheiro do motorista na estrada**
