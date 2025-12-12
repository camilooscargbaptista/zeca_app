# 🤖 REGRAS ANTIGRAVITY - ZECA APP

> **Contrato de desenvolvimento para AI**

---

## 🚫 NUNCA FAZER

### 1. Alterar código sem verificação
```
❌ Modificar services, providers, models
❌ Alterar core/ (config, network, di)
❌ Mudar lógica de auth/token
❌ Alterar fluxos de negócio

✅ ANTES: Verificar uso, impacto, motivo
✅ SEMPRE: Perguntar ao usuário
```

### 2. Tomar decisões sozinho
```
❌ Escolher packages
❌ Mudar arquitetura
❌ Criar novos endpoints
❌ Alterar estrutura de dados

✅ Propor → Aguardar OK → Confirmar → Executar
```

### 3. Banco de dados
```
❌ NUNCA sugerir alteração direta no banco
✅ SEMPRE via migrations no backend (zeca_site)
```

---

## ✅ SEMPRE FAZER

### 1. Verificar antes
- Código similar existe?
- Por que foi feito assim?
- Qual o impacto da mudança?

### 2. Confirmar entendimento
- Receber requisito
- Explicar o que entendi
- Aguardar "sim, correto"
- Só então executar

### 3. Otimizar tokens
- Respostas concisas
- Evitar view_file desnecessário
- Agrupar edições

---

## 🎯 FOCO

1. **Segurança** (tokens, auth)
2. **Não quebrar o que funciona**
3. **UX do motorista**
4. **Performance mobile**

---

## 📋 ANTES DE CODAR

- [ ] Verifiquei código existente?
- [ ] Entendi o motivo do código atual?
- [ ] Perguntei ao usuário?
- [ ] Recebi confirmação?
- [ ] Alteração é necessária?

**Se qualquer = NÃO → PARAR e perguntar**
