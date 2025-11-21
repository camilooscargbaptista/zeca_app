# Guia Completo - App Store Connect

## 📋 Informações do App

### Dados que você já preencheu:
- **Nome:** Abasteca com Zeca
- **ID do Pacote:** com.abasteca.zeca
- **Idioma Principal:** Português (Brasil)
- **SKU:** (preencher)
- **Acesso:** Acesso total

---

## 🚀 Ferramenta Recomendada: Fastlane

**Fastlane** é a melhor ferramenta para automatizar o processo de publicação na App Store.

### O que Fastlane pode fazer automaticamente:
- ✅ Capturar screenshots
- ✅ Gerar metadados
- ✅ Fazer upload do build
- ✅ Gerenciar versões
- ✅ Enviar para revisão

### O que ainda precisa fazer manualmente:
- ⚠️ Primeira configuração inicial
- ⚠️ Preencher descrição do app
- ⚠️ Adicionar screenshots (ou usar Fastlane para capturar)
- ⚠️ Configurar preços e disponibilidade

---

## 📝 Checklist - App Store Connect

### 1. Informações do App (já feito parcialmente)
- [x] Nome: Abasteca com Zeca
- [x] ID do Pacote: com.abasteca.zeca
- [x] Idioma: Português (Brasil)
- [ ] SKU: `zeca-app-ios` (preencher)
- [ ] Acesso: Acesso total (selecionar)

### 2. Versão 1.0 - Informações

#### Categoria Principal
- **Categoria:** Negócios ou Utilidades
- **Subcategoria:** (opcional)

#### Classificação de Conteúdo
- **Idade:** 4+ (ou 12+ se necessário)

#### Informações de Contato
- **Email de Suporte:** (seu email)
- **URL de Suporte:** (se tiver site)
- **URL de Marketing:** (opcional)

#### Informações de Privacidade
- **URL de Política de Privacidade:** (obrigatório)
- **Tipo de Conta:** (se aplicável)

### 3. Versão 1.0 - Preços e Disponibilidade

#### Preço
- **Gratuito:** Sim (marcar)
- Ou definir preço se for pago

#### Disponibilidade
- **Todos os países:** (recomendado)
- Ou selecionar países específicos

### 4. Versão 1.0 - Preparação para Envio

#### Screenshots (Obrigatório)
- **iPhone 6.7" (iPhone 14 Pro Max):** 1290 x 2796 pixels
- **iPhone 6.5" (iPhone 11 Pro Max):** 1242 x 2688 pixels
- **iPhone 5.5" (iPhone 8 Plus):** 1242 x 2208 pixels
- **iPad Pro 12.9":** 2048 x 2732 pixels

**Quantidade:** Mínimo 3 screenshots por tamanho

#### Descrição do App
```
Abasteça com Zeca - A forma mais fácil de gerenciar seus abastecimentos

O Abasteça com Zeca é o aplicativo ideal para motoristas e transportadoras que precisam controlar e validar abastecimentos de forma rápida e segura.

PRINCIPAIS FUNCIONALIDADES:
• Geração de códigos únicos para abastecimento
• Validação em tempo real pelos postos
• Registro automático de dados do abastecimento
• Confirmação e validação pelo motorista
• Histórico completo de abastecimentos
• Notificações push para atualizações

FACILIDADE E SEGURANÇA:
• Interface intuitiva e fácil de usar
• Validação segura de dados
• Registro preciso de quilometragem e litros
• Suporte para múltiplos tipos de combustível

Ideal para motoristas profissionais, transportadoras e empresas que precisam de controle total sobre seus abastecimentos.
```

#### Palavras-chave
```
abastecimento,combustível,posto,gasolina,diesel,transporte,motorista,quilometragem,controle
```
(Máximo 100 caracteres, separadas por vírgula)

#### URL de Suporte
```
https://www.abastecacomzeca.com.br/suporte
```
(ou sua URL de suporte)

#### URL de Marketing
```
https://www.abastecacomzeca.com.br
```

#### Política de Privacidade
```
https://www.abastecacomzeca.com.br/privacidade
```
(Obrigatório!)

### 5. Versão 1.0 - Informações de Build

#### Build para Enviar
- Aguardar build ser processado após upload
- Selecionar o build na lista

#### Informações de Exportação de Conformidade
- **Usa criptografia:** Sim (geralmente sim para apps modernos)
- **Usa criptografia de exportação:** Não (na maioria dos casos)

#### Informações de Publicidade
- **Este app contém publicidade:** Não (marcar se não tiver)

#### Informações de Conteúdo Gerado pelo Usuário
- **Contém conteúdo gerado pelo usuário:** Não (marcar se não tiver)

---

## 🛠️ Configuração Rápida com Scripts

### Versão e Build Number

No arquivo `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
- `1.0.0` = versão do app (mostrada na App Store)
- `+1` = build number (incrementa a cada build)

### Script para Build e Upload

Posso criar scripts que:
1. Incrementam automaticamente o build number
2. Fazem o build do app
3. Preparam para upload

---

## 📦 Próximos Passos

1. **Preencher SKU:** `zeca-app-ios`
2. **Selecionar:** Acesso total
3. **Criar o app** no App Store Connect
4. **Preparar screenshots** (mínimo 3 por tamanho)
5. **Preencher descrição** (usar template acima)
6. **Configurar URLs** de suporte e privacidade
7. **Fazer build** e upload via Xcode ou Fastlane

---

## 💡 Dica: Fastlane Setup

Quer que eu configure o Fastlane para automatizar?
- Captura de screenshots
- Upload automático
- Gerenciamento de versões

Posso criar a configuração completa!






