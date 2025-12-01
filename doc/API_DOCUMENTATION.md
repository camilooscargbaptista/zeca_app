# 📚 DOCUMENTAÇÃO COMPLETA - BACKEND API ZECA

## 📋 **ÍNDICE**

1. [Visão Geral da API](#1-visão-geral-da-api)
2. [Autenticação e Usuários](#2-autenticação-e-usuários)
3. [Veículos](#3-veículos)
4. [Postos de Combustível](#4-postos-de-combustível)
5. [Abastecimento e Códigos QR](#5-abastecimento-e-códigos-qr)
6. [Upload de Documentos](#6-upload-de-documentos)
7. [Notificações](#7-notificações)
8. [Geolocalização](#8-geolocalização)
9. [Histórico e Relatórios](#9-histórico-e-relatórios)
10. [Perfil e Configurações](#10-perfil-e-configurações)
11. [SITE DO POSTO - APIs Específicas](#11-site-do-posto---apis-específicas)
12. [Códigos de Erro](#12-códigos-de-erro)
13. [Exemplos de Integração](#13-exemplos-de-integração)

---

## 1. VISÃO GERAL DA API

### 1.1 Base URL
```
Produção: https://api.zeca.com/v1
Staging:  https://api-staging.zeca.com/v1
Desenvolvimento: https://api-dev.zeca.com/v1
```

### 1.2 Aplicações Atendidas
- **App Mobile ZECA** (Flutter) - Motoristas e transportadoras
- **Site do Posto ZECA** (Angular) - Postos de combustível conveniados

### 1.3 Autenticação
- **Tipo:** Bearer Token (JWT)
- **Header:** `Authorization: Bearer <token>`
- **Refresh Token:** Disponível para renovação automática

### 1.4 Formato de Response Padrão
```json
{
  "success": true,
  "data": {},
  "message": "Operação realizada com sucesso",
  "timestamp": "2025-01-13T10:30:00Z",
  "request_id": "req_123456789"
}
```

### 1.5 Formato de Erro Padrão
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Dados inválidos fornecidos",
    "details": {
      "field": "cpf",
      "reason": "CPF inválido"
    }
  },
  "timestamp": "2025-01-13T10:30:00Z",
  "request_id": "req_123456789"
}
```

### 1.6 Headers Obrigatórios
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer <token>
X-Platform: android|ios|web
X-App-Version: 1.0.0
X-Device-ID: <device_unique_id>
X-Client-Type: mobile|web
```

---

## 2. AUTENTICAÇÃO E USUÁRIOS

### 2.1 Login de Usuário

**Endpoint:** `POST /auth/login`

**Request:**
```json
{
  "cpf": "12345678900",
  "password": "senha123",
  "device_info": {
    "platform": "android",
    "version": "1.0.0",
    "device_id": "device_123456",
    "push_token": "fcm_token_123456"
  }
}
```

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_123456",
      "nome": "João Silva",
      "cpf": "12345678900",
      "email": "joao@empresa.com",
      "telefone": "11999999999",
      "empresa": {
        "id": "emp_123456",
        "nome": "Transportadora ABC Ltda",
        "cnpj": "12345678000199",
        "fantasia": "ABC Transportes"
      },
      "perfil": {
        "cargo": "Motorista",
        "departamento": "Operações",
        "nivel_acesso": "motorista",
        "permissoes": ["abastecer", "visualizar_historico"]
      },
      "preferencias": {
        "notificacoes_push": true,
        "notificacoes_email": true,
        "tema": "claro",
        "idioma": "pt_BR"
      },
      "ultimo_login": "2025-01-13T10:30:00Z",
      "ativo": true,
      "criado_em": "2025-01-01T00:00:00Z"
    },
    "tokens": {
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refresh_token": "refresh_token_123456",
      "expires_in": 3600,
      "token_type": "Bearer"
    }
  },
  "message": "Login realizado com sucesso"
}
```

### 2.2 Refresh Token

**Endpoint:** `POST /auth/refresh`

**Request:**
```json
{
  "refresh_token": "refresh_token_123456"
}
```

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "new_refresh_token_123456",
    "expires_in": 3600,
    "token_type": "Bearer"
  }
}
```

### 2.3 Logout

**Endpoint:** `POST /auth/logout`

**Request:**
```json
{
  "device_id": "device_123456"
}
```

**Response Success (200):**
```json
{
  "success": true,
  "message": "Logout realizado com sucesso"
}
```

### 2.4 Verificar Status de Autenticação

**Endpoint:** `GET /auth/status`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "authenticated": true,
    "user_id": "user_123456",
    "expires_at": "2025-01-13T11:30:00Z"
  }
}
```

---

## 3. VEÍCULOS

### 3.1 Buscar Veículo por Placa

**Endpoint:** `GET /vehicles/search/{placa}`

**Parâmetros:**
- `placa` (path): Placa do veículo (formato: ABC1234 ou ABC1D23)

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "veh_123456",
    "placa": "ABC1234",
    "modelo": "Volvo FH 540",
    "marca": "Volvo",
    "ano": 2023,
    "cor": "Branco",
    "combustiveis": ["diesel", "arla32"],
    "ultimo_km": 150000,
    "ultimo_abastecimento": "2025-01-10T14:30:00Z",
    "especificacoes": {
      "capacidade_tanque": 500.0,
      "consumo_medio": 2.5,
      "transmissao": "Manual",
      "eixos": 3
    },
    "seguro": {
      "seguradora": "Porto Seguro",
      "apolice": "123456789",
      "vencimento": "2025-12-31T23:59:59Z"
    },
    "empresa": {
      "id": "emp_123456",
      "nome": "Transportadora ABC Ltda"
    },
    "ativo": true,
    "criado_em": "2025-01-01T00:00:00Z"
  }
}
```

### 3.2 Listar Veículos da Empresa

**Endpoint:** `GET /vehicles`

**Query Parameters:**
- `page` (int): Página (padrão: 1)
- `limit` (int): Limite por página (padrão: 20, máximo: 100)
- `search` (string): Busca por placa, modelo ou marca
- `ativo` (boolean): Filtrar por status ativo

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "vehicles": [
      {
        "id": "veh_123456",
        "placa": "ABC1234",
        "modelo": "Volvo FH 540",
        "marca": "Volvo",
        "ano": 2023,
        "cor": "Branco",
        "ultimo_km": 150000,
        "ultimo_abastecimento": "2025-01-10T14:30:00Z",
        "ativo": true
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 95,
      "items_per_page": 20
    }
  }
}
```

### 3.3 Obter Detalhes do Veículo

**Endpoint:** `GET /vehicles/{id}`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "veh_123456",
    "placa": "ABC1234",
    "modelo": "Volvo FH 540",
    "marca": "Volvo",
    "ano": 2023,
    "cor": "Branco",
    "combustiveis": ["diesel", "arla32"],
    "ultimo_km": 150000,
    "ultimo_abastecimento": "2025-01-10T14:30:00Z",
    "especificacoes": {
      "capacidade_tanque": 500.0,
      "consumo_medio": 2.5,
      "transmissao": "Manual",
      "eixos": 3,
      "peso_bruto": 45000.0
    },
    "seguro": {
      "seguradora": "Porto Seguro",
      "apolice": "123456789",
      "vencimento": "2025-12-31T23:59:59Z"
    },
    "historico_abastecimentos": [
      {
        "id": "ref_123456",
        "data": "2025-01-10T14:30:00Z",
        "posto": "Posto Shell",
        "combustivel": "diesel",
        "quantidade": 200.0,
        "preco_litro": 4.50,
        "total": 900.0,
        "km": 150000
      }
    ],
    "empresa": {
      "id": "emp_123456",
      "nome": "Transportadora ABC Ltda"
    },
    "ativo": true,
    "criado_em": "2025-01-01T00:00:00Z"
  }
}
```

---

## 4. POSTOS DE COMBUSTÍVEL

### 4.1 Buscar Postos Próximos

**Endpoint:** `GET /fuel-stations/nearby`

**Query Parameters:**
- `latitude` (float): Latitude atual
- `longitude` (float): Longitude atual
- `radius` (int): Raio em metros (padrão: 10000, máximo: 50000)
- `combustivel` (string): Tipo de combustível (opcional)
- `conveniado` (boolean): Apenas postos conveniados (opcional)

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "stations": [
      {
        "id": "sta_123456",
        "cnpj": "12345678000199",
        "razao_social": "Posto Shell Ltda",
        "nome_fantasia": "Shell Express",
        "endereco": {
          "logradouro": "Av. Paulista",
          "numero": "1000",
          "complemento": "Loja 1",
          "bairro": "Bela Vista",
          "cidade": "São Paulo",
          "uf": "SP",
          "cep": "01310100",
          "latitude": -23.5613,
          "longitude": -46.6565
        },
        "conveniado": true,
        "precos": {
          "diesel": 4.50,
          "gasolina": 5.20,
          "etanol": 3.80,
          "arla32": 2.10
        },
        "servicos": ["restaurante", "banheiro", "wifi", "loja"],
        "formas_pagamento": ["dinheiro", "cartao", "pix"],
        "contato": {
          "telefone": "1133334444",
          "email": "contato@shell.com.br"
        },
        "avaliacao": 4.5,
        "distancia_km": 2.3,
        "tempo_estimado_min": 8,
        "horario_funcionamento": {
          "segunda_sex": "06:00-22:00",
          "sabado": "06:00-20:00",
          "domingo": "08:00-18:00"
        },
        "ativo": true
      }
    ],
    "total_encontrados": 15,
    "raio_busca_km": 10
  }
}
```

### 4.2 Validar Posto por CNPJ

**Endpoint:** `GET /fuel-stations/validate/{cnpj}`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "sta_123456",
    "cnpj": "12345678000199",
    "razao_social": "Posto Shell Ltda",
    "nome_fantasia": "Shell Express",
    "conveniado": true,
    "ativo": true,
    "precos_atualizados": "2025-01-13T08:00:00Z",
    "endereco": {
      "logradouro": "Av. Paulista",
      "numero": "1000",
      "bairro": "Bela Vista",
      "cidade": "São Paulo",
      "uf": "SP"
    }
  }
}
```

### 4.3 Obter Preços de Combustível

**Endpoint:** `GET /fuel-stations/{id}/prices`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "station_id": "sta_123456",
    "precos": {
      "diesel": {
        "preco": 4.50,
        "atualizado_em": "2025-01-13T08:00:00Z",
        "fonte": "posto"
      },
      "gasolina": {
        "preco": 5.20,
        "atualizado_em": "2025-01-13T08:00:00Z",
        "fonte": "posto"
      },
      "etanol": {
        "preco": 3.80,
        "atualizado_em": "2025-01-13T08:00:00Z",
        "fonte": "posto"
      },
      "arla32": {
        "preco": 2.10,
        "atualizado_em": "2025-01-13T08:00:00Z",
        "fonte": "posto"
      }
    },
    "historico_precos": [
      {
        "data": "2025-01-12T08:00:00Z",
        "diesel": 4.45,
        "gasolina": 5.15,
        "etanol": 3.75,
        "arla32": 2.05
      }
    ]
  }
}
```

---

## 5. ABASTECIMENTO E CÓDIGOS QR

### 5.1 Gerar Código de Abastecimento

**Endpoint:** `POST /refueling/generate-code`

**Request:**
```json
{
  "veiculo_id": "veh_123456",
  "veiculo_placa": "ABC1234",
  "km_atual": 150500,
  "combustivel": "diesel",
  "abastecer_arla": true,
  "posto_id": "sta_123456",
  "posto_cnpj": "12345678000199",
  "observacoes": "Abastecimento de rotina"
}
```

**Response Success (201):**
```json
{
  "success": true,
  "data": {
    "id": "ref_123456",
    "codigo": "ABC1-DEF2-GHI3",
    "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
    "veiculo": {
      "id": "veh_123456",
      "placa": "ABC1234",
      "modelo": "Volvo FH 540",
      "marca": "Volvo"
    },
    "posto": {
      "id": "sta_123456",
      "cnpj": "12345678000199",
      "nome": "Shell Express",
      "endereco": "Av. Paulista, 1000 - Bela Vista, São Paulo/SP"
    },
    "dados_abastecimento": {
      "combustivel": "diesel",
      "preco_litro": 4.50,
      "quantidade_maxima": 200.0,
      "valor_maximo": 900.0,
      "km_registrado": 150500,
      "abastecer_arla": true,
      "preco_arla": 2.10
    },
    "validade": {
      "valido_ate": "2025-01-13T16:30:00Z",
      "tempo_restante_minutos": 120
    },
    "status": "ativo",
    "gerado_em": "2025-01-13T14:30:00Z",
    "gerado_por": {
      "id": "user_123456",
      "nome": "João Silva",
      "cpf": "12345678900"
    }
  }
}
```

### 5.2 Validar Código de Abastecimento

**Endpoint:** `GET /refueling/validate-code/{codigo}`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "ref_123456",
    "codigo": "ABC1-DEF2-GHI3",
    "status": "ativo",
    "valido": true,
    "veiculo": {
      "placa": "ABC1234",
      "modelo": "Volvo FH 540"
    },
    "posto": {
      "cnpj": "12345678000199",
      "nome": "Shell Express"
    },
    "dados_abastecimento": {
      "combustivel": "diesel",
      "preco_litro": 4.50,
      "quantidade_maxima": 200.0,
      "valor_maximo": 900.0
    },
    "validade": {
      "valido_ate": "2025-01-13T16:30:00Z",
      "tempo_restante_minutos": 45
    }
  }
}
```

### 5.3 Finalizar Abastecimento

**Endpoint:** `POST /refueling/finalize`

**Request:**
```json
{
  "refueling_id": "ref_123456",
  "dados_abastecimento": {
    "quantidade_litros": 180.5,
    "valor_total": 812.25,
    "km_final": 150500,
    "quantidade_arla": 5.0,
    "valor_arla": 10.50,
    "observacoes": "Abastecimento completo"
  },
  "comprovantes": [
    {
      "documento_id": "doc_123456",
      "tipo": "nota_fiscal"
    },
    {
      "documento_id": "doc_123457",
      "tipo": "foto_bomba"
    }
  ]
}
```

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "ref_123456",
    "status": "finalizado",
    "dados_abastecimento": {
      "quantidade_litros": 180.5,
      "valor_total": 812.25,
      "km_final": 150500,
      "quantidade_arla": 5.0,
      "valor_arla": 10.50,
      "valor_total_geral": 822.75
    },
    "finalizado_em": "2025-01-13T15:45:00Z",
    "finalizado_por": {
      "id": "user_123456",
      "nome": "João Silva"
    },
    "comprovantes": [
      {
        "id": "doc_123456",
        "tipo": "nota_fiscal",
        "url": "https://storage.zeca.com/documents/doc_123456.pdf"
      },
      {
        "id": "doc_123457",
        "tipo": "foto_bomba",
        "url": "https://storage.zeca.com/documents/doc_123457.jpg"
      }
    ]
  }
}
```

### 5.4 Cancelar Código

**Endpoint:** `PUT /refueling/cancel/{id}`

**Request:**
```json
{
  "motivo": "Veículo não chegou ao posto",
  "observacoes": "Cancelado por atraso na entrega"
}
```

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "ref_123456",
    "status": "cancelado",
    "motivo": "Veículo não chegou ao posto",
    "cancelado_em": "2025-01-13T16:00:00Z",
    "cancelado_por": {
      "id": "user_123456",
      "nome": "João Silva"
    }
  }
}
```

