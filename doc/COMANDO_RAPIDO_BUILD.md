# ⚡ Comando Rápido: Build Android

## 🚀 **Um único comando faz tudo:**

```bash
./scripts/build-and-upload.sh
```

**Isso vai:**
1. ✅ Verificar ambiente
2. ✅ Criar `key.properties` automaticamente (recupera do GitHub Secrets)
3. ✅ Limpar build anterior
4. ✅ Obter dependências
5. ✅ Gerar AAB assinado
6. ✅ Abrir Play Console
7. ✅ Mostrar instruções de upload

---

## 📋 **O que você precisa fazer:**

**Apenas 2 coisas:**

1. **Executar o comando:**
   ```bash
   ./scripts/build-and-upload.sh
   ```

2. **Fazer upload na Play Console:**
   - O script abre a Play Console automaticamente
   - Arraste o arquivo AAB que aparece no Finder
   - Preencha as notas da versão
   - Publique

---

## 🎯 **Scripts Disponíveis:**

### `build-and-upload.sh` (RECOMENDADO)
Faz tudo: build + preparação para upload

### `build-android-release.sh`
Apenas gera o build (sem abrir Play Console)

### `upload-play-store.sh`
Apenas prepara para upload (se o build já existe)

---

## ⚙️ **Automações Incluídas:**

- ✅ Recupera credenciais do GitHub Secrets automaticamente
- ✅ Cria `key.properties` automaticamente
- ✅ Verifica versão do `pubspec.yaml`
- ✅ Limpa e obtém dependências
- ✅ Gera AAB assinado
- ✅ Abre Play Console no navegador
- ✅ Abre localização do arquivo no Finder
- ✅ Mostra instruções passo a passo

---

## 🔧 **Se precisar criar key.properties manualmente:**

```bash
./scripts/criar-key-properties.sh
```

---

**Última atualização:** 2025-01-27

