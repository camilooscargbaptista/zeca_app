# 📚 .cursor/ - Documentação ZECA App

Documentação estruturada, decisões arquiteturais, padrões e processos do app mobile ZECA (Flutter).

---

## 📂 Estrutura da Pasta `.cursor/`

```
.cursor/
├── README.md                          # Este arquivo (índice geral)
├── CHANGELOG.md                       # 🆕 Histórico de mudanças na documentação
├── RESUMO_ESTRUTURA.md               # Resumo executivo da estrutura criada
│
├── docs/
│   ├── architecture/                 # Documentação da arquitetura
│   │   └── README.md                 # Clean Architecture + BLoC + DI
│   │
│   ├── decisions/                    # Architecture Decision Records (ADRs)
│   │   ├── ADR-001-clean-architecture-bloc.md
│   │   ├── ADR-002-getit-injectable.md
│   │   ├── ADR-003-flutter-background-geolocation.md
│   │   └── ADR-004-google-mlkit-ocr.md
│   │
│   ├── patterns/                     # Padrões de código e boas práticas
│   │   ├── README.md                 # Standards de Flutter/Dart, Testing, UI/UX
│   │   ├── PIPELINE_DESENVOLVIMENTO.md  # 🆕 Pipeline: Da Ideia à Produção
│   │   └── README_PIPELINE_QUICK.md     # 🆕 Quick Reference do Pipeline
│   │
│   ├── specifications/               # Especificações técnicas detalhadas
│   │   └── README.md                 # Índice de specs (telemetria, polling, etc.)
│   │
│   └── user-stories/                 # User Stories e casos de uso
│       ├── TEMPLATE.md               # Template para novas user stories (🔄 atualizado)
│       ├── TEMPLATE_RETROATIVO.md    # Template para user stories retroativas
│       ├── UH-002-jornadas-tracking-gps.md
│       ├── UH-003-navegacao-tempo-real.md  # 🆕 Navegação em tempo real
│       ├── ANALISE_EXISTENTE_NAVEGACAO.md  # 🆕 Exemplo de análise
│       └── GUIA_USER_STORIES_RETROATIVAS.md
```

---

## 🎯 Objetivo

Garantir **contexto persistente** e **consistência** no desenvolvimento:

1. ✅ Documentação sempre atualizada
2. ✅ Decisões técnicas registradas (ADRs)
3. ✅ Padrões de código claros (Clean Architecture + BLoC)
4. ✅ Processo de desenvolvimento padronizado
5. ✅ **Validação do código existente antes de planejar** 🆕
6. ✅ Histórico completo de features

---

## 🚀 Como Usar Esta Estrutura

### 🆕 **NOVO: Pipeline Obrigatório (SEMPRE seguir!)**

#### **FASE 1: Investigação (15-30 min) 🔍**
> ⚠️ **OBRIGATÓRIO antes de qualquer planejamento!**

1. 📖 **Leia:** `docs/patterns/PIPELINE_DESENVOLVIMENTO.md`
2. 🔍 **Busque no código** o que já existe:
   ```bash
   grep -r "keyword" lib/
   find lib/features -name "*_page.dart"
   find lib -name "*widget*.dart"
   ```
3. 📸 **Tire screenshots** da funcionalidade atual (se aplicável)
4. 📝 **Crie:** `docs/user-stories/ANALISE_EXISTENTE_[FEATURE].md`
5. ✅ **Identifique:** O que existe vs O que falta

**Por quê?** Na primeira aplicação deste processo (UH-003), economizamos **12 horas (54%)** ao identificar que 70% já estava implementado!

---

#### **FASE 2: Planejamento (30-60 min) 📝**

1. **Use o template:** `docs/user-stories/TEMPLATE.md`
   - Preencha seção "🔍 Análise do Existente"
   - Liste o que já existe (backend + app)
   - Calcule % de completude

2. **Marque as tasks:**
   - ✅ Já existe (reutilizar)
   - ⚠️ Precisa adaptar
   - 🆕 Criar do zero

3. **Estime apenas o GAP:**
   - ❌ NÃO estime o total como se fosse criar tudo
   - ✅ Estime apenas o que FALTA

4. **Crie branch:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/UH-XXX-nome
   ```

---

#### **FASE 3: Implementação 💻**

1. **Siga a ordem (Clean Architecture):**
   - Backend (se necessário)
   - Domain Layer
   - Data Layer
   - Presentation Layer

2. **♻️ Reutilize ao máximo:**
   - Antes de criar widget, busque similar
   - Antes de criar serviço, verifique se existe
   - Adapte componentes existentes

3. **Use os padrões:**
   - BLoC para estado
   - GetIt + Injectable para DI
   - Consulte `docs/architecture/README.md`
   - Consulte `docs/patterns/README.md`

4. **Commits atômicos:**
   ```bash
   git commit -m "feat(journey): adiciona validação destino obrigatório"
   ```

---

#### **FASE 4: Qualidade ✅**

```bash
# Linter
flutter analyze

# Testes
flutter test

