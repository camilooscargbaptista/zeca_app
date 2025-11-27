# Pipeline de Desenvolvimento - ZECA App

**Versão:** 1.0  
**Data:** 27/11/2024  
**Objetivo:** Garantir que SEMPRE validamos o que existe antes de planejar novas features

---

## 🚨 REGRA DE OURO

> **"NUNCA planeje uma feature sem antes investigar o que JÁ EXISTE no código!"**

Isso evita:
- ❌ Duplicação de esforço
- ❌ Estimativas infladas (22h quando na verdade são 10h)
- ❌ Ignorar código existente que pode ser reutilizado
- ❌ Criar tasks para coisas que já funcionam

---

## 📋 Pipeline Completo: Da Ideia à Produção

### **FASE 1: Investigação e Validação** 🔍
**Tempo estimado:** 15-30 minutos  
**Responsável:** Dev/AI Assistant  
**Bloqueador:** ❌ NÃO avançar sem completar esta fase

#### Checklist Obrigatório:

1. **[ ] Buscar Funcionalidades Similares no Código**
   ```bash
   # Buscar no app
   grep -r "keyword" lib/
   
   # Buscar specs existentes
   ls -la *.md **/*.md
   ```

2. **[ ] Verificar Backend**
   - Endpoints já existem?
   - DTOs/Entidades criadas?
   - Buscar em `zeca_site/backend/src/`

3. **[ ] Revisar Widgets/Telas Existentes**
   - Já tem componente visual similar?
   - Pode ser reutilizado/adaptado?
   - Buscar em `lib/features/*/presentation/`

4. **[ ] Verificar Serviços Core**
   - `lib/core/services/` tem algo relacionado?
   - APIs externas já configuradas?

5. **[ ] Buscar Documentação Existente**
   - ADRs relacionados?
   - User Stories anteriores?
   - Specs técnicas?

6. **[ ] Testar App Manualmente (se possível)**
   - Rodar o app
   - Navegar pelas telas
   - Tirar screenshots da funcionalidade atual

#### Output desta Fase:

Criar documento **"ANALISE_EXISTENTE_[FEATURE].md"**:

```markdown
# Análise do Existente: [Nome da Feature]

## ✅ O Que JÁ Existe:
1. Backend:
   - Endpoints: [listar]
   - Entidades: [listar]
   
2. App Flutter:
   - Telas: [listar com paths]
   - Widgets: [listar]
   - Serviços: [listar]
   - BLoCs/Estados: [listar]

## ❌ O Que Falta Implementar:
1. [Item 1]
2. [Item 2]
...

## 📊 % de Completude Estimado:
[X]% já implementado

## 📸 Screenshots/Evidências:
[Adicionar prints ou links]

## 🎯 Recomendação:
- Reutilizar: [componentes]
- Adaptar: [componentes]
- Criar do zero: [componentes]
```

---

### **FASE 2: Planejamento e Documentação** 📝
**Tempo estimado:** 30-60 minutos  
**Responsável:** Dev/PO  
**Input:** Documento de análise da Fase 1

#### Checklist:

1. **[ ] Criar User Story**
   - Usar template `.cursor/docs/user-stories/TEMPLATE.md`
   - **IMPORTANTE:** Incluir seção "O Que Já Existe" no início
   - Estimar apenas o que FALTA (não o total)

2. **[ ] Quebrar em Tasks**
   - Separar por camada (Backend, Domain, Data, Presentation)
   - Marcar tasks com ✅ se já existe ou ⚠️ se precisa adaptar
   - Estimar horas realistas baseado no gap analysis

3. **[ ] Validar com Stakeholder**
   - Mostrar análise do existente
   - Confirmar escopo
   - Obter decisões de negócio (se necessário)