### 5.5 Obter Status do Abastecimento

**Endpoint:** `GET /refueling/{id}/status`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "ref_123456",
    "codigo": "ABC1-DEF2-GHI3",
    "status": "ativo",
    "veiculo": {
      "placa": "ABC1234",
      "modelo": "Volvo FH 540"
    },
    "posto": {
      "nome": "Shell Express",
      "cnpj": "12345678000199"
    },
    "progresso": {
      "etapa_atual": "aguardando_abastecimento",
      "etapas_completas": ["codigo_gerado", "validado_no_posto"],
      "proximas_etapas": ["abastecimento", "upload_comprovantes", "finalizacao"]
    },
    "validade": {
      "valido_ate": "2025-01-13T16:30:00Z",
      "tempo_restante_minutos": 30
    },
    "atualizado_em": "2025-01-13T15:30:00Z"
  }
}
```

---

## 6. UPLOAD DE DOCUMENTOS

### 6.1 Upload de Documento

**Endpoint:** `POST /documents/upload`

**Request:** `multipart/form-data`
```
file: [arquivo]
refueling_id: ref_123456
tipo: nota_fiscal|foto_bomba|foto_odometro|comprovante_pagamento
descricao: Nota fiscal do abastecimento
```

**Response Success (201):**
```json
{
  "success": true,
  "data": {
    "id": "doc_123456",
    "nome_original": "nota_fiscal_20250113.pdf",
    "nome_arquivo": "doc_123456.pdf",
    "tipo": "nota_fiscal",
    "tamanho_bytes": 245760,
    "mime_type": "application/pdf",
    "url": "https://storage.zeca.com/documents/doc_123456.pdf",
    "url_thumbnail": "https://storage.zeca.com/thumbnails/doc_123456.jpg",
    "uploadado_em": "2025-01-13T15:30:00Z",
    "uploadado_por": {
      "id": "user_123456",
      "nome": "João Silva"
    },
    "refueling_id": "ref_123456"
  }
}
```

### 6.2 Listar Documentos do Abastecimento

**Endpoint:** `GET /refueling/{id}/documents`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "refueling_id": "ref_123456",
    "documents": [
      {
        "id": "doc_123456",
        "tipo": "nota_fiscal",
        "nome_original": "nota_fiscal_20250113.pdf",
        "tamanho_bytes": 245760,
        "url": "https://storage.zeca.com/documents/doc_123456.pdf",
        "url_thumbnail": "https://storage.zeca.com/thumbnails/doc_123456.jpg",
        "uploadado_em": "2025-01-13T15:30:00Z"
      },
      {
        "id": "doc_123457",
        "tipo": "foto_bomba",
        "nome_original": "foto_bomba_20250113.jpg",
        "tamanho_bytes": 1024000,
        "url": "https://storage.zeca.com/documents/doc_123457.jpg",
        "url_thumbnail": "https://storage.zeca.com/thumbnails/doc_123457.jpg",
        "uploadado_em": "2025-01-13T15:35:00Z"
      }
    ],
    "total_documents": 2
  }
}
```

