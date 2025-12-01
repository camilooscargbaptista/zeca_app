# 🚀 Implementação: Fluxo de Início de Jornada

## 📋 Resumo da Implementação

Esta implementação adiciona um novo fluxo ao aplicativo ZECA onde o motorista precisa selecionar um veículo antes de acessar as funcionalidades principais (Abastecimento, Iniciar Viagem e Checklist).

---

## ✨ Funcionalidades Implementadas

### **1. Tela de Início de Jornada (`JourneyStartPage`)**

**Localização:** `lib/features/journey_start/presentation/pages/journey_start_page.dart`

**Características:**
- ✅ Card com dados do motorista e transportadora (Nome, CPF, Empresa, CNPJ)
- ✅ Campo de entrada para placa do veículo (formato antigo e Mercosul)
- ✅ Busca de veículo pela placa (via API)
- ✅ Validação de placa (reutiliza lógica de abastecimento)
- ✅ Exibição dos dados do veículo encontrado (Marca, Modelo, Ano, Cor, Combustível)
- ✅ Botões de Cancelar/Confirmar
- ✅ Salva todos os dados no storage local após confirmação
- ✅ Redireciona automaticamente para o dashboard se já houver jornada ativa

**Fluxo:**
1. Usuário faz login
2. É direcionado para `JourneyStartPage`
3. Visualiza seus dados e da transportadora
4. Digite a placa do veículo
5. Sistema busca e valida a placa
6. Usuário confirma o veículo
7. Dados são salvos no storage local
8. Redireciona para `JourneyDashboardPage`

---

### **2. Tela do Dashboard (`JourneyDashboardPage`)**

**Localização:** `lib/features/journey_start/presentation/pages/journey_dashboard_page.dart`

**Características:**
- ✅ Card destacado com informações do veículo ativo (Placa, Modelo, Combustível, Motorista, Transportadora)
- ✅ **3 Cards principais:**
  1. **Abastecimento** - Navega para `/home` (tela de abastecimento existente)
  2. **Iniciar Viagem** - Navega para `/journey` (tela de jornada existente)
  3. **Checklist** - Mostra mensagem "em desenvolvimento" (a ser implementado)
- ✅ Botão para finalizar jornada (limpa dados do veículo)
- ✅ Verifica se há jornada ativa ao carregar (se não houver, redireciona para `JourneyStartPage`)

---

### **3. Serviço de Storage (`StorageService`)**

**Localização:** `lib/core/services/storage_service.dart`

**Novos métodos adicionados:**

```dart
/// Salvar dados do veículo da jornada ativa
Future<void> saveJourneyVehicleData(Map<String, dynamic> vehicleData)

/// Recuperar dados do veículo da jornada ativa
Future<Map<String, dynamic>?> getJourneyVehicleData()

/// Limpar dados do veículo da jornada (ao finalizar jornada ou logout)
Future<void> clearJourneyVehicleData()

/// Verificar se existe uma jornada ativa (veículo selecionado)
Future<bool> hasActiveJourney()
```

**Dados salvos:**
- ID do veículo
- Placa
- Marca, Modelo, Ano, Cor
- Capacidade e Combustíveis
- Dados da transportadora
- Dados do motorista (CPF, Nome)

---

### **4. Roteamento (`AppRouter`)**

**Localização:** `lib/routes/app_router.dart`

**Novas rotas adicionadas:**

```dart
GoRoute(
  path: '/journey-start',
  name: 'journey-start',
  builder: (context, state) => const JourneyStartPage(),
),

GoRoute(
  path: '/journey-dashboard',
  name: 'journey-dashboard',
  builder: (context, state) => const JourneyDashboardPage(),
),
```

---

### **5. Navegação após Login**

**Localização:** `lib/features/auth/presentation/pages/login_page_simple.dart`

**Alteração:**
- **ANTES:** Login → `/home`
- **AGORA:** Login → `/journey-start`

---

## 🔄 Fluxo Completo da Aplicação

```
┌─────────┐
│ Splash  │
└────┬────┘
     │
     ▼
┌─────────┐
│  Login  │
└────┬────┘
     │
     ▼
┌──────────────────┐
│ Journey Start    │◄───────┐
│ (Selecionar      │        │
│  Veículo)        │        │ (Se não houver
└────┬─────────────┘        │  jornada ativa)
     │                      │
     │ (Após confirmar     │
     │  veículo)           │
     ▼                      │
┌──────────────────┐        │
│ Journey Dashboard│────────┘
│ (3 Cards)        │
└────┬─────────────┘
     │
     ├──► Card 1: Abastecimento → /home
     │
     ├──► Card 2: Iniciar Viagem → /journey
     │
     └──► Card 3: Checklist → (a implementar)
```

---

## 📦 Estrutura de Arquivos Criados

```
lib/
├── features/
│   └── journey_start/
│       └── presentation/
│           └── pages/
│               ├── journey_start_page.dart       # Tela de seleção de veículo
│               └── journey_dashboard_page.dart   # Dashboard com 3 cards
│
├── core/
│   └── services/
│       └── storage_service.dart                 # Métodos de storage adicionados
│
├── routes/
│   └── app_router.dart                          # Rotas adicionadas
│
└── features/
    └── auth/
        └── presentation/
            └── pages/
                └── login_page_simple.dart        # Navegação ajustada
```

---

## 🎨 Design e UI

### **Card de Dados do Motorista/Transportadora**
- ✅ Icon de pessoa
- ✅ Título "Bem-vindo!"
- ✅ Informações do motorista (Nome, CPF)
- ✅ Divider
- ✅ Informações da transportadora (Nome, CNPJ)

