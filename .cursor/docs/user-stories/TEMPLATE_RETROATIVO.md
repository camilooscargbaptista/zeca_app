# UH-XXX: [Título da Feature] (RETROATIVO)

**Status:** ✅ Implementado  
**Data Implementação:** [Mês/Ano]

> ⚠️ **Nota:** Esta é uma user story retroativa, criada após a implementação para fins de documentação.

---

## 📝 Descrição

**Como** [tipo de usuário]  
**Eu quero** [ação/funcionalidade]  
**Para que** [benefício/valor]

---

## 💼 Valor de Negócio

[Por que esta feature foi implementada? Qual problema resolve?]

---

## ✅ O Que Foi Implementado

### **Funcionalidades:**
- [x] Funcionalidade 1
- [x] Funcionalidade 2
- [x] Funcionalidade 3

### **Plataformas:**
- [x] iOS
- [x] Android

---

## 🏗️ Arquitetura Implementada

### **Estrutura de Código:**

```
lib/features/nome_feature/
├── data/
│   ├── datasources/
│   │   └── [arquivos criados]
│   ├── models/
│   │   └── [arquivos criados]
│   └── repositories/
│       └── [arquivos criados]
├── domain/
│   ├── entities/
│   │   └── [arquivos criados]
│   ├── repositories/
│   │   └── [arquivos criados]
│   └── usecases/
│       └── [arquivos criados]
└── presentation/
    ├── bloc/
    │   └── [arquivos criados]
    ├── pages/
    │   └── [arquivos criados]
    └── widgets/
        └── [arquivos criados]
```

### **Packages Utilizados:**

```yaml
dependencies:
  - package_1: ^version
  - package_2: ^version
```

---

## 🔧 Decisões Técnicas

### **Principais Decisões:**

1. **Decisão 1:** [Descrição]
   - **Por quê:** [Justificativa]
   - **ADR:** Link para `.cursor/docs/decisions/ADR-XXX.md` (se existir)

2. **Decisão 2:** [Descrição]
   - **Por quê:** [Justificativa]

### **Trade-offs:**

| Decisão | Vantagem | Desvantagem | Mitigação |
|---------|----------|-------------|-----------|
| [Nome] | [Pros] | [Cons] | [Como mitigamos] |

---

## 📱 Telas Implementadas

### **Principais Telas:**

1. **[Nome da Tela]**
   - Path: `lib/features/.../pages/nome_page.dart`
   - Função: [O que faz]

2. **[Nome da Tela 2]**
   - Path: `lib/features/.../pages/nome2_page.dart`
   - Função: [O que faz]

---

## 🔄 Fluxos de Usuário

### **Fluxo Principal:**
1. Usuário faz X
2. Sistema processa Y
3. Usuário vê resultado Z

### **Fluxos Alternativos:**
- **Erro:** [Como é tratado]
- **Offline:** [Como funciona]
- **Sem dados:** [Empty state]

---

## 🌐 Integração com Backend

### **Endpoints Utilizados:**

| Endpoint | Método | Descrição | Implementado em |
|----------|--------|-----------|-----------------|
| `/api/v1/recurso` | GET | Descrição | `nome_datasource.dart` |
| `/api/v1/recurso` | POST | Descrição | `nome_datasource.dart` |

### **Modelos de Dados:**

```dart
// Model principal
class NomeModel {
  final String id;
  final String campo;
  // ...
}
```

---

## 🧪 Testes Implementados

### **Cobertura:**
- [x] Unit tests (domain)
- [x] Unit tests (data)
- [x] BLoC tests
- [x] Widget tests
- [ ] Integration tests (se aplicável)

### **Localização dos Testes:**
- `test/features/nome_feature/`

---

## 📊 Métricas Atuais

**Como está performando:**

- **Adoção:** [% de usuários usando]
- **Performance:** [Tempo médio de resposta]
- **Erros:** [Taxa de erro]
- **Satisfação:** [Feedback dos usuários]

---

## 🐛 Problemas Conhecidos

### **Bugs/Limitações:**
- [ ] [Descrição do problema 1]
- [ ] [Descrição do problema 2]

### **Melhorias Futuras:**
- [ ] [Melhoria planejada 1]
- [ ] [Melhoria planejada 2]

---

## 📖 Documentação Relacionada

### **Especificações:**
- Link: `.cursor/docs/specifications/NOME_SPEC.md`

### **ADRs:**
- Link: `.cursor/docs/decisions/ADR-XXX.md`

### **Backend:**
- Link: `../../../zeca_site/.cursor/docs/...`

---

## 📚 Lições Aprendidas

### **O Que Funcionou Bem:**
- [Lição 1]
- [Lição 2]

### **O Que Poderia Ser Melhor:**
- [Lição 1]
- [Lição 2]

### **Recomendações para Features Similares:**
- [Recomendação 1]
- [Recomendação 2]

---

## 🔗 Links Úteis

- **Código principal:** `lib/features/nome_feature/`
- **Testes:** `test/features/nome_feature/`
- **Especificação original:** Link (se existir)
- **PRs relacionados:** Links do Git (se aplicável)

---

**Documentado em:** [Data atual]  
**Documentado por:** [Nome]  
**Última atualização:** [Data]