### 6.3 Deletar Documento

**Endpoint:** `DELETE /documents/{id}`

**Response Success (200):**
```json
{
  "success": true,
  "message": "Documento deletado com sucesso"
}
```

---

## 7. NOTIFICAÇÕES

### 7.1 Listar Notificações

**Endpoint:** `GET /notifications`

**Query Parameters:**
- `page` (int): Página (padrão: 1)
- `limit` (int): Limite por página (padrão: 20)
- `tipo` (string): Filtrar por tipo
- `lida` (boolean): Filtrar por status de leitura

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "notifications": [
      {
        "id": "not_123456",
        "titulo": "Código de Abastecimento Gerado",
        "mensagem": "Código ABC1-DEF2-GHI3 gerado para veículo ABC1234",
        "tipo": "abastecimento",
        "prioridade": "alta",
        "lida": false,
        "criada_em": "2025-01-13T14:30:00Z",
        "dados_extras": {
          "refueling_id": "ref_123456",
          "veiculo_placa": "ABC1234",
          "codigo": "ABC1-DEF2-GHI3"
        }
      },
      {
        "id": "not_123457",
        "titulo": "Preço de Combustível Atualizado",
        "mensagem": "Preço do diesel atualizado no posto Shell Express",
        "tipo": "preco",
        "prioridade": "media",
        "lida": true,
        "criada_em": "2025-01-13T08:00:00Z",
        "dados_extras": {
          "station_id": "sta_123456",
          "combustivel": "diesel",
          "preco_anterior": 4.45,
          "preco_novo": 4.50
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 3,
      "total_items": 45,
      "items_per_page": 20
    },
    "nao_lidas": 12
  }
}
```

### 7.2 Marcar Notificação como Lida

**Endpoint:** `PUT /notifications/{id}/read`

**Response Success (200):**
```json
{
  "success": true,
  "message": "Notificação marcada como lida"
}
```

### 7.3 Marcar Todas como Lidas

**Endpoint:** `PUT /notifications/read-all`

**Response Success (200):**
```json
{
  "success": true,
  "message": "Todas as notificações foram marcadas como lidas"
}
```

### 7.4 Configurar Preferências de Notificação

**Endpoint:** `PUT /notifications/preferences`

**Request:**
```json
{
  "push_enabled": true,
  "email_enabled": true,
  "tipos_notificacao": {
    "abastecimento": true,
    "preco": true,
    "manutencao": false,
    "sistema": true
  },
  "horario_silencioso": {
    "inicio": "22:00",
    "fim": "07:00"
  }
}
```

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "push_enabled": true,
    "email_enabled": true,
    "tipos_notificacao": {
      "abastecimento": true,
      "preco": true,
      "manutencao": false,
      "sistema": true
    },
    "horario_silencioso": {
      "inicio": "22:00",
      "fim": "07:00"
    }
  }
}
```

