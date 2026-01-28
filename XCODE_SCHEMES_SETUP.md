# Configuração de Xcode Schemes para Multi-Ambiente

## Visão Geral

Arquivos criados:
- `lib/main_staging.dart` → Entry point para Staging
- `lib/main_prod.dart` → Entry point para Produção
- `ios/Flutter/Staging.xcconfig` → Config Xcode para Staging
- `ios/Flutter/Prod.xcconfig` → Config Xcode para Produção

---

## Passo a Passo no Xcode

### 1. Abrir o Projeto
```bash
open ios/Runner.xcworkspace
```

### 2. Criar Scheme "Staging"

1. **Product → Scheme → Manage Schemes...**
2. Selecione "Runner" e clique em **Duplicate**
3. Renomeie para **"Runner-Staging"**
4. Clique em **Edit** no scheme criado
5. Em **Build → Pre-actions**, clique no **+** e escolha **"New Run Script Action"**
6. Cole este script:

```bash
echo "FLUTTER_TARGET=lib/main_staging.dart" > "${SRCROOT}/Flutter/flutter_env.xcconfig"
```

7. Em "Provide build settings from", escolha **"Runner"**
8. Clique **Close**

### 3. Criar Scheme "Prod"

1. **Product → Scheme → Manage Schemes...**
2. Selecione "Runner" e clique em **Duplicate**
3. Renomeie para **"Runner-Prod"**
4. Clique em **Edit** no scheme criado
5. Em **Build → Pre-actions**, clique no **+** e escolha **"New Run Script Action"**
6. Cole este script:

```bash
echo "FLUTTER_TARGET=lib/main_prod.dart" > "${SRCROOT}/Flutter/flutter_env.xcconfig"
```

7. Em "Provide build settings from", escolha **"Runner"**
8. Clique **Close**

### 4. Incluir o xcconfig (ORDEM IMPORTANTE!)

> ⚠️ O `flutter_env.xcconfig` deve vir **POR ÚLTIMO** para sobrescrever o `Generated.xcconfig`!

Edite `ios/Flutter/Debug.xcconfig`:
```
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
#include "Generated.xcconfig"
#include? "flutter_env.xcconfig"
```

Edite `ios/Flutter/Release.xcconfig`:
```
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include "Generated.xcconfig"
#include? "flutter_env.xcconfig"
```

### 5. Adicionar ao .gitignore

```
ios/Flutter/flutter_env.xcconfig
```

---

## Como Usar

| Para | Selecione o Scheme | App Name |
|------|-------------------|----------|
| **TestFlight/Beta** | Runner-Staging | ZECA STG |
| **App Store** | Runner-Prod | ZECA |

No Xcode, basta selecionar o scheme desejado e fazer o build normalmente.

---

## URLs por Ambiente

| Ambiente | URL |
|----------|-----|
| Staging | `https://stg.abastecacomzeca.com.br` |
| Produção | `https://www.abastecacomzeca.com.br` |

---

## Indicadores Visuais no App

### Banner "STAGING" (Automático)
- Aparece automaticamente no canto superior direito
- Cor laranja para Staging, vermelho para Dev
- **Não aparece em produção**

### Nome do App no Telefone
| Ambiente | Nome exibido |
|----------|-------------|
| Staging | **ZECA STG** |
| Prod | **ZECA** |

---

## Ícone Diferenciado para Staging (Opcional)

Para ter ícones diferentes por ambiente:

### 1. Criar ícone staging
- Criar versão do ícone com badge "STG" ou borda laranja
- Salvar em `ios/Runner/Assets.xcassets/AppIcon-Staging.appiconset/`

### 2. Configurar no Xcode
1. Em Runner → Assets.xcassets, criar novo App Icon Set chamado "AppIcon-Staging"
2. Adicionar os ícones staging
3. No Build Settings do Target, para o Configuration "Debug" e "Release":
   - Procure "Asset Catalog App Icon Set Name"
   - Configure para usar "AppIcon-Staging" quando for scheme staging

**Dica:** Use ferramenta online como makeappicon.com para gerar todos os tamanhos.

