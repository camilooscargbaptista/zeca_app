# Implementação Backend - Polling e Validação de Abastecimento

## 📋 Visão Geral

Este documento detalha todas as implementações necessárias no backend para suportar o fluxo de polling e validação de abastecimento pelo motorista no app mobile.

## 🔄 Fluxo Completo

1. **Motorista gera código** → Status: `PENDENTE`
2. **Posto valida código** → Código validado, ainda sem refueling criado
3. **Posto registra dados do abastecimento** → Cria refueling com status: `AGUARDANDO_VALIDACAO_MOTORISTA`
4. **App faz polling** → Verifica status periodicamente (a cada 15s)
5. **App detecta mudança de status** → Status mudou para `AGUARDANDO_VALIDACAO_MOTORISTA`
6. **App carrega dados** → Busca dados completos do abastecimento
7. **Motorista valida** → Confirma ou contesta os dados
8. **Status final** → `VALIDADO` ou `CONTESTADO`

---

## 1. ✅ Adicionar Enum `AGUARDANDO_VALIDACAO_MOTORISTA`

### Arquivo: `backend/src/entities/Refueling.entity.ts`

**Ação:** Adicionar novo status ao enum `RefuelingStatus`

**Código atual:**
```typescript
export enum RefuelingStatus {
  PENDENTE = 'PENDENTE',
  VALIDADO = 'VALIDADO',
  CONTESTADO = 'CONTESTADO',
  CANCELADO = 'CANCELADO'
}
```

**Código após alteração:**
```typescript
export enum RefuelingStatus {
  PENDENTE = 'PENDENTE',
  AGUARDANDO_VALIDACAO_MOTORISTA = 'AGUARDANDO_VALIDACAO_MOTORISTA', // NOVO
  VALIDADO = 'VALIDADO',
  CONTESTADO = 'CONTESTADO',
  CANCELADO = 'CANCELADO'
}
```

**Importante:** 
- Verificar se há migrations que precisam ser atualizadas
- Verificar se há constraints no banco de dados que precisam ser ajustadas

---

## 2. ✅ Modificar `registerSimpleRefueling` - Status Inicial

### Arquivo: `backend/src/refueling/refueling.service.ts`

**Método:** `registerSimpleRefueling`

**Ação:** Alterar o status inicial de `PENDENTE` para `AGUARDANDO_VALIDACAO_MOTORISTA` quando o posto registra os dados do abastecimento.

**Código atual (aproximadamente linha 412):**
```typescript
const refueling = this.refuelingRepository.create({
  // ... outros campos ...
  status: RefuelingStatus.PENDENTE,
  // ...
});
```

**Código após alteração:**
```typescript
const refueling = this.refuelingRepository.create({
  // ... outros campos ...
  status: RefuelingStatus.AGUARDANDO_VALIDACAO_MOTORISTA, // Alterado
  // ...
});
```

**Justificativa:** Quando o posto registra os dados do abastecimento, o status deve ser `AGUARDANDO_VALIDACAO_MOTORISTA` para que o app detecte que há dados pendentes de validação.

---

## 3. 🆕 Endpoint: Buscar Refueling por Código

### Endpoint: `GET /api/v1/refueling/by-code/:code`

**Descrição:** Busca um abastecimento pelo código (ex: `A1B2-2024-3F7A8B9C`). Necessário porque o app inicia o polling apenas com o código, sem ter o `refueling_id`.

**Parâmetros:**
- `code` (path parameter): Código do abastecimento (ex: `A1B2-2024-3F7A8B9C`)

**Autenticação:** Sim (JWT)

**Resposta de Sucesso (200):**
```json
{
  "id": "uuid-do-refueling",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "refueling_code_id": "uuid-do-codigo",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
  "quantity_liters": 100.5,
  "odometer_reading": 50000,
  "pump_number": "3",
  "unit_price": 4.50,
  "total_amount": 452.25,
  "attendant_name": "João Silva",
  "notes": "Observações do posto",
  "vehicle_plate": "ABC-1234",
  "driver_cpf": "555.666.777-88",
  "driver_name": "Pedro Oliveira",
  "transporter_cnpj": "98.765.432/0001-10",
  "transporter_name": "Transportadora ABC Ltda",
  "fuel_type": "Diesel S10",
  "refueling_datetime": "2025-11-12T14:00:00Z",
  "created_at": "2025-11-12T14:00:00Z",
  "updated_at": "2025-11-12T14:30:00Z"
}
```

