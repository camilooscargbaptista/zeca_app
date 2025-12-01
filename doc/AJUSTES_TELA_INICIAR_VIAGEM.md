# 🚀 Ajustes na Tela de Iniciar Viagem

## ✅ Alterações Implementadas

### **1. Campo de Placa Removido**
- ✅ Removido campo editável de placa do veículo
- ✅ A placa agora é carregada automaticamente do `StorageService` (salva no `journey_start_page`)

### **2. Odômetro Obrigatório**
- ✅ Campo de odômetro já estava com validação obrigatória
- ✅ Mantido como campo principal e destacado com `*` (asterisco)
- ✅ Validação: não pode ser vazio e deve ser maior que zero

### **3. Card Informativo Adicionado**
Um card com fundo azul claro mostrando:
- **🚗 Placa do Veículo** (não editável)
- **👤 Nome do Motorista** (se disponível)
- **🏢 Nome da Transportadora** (se disponível)

Este card funciona como uma **confirmação visual** dos dados antes de iniciar a viagem.

---

## 💡 Novos Campos Opcionais Implementados

### **4. Destino** (opcional)
- Campo de texto livre
- Exemplo: "São Paulo - SP"
- Útil para registrar onde o motorista está indo
- **Uso futuro:** pode ser usado para relatórios e análises de rotas

### **5. Previsão de KM** (opcional)
- Campo numérico
- Exemplo: "500 km"
- Motorista pode estimar quantos km espera rodar
- **Uso futuro:** comparar km previsto vs. km real

### **6. Observações** (opcional)
- Campo de texto com 3 linhas
- Espaço para notas gerais sobre a viagem
- Exemplos:
  - "Carga frágil"
  - "Rota alternativa pela BR-116"
  - "Cliente solicita entrega antes das 14h"

---

## 📋 Layout da Tela (Nova Estrutura)

```
┌────────────────────────────────────────┐
│  🚚 Iniciar Viagem         19/11/2024  │
├────────────────────────────────────────┤
│                                        │
│  ╔══════════════════════════════════╗  │
│  ║ Card Informativo (azul claro)   ║  │
│  ║                                  ║  │
│  ║ 🚗 Veículo: ABC-1234             ║  │
│  ║ 👤 Motorista: João Silva         ║  │
│  ║ 🏢 Transportadora: Transporte XY ║  │
│  ╚══════════════════════════════════╝  │
│                                        │
│  ┌────────────────────────────────┐   │
│  │ Odômetro Inicial (km) *        │   │
│  │ 0,000                          │   │
│  └────────────────────────────────┘   │
│                                        │
│  ┌────────────────────────────────┐   │
│  │ Destino (opcional)             │   │
│  │ Ex: São Paulo - SP             │   │
│  └────────────────────────────────┘   │
│                                        │
│  ┌────────────────────────────────┐   │
│  │ Previsão de KM (opcional)      │   │
│  │ Ex: 500            km          │   │
│  └────────────────────────────────┘   │
│                                        │
│  ┌────────────────────────────────┐   │
│  │ Observações (opcional)         │   │
│  │ Notas sobre a viagem...        │   │
│  │                                │   │
│  └────────────────────────────────┘   │
│                                        │
│  ╔══════════════════════════════════╗ │
│  ║  ▶  Iniciar Viagem              ║ │
│  ╚══════════════════════════════════╝ │
└────────────────────────────────────────┘
```

---

## 🔮 Próximos Passos (Backend)

Para que os novos campos sejam salvos no backend, será necessário:

1. **Adicionar colunas na tabela `journeys`:**
   ```sql
   ALTER TABLE journeys ADD COLUMN destino VARCHAR(255);
   ALTER TABLE journeys ADD COLUMN previsao_km INTEGER;
   ALTER TABLE journeys ADD COLUMN observacoes TEXT;
   ```

2. **Atualizar a API `POST /api/journeys/start`** para aceitar:
   ```typescript
   {
     placa: string;
     odometroInicial: number;
     destino?: string;        // NOVO
     previsaoKm?: number;     // NOVO
     observacoes?: string;    // NOVO
   }
   ```

3. **Atualizar o `StartJourney` event** no Flutter para incluir esses campos.

---

## 🎯 Benefícios das Alterações

### **UX/UI Melhoradas:**
- ✅ **Menos campos obrigatórios** = formulário mais rápido
- ✅ **Confirmação visual** dos dados (card informativo)
- ✅ **Campos opcionais úteis** sem atrapalhar o fluxo

### **Dados Mais Ricos:**
- 📍 Registro de destino para análise de rotas
- 📏 Comparação km previsto vs. real
- 📝 Observações úteis para o gestor de frota

### **Manutenibilidade:**
- 🔒 Dados carregados automaticamente (menos erro humano)
- 📦 Código mais limpo e organizado
- 🎨 UI moderna e consistente com o resto do app

---

## ❓ Discussão: Está OK ou Precisa de Mais?

### **Campos que PODERIAM ser adicionados (se necessário):**
1. **Hora Prevista de Chegada** 
   - TimePicker para selecionar
   - Útil para compromissos

2. **Tipo de Carga**
   - Dropdown: "Frágil", "Perecível", "Geral", etc.
   - Útil para compliance e segurança

3. **Número da Nota Fiscal**
   - Para vincular a viagem a um documento
   
4. **Cliente/Destinatário**
   - Nome da empresa que receberá a carga

5. **Upload de Foto da Carga**
   - Registro visual antes de sair

### **Campos que NÃO recomendo adicionar (por enquanto):**
- ❌ Peso da carga → melhor no checklist
- ❌ Rota planejada → muito complexo para um formulário simples
- ❌ Paradas planejadas → melhor em uma tela específica

---

## 📱 Como Testar

1. Faça login no app
2. Selecione um veículo na tela "Iniciar Jornada"
3. Na tela "Iniciar Viagem":
   - ✅ Veja a placa carregada automaticamente
   - ✅ Veja seu nome e transportadora
   - ✅ Digite o odômetro (OBRIGATÓRIO)
   - ✅ Preencha destino, previsão de km e observações (OPCIONAL)
   - ✅ Clique em "Iniciar Viagem"

**Observação:** Os campos opcionais ainda NÃO são enviados ao backend (linha 360 tem um TODO marcando isso).

---

## 🤔 Perguntas para o Usuário

1. **Os campos opcionais (destino, previsão km, observações) são úteis?**
   - Se sim → precisamos atualizar o backend
   - Se não → posso removê-los

2. **Quer adicionar mais algum campo específico?**
   - Por exemplo: tipo de carga, cliente, etc.

3. **O card informativo está bom ou prefere outro layout?**
   - Está claro e visível?

4. **Está OK ou precisa ajustar alguma coisa?**

