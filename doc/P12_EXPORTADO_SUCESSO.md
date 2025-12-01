# ✅ Certificado P12 Exportado com Sucesso!

**Parabéns!** Você conseguiu exportar o certificado como `.p12`! 🎉

---

## 📁 Arquivo Criado

**Localização:** `~/Documentos/camilo/ZECA/keys/zeca-distribution-cert.p12`

---

## 🚀 Próximos Passos

### 1️⃣ Gerar Base64 do P12

Execute o script:

```bash
./scripts/gerar-base64-p12.sh
```

O script vai:
- ✅ Encontrar o arquivo P12 automaticamente
- ✅ Gerar o base64
- ✅ Copiar para o clipboard
- ✅ Mostrar um resumo completo

**Ou manualmente:**

```bash
base64 -i ~/Documentos/camilo/ZECA/keys/zeca-distribution-cert.p12 | pbcopy
```

---

### 2️⃣ Anotar a Senha do P12

**⚠️ IMPORTANTE:** Anote a senha que você definiu ao exportar o certificado!

Esta senha será usada no secret `IOS_P12_PASSWORD` no GitHub.

---

### 3️⃣ Configurar no GitHub

Acesse: **GitHub → Settings → Secrets → Actions**

Adicione os secrets do iOS:

1. **`IOS_P12_CERTIFICATE_BASE64`**
   - Valor: Cole o base64 (já está no clipboard após executar o script)

2. **`IOS_P12_PASSWORD`**
   - Valor: A senha que você definiu ao exportar

3. **`APPSTORE_ISSUER_ID`**
   - Valor: Obter na página de Keys do App Store Connect
   - Ainda falta obter este valor

4. **`APPSTORE_API_KEY_ID`**
   - Valor: `ZX75XKMJ33` (já temos)

5. **`APPSTORE_API_PRIVATE_KEY`**
   - Valor: Já copiado em `/tmp/zeca-p8-content.txt`
   - Para copiar: `cat /tmp/zeca-p8-content.txt | pbcopy`

---

## 📋 Checklist iOS

- [x] Certificado P12 exportado ✅
- [ ] Base64 do P12 gerado (execute o script)
- [ ] Senha do P12 anotada
- [ ] `IOS_P12_CERTIFICATE_BASE64` configurado no GitHub
- [ ] `IOS_P12_PASSWORD` configurado no GitHub
- [ ] `APPSTORE_ISSUER_ID` obtido e configurado
- [x] `APPSTORE_API_KEY_ID` - `ZX75XKMJ33` ✅
- [x] `APPSTORE_API_PRIVATE_KEY` - Pronto ✅

---

## 🎯 O que Falta

### iOS:
- [ ] Obter **Issuer ID** do App Store Connect
- [ ] Gerar base64 do P12 (execute o script)
- [ ] Configurar secrets no GitHub

### Android:
- [ ] Criar **Service Account** no Google Cloud
- [ ] Configurar secret `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

---

## 💡 Comandos Úteis

```bash
# Gerar base64 do P12
./scripts/gerar-base64-p12.sh

# Ou manualmente
base64 -i ~/Documentos/camilo/ZECA/keys/zeca-distribution-cert.p12 | pbcopy

# Verificar se o arquivo existe
ls -lh ~/Documentos/camilo/ZECA/keys/zeca-distribution-cert.p12
```

---

**Próximo passo:** Execute `./scripts/gerar-base64-p12.sh` para gerar o base64! 🚀