**Resposta de Erro (404):**
```json
{
  "statusCode": 404,
  "message": "Abastecimento não encontrado para o código informado",
  "error": "Not Found"
}
```

**Resposta de Erro (400):**
```json
{
  "statusCode": 400,
  "message": "Código inválido",
  "error": "Bad Request"
}
```

**Implementação sugerida:**

**Controller (`refueling.controller.ts`):**
```typescript
@Get('by-code/:code')
@HttpCode(HttpStatus.OK)
async getRefuelingByCode(
  @Param('code') code: string,
  @Request() req: any
): Promise<Refueling> {
  this.logger.log(`Buscando abastecimento pelo código ${code}`);
  
  try {
    const refueling = await this.refuelingService.findByCode(code);
    
    if (!refueling) {
      throw new NotFoundException('Abastecimento não encontrado para o código informado');
    }
    
    return refueling;
  } catch (error) {
    this.logger.error(`Erro ao buscar abastecimento: ${error.message}`, error.stack);
    throw error;
  }
}
```

**Service (`refueling.service.ts`):**
```typescript
async findByCode(code: string): Promise<Refueling | null> {
  try {
    const refueling = await this.refuelingRepository.findOne({
      where: { refueling_code: code },
      relations: ['refueling_code'], // Se houver relação
    });
    
    return refueling || null;
  } catch (error) {
    throw error;
  }
}
```

**Validação:**
- Verificar se o código existe
- Verificar se o código está no formato correto (ex: `A1B2-2024-3F7A8B9C`)
- Retornar 404 se não encontrar

---

## 4. ✅ Endpoint: Obter Status do Refueling

### Endpoint: `GET /api/v1/refueling/:id`

**Descrição:** Retorna os dados completos do abastecimento, incluindo o status atual. Este endpoint já existe, mas precisa garantir que retorna todos os campos necessários.

**Parâmetros:**
- `id` (path parameter): UUID do abastecimento

**Autenticação:** Sim (JWT)

**Resposta de Sucesso (200):**
```json
{
  "id": "uuid-do-refueling",
  "refueling_code_id": "uuid-do-codigo",
  "station_id": "uuid-do-posto",
  "driver_id": "uuid-do-motorista",
  "vehicle_id": "uuid-do-veiculo",
  "fuel_type_id": "uuid-do-tipo-combustivel",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "vehicle_plate": "ABC-1234",
  "driver_cpf": "555.666.777-88",
  "driver_name": "Pedro Oliveira",
  "transporter_cnpj": "98.765.432/0001-10",
  "transporter_name": "Transportadora ABC Ltda",
  "refueling_datetime": "2025-11-12T14:00:00Z",
  "quantity_liters": 100.5,
  "unit_price": 4.50,
  "total_amount": 452.25,
  "pump_number": "3",
  "odometer_reading": 50000,
  "attendant_name": "João Silva",
  "notes": "Observações do posto",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
  "completed_at": null,
  "created_at": "2025-11-12T14:00:00Z",
  "updated_at": "2025-11-12T14:30:00Z",
  "created_by": "uuid-do-usuario",
  "updated_by": null
}
```

**Campos importantes para o app:**
- `id` - UUID do abastecimento (necessário para outras operações)
- `refueling_code` - Código do abastecimento
- `status` - Status atual (deve incluir `AGUARDANDO_VALIDACAO_MOTORISTA`)
- `quantity_liters` - Quantidade de litros
- `odometer_reading` - Quilometragem
- `pump_number` - Número da bomba
- `unit_price` - Preço por litro
- `total_amount` - Valor total
- `attendant_name` - Nome do atendente
- `notes` - Observações

