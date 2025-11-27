# UH-XXX: [Título da User Story]

**Status:** 🟡 Pendente | 🔵 Em Andamento | ✅ Concluída | ❌ Cancelada

---

## 🔍 Análise do Existente

> **⚠️ OBRIGATÓRIO:** Preencher ANTES de planejar tasks e estimar
> 
> **Consultar:** `.cursor/docs/patterns/PIPELINE_DESENVOLVIMENTO.md` (FASE 1)

### ✅ O Que JÁ Existe:

#### Backend:
- Endpoints: [listar com paths]
- Entidades: [listar]
- Status: [X]% implementado

#### App Flutter:
- Telas: [listar com paths dos arquivos]
- Widgets: [listar com paths]
- Serviços: [listar]
- BLoCs: [listar]
- Status: [X]% implementado

### ❌ O Que Precisa Ser Implementado:
1. [Item 1 - tempo estimado]
2. [Item 2 - tempo estimado]
...

### 📊 Completude Geral:
**[X]%** da funcionalidade já existe

### 📸 Evidências (screenshots, código, etc.):
- [Adicionar aqui ou linkar documento separado]

### 📄 Documento de Análise Detalhada:
- Link: `.cursor/docs/user-stories/ANALISE_EXISTENTE_[NOME].md`

---

## 📝 Descrição

**Como** [tipo de usuário]  
**Eu quero** [ação/funcionalidade]  
**Para que** [benefício/valor]

---

## 💼 Valor de Negócio

[Por que esta feature é importante? Qual problema resolve?]

**Prioridade:** 🔴 Alta | 🟡 Média | 🟢 Baixa

---

## 🎯 Critérios de Aceite

- [ ] **CA-1:** Descrição do critério 1
- [ ] **CA-2:** Descrição do critério 2
- [ ] **CA-3:** Descrição do critério 3
- [ ] **CA-4:** Funciona em iOS e Android
- [ ] **CA-5:** Testes passando (unit + widget)
- [ ] **CA-6:** Code review aprovado

---

## 🔧 Requisitos Técnicos

### **Flutter/Dart:**

#### Packages necessários:
```yaml
dependencies:
  - package_name: ^version
```

#### Permissões necessárias:
- **iOS:** Lista de permissões no Info.plist
- **Android:** Lista de permissões no AndroidManifest.xml

#### Estrutura de código:
```
lib/features/nome_feature/
├── data/
├── domain/
└── presentation/
```

### **Backend (zeca_site):**

#### Endpoints necessários:
- `GET /api/v1/recurso` - Descrição
- `POST /api/v1/recurso` - Descrição

#### Alterações necessárias:
- [ ] Novo endpoint
- [ ] Migration de banco
- [ ] DTO atualizado

---

## 🎨 Requisitos de UI/UX

### **Telas:**
1. **Tela 1:** Nome e descrição
2. **Tela 2:** Nome e descrição

### **Wireframes/Mockups:**
[Incluir links ou imagens]

### **Design System:**
- Seguir padrões definidos em `.cursor/docs/patterns/ui-ux-mobile-standards.md`
- Cores, tipografia, espaçamentos

### **Responsividade:**
- [ ] Portrait (modo retrato)
- [ ] Landscape (modo paisagem) - se aplicável
- [ ] Tablets - se aplicável

### **Acessibilidade:**
- [ ] Contraste adequado
- [ ] Tamanhos de fonte legíveis
- [ ] Feedback tátil (vibração) quando apropriado

---

## 👤 User Flows

### **Fluxo Principal:**
1. Usuário abre tela X
2. Usuário clica em botão Y
3. Sistema faz Z
4. Usuário vê resultado W

### **Fluxos Alternativos:**

#### Fluxo Alternativo 1: [Cenário de erro]
1. Passo 1
2. Passo 2
3. Sistema mostra mensagem de erro

#### Fluxo Alternativo 2: [Cenário sem dados]
1. Passo 1
2. Sistema mostra tela vazia (empty state)

---

## 📊 Estrutura de Dados

### **Entities (Domain):**
```dart
class NomeEntity {
  final String id;
  final String nome;
  // ...
}
```

