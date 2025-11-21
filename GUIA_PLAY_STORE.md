# 🚀 Guia Completo: Deploy na Google Play Store

## 📋 Índice
1. [Pré-requisitos](#pré-requisitos)
2. [Criar Conta e App na Play Console](#criar-conta-e-app)
3. [Gerar App Bundle (AAB)](#gerar-app-bundle)
4. [Configurar App na Play Console](#configurar-app)
5. [Fazer Upload e Publicar](#upload-e-publicar)
6. [Checklist Completo](#checklist)

---

## 🔧 Pré-requisitos

### 1. Conta Google Play Developer
- **Custo:** Taxa única de $25 USD (válida para sempre)
- **Acesso:** https://play.google.com/console
- **Requisitos:**
  - Conta Google
  - Cartão de crédito para pagar a taxa
  - Documentos de identidade (pode ser solicitado)

### 2. Informações do App
- **Package Name:** `com.zeca.app` (já configurado)
- **Versão Atual:** 1.0.3+32 (verificar em `pubspec.yaml`)
- **Nome do App:** ZECA App
- **Descrição:** Sistema de abastecimento corporativo

---

## 🆕 Criar Conta e App na Play Console

### Passo 1: Acessar Play Console
1. Acesse: **https://play.google.com/console**
2. Faça login com sua conta Google
3. Se for a primeira vez, aceite os termos e pague a taxa de $25 USD

### Passo 2: Criar Novo App
1. No dashboard, clique em **"Criar app"** ou **"Create app"**
2. Preencha os dados:
   - **Nome do app:** ZECA App
   - **Idioma padrão:** Português (Brasil)
   - **Tipo de app:** App
   - **Gratuito ou pago:** Gratuito
   - **Declaração de conformidade:** Marque as opções aplicáveis
3. Clique em **"Criar app"**

### Passo 3: Configurar Informações Básicas
1. Vá em **Política e programas** → **Política de conteúdo**
2. Complete o questionário sobre o conteúdo do app
3. Vá em **Configuração do app** → **Detalhes do app**

---

## 📦 Gerar App Bundle (AAB)

### Opção 1: Build Automático (Recomendado)

```bash
cd /Users/camilooscargirardellibaptista/Documentos/camilo/ZECA/zeca_app

# Limpar builds anteriores
flutter clean

# Gerar App Bundle
flutter build appbundle --release
```

O arquivo será gerado em:
```
build/app/outputs/bundle/release/app-release.aab
```

### Opção 2: Build com Versão Específica

```bash
# Atualizar versão no pubspec.yaml primeiro
# Depois:
flutter build appbundle --release
```

### Verificar o AAB Gerado

```bash
# Verificar tamanho e localização
ls -lh build/app/outputs/bundle/release/app-release.aab

# Verificar informações do bundle
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=test.apks --mode=universal
```

---

## ⚙️ Configurar App na Play Console

### 1. Configuração do App (App Settings)

**Acesse:** Play Console → Seu App → **Configuração do app** → **Detalhes do app**

#### Informações Básicas:
- **Nome do app:** ZECA App
- **Descrição curta:** (até 80 caracteres)
  - Exemplo: "Sistema de abastecimento corporativo para gestão de frotas"
- **Descrição completa:** (até 4000 caracteres)
  - Descreva todas as funcionalidades do app
- **URL do site:** https://www.abastecacomzeca.com.br
- **Email de suporte:** (seu email de suporte)
- **Telefone de suporte:** (opcional)

#### Categoria:
- **Categoria principal:** Negócios ou Produtividade
- **Categoria secundária:** (opcional)

#### Classificação de conteúdo:
- Complete o questionário sobre conteúdo do app

### 2. Política de Privacidade

**Acesse:** **Configuração do app** → **Política de privacidade**

- **URL da política:** https://www.abastecacomzeca.com.br/politica-privacidade
- Ou crie uma página com a política de privacidade

### 3. Preços e Distribuição

**Acesse:** **Configuração do app** → **Preços e distribuição**

- **Países/regiões:** Selecione onde o app estará disponível
- **Preço:** Gratuito
- **Conteúdo do app:** Complete o questionário
- **Declarações de conformidade:** Marque as opções aplicáveis

### 4. Assets do App

**Acesse:** **Crescer** → **Store presence** → **Principais assets**

#### Ícone do App:
- **Tamanho:** 512x512 pixels (PNG, sem transparência)
- **Localização:** `android/app/src/main/res/mipmap-xxx/ic_launcher.png`

#### Imagens Promocionais:

**Banner de destaque:**
- **Tamanho:** 1024x500 pixels (JPG ou PNG 24 bits)
- **Obrigatório:** Não, mas recomendado

**Capturas de tela:**
- **Mínimo:** 2 screenshots
- **Recomendado:** 4-8 screenshots
- **Tamanhos necessários:**
  - **Telefone:** 320px - 3840px (largura ou altura)
  - **Tablet (7"):** 320px - 3840px
  - **Tablet (10"):** 320px - 3840px

**Como gerar screenshots:**
```bash
# Usar emulador Android ou dispositivo físico
# Tirar screenshots das principais telas do app
```

**Vídeo promocional:**
- **Opcional:** Mas recomendado
- **Duração:** 30 segundos a 2 minutos
- **Formato:** YouTube (link) ou upload direto

### 5. Classificação de Conteúdo

**Acesse:** **Política e programas** → **Classificação de conteúdo**

Complete o questionário sobre:
- Violência
- Conteúdo sexual
- Linguagem
- Drogas
- Etc.

---

## 📤 Fazer Upload e Publicar

### Passo 1: Criar Versão de Produção

1. Acesse: **Produção** → **Criar nova versão**
2. Preencha:
   - **Nome da versão:** 1.0.3 (ou a versão atual)
   - **Notas da versão:** Descreva as mudanças desta versão
     - Exemplo: "Versão inicial do ZECA App com funcionalidades de abastecimento e gestão de jornadas"

### Passo 2: Fazer Upload do AAB

1. Na página de criação de versão, clique em **"Fazer upload do arquivo .aab ou .apk"**
2. Selecione o arquivo: `build/app/outputs/bundle/release/app-release.aab`
3. Aguarde o upload completar (pode levar alguns minutos)
4. O Google Play irá validar o arquivo automaticamente

### Passo 3: Revisar e Publicar

1. Após o upload, revise todas as informações:
   - ✅ Versão correta
   - ✅ Notas da versão preenchidas
   - ✅ Assets configurados
   - ✅ Política de privacidade linkada
   - ✅ Classificação de conteúdo completa

2. Clique em **"Revisar versão"**

3. Se tudo estiver OK, clique em **"Iniciar lançamento para produção"**

4. **Atenção:** Na primeira publicação, você precisará:
   - Completar TODOS os campos obrigatórios
   - Aguardar revisão do Google (pode levar de horas a dias)

### Passo 4: Aguardar Revisão

- **Primeira publicação:** 1-7 dias (geralmente 2-3 dias)
- **Atualizações:** Algumas horas a 1 dia
- Você receberá um email quando o app for aprovado ou se houver problemas

---

## ✅ Checklist Completo

### Antes de Publicar

#### Informações do App:
- [ ] Nome do app definido
- [ ] Descrição curta (até 80 caracteres)
- [ ] Descrição completa (até 4000 caracteres)
- [ ] URL do site configurada
- [ ] Email de suporte configurado
- [ ] Categoria selecionada

#### Assets:
- [ ] Ícone do app (512x512px)
- [ ] Mínimo 2 screenshots (recomendado 4-8)
- [ ] Screenshots para diferentes tamanhos de tela (se aplicável)
- [ ] Banner de destaque (opcional, mas recomendado)

#### Políticas:
- [ ] Política de privacidade criada e linkada
- [ ] Classificação de conteúdo completa
- [ ] Questionário de política de conteúdo respondido

#### Build:
- [ ] App Bundle (AAB) gerado
- [ ] Versão atualizada no `pubspec.yaml`
- [ ] Build testado localmente
- [ ] API configurada para produção

#### Configurações Técnicas:
- [ ] Package name: `com.zeca.app`
- [ ] Versão code incrementado
- [ ] Signing configurado (atualmente usando debug, mas para produção precisa de release key)

---

## 🔐 Configurar Assinatura para Produção

**⚠️ IMPORTANTE:** Atualmente o app está usando `signingConfig signingConfigs.debug`. Para produção, você precisa criar uma chave de assinatura.

### Criar Keystore:

```bash
cd android
keytool -genkey -v -keystore zeca-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias zeca-key
```

### Configurar build.gradle:

Edite `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... código existente ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Criar key.properties:

Crie `android/key.properties` (NÃO commite este arquivo!):

```properties
storePassword=sua_senha_aqui
keyPassword=sua_senha_aqui
keyAlias=zeca-key
storeFile=zeca-release-key.jks
```

### Adicionar ao .gitignore:

```bash
echo "android/key.properties" >> .gitignore
echo "android/*.jks" >> .gitignore
```

---

## 📍 URLs Importantes

- **Play Console:** https://play.google.com/console
- **Dashboard:** https://play.google.com/console/u/0/developers
- **Documentação:** https://support.google.com/googleplay/android-developer

---

## 🆘 Troubleshooting

### Erro: "Upload failed"
- Verifique se o AAB foi gerado corretamente
- Verifique o tamanho do arquivo (não pode exceder 150MB)
- Tente fazer upload novamente

### Erro: "Version code already used"
- Incremente o `versionCode` no `pubspec.yaml`
- Gere um novo AAB

### Erro: "Missing privacy policy"
- Crie uma página com a política de privacidade
- Adicione o link na configuração do app

### App rejeitado
- Verifique o email do Google Play
- Corrija os problemas apontados
- Reenvie o app

---

## 📊 Após Publicar

### Monitorar:
- **Estatísticas:** Play Console → **Estatísticas**
- **Avaliações:** Play Console → **Avaliações e comentários**
- **Crashs:** Play Console → **Qualidade** → **Android vitals**

### Atualizar App:
1. Atualize a versão no `pubspec.yaml`
2. Gere novo AAB: `flutter build appbundle --release`
3. Faça upload na Play Console
4. Publique a atualização

---

## 📝 Notas Importantes

1. **Primeira publicação:** Pode levar vários dias para revisão
2. **Assinatura:** Guarde a chave de assinatura em local seguro! Sem ela, não poderá atualizar o app
3. **Versão:** Sempre incremente o `versionCode` para cada nova versão
4. **Testes:** Considere usar **Track Interno** ou **Track Fechado** para testar antes de publicar em produção

---

## 🎯 Próximos Passos

Após a primeira publicação:
1. Configure **Track Interno** para testes
2. Configure **Track Fechado** para beta testers
3. Monitore estatísticas e avaliações
4. Planeje atualizações regulares

---

**Última atualização:** 2025-11-21
**Versão do app:** 1.0.3+32