---

## 8. GEOLOCALIZAÇÃO

### 8.1 Buscar Postos por Proximidade

**Endpoint:** `GET /fuel-stations/nearby`

**Query Parameters:**
- `latitude` (float): Latitude atual
- `longitude` (float): Longitude atual
- `radius` (int): Raio em metros (padrão: 10000)
- `combustivel` (string): Tipo de combustível
- `conveniado` (boolean): Apenas postos conveniados

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "stations": [
      {
        "id": "sta_123456",
        "nome": "Shell Express",
        "cnpj": "12345678000199",
        "endereco": "Av. Paulista, 1000 - Bela Vista, São Paulo/SP",
        "coordenadas": {
          "latitude": -23.5613,
          "longitude": -46.6565
        },
        "distancia_km": 2.3,
        "tempo_estimado_min": 8,
        "conveniado": true,
        "precos": {
          "diesel": 4.50,
          "gasolina": 5.20
        },
        "avaliacao": 4.5,
        "servicos": ["restaurante", "banheiro", "wifi"]
      }
    ],
    "total_encontrados": 15,
    "raio_busca_km": 10,
    "sua_localizacao": {
      "latitude": -23.5505,
      "longitude": -46.6333,
      "precisao_metros": 10
    }
  }
}
```

### 8.2 Geocodificação (Endereço → Coordenadas)

**Endpoint:** `GET /geocoding/address`

**Query Parameters:**
- `endereco` (string): Endereço completo
- `cidade` (string): Cidade
- `uf` (string): Estado

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "endereco": "Av. Paulista, 1000 - Bela Vista, São Paulo/SP",
    "coordenadas": {
      "latitude": -23.5613,
      "longitude": -46.6565
    },
    "precisao": "high",
    "componentes": {
      "logradouro": "Avenida Paulista",
      "numero": "1000",
      "bairro": "Bela Vista",
      "cidade": "São Paulo",
      "uf": "SP",
      "cep": "01310100"
    }
  }
}
```

### 8.3 Geocodificação Reversa (Coordenadas → Endereço)

**Endpoint:** `GET /geocoding/reverse`

**Query Parameters:**
- `latitude` (float): Latitude
- `longitude` (float): Longitude

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "coordenadas": {
      "latitude": -23.5613,
      "longitude": -46.6565
    },
    "endereco": "Av. Paulista, 1000 - Bela Vista, São Paulo/SP",
    "componentes": {
      "logradouro": "Avenida Paulista",
      "numero": "1000",
      "bairro": "Bela Vista",
      "cidade": "São Paulo",
      "uf": "SP",
      "cep": "01310100"
    }
  }
}
```

---

## 9. HISTÓRICO E RELATÓRIOS

### 9.1 Histórico de Abastecimentos

**Endpoint:** `GET /refueling/history`

**Query Parameters:**
- `page` (int): Página (padrão: 1)
- `limit` (int): Limite por página (padrão: 20)
- `veiculo_id` (string): Filtrar por veículo
- `data_inicio` (date): Data início (YYYY-MM-DD)
- `data_fim` (date): Data fim (YYYY-MM-DD)
- `status` (string): Filtrar por status
- `search` (string): Busca por código ou placa

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "refuelings": [
      {
        "id": "ref_123456",
        "codigo": "ABC1-DEF2-GHI3",
        "status": "finalizado",
        "veiculo": {
          "id": "veh_123456",
          "placa": "ABC1234",
          "modelo": "Volvo FH 540",
          "marca": "Volvo"
        },
        "posto": {
          "id": "sta_123456",
          "nome": "Shell Express",
          "cnpj": "12345678000199",
          "endereco": "Av. Paulista, 1000 - São Paulo/SP"
        },
        "dados_abastecimento": {
          "combustivel": "diesel",
          "quantidade_litros": 180.5,
          "preco_litro": 4.50,
          "valor_total": 812.25,
          "km_inicial": 150000,
          "km_final": 150500,
          "quantidade_arla": 5.0,
          "valor_arla": 10.50
        },
        "datas": {
          "gerado_em": "2025-01-13T14:30:00Z",
          "finalizado_em": "2025-01-13T15:45:00Z"
        },
        "usuario": {
          "id": "user_123456",
          "nome": "João Silva"
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 10,
      "total_items": 195,
      "items_per_page": 20
    },
    "resumo": {
      "total_abastecimentos": 195,
      "total_litros": 35100.5,
      "total_valor": 157952.25,
      "media_litros_por_abastecimento": 180.0,
      "media_valor_por_abastecimento": 810.01
    }
  }
}
```

