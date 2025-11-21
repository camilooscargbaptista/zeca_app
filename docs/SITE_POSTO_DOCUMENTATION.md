# 🏪 **SITE DO POSTO ZECA - Documentação Completa**

## 📋 **Visão Geral do Projeto**

O site do posto ZECA é uma aplicação web Angular para gerenciar abastecimentos, validar códigos QR e gerar relatórios. A **validação de códigos** é a funcionalidade principal e deve estar em destaque no dashboard.

---

## 🎯 **Funcionalidades Principais**

### **1. Validação de Códigos (PRINCIPAL)**
- **Scanner QR** (câmera integrada)
- **Digitação manual** (campo de texto)
- **Validação em tempo real** (backend)
- **Dados retornados**: motorista, transportadora, placa, status
- **Ação**: Botão "Lançar Abastecimento" (só aparece se válido)

### **2. Dashboard Principal**
- **Card Principal**: Validação de Código (destaque visual)
- **Cards Secundários**: Métricas
  - Abastecimentos pendentes (sem comprovante)
  - ✅ Abastecimentos finalizados
  - Valor total abastecido
  - ⛽ Quantidade de litros
  - Total de abastecimentos
- **Filtros**: diário, mensal, período customizado

### **3. Lançamento de Abastecimento**
- **Formulário**: valor, quantidade, descrição (opcional)
- **Upload de comprovante** (JPG, PDF, PNG)
- **Salvar rascunho** (lançamento posterior)
- **Validações**: campos obrigatórios, formatos de arquivo

### **4. Gestão de Funcionários**
- **Cadastro** (nome, CPF, cargo, permissões)
- **Edição** (dados, status ativo/inativo)
- **Permissões múltiplas** (lançar, visualizar, relatórios)
- **Histórico de ações** (auditoria)

### **5. Relatórios Detalhados**
- **Lista completa de abastecimentos**:
  - Placa do veículo
  - Horário
  - Código utilizado
  - Quantidade abastecida
  - Tipo de combustível
  - Valor por litro
  - Valor total
- **Agrupamento por transportadora**
- **Filtros**: período, transportadora, status
- **Exportação** (PDF, Excel)

### **6. Tela de Detalhes**
- **Lista de abastecimentos** (filtros, busca)
- **Ações por status**:
  - **Pendentes**: anexar comprovante
  - **Finalizados**: apenas visualização
- **Informações completas** (motorista, veículo, valores, etc.)

---

## 🚀 **Stack Técnica**

### **Frontend:**
- **Angular 18+** (última versão)
- **Angular Material** (UI components)
- **PrimeNG** (componentes avançados)
- **NgRx** (state management)
- **RxJS** (reactive programming)
- **Angular Flex Layout** (responsividade)
- **Chart.js** (gráficos)
- **Angular PWA** (Progressive Web App)

### **Backend Integration:**
- **Angular HttpClient** (API calls)
- **Interceptors** (auth, logging)
- **Guards** (roteamento protegido)
- **Resolvers** (data pre-loading)

---

## 🔐 **Sistema de Permissões**

### **Níveis de Acesso:**
- **Gerente**: acesso total (funcionários, relatórios, lançamentos)
- **Operador**: lançamentos e visualização básica
- **Financeiro**: relatórios e visualização completa

### **Permissões Múltiplas:**
- Um usuário pode ter múltiplos níveis
- Sistema de roles flexível
- Controle granular de acesso

---

## 📁 **Estrutura do Projeto**

```
zeca-posto-web/
├── src/
│   ├── app/
│   │   ├── core/
│   │   │   ├── auth/
│   │   │   │   ├── auth.service.ts
│   │   │   │   ├── auth.guard.ts
│   │   │   │   └── auth.interceptor.ts
│   │   │   ├── guards/
│   │   │   │   ├── role.guard.ts
│   │   │   │   └── feature.guard.ts
│   │   │   ├── interceptors/
│   │   │   │   ├── auth.interceptor.ts
│   │   │   │   └── error.interceptor.ts
│   │   │   └── services/
│   │   │       ├── api.service.ts
│   │   │       ├── validation.service.ts
│   │   │       ├── refueling.service.ts
│   │   │       └── reports.service.ts
│   │   ├── shared/
│   │   │   ├── components/
│   │   │   │   ├── qr-scanner/
│   │   │   │   ├── file-upload/
│   │   │   │   └── confirmation-dialog/
│   │   │   ├── directives/
│   │   │   └── pipes/
│   │   ├── features/
│   │   │   ├── dashboard/
│   │   │   │   ├── dashboard.component.ts
│   │   │   │   ├── validation-card/
│   │   │   │   └── metrics-cards/
│   │   │   ├── validation/
│   │   │   │   ├── validation.component.ts
│   │   │   │   ├── qr-scanner/
│   │   │   │   └── code-input/
│   │   │   ├── refueling/
│   │   │   │   ├── refueling-form/
│   │   │   │   └── refueling-list/
│   │   │   ├── reports/
│   │   │   │   ├── reports.component.ts
│   │   │   │   └── export-dialog/
│   │   │   └── employees/
│   │   │       ├── employee-list/
│   │   │       └── employee-form/
│   │   └── layout/
│   │       ├── header/
│   │       ├── sidebar/
│   │       └── footer/
│   ├── assets/
│   │   ├── images/
│   │   ├── icons/
│   │   └── styles/
│   └── environments/
│       ├── environment.ts
│       └── environment.prod.ts
├── package.json
├── angular.json
└── tsconfig.json
```