### **Models (Data):**
```dart
@JsonSerializable()
class NomeModel {
  @JsonKey(name: 'campo_backend')
  final String campoApp;
  // ...
}
```

### **States (BLoC):**
```dart
abstract class NomeState extends Equatable {}
class NomeInitial extends NomeState {}
class NomeLoading extends NomeState {}
class NomeLoaded extends NomeState {
  final List<NomeEntity> items;
}
class NomeError extends NomeState {
  final String message;
}
```

---

## 🔒 Requisitos Não-Funcionais

### **Performance:**
- Tempo de resposta máximo: X segundos
- Tamanho máximo de imagens: X MB
- Uso de memória: < X MB

### **Segurança:**
- Dados sensíveis armazenados em `flutter_secure_storage`
- Comunicação via HTTPS
- Validação de inputs

### **Escalabilidade:**
- Suportar X registros sem degradação
- Pagination em listas grandes

### **Offline-first (se aplicável):**
- Funciona sem internet
- Sincroniza quando online
- Cache local (Hive)

---

## ⚠️ Riscos e Mitigações

| Risco | Probabilidade | Impacto | Mitigação |
|-------|---------------|---------|-----------|
| Permissões negadas pelo usuário | Alta | Alto | Modal explicativo + fallback |
| API lenta/indisponível | Média | Alto | Cache local + retry com backoff |
| Bateria/memória insuficiente | Baixa | Médio | Otimizações + monitoramento |

---

## 🧪 Estratégia de Testes

### **Unit Tests:**
- [ ] Domain layer (use cases)
- [ ] Data layer (repositories, models)
- [ ] BLoC (events, states)

### **Widget Tests:**
- [ ] Widgets isolados
- [ ] Pages principais

### **Integration Tests:**
- [ ] Fluxo completo end-to-end
- [ ] Navegação entre telas

### **Manual Tests:**
- [ ] iOS (simulador + device)
- [ ] Android (emulador + device)
- [ ] Casos extremos (sem internet, bateria baixa, etc)

---

## 📱 Plataformas

- [ ] iOS 13.0+
- [ ] Android API 21+

---

## 📊 Métricas de Sucesso

**Como medir o sucesso desta feature:**

- **Adoção:** X% dos usuários usam a feature em Y dias
- **Performance:** Z% de sucesso nas operações
- **Satisfação:** Rating > W estrelas
- **Bugs:** < X bugs críticos reportados

---

## 📖 Documentação Relacionada

### **Especificações:**
- Link para `.cursor/docs/specifications/NOME_SPEC.md`

### **ADRs:**
- Link para `.cursor/docs/decisions/ADR-XXX.md` se houver decisão relevante

### **Backend:**
- Link para `../../../zeca_site/.cursor/docs/...` se houver doc do backend

---

## 📅 Timeline

| Fase | Estimativa | Status |
|------|------------|--------|
| Planning | X dias | 🟡 |
| Implementação: Data Layer | X dias | 🟡 |
| Implementação: Domain Layer | X dias | 🟡 |
| Implementação: Presentation Layer | X dias | 🟡 |
| Testes | X dias | 🟡 |
| Code Review | X dias | 🟡 |
| Deploy TestFlight/Internal | X dias | 🟡 |
| **TOTAL** | **X dias** | 🟡 |

---

## 📝 Notas Adicionais

[Qualquer informação adicional relevante]

---

## ✅ Checklist Final

### **Antes de Iniciar:**
- [ ] User story revisada e aprovada
- [ ] Backend endpoints prontos (ou planejados)
- [ ] Mockups aprovados
- [ ] Dependências identificadas

### **Durante Desenvolvimento:**
- [ ] Seguir Clean Architecture
- [ ] Seguir padrões de código
- [ ] Escrever testes
- [ ] Comentar código complexo

### **Antes de Finalizar:**
- [ ] Todos os critérios de aceite atendidos
- [ ] Testes passando (unit + widget + integration)
- [ ] Code review aprovado
- [ ] Documentação atualizada
- [ ] Testado em iOS e Android
- [ ] Sem linter warnings

---

**Criado em:** DD/MM/AAAA  
**Criado por:** [Nome]  
**Última atualização:** DD/MM/AAAA  
**Responsável:** [Nome]