### 9.2 Relatório de Consumo

**Endpoint:** `GET /reports/consumption`

**Query Parameters:**
- `veiculo_id` (string): ID do veículo
- `data_inicio` (date): Data início (YYYY-MM-DD)
- `data_fim` (date): Data fim (YYYY-MM-DD)
- `tipo_periodo` (string): diario|semanal|mensal

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "veiculo": {
      "id": "veh_123456",
      "placa": "ABC1234",
      "modelo": "Volvo FH 540"
    },
    "periodo": {
      "inicio": "2025-01-01",
      "fim": "2025-01-31"
    },
    "consumo": {
      "total_litros": 2500.0,
      "total_km": 10000,
      "consumo_medio": 4.0,
      "custo_total": 11250.0,
      "custo_por_km": 1.125
    },
    "detalhamento": [
      {
        "data": "2025-01-01",
        "litros": 200.0,
        "km": 800,
        "consumo": 4.0,
        "custo": 900.0
      }
    ],
    "graficos": {
      "consumo_por_dia": "https://charts.zeca.com/consumo_123456.png",
      "custo_por_dia": "https://charts.zeca.com/custo_123456.png"
    }
  }
}
```

### 9.3 Relatório de Custos

**Endpoint:** `GET /reports/costs`

**Query Parameters:**
- `empresa_id` (string): ID da empresa
- `data_inicio` (date): Data início (YYYY-MM-DD)
- `data_fim` (date): Data fim (YYYY-MM-DD)
- `agrupamento` (string): veiculo|posto|combustivel

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "empresa": {
      "id": "emp_123456",
      "nome": "Transportadora ABC Ltda"
    },
    "periodo": {
      "inicio": "2025-01-01",
      "fim": "2025-01-31"
    },
    "resumo": {
      "total_abastecimentos": 150,
      "total_litros": 30000.0,
      "total_custo": 135000.0,
      "custo_medio_por_litro": 4.50
    },
    "detalhamento": [
      {
        "categoria": "ABC1234",
        "tipo": "veiculo",
        "abastecimentos": 25,
        "litros": 5000.0,
        "custo": 22500.0,
        "percentual": 16.67
      }
    ],
    "graficos": {
      "custo_por_veiculo": "https://charts.zeca.com/custo_veiculo_123456.png",
      "custo_por_posto": "https://charts.zeca.com/custo_posto_123456.png"
    }
  }
}
```

---

## 10. PERFIL E CONFIGURAÇÕES

### 10.1 Obter Perfil do Usuário

**Endpoint:** `GET /profile`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "user_123456",
    "nome": "João Silva",
    "cpf": "12345678900",
    "email": "joao@empresa.com",
    "telefone": "11999999999",
    "empresa": {
      "id": "emp_123456",
      "nome": "Transportadora ABC Ltda",
      "cnpj": "12345678000199",
      "fantasia": "ABC Transportes"
    },
    "perfil": {
      "cargo": "Motorista",
      "departamento": "Operações",
      "nivel_acesso": "motorista",
      "permissoes": ["abastecer", "visualizar_historico"]
    },
    "preferencias": {
      "notificacoes_push": true,
      "notificacoes_email": true,
      "tema": "claro",
      "idioma": "pt_BR"
    },
    "estatisticas": {
      "total_abastecimentos": 150,
      "total_litros": 30000.0,
      "total_custo": 135000.0,
      "ultimo_abastecimento": "2025-01-13T15:45:00Z"
    },
    "ultimo_login": "2025-01-13T10:30:00Z",
    "ativo": true,
    "criado_em": "2025-01-01T00:00:00Z"
  }
}
```

### 10.2 Atualizar Perfil

**Endpoint:** `PUT /profile`

**Request:**
```json
{
  "nome": "João Silva Santos",
  "email": "joao.santos@empresa.com",
  "telefone": "11988888888",
  "preferencias": {
    "notificacoes_push": true,
    "notificacoes_email": false,
    "tema": "escuro",
    "idioma": "pt_BR"
  }
}
```

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "user_123456",
    "nome": "João Silva Santos",
    "email": "joao.santos@empresa.com",
    "telefone": "11988888888",
    "preferencias": {
      "notificacoes_push": true,
      "notificacoes_email": false,
      "tema": "escuro",
      "idioma": "pt_BR"
    },
    "atualizado_em": "2025-01-13T16:00:00Z"
  }
}
```

### 10.3 Alterar Senha

**Endpoint:** `PUT /profile/password`

**Request:**
```json
{
  "senha_atual": "senha123",
  "nova_senha": "novaSenha456",
  "confirmar_senha": "novaSenha456"
}
```

**Response Success (200):**
```json
{
  "success": true,
  "message": "Senha alterada com sucesso"
}
```

### 10.4 Obter Configurações da Empresa