### **Card de Veículo**
- ✅ Campo de placa com máscara (AAA-####)
- ✅ Botão "Buscar"
- ✅ Resultado da busca em card cinza
- ✅ Botões "Cancelar" e "Iniciar Jornada"

### **Card de Veículo Ativo (Dashboard)**
- ✅ Gradiente azul (AppColors.zecaBlue)
- ✅ Placa em destaque (fonte grande, bold, espaçamento)
- ✅ Badge "ATIVA" em verde
- ✅ Informações do veículo, motorista e transportadora

### **Cards de Ação (Dashboard)**
- ✅ Icon grande com background colorido
- ✅ Título e descrição
- ✅ Seta para a direita
- ✅ Efeito ripple ao clicar

---

## ✅ Validações Implementadas

1. **Placa obrigatória:** Não permite buscar sem informar a placa
2. **Formato de placa:** Valida formato antigo (ABC-1234) e Mercosul (ABC1D23)
3. **Veículo não encontrado:** Mostra mensagem de erro clara
4. **Jornada ativa:** Verifica se já existe jornada e redireciona automaticamente
5. **Dados completos:** Salva todos os dados necessários do veículo, motorista e transportadora

---

## 🔐 Segurança e Persistência

- ✅ Dados salvos em `SharedPreferences` (storage local)
- ✅ Dados persistem entre sessões do app
- ✅ Dados são limpos ao finalizar jornada
- ✅ Verificação automática de jornada ativa ao carregar telas

---

## 🚀 Próximos Passos (Sugeridos)

### **1. Tela de Checklist (A implementar)**
- [ ] Criar `ChecklistPage`
- [ ] Definir itens do checklist (pneus, óleo, freios, etc.)
- [ ] Adicionar rota `/checklist` no router
- [ ] Implementar lógica de salvamento do checklist

### **2. Melhorias Futuras**
- [ ] Adicionar histórico de veículos usados
- [ ] Permitir seleção rápida de veículo favorito
- [ ] Adicionar foto do veículo no card
- [ ] Implementar busca de veículo por QR Code
- [ ] Adicionar notificação quando jornada estiver ativa há muito tempo

### **3. Integração com Abastecimento**
- [ ] Validar se há jornada ativa antes de permitir abastecimento
- [ ] Associar abastecimento ao veículo da jornada ativa
- [ ] Mostrar dados do veículo ativo na tela de abastecimento

---

## 🧪 Como Testar

### **Teste 1: Fluxo Completo (Primeira Vez)**
1. Faça login no app
2. Verifique se é direcionado para `JourneyStartPage`
3. Veja se os dados do motorista e transportadora são exibidos
4. Digite uma placa válida (ex: ABC-1234)
5. Clique em "Buscar"
6. Verifique se os dados do veículo são exibidos
7. Clique em "Iniciar Jornada"
8. Verifique se é direcionado para `JourneyDashboardPage`
9. Veja se o card do veículo ativo é exibido corretamente
10. Teste os 3 cards:
    - Abastecimento → deve ir para `/home`
    - Iniciar Viagem → deve ir para `/journey`
    - Checklist → deve mostrar "em desenvolvimento"

### **Teste 2: Jornada Já Ativa**
1. Com jornada já iniciada, feche e reabra o app
2. Faça login
3. Verifique se é direcionado automaticamente para `JourneyDashboardPage`
4. Confirme que os dados do veículo persistiram

### **Teste 3: Finalizar Jornada**
1. No `JourneyDashboardPage`, clique no botão de power (canto superior direito)
2. Confirme a finalização
3. Verifique se é redirecionado para `JourneyStartPage`
4. Confirme que precisa selecionar um veículo novamente

### **Teste 4: Erros e Validações**
1. Tente buscar veículo sem informar placa → deve mostrar erro
2. Digite placa inválida → deve mostrar erro
3. Digite placa não cadastrada → deve mostrar "Veículo não encontrado"
4. Clique em "Cancelar" após buscar veículo → deve limpar dados

---

## 📝 Observações Importantes

1. **API Integration:**
   - A busca de veículo usa `ApiService().searchVehicle(placa)`
   - A busca de dados do usuário usa `ApiService().getUserProfile()`
   - Certifique-se de que a API está respondendo corretamente

2. **Storage:**
   - Os dados são salvos em `journey_vehicle_data` no SharedPreferences
   - Os dados incluem TUDO: veículo, motorista e transportadora
   - Use `StorageService` para acessar os dados em qualquer lugar do app

3. **Navegação:**
   - O fluxo sempre começa em `/journey-start` após login
   - Se já houver jornada, é redirecionado automaticamente para `/journey-dashboard`
   - Ao finalizar jornada, retorna para `/journey-start`

4. **Checklist:**
   - O card de Checklist atualmente apenas mostra uma mensagem
   - A funcionalidade será implementada na próxima fase

---

## 🎉 Conclusão

A implementação está **completa e funcional**! 

**O que foi entregue:**
- ✅ Tela de seleção de veículo com validação
- ✅ Dashboard com 3 cards principais
- ✅ Persistência de dados no storage local
- ✅ Roteamento ajustado
- ✅ Integração com telas existentes (Abastecimento e Iniciar Viagem)
- ✅ Verificação automática de jornada ativa
- ✅ UI moderna e intuitiva
- ✅ Sem erros de lint

**Pronto para testar! 🚀**