**Verificações necessárias:**
- ✅ Endpoint já existe?
- ✅ Retorna todos os campos necessários?
- ✅ Retorna o status corretamente?
- ✅ Trata erro 404 quando não encontra?

---

## 5. 🆕 Endpoint: Obter Dados Pendentes de Validação

### Endpoint: `GET /api/v1/refueling/:id/pending-validation`

**Descrição:** Retorna os dados do abastecimento quando o status é `AGUARDANDO_VALIDACAO_MOTORISTA`. Se o status não for este, retorna 404 ou null.

**Parâmetros:**
- `id` (path parameter): UUID do abastecimento

**Autenticação:** Sim (JWT)

**Resposta de Sucesso (200):**
```json
{
  "id": "uuid-do-refueling",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
  "quantity_liters": 100.5,
  "odometer_reading": 50000,
  "pump_number": "3",
  "unit_price": 4.50,
  "total_amount": 452.25,
  "attendant_name": "João Silva",
  "notes": "Observações do posto",
  "vehicle_plate": "ABC-1234",
  "driver_name": "Pedro Oliveira",
  "driver_cpf": "555.666.777-88",
  "transporter_name": "Transportadora ABC Ltda",
  "transporter_cnpj": "98.765.432/0001-10",
  "fuel_type": "Diesel S10",
  "refueling_datetime": "2025-11-12T14:00:00Z",
  "created_at": "2025-11-12T14:00:00Z",
  "updated_at": "2025-11-12T14:30:00Z"
}
```

**Resposta quando status não é `AGUARDANDO_VALIDACAO_MOTORISTA` (404):**
```json
{
  "statusCode": 404,
  "message": "Não há dados pendentes de validação para este abastecimento",
  "error": "Not Found"
}
```

**Resposta quando refueling não existe (404):**
```json
{
  "statusCode": 404,
  "message": "Abastecimento não encontrado",
  "error": "Not Found"
}
```

**Implementação sugerida:**

**Controller (`refueling.controller.ts`):**
```typescript
@Get(':id/pending-validation')
@HttpCode(HttpStatus.OK)
async getPendingValidation(
  @Param('id') id: string,
  @Request() req: any
): Promise<Refueling> {
  this.logger.log(`Buscando dados pendentes de validação para abastecimento ${id}`);
  
  try {
    const refueling = await this.refuelingService.getPendingValidation(id);
    
    if (!refueling) {
      throw new NotFoundException('Não há dados pendentes de validação para este abastecimento');
    }
    
    return refueling;
  } catch (error) {
    this.logger.error(`Erro ao buscar dados pendentes: ${error.message}`, error.stack);
    throw error;
  }
}
```

**Service (`refueling.service.ts`):**
```typescript
async getPendingValidation(refuelingId: string): Promise<Refueling | null> {
  try {
    const refueling = await this.refuelingRepository.findOne({
      where: { 
        id: refuelingId,
        status: RefuelingStatus.AGUARDANDO_VALIDACAO_MOTORISTA
      },
    });
    
    return refueling || null;
  } catch (error) {
    throw error;
  }
}
```

**Validação:**
- Verificar se o refueling existe
- Verificar se o status é `AGUARDANDO_VALIDACAO_MOTORISTA`
- Retornar 404 se não atender aos critérios

---

## 6. 🆕 Endpoint: Validação do Motorista (Confirmar ou Contestar)

### Endpoint: `POST /api/v1/refueling/:id/driver-validation`

**Descrição:** Permite ao motorista confirmar ou contestar os dados do abastecimento registrados pelo posto.

**Parâmetros:**
- `id` (path parameter): UUID do abastecimento

**Autenticação:** Sim (JWT)

**Body:**
```json
{
  "action": "confirmar" | "contestar",
  "corrected_data": {
    "quantity_liters": 100.5,      // Opcional, apenas se contestar
    "odometer_reading": 50000,     // Opcional, apenas se contestar
    "notes": "Observações do motorista"  // Opcional
  }
}
```

