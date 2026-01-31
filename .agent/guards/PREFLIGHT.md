---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Checklist pré-tarefa - OBRIGATÓRIO antes de qualquer desenvolvimento"
---


# 🚀 PREFLIGHT Checklist - ZECA App

> **OBRIGATÓRIO antes de QUALQUER tarefa de desenvolvimento.**
>
> Este checklist garante que você está preparado para implementar com qualidade.

---

## 📋 Visão Geral das Fases

| Fase | Nome | Objetivo | Tempo |
|------|------|----------|-------|
| 1️⃣ | Preparação Mental | Entrar no modo "não sei nada" | 1 min |
| 2️⃣ | Leitura Obrigatória | Consultar documentação essencial | 5-10 min |
| 3️⃣ | Verificação do Ambiente | Garantir que tudo está funcionando | 2 min |
| 4️⃣ | Regras de Negócio | Entender as RN-XXX relevantes | 5-10 min |
| 5️⃣ | Verificação por Tipo | Checklist específico da tarefa | 3-5 min |
| 6️⃣ | Entrega | Validar antes de commitar | 5 min |

---

## 1️⃣ FASE 1: Preparação Mental

> **"Eu não sei nada. Eu consulto, aprendo, verifico, e só então executo."**

### Mindset Obrigatório

```
╔══════════════════════════════════════════════════════════════════════════╗
║  ❌ NÃO assumir que sei como fazer                                       ║
║  ❌ NÃO pular etapas para "ganhar tempo"                                 ║
║  ❌ NÃO inventar código que não existe                                   ║
║  ❌ NÃO ignorar erros passados                                           ║
║                                                                          ║
║  ✅ SEMPRE consultar antes de implementar                                ║
║  ✅ SEMPRE verificar se código/método existe                             ║
║  ✅ SEMPRE seguir padrões estabelecidos                                  ║
║  ✅ SEMPRE aprender com erros anteriores                                 ║
╚══════════════════════════════════════════════════════════════════════════╝
```

### Autochecklist Mental
- [ ] Estou preparado para consultar antes de agir?
- [ ] Vou seguir TODOS os passos deste preflight?
- [ ] Entendo que qualidade > velocidade?

---

## 2️⃣ FASE 2: Leitura Obrigatória

### 2.1 Erros Passados (CRÍTICO)

```bash
cat .context/LESSONS-LEARNED.md
```

**Por quê?** Cada erro ali custou tempo e retrabalho. Não repita.

**Procurar:**
- [ ] Erros relacionados ao tipo de tarefa atual
- [ ] Padrões que devo seguir
- [ ] Armadilhas a evitar

### 2.2 Error Patterns

```bash
cat .agent/guards/ERROR-PATTERNS.md
```

**Por quê?** Catálogo de anti-patterns Flutter para evitar.

**Verificar:**
- [ ] Anti-patterns de Estado (EP-STA-XXX)
- [ ] Anti-patterns de Arquitetura (EP-ARC-XXX)
- [ ] Anti-patterns de UI (EP-WID-XXX)

### 2.3 Quality Gates

```bash
cat .agent/guards/QUALITY-GATES.md
```

**Por quê?** São os critérios que o código precisa passar.

**Lembrar:**
- [ ] QG-01: Compilação sem erros
- [ ] QG-02: Testes ≥ 60%
- [ ] QG-03: build_runner executado
- [ ] QG-04: Regras RN-XXX implementadas

### 2.4 Brain (Conhecimento Técnico)

```bash
# Arquitetura
cat .agent/brain/CLEAN-ARCHITECTURE.md

# BLoC
cat .agent/brain/BLOC-PATTERNS.md

# Freezed
cat .agent/brain/FREEZED-PATTERNS.md

# DI
cat .agent/brain/DI-PATTERNS.md
```

**Por quê?** Padrões técnicos do projeto.

---

## 3️⃣ FASE 3: Verificação do Ambiente

### 3.1 Dependências Atualizadas

```bash
flutter pub get
```

### 3.2 Código Gerado Atualizado

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3.3 Análise Estática Limpa

```bash
flutter analyze
```

**Esperado:** `No issues found!`

### 3.4 Testes Passando

```bash
flutter test
```

**Esperado:** Todos os testes passando (verde)