**Endpoint:** `GET /company/settings`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "emp_123456",
    "nome": "Transportadora ABC Ltda",
    "cnpj": "12345678000199",
    "configuracoes": {
      "max_veiculos": 100,
      "max_usuarios": 50,
      "limite_orcamento_combustivel": 50000.0,
      "requer_aprovacao": false,
      "permite_postos_externos": true,
      "notificacoes": {
        "email": true,
        "push": true,
        "sms": false
      }
    },
    "contato": {
      "telefone": "1133334444",
      "email": "contato@empresa.com",
      "endereco": "Rua das Flores, 123 - Centro, São Paulo/SP"
    }
  }
}
```

---

## 11. SITE DO POSTO - APIs Específicas

### 11.1 Login do Posto

**Endpoint:** `POST /auth/posto/login`

**Request:**
```json
{
  "cnpj": "12345678000199",
  "senha": "senha123",
  "device_info": {
    "platform": "web",
    "version": "1.0.0",
    "device_id": "web_123456"
  }
}
```

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "posto": {
      "id": "posto_123456",
      "cnpj": "12345678000199",
      "razao_social": "Posto Shell Ltda",
      "nome_fantasia": "Shell Express",
      "endereco": {
        "logradouro": "Av. Paulista",
        "numero": "1000",
        "bairro": "Bela Vista",
        "cidade": "São Paulo",
        "uf": "SP"
      },
      "conveniado": true,
      "ativo": true
    },
    "usuario": {
      "id": "user_123456",
      "nome": "João Gerente",
      "email": "joao@posto.com",
      "cargo": "Gerente",
      "niveis_acesso": ["gerente", "operador"],
      "permissoes": ["validar_codigo", "lancar_abastecimento", "gerar_relatorios", "gerenciar_funcionarios"]
    },
    "tokens": {
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refresh_token": "refresh_token_123456",
      "expires_in": 3600,
      "token_type": "Bearer"
    }
  }
}
```

### 11.2 Dashboard do Posto

**Endpoint:** `GET /posto/dashboard`

**Query Parameters:**
- `periodo` (string): diario|mensal|customizado
- `data_inicio` (date): Data início (YYYY-MM-DD) - para customizado
- `data_fim` (date): Data fim (YYYY-MM-DD) - para customizado

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "periodo": {
      "tipo": "diario",
      "data": "2025-01-13"
    },
    "metricas": {
      "abastecimentos_pendentes": 5,
      "abastecimentos_finalizados": 25,
      "valor_total_abastecido": 12500.50,
      "quantidade_litros": 2500.0,
      "total_abastecimentos": 30
    },
    "abastecimentos_recentes": [
      {
        "id": "ref_123456",
        "codigo": "ABC1-DEF2-GHI3",
        "placa": "ABC1234",
        "motorista": "João Silva",
        "transportadora": "ABC Transportes",
        "combustivel": "diesel",
        "quantidade": 200.0,
        "valor": 900.0,
        "status": "pendente",
        "criado_em": "2025-01-13T14:30:00Z"
      }
    ]
  }
}
```

### 11.3 Validar Código de Abastecimento (PRINCIPAL)

**Endpoint:** `POST /posto/validation/validate-code`

**Request:**
```json
{
  "codigo": "ABC1-DEF2-GHI3"
}
```

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "ref_123456",
    "codigo": "ABC1-DEF2-GHI3",
    "status": "ativo",
    "valido": true,
    "veiculo": {
      "placa": "ABC1234",
      "modelo": "Volvo FH 540",
      "marca": "Volvo"
    },
    "motorista": {
      "nome": "João Silva",
      "cpf": "12345678900"
    },
    "transportadora": {
      "nome": "ABC Transportes",
      "cnpj": "12345678000199"
    },
    "dados_abastecimento": {
      "combustivel": "diesel",
      "preco_litro": 4.50,
      "quantidade_maxima": 200.0,
      "valor_maximo": 900.0,
      "abastecer_arla": true,
      "preco_arla": 2.10
    },
    "validade": {
      "valido_ate": "2025-01-13T16:30:00Z",
      "tempo_restante_minutos": 45
    }
  }
}
```

### 11.4 Lançar Abastecimento

**Endpoint:** `POST /posto/refueling/register`

**Request:**
```json
{
  "refueling_id": "ref_123456",
  "dados_abastecimento": {
    "quantidade_litros": 180.5,
    "valor_total": 812.25,
    "km_final": 150500,
    "quantidade_arla": 5.0,
    "valor_arla": 10.50,
    "observacoes": "Abastecimento completo"
  },
  "comprovantes": [
    {
      "documento_id": "doc_123456",
      "tipo": "nota_fiscal"
    }
  ]
}
```

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "ref_123456",
    "status": "finalizado",
    "dados_abastecimento": {
      "quantidade_litros": 180.5,
      "valor_total": 812.25,
      "km_final": 150500,
      "quantidade_arla": 5.0,
      "valor_arla": 10.50,
      "valor_total_geral": 822.75
    },
    "finalizado_em": "2025-01-13T15:45:00Z",
    "finalizado_por": {
      "id": "user_123456",
      "nome": "João Gerente"
    }
  }
}
```

### 11.5 Listar Abastecimentos do Posto

**Endpoint:** `GET /posto/refueling/list`

**Query Parameters:**
- `page` (int): Página (padrão: 1)
- `limit` (int): Limite por página (padrão: 20)
- `status` (string): pendente|finalizado|cancelado
- `data_inicio` (date): Data início (YYYY-MM-DD)
- `data_fim` (date): Data fim (YYYY-MM-DD)
- `search` (string): Busca por código, placa ou motorista

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "abastecimentos": [
      {
        "id": "ref_123456",
        "codigo": "ABC1-DEF2-GHI3",
        "status": "pendente",
        "veiculo": {
          "placa": "ABC1234",
          "modelo": "Volvo FH 540"
        },
        "motorista": {
          "nome": "João Silva",
          "cpf": "12345678900"
        },
        "transportadora": {
          "nome": "ABC Transportes",
          "cnpj": "12345678000199"
        },
        "dados_abastecimento": {
          "combustivel": "diesel",
          "preco_litro": 4.50,
          "quantidade_maxima": 200.0,
          "valor_maximo": 900.0
        },
        "criado_em": "2025-01-13T14:30:00Z",
        "tempo_restante_minutos": 45
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 95,
      "items_per_page": 20
    }
  }
}
```

### 11.6 Upload de Comprovante

**Endpoint:** `POST /posto/documents/upload`