**DTO sugerido (`DriverValidationDto.ts`):**
```typescript
import { IsString, IsNotEmpty, IsEnum, IsOptional, IsNumber, Min } from 'class-validator';

export enum DriverValidationAction {
  CONFIRMAR = 'confirmar',
  CONTESTAR = 'contestar'
}

export class CorrectedDataDto {
  @IsNumber()
  @IsOptional()
  @Min(0.001)
  quantity_liters?: number;

  @IsNumber()
  @IsOptional()
  @Min(0)
  odometer_reading?: number;

  @IsString()
  @IsOptional()
  notes?: string;
}

export class DriverValidationDto {
  @IsEnum(DriverValidationAction)
  @IsNotEmpty()
  action: DriverValidationAction;

  @IsOptional()
  corrected_data?: CorrectedDataDto;
}
```

**Resposta de Sucesso (200):**
```json
{
  "success": true,
  "message": "Validação confirmada com sucesso" | "Contestação registrada com sucesso",
  "refueling_id": "uuid-do-refueling",
  "status": "VALIDADO" | "CONTESTADO",
  "data": {
    "id": "uuid-do-refueling",
    "status": "VALIDADO" | "CONTESTADO",
    "updated_at": "2025-11-12T15:00:00Z"
  }
}
```

**Resposta de Erro (400):**
```json
{
  "statusCode": 400,
  "message": "Ação inválida. Use 'confirmar' ou 'contestar'",
  "error": "Bad Request"
}
```

**Resposta de Erro (404):**
```json
{
  "statusCode": 404,
  "message": "Abastecimento não encontrado ou não está aguardando validação",
  "error": "Not Found"
}
```

**Resposta de Erro (409):**
```json
{
  "statusCode": 409,
  "message": "Abastecimento já foi validado ou contestado",
  "error": "Conflict"
}
```

**Implementação sugerida:**

**Controller (`refueling.controller.ts`):**
```typescript
@Post(':id/driver-validation')
@HttpCode(HttpStatus.OK)
async driverValidation(
  @Param('id') id: string,
  @Body() validationDto: DriverValidationDto,
  @Request() req: any
): Promise<any> {
  this.logger.log(`Processando validação do motorista para abastecimento ${id}: ${validationDto.action}`);
  
  try {
    const result = await this.refuelingService.processDriverValidation(
      id,
      validationDto,
      req.user
    );
    
    return {
      success: true,
      message: validationDto.action === 'confirmar' 
        ? 'Validação confirmada com sucesso' 
        : 'Contestação registrada com sucesso',
      refueling_id: id,
      status: result.status,
      data: result
    };
  } catch (error) {
    this.logger.error(`Erro ao processar validação: ${error.message}`, error.stack);
    throw error;
  }
}
```

**Service (`refueling.service.ts`):**
```typescript
async processDriverValidation(
  refuelingId: string,
  validationDto: DriverValidationDto,
  user: any
): Promise<Refueling> {
  try {
    // 1. Buscar refueling
    const refueling = await this.refuelingRepository.findOne({
      where: { id: refuelingId }
    });
    
    if (!refueling) {
      throw new NotFoundException('Abastecimento não encontrado');
    }
    
    // 2. Verificar se está aguardando validação
    if (refueling.status !== RefuelingStatus.AGUARDANDO_VALIDACAO_MOTORISTA) {
      throw new ConflictException('Abastecimento não está aguardando validação');
    }
    
    // 3. Processar ação
    if (validationDto.action === 'confirmar') {
      // Confirmar: apenas mudar status
      refueling.status = RefuelingStatus.VALIDADO;
      refueling.completed_at = new Date();
      refueling.updated_by = user.userId || user.id;
      
    } else if (validationDto.action === 'contestar') {
      // Contestar: mudar status e salvar dados corrigidos
      refueling.status = RefuelingStatus.CONTESTADO;
      refueling.completed_at = new Date();
      refueling.updated_by = user.userId || user.id;
      
      // Se houver dados corrigidos, atualizar (ou criar registro separado)
      if (validationDto.corrected_data) {
        // Opção 1: Atualizar campos diretamente
        if (validationDto.corrected_data.quantity_liters !== undefined) {
          refueling.quantity_liters = validationDto.corrected_data.quantity_liters;
        }
        if (validationDto.corrected_data.odometer_reading !== undefined) {
          refueling.odometer_reading = validationDto.corrected_data.odometer_reading;
        }
        if (validationDto.corrected_data.notes !== undefined) {
          refueling.notes = validationDto.corrected_data.notes;
        }
        
        // Opção 2: Criar tabela separada para dados contestados
        // (depende da arquitetura escolhida)
      }
    } else {
      throw new BadRequestException("Ação inválida. Use 'confirmar' ou 'contestar'");
    }
    
    // 4. Salvar alterações
    const updatedRefueling = await this.refuelingRepository.save(refueling);
    
    // 5. (Opcional) Enviar notificação push para o posto
    // await this.notificationService.sendNotification(...);
    
    return updatedRefueling;
  } catch (error) {
    throw error;
  }
}
```

