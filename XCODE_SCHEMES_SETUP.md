# Configuração de Schemes no Xcode - ZECA App

> Guia completo para configurar e usar os diferentes ambientes no ZECA App Flutter

---

## 📋 Visão Geral

O ZECA App suporta múltiplos ambientes através de **Xcode Schemes** que selecionam diferentes entrypoints Flutter:

| Scheme | Entrypoint | Ambiente | URL Base |
|--------|------------|----------|----------|
| **Runner** | `main.dart` | DEV | (fallback para prod) |
| **Runner-Staging** | `main_staging.dart` | STAGING | `api-staging.zeca.com.br` |
| **Runner-Prod** | `main_prod.dart` | PROD | `www.abastecacomzeca.com.br` |

---

## 🚀 Como Usar

### Selecionando o Ambiente no Xcode

1. Abra o projeto no Xcode: `ios/Runner.xcworkspace`
2. Clique no seletor de scheme (ao lado do botão Run)
3. Escolha o scheme desejado:
   - **Runner-Staging** para testar em staging
   - **Runner-Prod** para build de produção

### Verificando o Ambiente

No console do Flutter, você verá logs indicando o ambiente:
```
⏱️ [INIT] FlavorConfig: 5ms
🔄 [INIT] Iniciando inicializações lazy...
```

O nome do app também muda:
- **ZECA DEV** - Ambiente de desenvolvimento
- **ZECA STAGING** - Ambiente de staging
- **ZECA** - Produção

---

## 🛠️ Arquitetura

### Entrypoints

```
lib/
├── main.dart           # Entrypoint padrão (DEV)
├── main_dev.dart       # Entrypoint explícito DEV
├── main_staging.dart   # Entrypoint STAGING ⭐
└── main_prod.dart      # Entrypoint PRODUÇÃO ⭐
```

Cada entrypoint chama `mainCommon(Flavor.xxx)`:

```dart
// main_staging.dart
import 'main.dart';
import 'core/config/flavor_config.dart';

void main() {
  mainCommon(Flavor.staging);
}
```

### Configuração de URLs

As URLs são definidas em `lib/core/config/flavor_config.dart`:

```dart
case Flavor.staging:
  baseUrl: 'https://api-staging.zeca.com.br',
  
case Flavor.prod:
  baseUrl: 'https://www.abastecacomzeca.com.br',
```

O `ApiConfig` usa automaticamente a URL do flavor atual:

```dart
// lib/core/config/api_config.dart
static String get baseUrl => FlavorConfig.instance.baseUrl;
static String get apiUrl => '$baseUrl/api/v1';
```

---

## ⚙️ Configuração dos Schemes

### Como os Schemes Funcionam

Cada scheme tem um **Pre-action Script** que define o `FLUTTER_TARGET`:

```bash
# Runner-Staging Pre-action
echo "FLUTTER_TARGET=lib/main_staging.dart" > "${SRCROOT}/Flutter/flutter_env.xcconfig"
```

Este arquivo é lido pelo Flutter durante o build para determinar qual entrypoint usar.

### Criando um Novo Scheme

1. No Xcode: **Product > Scheme > Manage Schemes**
2. Duplique um scheme existente
3. Renomeie (ex: `Runner-NewEnv`)
4. Edite o scheme: **Edit Scheme > Build > Pre-actions**
5. Adicione script:
   ```bash
   echo "FLUTTER_TARGET=lib/main_newenv.dart" > "${SRCROOT}/Flutter/flutter_env.xcconfig"
   ```
6. Crie o entrypoint `lib/main_newenv.dart`
7. Adicione o caso no `FlavorConfig.initialize()`

---

## 🔍 Troubleshooting

### Problema: Build usa ambiente errado

**Sintomas:** Logs mostram URLs de produção mesmo usando Runner-Staging

**Solução:**
1. Limpe o build: `flutter clean`
2. Feche e reabra o Xcode
3. Verifique se `ios/Flutter/flutter_env.xcconfig` contém o entrypoint correto
4. Rebuild: `flutter build ios --debug`

### Problema: Scheme não aparece

**Solução:**
1. Verifique se o scheme está em `xcuserdata` ou `xcshareddata`
2. Para compartilhar schemes: mova para `xcshareddata/xcschemes/`

### Problema: Pre-action não executa

**Solução:**
1. Verifique se o script tem permissão de execução
2. Confirme que "Provide build settings from" está configurado para "Runner"

---

## 📁 Arquivos Importantes

```
ios/
├── Runner.xcodeproj/
│   ├── xcshareddata/xcschemes/
│   │   └── Runner.xcscheme          # Scheme padrão (compartilhado)
│   └── xcuserdata/.../xcschemes/
│       ├── Runner-Staging.xcscheme  # Scheme staging (local)
│       └── Runner-Prod.xcscheme     # Scheme produção (local)
└── Flutter/
    └── flutter_env.xcconfig         # Variáveis de ambiente Flutter

lib/
├── core/config/
│   ├── api_config.dart              # Configuração de API
│   └── flavor_config.dart           # Configuração de Flavors
├── main.dart                        # Entrypoint padrão
├── main_staging.dart                # Entrypoint staging
└── main_prod.dart                   # Entrypoint produção
```

---

## ✅ Checklist de Validação

Antes de um release, verifique:

- [ ] `flutter_env.xcconfig` aponta para o entrypoint correto
- [ ] Console mostra a URL base esperada
- [ ] Nome do app (appName) corresponde ao ambiente
- [ ] Requisições vão para o servidor correto

---

*Documentação atualizada em: 2026-01-28*
