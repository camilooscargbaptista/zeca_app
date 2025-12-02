# 📝 Respostas para Google Play Store - ZECA App

## 🎯 Finalidade do App

**Já preenchido:**
```
Gestão de abastecimento de frotas
```

**Alternativas (se precisar ajustar):**
- Sistema de abastecimento corporativo para motoristas e frotas
- Gestão e rastreamento de abastecimentos de veículos
- Controle de abastecimentos corporativos com rastreabilidade

---

## 📍 Acesso ao Local (Location Access)

### **Descrição Recomendada:**

```
O app utiliza rastreamento de localização em segundo plano para registrar a jornada dos veículos durante viagens. Este recurso permite que empresas de transporte monitorem a rota percorrida pelos motoristas, garantindo segurança, rastreabilidade e controle operacional. A localização é registrada continuamente enquanto a jornada está ativa, permitindo o acompanhamento em tempo real da posição do veículo e a geração de relatórios detalhados de trajetos.
```

### **Versão Alternativa (Mais Curta):**

```
Rastreamento de jornadas de veículos em tempo real. O app registra a localização do veículo durante viagens para permitir que empresas monitorem rotas, garantam segurança e gerem relatórios de trajetos. A localização é coletada em segundo plano apenas quando uma jornada está ativa.
```

### **Versão Técnica (Se Necessário):**

```
O recurso de rastreamento de jornadas utiliza geolocalização em segundo plano para registrar coordenadas GPS do veículo durante viagens ativas. Isso permite monitoramento em tempo real, geração de relatórios de rota, verificação de conformidade com trajetos planejados e auditoria de deslocamentos. A coleta de localização ocorre apenas quando o motorista inicia uma jornada e é interrompida automaticamente ao finalizar.
```

---

## 📋 Resumo para Copiar e Colar

### **Campo: "Acesso ao local"**

```
O app utiliza rastreamento de localização em segundo plano para registrar a jornada dos veículos durante viagens. Este recurso permite que empresas de transporte monitorem a rota percorrida pelos motoristas, garantindo segurança, rastreabilidade e controle operacional. A localização é registrada continuamente enquanto a jornada está ativa, permitindo o acompanhamento em tempo real da posição do veículo e a geração de relatórios detalhados de trajetos.
```

**Caracteres:** ~330 (dentro do limite de 500)

---

## ✅ Checklist

- [x] Finalidade do app: "Gestão de abastecimento de frotas"
- [ ] Acesso ao local: Descrever recurso de rastreamento de jornadas
- [ ] Verificar se está dentro do limite de 500 caracteres
- [ ] Revisar antes de enviar

---

## 🔍 Informações Importantes

### **Por que precisamos de localização em segundo plano?**

1. **Rastreamento de Jornadas:** Registrar a rota completa do veículo durante viagens
2. **Segurança:** Monitorar posição em tempo real
3. **Rastreabilidade:** Auditoria e relatórios de trajetos
4. **Controle Operacional:** Gestão de frotas e otimização de rotas

### **Quando a localização é coletada?**

- Apenas quando uma jornada está ativa
- Durante o período de viagem
- Interrompida automaticamente ao finalizar a jornada

---

## 🔄 Permissão: ACTIVITY_RECOGNITION

### **Descrição do Uso:**

```
O app utiliza a permissão ACTIVITY_RECOGNITION para detectar quando o veículo está em movimento ou parado durante o rastreamento de jornadas. Esta permissão permite que o sistema otimize o consumo de bateria ao reduzir a frequência de coleta de localização quando o veículo está estacionado, e aumentar a precisão quando está em movimento. Isso garante um rastreamento eficiente e preciso das rotas, preservando a bateria do dispositivo do motorista.
```

### **Versão Alternativa (Mais Técnica):**

```
A permissão ACTIVITY_RECOGNITION é utilizada pelo serviço de rastreamento GPS em segundo plano para detectar o estado de movimento do veículo (parado, em movimento, caminhando, em veículo). Esta detecção permite que o app ajuste dinamicamente a frequência de coleta de coordenadas GPS: reduzindo quando o veículo está parado (economizando bateria) e aumentando quando está em movimento (garantindo precisão). O recurso é essencial para otimizar o consumo de recursos durante o rastreamento contínuo de jornadas de trabalho.
```

### **Versão Resumida:**

```
Detecção de movimento do veículo para otimizar o rastreamento GPS. O app ajusta a frequência de coleta de localização baseado no estado de movimento: reduz quando parado (economiza bateria) e aumenta quando em movimento (garante precisão).
```

---

## 📋 Resumo para Copiar e Colar - ACTIVITY_RECOGNITION

### **Campo: "Descreva o uso da permissão android.permission.ACTIVITY_RECOGNITION"**

```
O app utiliza a permissão ACTIVITY_RECOGNITION para detectar quando o veículo está em movimento ou parado durante o rastreamento de jornadas. Esta permissão permite que o sistema otimize o consumo de bateria ao reduzir a frequência de coleta de localização quando o veículo está estacionado, e aumentar a precisão quando está em movimento. Isso garante um rastreamento eficiente e preciso das rotas, preservando a bateria do dispositivo do motorista.
```

**Caracteres:** ~330 (dentro do limite típico de 500)

---

## ✅ Por que usamos ACTIVITY_RECOGNITION?

### **1. Otimização de Bateria**
- **Quando parado:** Reduz a frequência de GPS (economiza bateria)
- **Quando em movimento:** Aumenta a frequência (garante precisão)

### **2. Detecção Inteligente de Estado**
- Detecta se o veículo está:
  - 🚗 **Em movimento** (em veículo)
  - 🛑 **Parado** (estacionado)
  - 🚶 **Caminhando** (motorista fora do veículo)

### **3. Melhor Precisão do Rastreamento**
- Ajusta dinamicamente a precisão do GPS baseado no movimento
- Evita coletar dados desnecessários quando parado
- Garante dados precisos quando em movimento

### **4. Integração com flutter_background_geolocation**
- O plugin `flutter_background_geolocation` usa esta permissão para:
  - Detectar automaticamente quando parar o tracking
  - Otimizar o uso de sensores
  - Reduzir consumo de recursos

### **5. Benefícios para o Usuário**
- ✅ Bateria dura mais durante jornadas longas
- ✅ Rastreamento mais preciso quando necessário
- ✅ Menos uso de dados móveis
- ✅ Melhor experiência geral

---

## 🔍 Contexto Técnico

### **Onde é usado no código:**

```dart
// lib/core/services/background_geolocation_service.dart
disableMotionActivityUpdates: false, // Usar sensores de movimento
```

### **Configuração no AndroidManifest.xml:**

```xml
<uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION" />
```

### **Quando é solicitada:**
- Apenas quando o motorista inicia uma jornada
- Durante o período de rastreamento ativo
- Não é usada quando o app está inativo

---

**Última atualização:** 2025-01-27