**Validações:**
- ✅ Verificar se o refueling existe
- ✅ Verificar se o status é `AGUARDANDO_VALIDACAO_MOTORISTA`
- ✅ Verificar se a ação é válida (`confirmar` ou `contestar`)
- ✅ Se contestar, validar que `corrected_data` foi fornecido
- ✅ Se contestar, validar campos obrigatórios (`quantity_liters`, `odometer_reading`)
- ✅ Retornar erro 409 se já foi validado/contestado

**Considerações:**
- **Dados contestados:** Decidir se os dados corrigidos devem sobrescrever os dados originais ou ser armazenados separadamente (ex: tabela `refueling_disputes`)
- **Auditoria:** Considerar criar log/auditoria das validações
- **Notificações:** Enviar push notification para o posto quando houver contestação

---

## 7. 📊 Estrutura de Dados Esperada

### Refueling Entity - Campos Importantes

```typescript
{
  id: string;                    // UUID
  refueling_code_id: string;     // UUID do código gerado
  station_id: string;            // UUID do posto
  driver_id: string;             // UUID do motorista
  vehicle_id: string;            // UUID do veículo
  fuel_type_id: string;          // UUID do tipo de combustível
  refueling_code: string;        // Código (ex: "A1B2-2024-3F7A8B9C")
  vehicle_plate: string;         // Placa do veículo
  driver_cpf: string;            // CPF do motorista
  driver_name: string;           // Nome do motorista
  transporter_cnpj: string;      // CNPJ da transportadora
  transporter_name: string;      // Nome da transportadora
  refueling_datetime: Date;      // Data/hora do abastecimento
  quantity_liters: number;       // Quantidade de litros
  unit_price: number;            // Preço por litro
  total_amount: number;          // Valor total
  pump_number: string;          // Número da bomba (opcional)
  odometer_reading: number;      // Quilometragem (opcional)
  attendant_name: string;        // Nome do atendente
  notes: string;                 // Observações (opcional)
  status: RefuelingStatus;      // Status atual
  completed_at: Date;           // Data de conclusão (opcional)
  created_at: Date;             // Data de criação
  updated_at: Date;             // Data de atualização
  created_by: string;           // UUID do usuário que criou
  updated_by: string;           // UUID do usuário que atualizou
}
```

---

## 8. 🔍 Endpoints Existentes que Precisam ser Verificados

### 8.1. `GET /api/v1/refueling/:id`

**Status:** Provavelmente já existe

**Verificações:**
- ✅ Retorna todos os campos necessários?
- ✅ Retorna o status corretamente?
- ✅ Retorna relacionamentos (se necessário)?
- ✅ Trata erro 404 corretamente?

### 8.2. `POST /api/v1/refueling/register-simple`

**Status:** Já existe (baseado no código encontrado)

**Verificações:**
- ✅ Define status inicial como `AGUARDANDO_VALIDACAO_MOTORISTA`?
- ✅ Retorna o `refueling_id` na resposta?
- ✅ Valida todos os campos obrigatórios?
- ✅ Calcula valores corretamente?

**Resposta esperada após registro:**
```json
{
  "id": "uuid-do-refueling",
  "refueling_code": "A1B2-2024-3F7A8B9C",
  "status": "AGUARDANDO_VALIDACAO_MOTORISTA",
  "created_at": "2025-11-12T14:30:00Z",
  ...
}
```