### 3.5 Branch Atualizada

```bash
git checkout develop
git pull origin develop
git checkout -b feature/minha-feature  # Nova branch para a tarefa
```

### Checklist do Ambiente
- [ ] `flutter pub get` executado
- [ ] `build_runner` executado sem erros
- [ ] `flutter analyze` sem issues
- [ ] Testes existentes passando
- [ ] Nova branch criada a partir de develop

---

## 4️⃣ FASE 4: Regras de Negócio

### 4.1 Consultar BUSINESS-RULES.md

```bash
cat .context/BUSINESS-RULES.md
```

### 4.2 Identificar RN-XXX Relevantes

**Pergunta:** Quais regras de negócio afetam minha tarefa?

| Módulo | Prefixo | Exemplo |
|--------|---------|---------|
| Jornada | RN-JRN-XXX | RN-JRN-001: Motorista ativo |
| Abastecimento | RN-ABT-XXX | RN-ABT-001: Jornada ativa |
| Pagamento | RN-PAG-XXX | RN-PAG-001: PIX válido |
| Veículo | RN-VEI-XXX | RN-VEI-001: Combustível compatível |

### 4.3 Checklist de Regras
- [ ] Li as regras RN-XXX relevantes
- [ ] Entendi as validações necessárias
- [ ] Sei quais mensagens de erro mostrar
- [ ] Conheço os estados do fluxo

### 4.4 Consultar API-CONTRACTS

```bash
cat .context/API-CONTRACTS.md | grep -A 30 "[endpoint_relevante]"
```

**Verificar:**
- [ ] Endpoint existe
- [ ] Request body correto
- [ ] Response esperado
- [ ] Códigos de erro possíveis

---

## 5️⃣ FASE 5: Verificação por Tipo de Tarefa

### 5A. Nova Feature (UI)

```bash
# Consultar padrões de Widget
cat .agent/skills/WIDGET-PATTERNS.md

# Ver estrutura de feature existente
ls -la lib/features/auth/  # Exemplo
```

**Checklist Nova Feature UI:**
- [ ] Criar mockup HTML/ASCII ANTES de implementar
- [ ] Aguardar aprovação do mockup
- [ ] Seguir estrutura de pastas (Clean Architecture)
- [ ] Incluir todos os estados (loading, error, empty, loaded)
- [ ] Usar BLoC para gerenciar estado
- [ ] Usar Freezed para states/events
- [ ] Criar testes de BLoC
- [ ] Criar testes de Widget

### 5B. Nova Feature (Lógica)

```bash
# Consultar arquitetura
cat .agent/brain/CLEAN-ARCHITECTURE.md

# Ver feature existente como referência
find lib/features/refueling -name "*.dart" | head -20
```

**Checklist Nova Feature Lógica:**
- [ ] Criar Entity no Domain
- [ ] Criar Repository interface no Domain
- [ ] Criar UseCase no Domain
- [ ] Criar Model no Data (com fromJson/toJson/toEntity)
- [ ] Criar DataSource no Data
- [ ] Criar Repository implementation no Data
- [ ] Registrar com @injectable/@lazySingleton
- [ ] Rodar build_runner
- [ ] Criar testes unitários

### 5C. Correção de Bug

```bash
# Consultar lições aprendidas
cat .context/LESSONS-LEARNED.md

# Buscar código relacionado
grep -rn "termo_do_bug" lib/
```

**Checklist Correção de Bug:**
- [ ] Reproduzir o bug antes de corrigir
- [ ] Identificar causa raiz
- [ ] Verificar se não quebra fluxo existente
- [ ] Escrever teste que falha com o bug
- [ ] Corrigir o bug
- [ ] Verificar teste passando
- [ ] Rodar todos os testes
- [ ] Adicionar ao LESSONS-LEARNED se relevante

### 5D. Refatoração

```bash
# Consultar padrões
cat .agent/brain/BLOC-PATTERNS.md
cat .agent/brain/CLEAN-ARCHITECTURE.md
```

**Checklist Refatoração:**
- [ ] Testes existentes passando ANTES
- [ ] Não alterar comportamento externo
- [ ] Manter assinaturas de métodos públicos
- [ ] Todos os testes passando DEPOIS
- [ ] flutter analyze limpo

