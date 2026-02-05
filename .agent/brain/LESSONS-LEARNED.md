---
antigravity:
  trigger: "always_on"
  globs: ["**/*"]
  description: "Erros passados - SEMPRE consultar antes de qualquer tarefa"
---


# 📚 LESSONS LEARNED - ZECA App

> **"Quem não aprende com os erros está condenado a repeti-los."**

---

## 🔴 CRÍTICAS

### LESSON-APP-001: Payload com campos não aceitos pelo DTO
**Data:** 2025-12-31

**O que aconteceu:** 
App enviou `fuel_types` e `has_arla` para `/autonomous/vehicles`, mas DTO do backend não aceita esses campos.

**Erro:**
```json
{"message":["property fuel_types should not exist","property has_arla should not exist"]}
```

**Causa:** Frontend e backend não alinhados sobre campos do DTO.

**Regra:** 
ANTES de implementar chamada de API:
```bash
# Verificar DTO no backend
find backend/src -name "*dto*.dart" | xargs grep -l "vehicle"
cat [arquivo_encontrado]
```

---

### LESSON-APP-002: Esquecer de rodar build_runner
**O que aconteceu:** Arquivos `.freezed.dart` e `.g.dart` não gerados, causando erros de compilação.

**Regra:**
```bash
# SEMPRE após criar/modificar arquivos Freezed ou Retrofit
dart run build_runner build --delete-conflicting-outputs
```

---

### LESSON-APP-003: BLoC não registrado no get_it
**O que aconteceu:** Erro `Could not find factory for NomeBloc` em runtime.

**Regra:**
```bash
# Verificar se tem @injectable no BLoC
grep -r "@injectable" lib/features/nome/presentation/bloc/

# Regenerar DI
dart run build_runner build --delete-conflicting-outputs
```

---

## 🟠 ALTAS

### LESSON-APP-004: Chamar API diretamente da Page
**O que aconteceu:** Page fazia `dio.get()` diretamente, quebrando Clean Architecture.

**Regra:** SEMPRE usar fluxo:
```
Page → BLoC → UseCase → Repository → DataSource → API
```

---

### LESSON-APP-005: State mutável
**O que aconteceu:** Lista modificada diretamente causou bugs de renderização.

**Regra:** SEMPRE usar Freezed para States imutáveis.

---

## 🟡 MÉDIAS

### LESSON-APP-006: Import relativo entre features
**O que aconteceu:** Feature A importando diretamente de Feature B.

**Regra:** Se precisar compartilhar, mover para `core/` ou `shared/`.

---

### LESSON-APP-007: Mockup como Imagem ao invés de Widget Real
**Data:** 2025-12-31

**O que aconteceu:** Criou imagem PNG de mockup ao invés de Widget Flutter funcional.

**Regra:** 
- MOCKUP = ASCII art ou descrição textual (para aprovação)
- IMPLEMENTAÇÃO = Widget Dart FUNCIONAL
- ❌ NUNCA criar imagem como "widget"
- ✅ SEMPRE criar código real (.dart)

```bash
# Buscar widget similar para copiar
find lib/features -name "*dialog*.dart" -o -name "*modal*.dart"
find lib/shared/widgets -name "*.dart"
```

---

## 📊 ESTATÍSTICAS

| Críticas | Altas | Médias |
|----------|-------|--------|
| 3 | 2 | 2 |

---

## 📝 TEMPLATE PARA NOVA LIÇÃO

```markdown
### LESSON-APP-XXX: [Título]
**Data:** YYYY-MM-DD

**O que aconteceu:** [Descrição]

**Erro:** [Mensagem de erro se houver]

**Causa:** [Por que aconteceu]

**Regra:** [Como evitar + comando de verificação]
```
