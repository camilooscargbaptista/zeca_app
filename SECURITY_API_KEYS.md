# 🔒 Segurança: Configuração de Chaves de API

## ⚠️ Problema Detectado

O GitGuardian detectou que a chave da API do Google Maps estava exposta no repositório.

## ✅ Solução Implementada

1. **Chave removida dos arquivos commitados**
2. **Sistema de configuração segura implementado**
3. **Arquivos sensíveis adicionados ao `.gitignore`**

## 📋 Como Configurar

### Opção 1: Variável de Ambiente (Recomendado)

```bash
export GOOGLE_MAPS_API_KEY=sua_chave_aqui
flutter run
```

### Opção 2: Arquivo Local (Desenvolvimento)

1. Copie o arquivo de exemplo:
```bash
cp lib/core/config/api_keys.local.dart.example lib/core/config/api_keys.local.dart
```

2. Edite `lib/core/config/api_keys.local.dart` e adicione sua chave:
```dart
class LocalApiKeys {
  static const String googleMapsApiKey = 'SUA_CHAVE_AQUI';
}
```

3. Atualize `lib/core/config/api_keys.dart` para usar o arquivo local:
```dart
// Adicione no início do arquivo:
import 'api_keys.local.dart' as local;

// E no método googleMapsApiKey, adicione:
try {
  return LocalApiKeys.googleMapsApiKey;
} catch (e) {
  // Continuar com outras opções
}
```

### Opção 3: Arquivos Nativos (Android/iOS)

Para builds de produção, substitua os placeholders:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_CHAVE_AQUI" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>GMSApiKey</key>
<string>SUA_CHAVE_AQUI</string>
```

## 🗑️ Remover do Histórico do Git

A chave ainda está no histórico do Git. Para removê-la completamente:

### Método 1: git filter-branch (Git nativo)

```bash
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch android/app/src/main/AndroidManifest.xml ios/Runner/Info.plist lib/core/services/places_service.dart lib/core/services/directions_service.dart PLACES_AUTOCOMPLETE_SETUP.md" \
  --prune-empty --tag-name-filter cat -- --all

# Forçar push (CUIDADO: isso reescreve o histórico)
git push origin --force --all
```

### Método 2: BFG Repo-Cleaner (Mais rápido)

1. Instale BFG: `brew install bfg` (Mac) ou baixe de https://rtyley.github.io/bfg-repo-cleaner/
2. Crie um arquivo `keys.txt` com a chave:
```
AIzaSyCTlAYLa9K04yfP65Qjg83vqoXhjee5Z2Q
```
3. Execute:
```bash
bfg --replace-text keys.txt
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git push origin --force --all
```

### Método 3: Rotacionar a Chave (Mais Seguro)

1. No Google Cloud Console, crie uma nova API key
2. Revogue a chave antiga
3. Use a nova chave nas configurações
4. O histórico antigo ainda terá a chave antiga, mas ela estará inválida

## 📝 Checklist de Segurança

- [x] Chave removida dos arquivos commitados
- [x] Sistema de configuração segura implementado
- [x] Arquivos sensíveis no `.gitignore`
- [ ] Chave removida do histórico do Git (escolha um método acima)
- [ ] Restrições de API Key configuradas no Google Cloud Console
- [ ] Nova chave criada e antiga revogada (se rotacionar)

## 🔐 Restrições Recomendadas no Google Cloud Console

1. **Application restrictions**:
   - Android: Package name + SHA-1
   - iOS: Bundle ID

2. **API restrictions**:
   - Apenas: Places API, Directions API, Geocoding API

3. **Quotas**:
   - Configure limites diários para evitar custos inesperados