# Build
flutter build apk --debug
```

- [ ] Linter sem erros críticos
- [ ] Testes passando
- [ ] Testado em iOS e Android
- [ ] Self-review completo
- [ ] TODOs/FIXMEs removidos

---

#### **FASE 5: Deploy 🚀**

1. **Pull Request:**
   - Título: `[UH-XXX] Nome da Feature`
   - Descrição: Link para User Story
   - Screenshots (se mudança visual)

2. **Merge:**
   ```bash
   git checkout develop
   git merge feature/UH-XXX-nome --no-ff
   git push origin develop
   ```

3. **Documentação:**
   - Atualizar CHANGELOG.md (se necessário)
   - Atualizar ADRs (se decisão arquitetural)

---

### ⚠️ REGRA DE OURO:

> ## **"NUNCA planeje uma feature sem antes investigar o que JÁ EXISTE!"**

**Consulta rápida:** `docs/patterns/README_PIPELINE_QUICK.md` ⚡

---

## 📚 Documentos Principais

| Documento | Descrição | Caminho |
|-----------|-----------|---------|
| **🆕 Pipeline de Desenvolvimento** | Processo completo obrigatório | `docs/patterns/PIPELINE_DESENVOLVIMENTO.md` |
| **⚡ Quick Reference** | Checklist rápido do pipeline | `docs/patterns/README_PIPELINE_QUICK.md` |
| **Arquitetura** | Clean Architecture + BLoC + DI | `docs/architecture/README.md` |
| **Padrões** | Convenções Flutter/Dart, Testing, UI/UX | `docs/patterns/README.md` |
| **ADRs** | Decisões arquiteturais | `docs/decisions/` |
| **Especificações** | Specs técnicas detalhadas | `docs/specifications/` |
| **User Stories** | Features documentadas | `docs/user-stories/` |
| **Gitflow** | Processo de merge | `GUIA_GITFLOW_MERGE.md` |

---

## 🆕 Para Novos Desenvolvedores

### **Primeiro Dia:**

1. 📖 **Leia (nesta ordem):**
   - Este README completo
   - `docs/patterns/PIPELINE_DESENVOLVIMENTO.md` ⭐ **ESSENCIAL**
   - `docs/architecture/README.md`
   - `docs/patterns/README.md`

2. 🔍 **Estude um exemplo completo:**
   - User Story: `docs/user-stories/UH-003-navegacao-tempo-real.md`
   - Análise: `docs/user-stories/ANALISE_EXISTENTE_NAVEGACAO.md`
   - Veja como 70% já existia e economizou 12 horas!

3. 🏃 **Rode o projeto:**
   ```bash
   flutter pub get
   flutter run
   ```

4. 🗺️ **Navegue pelo app:**
   - Explore as telas
   - Veja os widgets em ação
   - Tire screenshots para referência

### **Sua Primeira Feature:**

1. ✅ **Siga o pipeline** (`PIPELINE_DESENVOLVIMENTO.md`)
2. ✅ **Fase 1 é obrigatória** (análise do existente)
3. ✅ **Use o template** atualizado (`TEMPLATE.md`)
4. 💬 **Tire dúvidas** com o time antes de estimar

---

## 🚨 Anti-Patterns (NUNCA fazer!)

❌ **"Vou criar do zero porque é mais rápido"**  
→ Sempre buscar código existente primeiro

❌ **"Já sei como funciona, não preciso investigar"**  
→ Código muda rápido, sempre validar

❌ **"Vou fazer diferente porque meu jeito é melhor"**  
→ Consistência > perfeição individual

❌ **"Depois eu refatoro"**  
→ Fazer certo desde o início

❌ **"É só uma mudança pequena, não precisa de branch"**  
→ SEMPRE usar branch (Gitflow)

---

## 📊 Métricas de Sucesso

### KPIs do Pipeline:

1. **Reuso de Código:**
   - Meta: 30%+ das tasks marcadas como ✅ (já existe)
   - Atual: 70% (UH-003)

2. **Acurácia de Estimativas:**
   - Meta: Variação < 20% entre estimado e real
   - Atual: Redução de 54% após análise (UH-003)

3. **Time to Market:**
   - Meta: Feature média em produção em < 5 dias

---

## 🛠️ Stack Tecnológico

### **Framework:**
- Flutter 3.x
- Dart 3.x

### **Arquitetura:**
- Clean Architecture
- BLoC Pattern (flutter_bloc)
- Dependency Injection (get_it + injectable)

### **Principais Packages:**
- **State:** flutter_bloc, equatable
- **Network:** dio, retrofit
- **Storage:** hive, shared_preferences, flutter_secure_storage
- **Navigation:** go_router
- **Location:** flutter_background_geolocation, geolocator
- **Maps:** google_maps_flutter
- **Camera/OCR:** camera, google_mlkit_text_recognition
- **Push:** firebase_messaging
- **QR:** mobile_scanner, qr_flutter

### **Features Implementadas:**
- 🔐 Autenticação (JWT, CPF)
- 🚗 Abastecimento (QR code, validação, polling)
- 🗺️ Jornadas (tracking GPS, navegação)
- 📸 Odômetro (OCR com ML Kit)
- 🔔 Notificações (Push Firebase)
- ✅ Checklist (Veículos)
- 🏷️ White-label (Multi-brand)

---

## 📞 Links Úteis

- **Backend:** `../zeca_site/`
- **Documentação Backend:** `../zeca_site/.cursor/`
- **Gitflow:** `GUIA_GITFLOW_MERGE.md`
- **Changelog:** `CHANGELOG.md`

---

## 🔄 Histórico

**v1.1.0** (27/11/2024):
- ✨ Adicionado Pipeline de Desenvolvimento obrigatório
- ✨ Template atualizado com análise do existente
- ✨ Exemplo completo (UH-003) com economia de 54%
- 📝 CHANGELOG criado

**v1.0.0** (27/11/2024):
- 🎉 Estrutura inicial da documentação
- 📖 ADRs, patterns, architecture
- 📝 Templates de User Stories

---

**Criado em:** 27/11/2024  
**Versão:** 1.1.0  
**Status:** ✅ Ativo  
**Última atualização:** 27/11/2024