**Request:** `multipart/form-data`
```
file: [arquivo]
refueling_id: ref_123456
tipo: nota_fiscal|foto_bomba|foto_odometro|comprovante_pagamento
descricao: Nota fiscal do abastecimento
```

**Response Success (201):**
```json
{
  "success": true,
  "data": {
    "id": "doc_123456",
    "nome_original": "nota_fiscal_20250113.pdf",
    "tipo": "nota_fiscal",
    "url": "https://storage.zeca.com/documents/doc_123456.pdf",
    "uploadado_em": "2025-01-13T15:30:00Z",
    "refueling_id": "ref_123456"
  }
}
```

### 11.7 Relatórios do Posto

**Endpoint:** `GET /posto/reports/refueling-list`

**Query Parameters:**
- `data_inicio` (date): Data início (YYYY-MM-DD)
- `data_fim` (date): Data fim (YYYY-MM-DD)
- `transportadora_id` (string): Filtrar por transportadora
- `status` (string): Filtrar por status
- `export` (string): pdf|excel - para exportação

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "periodo": {
      "inicio": "2025-01-01",
      "fim": "2025-01-31"
    },
    "abastecimentos": [
      {
        "id": "ref_123456",
        "codigo": "ABC1-DEF2-GHI3",
        "placa": "ABC1234",
        "motorista": "João Silva",
        "transportadora": "ABC Transportes",
        "cnpj_transportadora": "12345678000199",
        "combustivel": "diesel",
        "quantidade_litros": 180.5,
        "preco_litro": 4.50,
        "valor_total": 812.25,
        "quantidade_arla": 5.0,
        "valor_arla": 10.50,
        "valor_total_geral": 822.75,
        "data_hora": "2025-01-13T15:45:00Z",
        "status": "finalizado"
      }
    ],
    "resumo": {
      "total_abastecimentos": 150,
      "total_litros": 30000.0,
      "total_valor": 135000.0,
      "por_transportadora": [
        {
          "transportadora": "ABC Transportes",
          "cnpj": "12345678000199",
          "abastecimentos": 25,
          "litros": 5000.0,
          "valor": 22500.0,
          "percentual": 16.67
        }
      ]
    }
  }
}
```

### 11.8 Gestão de Funcionários do Posto

**Endpoint:** `GET /posto/employees`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "funcionarios": [
      {
        "id": "emp_123456",
        "nome": "João Gerente",
        "cpf": "12345678900",
        "email": "joao@posto.com",
        "cargo": "Gerente",
        "niveis_acesso": ["gerente", "operador"],
        "permissoes": ["validar_codigo", "lancar_abastecimento", "gerar_relatorios", "gerenciar_funcionarios"],
        "ativo": true,
        "criado_em": "2025-01-01T00:00:00Z",
        "ultimo_acesso": "2025-01-13T10:30:00Z"
      }
    ]
  }
}
```

**Endpoint:** `POST /posto/employees`

**Request:**
```json
{
  "nome": "Maria Operadora",
  "cpf": "98765432100",
  "email": "maria@posto.com",
  "cargo": "Operadora",
  "niveis_acesso": ["operador"],
  "permissoes": ["validar_codigo", "lancar_abastecimento"],
  "senha": "senha123"
}
```

**Endpoint:** `PUT /posto/employees/{id}`

**Request:**
```json
{
  "nome": "Maria Operadora Silva",
  "email": "maria.silva@posto.com",
  "cargo": "Operadora Senior",
  "niveis_acesso": ["operador", "financeiro"],
  "permissoes": ["validar_codigo", "lancar_abastecimento", "gerar_relatorios"],
  "ativo": true
}
```

### 11.9 Obter Dados do Posto

**Endpoint:** `GET /posto/info`

**Response Success (200):**
```json
{
  "success": true,
  "data": {
    "id": "posto_123456",
    "cnpj": "12345678000199",
    "razao_social": "Posto Shell Ltda",
    "nome_fantasia": "Shell Express",
    "endereco": {
      "logradouro": "Av. Paulista",
      "numero": "1000",
      "complemento": "Loja 1",
      "bairro": "Bela Vista",
      "cidade": "São Paulo",
      "uf": "SP",
      "cep": "01310100"
    },
    "conveniado": true,
    "precos": {
      "diesel": 4.50,
      "gasolina": 5.20,
      "etanol": 3.80,
      "arla32": 2.10
    },
    "contato": {
      "telefone": "1133334444",
      "email": "contato@posto.com"
    },
    "horario_funcionamento": {
      "segunda_sex": "06:00-22:00",
      "sabado": "06:00-20:00",
      "domingo": "08:00-18:00"
    },
    "ativo": true
  }
}
```

---

## 12. CÓDIGOS DE ERRO

### 12.1 Códigos de Erro HTTP
- `200` - Sucesso
- `201` - Criado com sucesso
- `400` - Dados inválidos
- `401` - Não autorizado
- `403` - Acesso negado
- `404` - Recurso não encontrado
- `409` - Conflito (recurso já existe)
- `422` - Erro de validação
- `429` - Muitas requisições
- `500` - Erro interno do servidor
- `503` - Serviço indisponível

### 12.2 Códigos de Erro Específicos

#### Autenticação
- `AUTH_INVALID_CREDENTIALS` - Credenciais inválidas
- `AUTH_TOKEN_EXPIRED` - Token expirado
- `AUTH_TOKEN_INVALID` - Token inválido
- `AUTH_USER_INACTIVE` - Usuário inativo
- `AUTH_ACCOUNT_LOCKED` - Conta bloqueada

#### Validação
- `VALIDATION_REQUIRED_FIELD` - Campo obrigatório
- `VALIDATION_INVALID_FORMAT` - Formato inválido
- `VALIDATION_CPF_INVALID` - CPF inválido
- `VALIDATION_CNPJ_INVALID` - CNPJ inválido
- `VALIDATION_PLACA_INVALID` - Placa inválida
- `VALIDATION_KM_INVALID` - KM inválido

#### Veículos
- `VEHICLE_NOT_FOUND` - Veículo não encontrado
- `VEHICLE_INACTIVE` - Veículo inativo
- `VEHICLE_NOT_ACCESSIBLE` - Veículo não acessível pelo usuário