---

## 🔄 **Fluxo Principal**

1. **Login** → Validação de credenciais
2. **Dashboard** → Validação em destaque + métricas
3. **Validação** → Scanner QR ou digitação
4. **Lançamento** → Preenchimento e upload
5. **Detalhes** → Gestão de abastecimentos
6. **Relatórios** → Geração sob demanda

---

## 📱 **Responsividade**

- **Desktop** (prioridade)
- **Tablet** (funcional)
- **Mobile** (não priorizado)

---

## 🛠️ **Configuração Inicial**

### **1. Criar Projeto Angular:**
```bash
ng new zeca-posto-web --routing --style=scss
cd zeca-posto-web
```

### **2. Instalar Dependências:**
```bash
ng add @angular/material
ng add @ngrx/store
ng add @angular/pwa
npm install primeng chart.js lodash moment file-saver
```

### **3. Configurar Angular Material:**
```bash
ng generate @angular/material:nav navigation
ng generate @angular/material:dashboard dashboard
```

### **4. Configurar NgRx:**
```bash
ng generate @ngrx/store:feature auth
ng generate @ngrx/store:feature validation
ng generate @ngrx/store:feature refueling
```

---

## 🔌 **APIs Necessárias**

### **Validação:**
- `POST /api/validation/validate-code`
- `GET /api/validation/status/{code}`

### **Abastecimentos:**
- `POST /api/refueling/create`
- `GET /api/refueling/list`
- `PUT /api/refueling/{id}/upload-document`

### **Relatórios:**
- `GET /api/reports/dashboard`
- `GET /api/reports/refueling-list`
- `GET /api/reports/export`

### **Funcionários:**
- `GET /api/employees/list`
- `POST /api/employees/create`
- `PUT /api/employees/{id}`
- `DELETE /api/employees/{id}`

---

## 🎨 **UI/UX Prioridades**

### **Validação (Principal):**
- **Card destacado** (cor primária)
- **Botões grandes** (fácil acesso)
- **Feedback imediato** (status visual)
- **Fluxo simplificado** (menos cliques)

### **Dashboard:**
- **Layout responsivo** (desktop/tablet)
- **Atualização automática** (dados em tempo real)
- **Navegação intuitiva** (breadcrumbs)

---

## 📋 **Checklist de Implementação**

### **Fase 1 - Base:**
- [ ] Configurar projeto Angular
- [ ] Instalar dependências
- [ ] Configurar roteamento
- [ ] Implementar autenticação
- [ ] Criar layout base

### **Fase 2 - Validação:**
- [ ] Implementar QR Scanner
- [ ] Criar campo de digitação
- [ ] Integrar API de validação
- [ ] Implementar feedback visual

### **Fase 3 - Dashboard:**
- [ ] Criar cards de métricas
- [ ] Implementar filtros
- [ ] Adicionar atualização automática
- [ ] Destacar validação

### **Fase 4 - Lançamentos:**
- [ ] Criar formulário de abastecimento
- [ ] Implementar upload de arquivos
- [ ] Adicionar validações
- [ ] Salvar rascunhos

### **Fase 5 - Relatórios:**
- [ ] Implementar listagem
- [ ] Adicionar filtros avançados
- [ ] Criar exportação
- [ ] Agrupar por transportadora

### **Fase 6 - Funcionários:**
- [ ] CRUD de funcionários
- [ ] Sistema de permissões
- [ ] Auditoria de ações

---

## 🚀 **Comandos Úteis**

### **Desenvolvimento:**
```bash
ng serve
ng build
ng test
ng e2e
```

### **Geração de Componentes:**
```bash
ng generate component features/dashboard/validation-card
ng generate service core/services/validation
ng generate guard core/guards/role
```

### **Build e Deploy:**
```bash
ng build --prod
ng build --configuration=production
```

---

## 📝 **Notas Importantes**

1. **Validação é prioridade** - sempre em destaque
2. **Responsividade** - foco em desktop/tablet
3. **Permissões** - sistema flexível de roles
4. **APIs** - usar as mesmas do app mobile
5. **UX** - fluxo simples e intuitivo

---

## 🎯 **Próximos Passos**

1. **Configurar projeto Angular**
2. **Implementar autenticação**
3. **Criar dashboard com validação em destaque**
4. **Integrar APIs de validação**
5. **Desenvolver sistema de permissões**

---

**Documento criado para desenvolvimento em nova janela do Cursor**
**Data: ${new Date().toLocaleDateString('pt-BR')}**
**Versão: 1.0**