4. **[ ] Criar Branch**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/UH-XXX-nome-curto
   ```

#### Output desta Fase:
- ✅ User Story completa (`.cursor/docs/user-stories/UH-XXX-*.md`)
- ✅ Tasks detalhadas
- ✅ Branch criada

---

### **FASE 3: Implementação** 💻
**Tempo estimado:** Conforme estimativa da User Story  
**Responsável:** Dev

#### Ordem de Implementação (Clean Architecture):

1. **Backend (se necessário)**
   - DTOs
   - Entidades
   - Services
   - Controllers
   - Testes

2. **Domain Layer**
   - Entities (se necessário)
   - Use cases (se necessário)

3. **Data Layer**
   - Models (se necessário)
   - Services/Repositories
   - DTOs

4. **Presentation Layer**
   - BLoCs/States
   - Pages
   - Widgets
   - Navigation

#### Checklist de Implementação:

- **[ ] Seguir padrões do projeto**
  - Consultar `.cursor/docs/patterns/README.md`
  - Usar convenções de nomenclatura
  - Seguir estrutura de pastas

- **[ ] Reutilizar ao máximo**
  - Antes de criar widget novo, buscar similar
  - Antes de criar serviço, verificar se já existe
  - DRY (Don't Repeat Yourself)

- **[ ] Commits atômicos**
  ```bash
  git commit -m "feat(journey): adiciona validação destino obrigatório"
  git commit -m "feat(journey): implementa animação inicial 5s"
  ```

- **[ ] Testar localmente**
  - Build sem erros
  - Linter sem warnings críticos
  - Funcionalidade testada manualmente

---

### **FASE 4: Code Review e Qualidade** 🔍
**Tempo estimado:** 15-30 minutos  
**Responsável:** Dev/Reviewer

#### Checklist:

- **[ ] Linter OK**
  ```bash
  flutter analyze
  ```

- **[ ] Sem TODOs ou FIXMEs**
  ```bash
  grep -r "TODO\|FIXME" lib/
  ```

- **[ ] Build Android/iOS OK**
  ```bash
  flutter build apk --debug
  flutter build ios --debug --no-codesign
  ```

- **[ ] Self-Review**
  - Ler o diff completo
  - Remover logs de debug
  - Remover código comentado
  - Validar nomenclatura

- **[ ] Criar Pull Request**
  - Título: `[UH-XXX] Nome da Feature`
  - Descrição: Link para User Story
  - Screenshots/GIFs (se mudança visual)
  - Checklist de testes

---

### **FASE 5: Merge e Deploy** 🚀
**Tempo estimado:** 5-10 minutos  
**Responsável:** Tech Lead/DevOps

#### Checklist:

- **[ ] PR aprovado**
- **[ ] Branch atualizada com develop**
  ```bash
  git checkout feature/UH-XXX-nome
  git merge develop
  # Resolver conflitos se houver
  ```
- **[ ] Merge para develop**
  ```bash
  git checkout develop
  git merge feature/UH-XXX-nome --no-ff
  git push origin develop
  ```
- **[ ] Tag de versão (se release)**
  ```bash
  git tag -a v1.2.0 -m "Release 1.2.0 - Navegação em tempo real"
  git push origin v1.2.0
  ```
- **[ ] Atualizar CHANGELOG.md**
- **[ ] Deploy para ambiente de teste**

---

## 🛠️ Ferramentas e Comandos Úteis

### Busca no Código
```bash
# Buscar por funcionalidade
grep -r "keyword" lib/ --include="*.dart"

# Buscar endpoints no backend
grep -r "Post\|Get\|Put\|Delete" backend/src/ -A 2

# Listar todas as telas
find lib/features -name "*_page.dart"

# Listar todos os widgets
find lib -name "*widget*.dart" -o -name "*card*.dart"

# Listar todos os serviços
find lib/core/services -name "*.dart"
```

### Análise de Código
```bash
# Ver estrutura de diretórios
tree lib/ -L 3

# Contar linhas por feature
cloc lib/features/journey

# Ver histórico de uma feature
git log --oneline --graph -- lib/features/journey/
```

### Testes Rápidos
```bash
# Rodar apenas linter
flutter analyze

# Rodar app em debug
flutter run --debug

# Hot reload sem perder estado
# (pressionar 'r' no terminal do flutter run)

# Build de teste
flutter build apk --debug
```

---

## 📊 Métricas de Sucesso do Pipeline

### KPIs:
1. **Reuso de Código:** 
   - Meta: 30%+ das tasks marcadas como ✅ (já existe)
   
2. **Acurácia de Estimativas:**
   - Meta: Variação < 20% entre estimado e real
   
3. **Bugs em Produção:**
   - Meta: < 2 bugs críticos por release
   
4. **Time to Market:**
   - Meta: Feature média em produção em < 5 dias

---

## ⚠️ Anti-Patterns a Evitar

### ❌ **"Vou criar do zero porque é mais rápido"**
- Sempre buscar código existente primeiro
- Adaptar é quase sempre mais rápido que criar

### ❌ **"Já sei como funciona, não preciso investigar"**
- Código muda rápido
- Outros devs podem ter implementado algo similar

### ❌ **"Vou fazer diferente porque meu jeito é melhor"**
- Consistência > perfeição
- Seguir padrões do projeto

### ❌ **"Depois eu refatoro"**
- Fazer certo desde o início
- Débito técnico acumula rápido

### ❌ **"É só uma mudança pequena, não precisa de branch"**
- SEMPRE usar branch
- SEMPRE seguir Gitflow

---

## 📚 Referências

- [Clean Architecture - Flutter](./README.md)
- [Padrões de Código](./README.md#padrões-de-código)
- [Template User Story](../user-stories/TEMPLATE.md)
- [Gitflow](../../GUIA_GITFLOW_MERGE.md)
- [ADRs](../decisions/)

---

## 🔄 Histórico de Mudanças

| Data | Versão | Mudança | Autor |
|------|--------|---------|-------|
| 27/11/2024 | 1.0 | Criação do pipeline com foco em validação do existente | AI Assistant |

---

## 💡 Exemplo Prático: UH-003

### ❌ Abordagem Antiga (Errada):
1. Ler requisito do usuário
2. Criar User Story completa (22h estimadas)
3. Começar a codar
4. Descobrir que 70% já existe
5. Reestimar para 10h (frustração!)

### ✅ Abordagem Nova (Correta):
1. Ler requisito do usuário
2. **FASE 1:** Investigar código (30 min)
   - Encontrar `NavigationInfoCard` existente
   - Encontrar `RouteMapView` com polyline
   - Encontrar botões de descanso funcionando
   - Tirar screenshots
3. Criar documento `ANALISE_EXISTENTE_NAVEGACAO.md`:
   - "✅ 70% já implementado"
   - "❌ Falta: animação 5s, FAB, instruções dinâmicas"
4. **FASE 2:** Criar UH-003 com estimativa realista (10h)
5. **FASE 3:** Implementar apenas o gap
6. ✅ Feature entregue no prazo!

---

**Use este pipeline em TODAS as novas features!** 🎯

