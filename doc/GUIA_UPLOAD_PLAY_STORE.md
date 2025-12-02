# 📤 Guia: Upload de Versão na Google Play Store

## 🎯 Onde Fazer Upload

Você está na tela correta! Na tela de **"Produção"** que você está vendo:

1. **Clique no botão:** `Criar nova versão` (botão cinza no topo direito)
2. Isso abrirá a tela de criação de release

---

## 📋 Passo a Passo Completo

### **Passo 1: Criar Nova Versão**

1. Na tela de **"Produção"**, clique em **"Criar nova versão"**
2. Você será direcionado para a tela de criação de release

### **Passo 2: Upload do AAB**

Na nova tela, você verá:

1. **Seção "Artefatos do app"**
   - Clique em **"Fazer upload"** ou **"Upload"**
   - Selecione o arquivo: `build/app/outputs/bundle/release/app-release.aab`
   - Aguarde o upload completar (pode levar alguns minutos)

### **Passo 3: Preencher Informações da Release**

Após o upload, preencha:

1. **Nome da versão:**
   - Exemplo: `1.0.3`
   - (Use a versão do `pubspec.yaml`)

2. **Notas da versão:**
   - Descreva as mudanças desta versão
   - Exemplo:
   ```
   Versão 1.0.3
   
   ✨ Melhorias:
   - Correção da tela branca no iOS
   - Melhorias na estabilidade do app
   - Otimizações de performance
   
   🔧 Ajustes:
   - Interface simplificada
   - Melhorias na experiência do usuário
   ```

### **Passo 4: Revisar e Enviar**

1. Revise todas as informações
2. Verifique se o AAB foi carregado corretamente
3. Clique em **"Revisar release"** (no final da página)
4. Na tela de revisão, clique em **"Iniciar rollout para Produção"**

---

## 🚨 Importante: Revisão da Google

Após enviar:

1. **Status inicial:** "Em revisão" (pode levar de algumas horas a alguns dias)
2. **Aprovação:** Você receberá uma notificação quando for aprovado
3. **Publicação:** O app será publicado automaticamente após aprovação

---

## 📍 Caminho Completo na Play Console

```
Google Play Console
  └─ Testar e lançar
      └─ Produção
          └─ [Criar nova versão] ← CLIQUE AQUI
              └─ Upload AAB
              └─ Preencher informações
              └─ Revisar release
              └─ Iniciar rollout
```

---

## ✅ Checklist Antes de Enviar

- [ ] AAB gerado e testado localmente
- [ ] Versão incrementada no `pubspec.yaml`
- [ ] AAB assinado corretamente (não debug)
- [ ] Notas da versão preenchidas
- [ ] Screenshots adicionados (se necessário)
- [ ] Políticas da Play Store atendidas
- [ ] Informações de contato atualizadas

---

## 🔍 Onde Está o Botão "Criar nova versão"

Na tela atual que você está vendo:

- **Localização:** Topo direito da tela, ao lado do seletor de dispositivos
- **Cor:** Botão cinza
- **Texto:** "Criar nova versão"

---

## 📝 Notas da Versão (Template)

Use este template para as notas da versão:

```
Versão 1.0.3

✨ Melhorias:
- Correção da tela branca no iOS
- Melhorias na estabilidade do app
- Otimizações de performance
- Correções de bugs menores

🔧 Ajustes:
- Interface simplificada
- Ocultação das opções "Iniciar Viagem" e "Checklist"
- Melhorias na experiência do usuário
- Correções de navegação

🔒 Segurança:
- Melhorias no tratamento de erros
- Correções de inicialização
```

---

## 🎯 Resumo Rápido

1. **Clique em:** "Criar nova versão" (botão cinza no topo)
2. **Faça upload do:** `app-release.aab`
3. **Preencha:** Nome da versão e notas
4. **Revise e envie:** "Iniciar rollout para Produção"

---

**Última atualização:** 2025-01-27