### 5E. Integração com API

```bash
# Consultar contratos
cat .context/API-CONTRACTS.md

# Ver DataSource existente
cat lib/features/auth/data/datasources/auth_remote_datasource.dart
```

**Checklist Integração API:**
- [ ] Endpoint documentado em API-CONTRACTS.md
- [ ] Model com @JsonSerializable
- [ ] DataSource com @RestApi (Retrofit)
- [ ] Repository trata erros (Either)
- [ ] UseCase valida regras de negócio
- [ ] BLoC emite estados corretos
- [ ] Teste com mock do Repository

---

## 6️⃣ FASE 6: Entrega

### 6.1 Verificações Finais

```bash
# Análise estática
flutter analyze

# Testes
flutter test

# Cobertura
flutter test --coverage

# Formatação
dart format lib/

# Build Android
flutter build apk --debug

# Build iOS (se no Mac)
flutter build ios --debug --no-codesign
```

### 6.2 Checklist Pré-Commit
- [ ] `flutter analyze` sem erros
- [ ] Todos os testes passando
- [ ] Cobertura ≥ 60%
- [ ] Código formatado
- [ ] Build Android OK
- [ ] Build iOS OK
- [ ] build_runner executado
- [ ] Sem arquivos sensíveis (.env, keys)

### 6.3 Git Commit

```bash
# Adicionar arquivos específicos
git add lib/features/minha_feature/
git add test/features/minha_feature/

# Commit com mensagem descritiva
git commit -m "feat(refueling): add QR code payment screen

- Add RefuelingPaymentPage with BLoC
- Add payment state management
- Add unit tests for RefuelingPaymentBloc
- Implements RN-PAG-001, RN-PAG-002"
```

### 6.4 Checklist Pré-PR
- [ ] Branch atualizada com develop
- [ ] Commits atômicos e descritivos
- [ ] Quality Gates passando
- [ ] Documentação atualizada (se necessário)
- [ ] LESSONS-LEARNED atualizado (se descobriu algo novo)

---

## 📊 Resumo Visual

```
┌─────────────────────────────────────────────────────────────────┐
│                    PREFLIGHT CHECKLIST                          │
├─────────────────────────────────────────────────────────────────┤
│  1️⃣ PREPARAÇÃO MENTAL                                           │
│     □ Mindset "não sei nada"                                    │
│     □ Pronto para consultar                                     │
├─────────────────────────────────────────────────────────────────┤
│  2️⃣ LEITURA OBRIGATÓRIA                                         │
│     □ LESSONS-LEARNED.md                                        │
│     □ ERROR-PATTERNS.md                                         │
│     □ QUALITY-GATES.md                                          │
│     □ Brain (arquitetura, BLoC, Freezed)                        │
├─────────────────────────────────────────────────────────────────┤
│  3️⃣ AMBIENTE                                                    │
│     □ flutter pub get                                           │
│     □ build_runner executado                                    │
│     □ flutter analyze limpo                                     │
│     □ Testes passando                                           │
│     □ Nova branch criada                                        │
├─────────────────────────────────────────────────────────────────┤
│  4️⃣ REGRAS DE NEGÓCIO                                           │
│     □ BUSINESS-RULES.md consultado                              │
│     □ RN-XXX relevantes identificadas                           │
│     □ API-CONTRACTS.md verificado                               │
├─────────────────────────────────────────────────────────────────┤
│  5️⃣ VERIFICAÇÃO POR TIPO                                        │
│     □ Checklist específico da tarefa                            │
│     □ Padrões do projeto seguidos                               │
├─────────────────────────────────────────────────────────────────┤
│  6️⃣ ENTREGA                                                     │
│     □ Análise + Testes + Build OK                               │
│     □ Commit com mensagem descritiva                            │
│     □ PR pronto para review                                     │
└─────────────────────────────────────────────────────────────────┘
```

---

## ⚠️ NUNCA Pular Este Checklist

Cada item existe porque um erro já aconteceu. Pular o preflight é garantia de:
- Retrabalho
- Bugs em produção
- Código fora do padrão
- Testes faltando
- Frustração

**Invista 15-20 minutos no preflight para economizar horas de correção.**

---

*PREFLIGHT v2.0.0 - Janeiro 2026*