---

## 9. 🧪 Casos de Teste Sugeridos

### 9.1. Buscar Refueling por Código

**Cenário 1: Código existe**
- **Input:** `GET /api/v1/refueling/by-code/A1B2-2024-3F7A8B9C`
- **Esperado:** Retorna dados do refueling (200)

**Cenário 2: Código não existe**
- **Input:** `GET /api/v1/refueling/by-code/INVALID-CODE`
- **Esperado:** Retorna 404

**Cenário 3: Código inválido (formato)**
- **Input:** `GET /api/v1/refueling/by-code/123`
- **Esperado:** Retorna 400

### 9.2. Obter Dados Pendentes

**Cenário 1: Status é `AGUARDANDO_VALIDACAO_MOTORISTA`**
- **Input:** `GET /api/v1/refueling/{id}/pending-validation`
- **Esperado:** Retorna dados (200)

**Cenário 2: Status não é `AGUARDANDO_VALIDACAO_MOTORISTA`**
- **Input:** `GET /api/v1/refueling/{id}/pending-validation` (status = `VALIDADO`)
- **Esperado:** Retorna 404

**Cenário 3: Refueling não existe**
- **Input:** `GET /api/v1/refueling/invalid-id/pending-validation`
- **Esperado:** Retorna 404

### 9.3. Validação do Motorista

**Cenário 1: Confirmar com sucesso**
- **Input:** `POST /api/v1/refueling/{id}/driver-validation` com `{"action": "confirmar"}`
- **Esperado:** Status muda para `VALIDADO` (200)

**Cenário 2: Contestar com sucesso**
- **Input:** `POST /api/v1/refueling/{id}/driver-validation` com `{"action": "contestar", "corrected_data": {...}}`
- **Esperado:** Status muda para `CONTESTADO` (200)

**Cenário 3: Ação inválida**
- **Input:** `POST /api/v1/refueling/{id}/driver-validation` com `{"action": "invalido"}`
- **Esperado:** Retorna 400

**Cenário 4: Refueling já validado**
- **Input:** `POST /api/v1/refueling/{id}/driver-validation` (status já é `VALIDADO`)
- **Esperado:** Retorna 409

**Cenário 5: Contestar sem dados corrigidos**
- **Input:** `POST /api/v1/refueling/{id}/driver-validation` com `{"action": "contestar"}`
- **Esperado:** Retorna 400 (dados corrigidos obrigatórios)

---

## 10. 📝 Checklist de Implementação

### Fase 1: Preparação
- [ ] Adicionar enum `AGUARDANDO_VALIDACAO_MOTORISTA` ao `RefuelingStatus`
- [ ] Criar/atualizar migration se necessário
- [ ] Verificar constraints no banco de dados

### Fase 2: Modificações em Endpoints Existentes
- [ ] Modificar `registerSimpleRefueling` para definir status inicial como `AGUARDANDO_VALIDACAO_MOTORISTA`
- [ ] Verificar `GET /api/v1/refueling/:id` retorna todos os campos necessários
- [ ] Testar endpoints existentes

### Fase 3: Novos Endpoints
- [ ] Implementar `GET /api/v1/refueling/by-code/:code`
- [ ] Implementar `GET /api/v1/refueling/:id/pending-validation`
- [ ] Implementar `POST /api/v1/refueling/:id/driver-validation`
- [ ] Criar DTOs necessários (`DriverValidationDto`, `CorrectedDataDto`)

### Fase 4: Validações e Tratamento de Erros
- [ ] Validar parâmetros de entrada
- [ ] Tratar erros 404, 400, 409
- [ ] Adicionar logs adequados
- [ ] Validar permissões (motorista só pode validar seus próprios abastecimentos?)

### Fase 5: Testes
- [ ] Testar todos os cenários listados acima
- [ ] Testar integração com o app mobile
- [ ] Verificar performance do polling (muitas requisições)

