# 🧠 ZECA APP BRAIN - Base de Conhecimento

> **"Conhecimento compartilhado é poder multiplicado."**

---

## 📂 ESTRUTURA

| Arquivo | Conteúdo | Quando Consultar |
|---------|----------|------------------|
| **LESSONS-LEARNED.md** | Erros → Regras | ⭐ SEMPRE (primeiro!) |
| **FLUTTER-GUIDE.md** | Guia completo Flutter | Criar qualquer código |
| **CLEAN-ARCHITECTURE.md** | Arquitetura do projeto | Criar nova feature |
| **BLOC-PATTERNS.md** | Padrões de BLoC | Criar/modificar BLoC |

---

## 🚨 REGRA DE OURO

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🧠 EU NÃO SEI NADA. EU CONSULTO O BRAIN.                      ║
║                                                                  ║
║   Antes de TUDO → LESSONS-LEARNED.md                            ║
║   Nova feature → CLEAN-ARCHITECTURE.md                          ║
║   Código Dart → FLUTTER-GUIDE.md                                ║
║   Estado/BLoC → BLOC-PATTERNS.md                                ║
║                                                                  ║
║   SE NÃO ENCONTRO → BUSCO FEATURE SIMILAR (auth é referência)   ║
║   SE NÃO SEI → NÃO INVENTO                                      ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🔍 FEATURE DE REFERÊNCIA

A feature `auth` é a mais completa e bem estruturada. Use como referência:

```bash
# Ver estrutura
find lib/features/auth -type f -name "*.dart" | grep -v ".freezed\|.g.dart"

# Copiar estrutura para nova feature
cp -r lib/features/auth lib/features/nova_feature
```

---

## 🔧 COMANDOS ESSENCIAIS

```bash
# Gerar código Freezed/Retrofit
dart run build_runner build --delete-conflicting-outputs

# Analisar código
flutter analyze

# Rodar testes
flutter test
```
