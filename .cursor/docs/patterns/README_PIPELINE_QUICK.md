# Quick Reference: Pipeline de Desenvolvimento ⚡

**Documento completo:** `PIPELINE_DESENVOLVIMENTO.md`

---

## ⚡ Checklist Rápido

### ✅ Antes de Planejar Qualquer Feature:

```bash
# 1. Buscar funcionalidade similar
grep -r "keyword" lib/

# 2. Listar telas
find lib/features -name "*_page.dart"

# 3. Listar widgets
find lib -name "*widget*.dart" -o -name "*card*.dart"

# 4. Verificar backend
ls ../zeca_site/backend/src/[feature]/

# 5. Ver specs existentes
ls *.md **/*.md
```

### ✅ Durante Planejamento:

- [ ] Criar `ANALISE_EXISTENTE_[NOME].md`
- [ ] Preencher seção "Análise do Existente" na User Story
- [ ] Estimar apenas o GAP (não duplicar estimativa)
- [ ] Marcar tasks: ✅ existe | ⚠️ adaptar | 🆕 criar

### ✅ Durante Implementação:

- [ ] Reutilizar código existente ao máximo
- [ ] Adaptar componentes antes de criar novo
- [ ] Seguir padrões do projeto (consultar `docs/patterns/README.md`)
- [ ] Commits atômicos com mensagens claras

### ✅ Antes de PR:

- [ ] `flutter analyze` sem erros críticos
- [ ] Testes passando
- [ ] Self-review completo
- [ ] Código comentado/debug removido

---

## 🚨 Anti-Patterns (NUNCA fazer):

❌ "Vou criar do zero porque é mais rápido"  
❌ "Já sei como funciona, não preciso investigar"  
❌ "Vou fazer diferente porque meu jeito é melhor"  
❌ "Depois eu refatoro"  
❌ "É só uma mudança pequena, não precisa de branch"

---

## 📊 Exemplo Real:

### ❌ Abordagem Errada:
1. Ler requisito → 2. Criar US (22h) → 3. Codar → 4. Descobrir que 70% existe → 5. Frustração!

### ✅ Abordagem Correta:
1. Ler requisito → 2. **INVESTIGAR** (30min) → 3. Criar US (10h) → 4. Codar apenas gap → 5. Sucesso! ✨

**Economia: 12 horas (54%)**

---

## 🔗 Links Úteis:

- 📖 **Pipeline Completo:** `PIPELINE_DESENVOLVIMENTO.md`
- 📄 **Template User Story:** `../user-stories/TEMPLATE.md`
- 🏗️ **Arquitetura:** `../architecture/README.md`
- 📝 **Padrões de Código:** `README.md`
- 🌿 **Gitflow:** `../../GUIA_GITFLOW_MERGE.md`

---

**Dúvidas?** Consulte o documento completo ou pergunte ao time! 💬