### Fase 6: Documentação
- [ ] Atualizar documentação da API (Swagger/OpenAPI)
- [ ] Documentar mudanças no fluxo
- [ ] Atualizar coleção do Postman (se houver)

---

## 11. 🔐 Considerações de Segurança

### Autenticação e Autorização

1. **Todos os endpoints devem exigir autenticação JWT**
2. **Validação de propriedade:**
   - Motorista só pode validar abastecimentos onde `driver_cpf` corresponde ao CPF do usuário logado
   - Verificar se o `driver_id` ou `driver_cpf` do refueling corresponde ao usuário autenticado

**Exemplo de validação:**
```typescript
// No service, antes de processar validação
const refueling = await this.refuelingRepository.findOne({
  where: { id: refuelingId }
});

// Verificar se o motorista logado é o dono do abastecimento
if (refueling.driver_cpf !== user.cpf) {
  throw new ForbiddenException('Você não tem permissão para validar este abastecimento');
}
```

### Validação de Dados

- Validar formato do código de abastecimento
- Validar que `quantity_liters` e `odometer_reading` são números positivos
- Validar que `action` é apenas `confirmar` ou `contestar`
- Validar que `corrected_data` é obrigatório quando `action = contestar`

---

## 12. 📱 Integração com o App Mobile

### Endpoints que o App Chama

1. **Polling (a cada 15 segundos):**
   - `GET /api/v1/refueling/:id` - Verificar status
   - `GET /api/v1/refueling/by-code/:code` - Buscar refueling_id pelo código

2. **Quando status muda para `AGUARDANDO_VALIDACAO_MOTORISTA`:**
   - `GET /api/v1/refueling/:id/pending-validation` - Carregar dados

3. **Quando motorista valida:**
   - `POST /api/v1/refueling/:id/driver-validation` - Confirmar ou contestar

### Formato de Resposta Esperado pelo App

O app espera respostas no formato:
```json
{
  "success": true,
  "data": { ... }
}
```

ou

```json
{
  "success": false,
  "error": "Mensagem de erro"
}
```

**Nota:** Se o backend usa formato diferente (ex: NestJS padrão), pode ser necessário criar um interceptor ou ajustar o formato de resposta.

---

## 13. 🚀 Ordem de Implementação Recomendada

1. **Adicionar enum** `AGUARDANDO_VALIDACAO_MOTORISTA` (Fase 1)
2. **Modificar** `registerSimpleRefueling` (Fase 2)
3. **Implementar** `GET /api/v1/refueling/by-code/:code` (Fase 3)
4. **Implementar** `GET /api/v1/refueling/:id/pending-validation` (Fase 3)
5. **Implementar** `POST /api/v1/refueling/:id/driver-validation` (Fase 3)
6. **Testar** todos os endpoints (Fase 5)
7. **Integrar** com o app mobile (Fase 5)

---

## 14. 📞 Dúvidas ou Problemas

Se houver dúvidas durante a implementação:

1. Verificar o código do app mobile em `lib/core/services/refueling_polling_service.dart`
2. Verificar o código do app mobile em `lib/core/services/api_service.dart`
3. Verificar o código do app mobile em `lib/features/refueling/presentation/pages/refueling_waiting_page.dart`

---

## 15. 📋 Resumo Executivo

### O que precisa ser feito:

1. ✅ **Adicionar enum** `AGUARDANDO_VALIDACAO_MOTORISTA`
2. ✅ **Modificar** `registerSimpleRefueling` para status inicial `AGUARDANDO_VALIDACAO_MOTORISTA`
3. 🆕 **Criar endpoint** `GET /api/v1/refueling/by-code/:code`
4. 🆕 **Criar endpoint** `GET /api/v1/refueling/:id/pending-validation`
5. 🆕 **Criar endpoint** `POST /api/v1/refueling/:id/driver-validation`
6. ✅ **Verificar** `GET /api/v1/refueling/:id` retorna todos os campos

### Prioridade: **ALTA** 🔴

O app mobile já está implementado e aguardando estes endpoints para funcionar completamente.

---

**Documento criado em:** 2025-11-12  
**Versão:** 1.0  
**Autor:** Cursor AI Assistant