#### Postos
- `STATION_NOT_FOUND` - Posto não encontrado
- `STATION_INACTIVE` - Posto inativo
- `STATION_NOT_PARTNER` - Posto não conveniado

#### Abastecimento
- `REFUELING_CODE_NOT_FOUND` - Código não encontrado
- `REFUELING_CODE_EXPIRED` - Código expirado
- `REFUELING_CODE_INVALID` - Código inválido
- `REFUELING_ALREADY_FINALIZED` - Abastecimento já finalizado
- `REFUELING_QUANTITY_EXCEEDED` - Quantidade excedida

#### Documentos
- `DOCUMENT_UPLOAD_FAILED` - Falha no upload
- `DOCUMENT_INVALID_TYPE` - Tipo de documento inválido
- `DOCUMENT_SIZE_EXCEEDED` - Tamanho excedido
- `DOCUMENT_NOT_FOUND` - Documento não encontrado

#### Sistema
- `SYSTEM_MAINTENANCE` - Sistema em manutenção
- `SYSTEM_RATE_LIMIT` - Limite de requisições excedido
- `SYSTEM_UNAVAILABLE` - Sistema indisponível

### 12.3 Exemplo de Response de Erro
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_CPF_INVALID",
    "message": "CPF inválido fornecido",
    "details": {
      "field": "cpf",
      "value": "12345678900",
      "reason": "Dígitos verificadores inválidos"
    }
  },
  "timestamp": "2025-01-13T10:30:00Z",
  "request_id": "req_123456789"
}
```

---

## 12. EXEMPLOS DE INTEGRAÇÃO

### 12.1 Fluxo Completo de Abastecimento

#### 1. Login
```bash
curl -X POST https://api.zeca.com/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "cpf": "12345678900",
    "password": "senha123",
    "device_info": {
      "platform": "android",
      "version": "1.0.0",
      "device_id": "device_123456"
    }
  }'
```

#### 2. Buscar Veículo
```bash
curl -X GET https://api.zeca.com/v1/vehicles/search/ABC1234 \
  -H "Authorization: Bearer <token>"
```

#### 3. Buscar Postos Próximos
```bash
curl -X GET "https://api.zeca.com/v1/fuel-stations/nearby?latitude=-23.5505&longitude=-46.6333&radius=10000" \
  -H "Authorization: Bearer <token>"
```

#### 4. Gerar Código de Abastecimento
```bash
curl -X POST https://api.zeca.com/v1/refueling/generate-code \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "veiculo_id": "veh_123456",
    "veiculo_placa": "ABC1234",
    "km_atual": 150500,
    "combustivel": "diesel",
    "abastecer_arla": true,
    "posto_id": "sta_123456",
    "posto_cnpj": "12345678000199"
  }'
```

#### 5. Upload de Documento
```bash
curl -X POST https://api.zeca.com/v1/documents/upload \
  -H "Authorization: Bearer <token>" \
  -F "file=@nota_fiscal.pdf" \
  -F "refueling_id=ref_123456" \
  -F "tipo=nota_fiscal"
```

#### 6. Finalizar Abastecimento
```bash
curl -X POST https://api.zeca.com/v1/refueling/finalize \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "refueling_id": "ref_123456",
    "dados_abastecimento": {
      "quantidade_litros": 180.5,
      "valor_total": 812.25,
      "km_final": 150500
    },
    "comprovantes": [
      {"documento_id": "doc_123456", "tipo": "nota_fiscal"}
    ]
  }'
```

### 12.2 Tratamento de Erros no Cliente

```dart
try {
  final response = await dioClient.post('/refueling/generate-code', data: data);
  return RefuelingCodeModel.fromJson(response.data['data']);
} on DioException catch (e) {
  if (e.response?.statusCode == 422) {
    final error = e.response?.data['error'];
    throw ValidationException(error['message']);
  } else if (e.response?.statusCode == 401) {
    throw UnauthorizedException('Token expirado');
  } else {
    throw ServerException('Erro no servidor');
  }
}
```

### 12.3 Paginação

```dart
class PaginatedResponse<T> {
  final List<T> items;
  final PaginationInfo pagination;
  
  PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) : items = (json['items'] as List).map((item) => fromJsonT(item)).toList(),
       pagination = PaginationInfo.fromJson(json['pagination']);
}

class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  
  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
}
```

---

## 📋 **RESUMO DAS APIs**

### **Total de Endpoints:** 50+
### **Categorias:**
- **Autenticação:** 4 endpoints
- **Veículos:** 3 endpoints  
- **Postos:** 3 endpoints
- **Abastecimento:** 5 endpoints
- **Documentos:** 3 endpoints
- **Notificações:** 4 endpoints
- **Geolocalização:** 3 endpoints
- **Histórico/Relatórios:** 3 endpoints
- **Perfil:** 4 endpoints
- **Site do Posto:** 9 endpoints

### **Funcionalidades Cobertas:**

#### **App Mobile (Flutter):**
✅ Login e autenticação
✅ Busca de veículos por placa
✅ Busca de postos por proximidade
✅ Geração de códigos QR
✅ Upload de documentos
✅ Notificações push
✅ Geolocalização
✅ Histórico e relatórios
✅ Perfil e configurações

#### **Site do Posto (Angular):**
✅ Login do posto (CNPJ + senha)
✅ Dashboard com métricas em tempo real
✅ Validação de códigos QR (funcionalidade principal)
✅ Lançamento de abastecimentos
✅ Upload de comprovantes
✅ Relatórios detalhados por transportadora
✅ Gestão de funcionários
✅ Sistema de permissões múltiplas

### **Próximos Passos:**
1. Implementar backend com estas APIs
2. Configurar banco de dados
3. Implementar autenticação JWT (mobile + web)
4. Configurar storage para documentos
5. Implementar notificações push
6. Configurar geolocalização
7. Implementar relatórios e analytics
8. Implementar sistema de permissões para postos
9. Configurar validação de códigos QR em tempo real

### **Aplicações Atendidas:**
- **App Mobile ZECA** (Flutter) - Motoristas e transportadoras
- **Site do Posto ZECA** (Angular) - Postos de combustível conveniados

Este documento serve como especificação completa para o desenvolvimento do backend que atenderá tanto o aplicativo ZECA quanto o site do posto.
