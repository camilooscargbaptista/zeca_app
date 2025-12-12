# 📋 Justificativas de Permissões - ZECA App

> **Documento para submissão nas stores (Play Store e App Store)**

---

## 📍 Permissões de Localização

### ACCESS_FINE_LOCATION / ACCESS_COARSE_LOCATION
**Justificativa:** O ZECA App é um aplicativo de gestão de jornadas para motoristas de frota. A localização é necessária para:
- Registrar o ponto de origem e destino das jornadas de trabalho
- Encontrar postos de combustível próximos para abastecimento
- Validar que o abastecimento está ocorrendo em um posto parceiro credenciado

### ACCESS_BACKGROUND_LOCATION (se aplicável)
**Justificativa:** Motoristas profissionais precisam de rastreamento contínuo durante suas jornadas de trabalho que podem durar 8-12 horas. O tracking em background permite:
- Registrar automaticamente a rota percorrida para relatórios de quilometragem
- Garantir compliance com a Lei 13.103/2015 (Lei do Caminhoneiro)
- Monitorar tempo de direção contínua para segurança

---

## 📸 Permissões de Câmera e Galeria

### CAMERA
**Justificativa:** Usado para capturar comprovantes de abastecimento e fotos do odômetro do veículo para registro de quilometragem.

### READ_EXTERNAL_STORAGE / WRITE_EXTERNAL_STORAGE / READ_MEDIA_IMAGES
**Justificativa:** Necessário para salvar e acessar fotos capturadas de comprovantes e registros do veículo.

---

## 🔔 Permissões de Notificação

### POST_NOTIFICATIONS
**Justificativa:** Envia alertas importantes ao motorista:
- Notificações de abastecimento aguardando validação
- Alertas de ciclos de faturamento
- Comunicados importantes da frota

### VIBRATE
**Justificativa:** Feedback tátil para notificações importantes quando o motorista está dirigindo.

---

## 📶 Permissões de Rede

### INTERNET / ACCESS_NETWORK_STATE
**Justificativa:** Comunicação com o servidor para:
- Sincronizar dados de jornadas e abastecimentos
- Gerar códigos de abastecimento
- Autenticação do usuário

---

## 🔋 Permissões de Sistema

### FOREGROUND_SERVICE / FOREGROUND_SERVICE_LOCATION
**Justificativa:** Manter o serviço de rastreamento ativo durante as jornadas de trabalho.

### RECEIVE_BOOT_COMPLETED
**Justificativa:** Restaurar serviços essenciais após reinicialização do dispositivo.

### WAKE_LOCK
**Justificativa:** Manter o dispositivo ativo para registros precisos de GPS durante jornadas.

### REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
**Justificativa:** Garantir que o rastreamento não seja interrompido pelo sistema de economia de bateria durante jornadas de trabalho oficiais.

---

## 📊 Resumo do Uso de Dados

| Dado | Uso | Compartilhamento |
|------|-----|------------------|
| Localização | Registro de jornadas e validação de abastecimentos | Apenas com gestores da frota |
| Fotos | Comprovantes e odômetro | Armazenado no servidor da empresa |
| Dados de uso | Analytics para melhorias | Anonimizado |

---

**Política de Privacidade:** [URL da política de privacidade]
**Termos de Uso:** [URL dos termos de uso]
