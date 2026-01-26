# Prompt para Antigravity: Implementar Alterar Senha

## Tarefa: Implementar Funcionalidade de Alterar Senha no App do Motorista

### Contexto
O usuário do ZECA App (motorista) precisa poder alterar sua própria senha através do menu de Configurações. Atualmente, o item "Configurações" no menu lateral apenas mostra "em desenvolvimento".

### ⚠️ INSTRUÇÃO CRÍTICA - ANÁLISE DO BACKEND EXISTENTE
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║   📋 ENDPOINT EXISTENTE ANALISADO:                                           ║
║   `POST /drivers/:cpf/change-password`                                       ║
║                                                                               ║
║   SITUAÇÃO ATUAL:                                                             ║
║   ✅ Endpoint existe e funciona                                               ║
║   ❌ Só permite Admin e Admin de Frota (motorista NÃO pode usar)             ║
║   ❌ Exige senha alfanumérica complexa (8+ chars, maiúscula, especial, etc)  ║
║   ✅ Envia email de notificação                                               ║
║   ✅ Usa JWT para autenticação                                                ║
║                                                                               ║
║   AJUSTES NECESSÁRIOS NO BACKEND:                                             ║
║   1. Criar endpoint `POST /drivers/me/change-password` para self-service     ║
║   2. Permitir senha numérica de 6 dígitos (PIN) para motoristas              ║
║   3. Manter validações de segurança (sem sequências, sem repetição)          ║
║                                                                               ║
║   ARQUIVOS A ALTERAR:                                                         ║
║   - BACKEND: drivers.controller.ts (adicionar endpoint)                      ║
║   - BACKEND: drivers.service.ts (adicionar método)                           ║
║   - BACKEND: criar ChangeOwnPasswordDto.ts (validações PIN 6 dígitos)        ║
║   - FRONTEND: Nova feature change_password                                   ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝

### Análise do Endpoint Existente

**Arquivo:** `zeca_site/backend/src/drivers/drivers.controller.ts` (linhas 307-350)
**Arquivo:** `zeca_site/backend/src/drivers/drivers.service.ts` (linhas 600-680)

**Endpoint atual:** `POST /drivers/:cpf/change-password`
- **Autorização:** Só Admin (`req.user.type === 'admin'`) ou Admin de Frota (`PORTAL_FROTA + ADMINISTRADOR`)
- **DTO:** `ChangeDriverPasswordDto` com validações complexas
- **Regras atuais:** Min 8 chars, maiúscula, minúscula, número, caractere especial

**Por que NÃO usar o existente diretamente:**
1. Motorista não tem permissão (throw `BadRequestException`)
2. Regras de senha são para portal web, não para app (PIN)
3. Endpoint espera CPF na URL, não extrai do token

---

## Comparação: Endpoint Existente vs Novo

| Aspecto | Existente (`/drivers/:cpf/change-password`) | Novo (`/drivers/me/change-password`) |
|---------|---------------------------------------------|--------------------------------------|
| **Quem usa** | Admin / Admin de Frota | Próprio motorista |
| **Identificação** | CPF na URL | userId do token JWT |
| **Tipo de senha** | Alfanumérica complexa (8+ chars) | PIN numérico (6 dígitos) |
| **Validações** | Maiúscula, minúscula, número, especial | Sem sequência, sem repetição |
| **Exige senha atual** | Não | Não (pode adicionar se quiser) |
| **Notifica por email** | Sim | Sim (manter) |
| **Desloga usuário** | Não | Sim (app faz logout após sucesso) |

---

## Git Flow

**Branch:** `feat/alterar-senha-motorista`
**Base:** `develop`
**Commits:** Semânticos
**PR:** Para `develop`

---

## Regras de Senha (Segurança)

### Regras Propostas para Senha Numérica de 6 Dígitos

| Regra | Descrição | Exemplo Válido | Exemplo Inválido |
|-------|-----------|----------------|------------------|
| **Tamanho** | Exatamente 6 dígitos | `123456` | `12345` ou `1234567` |
| **Apenas números** | Somente caracteres 0-9 | `987654` | `12345a` |
| **Sem sequências** | Não permitir sequências crescentes/decrescentes | `159753` | `123456` ou `654321` |
| **Sem repetição total** | Não permitir todos dígitos iguais | `121212` | `111111` ou `000000` |
| **Sem repetição >3** | Máximo 3 dígitos iguais consecutivos | `112233` | `111123` |
| **Diferente da atual** | Nova senha ≠ senha atual | - | - |

### Validações no Frontend

```dart
class PasswordValidator {
  static const int requiredLength = 6;

  /// Valida se é apenas números
  static bool isNumericOnly(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  /// Valida tamanho exato
  static bool hasCorrectLength(String value) {
    return value.length == requiredLength;
  }

  /// Valida se não é sequência crescente (123456, 234567, etc)
  static bool isNotAscendingSequence(String value) {
    if (value.length != requiredLength) return true;
    for (int i = 0; i < value.length - 1; i++) {
      if (int.parse(value[i + 1]) != int.parse(value[i]) + 1) {
        return true;
      }
    }
    return false;
  }

  /// Valida se não é sequência decrescente (654321, 987654, etc)
  static bool isNotDescendingSequence(String value) {
    if (value.length != requiredLength) return true;
    for (int i = 0; i < value.length - 1; i++) {
      if (int.parse(value[i + 1]) != int.parse(value[i]) - 1) {
        return true;
      }
    }
    return false;
  }

  /// Valida se não são todos dígitos iguais (111111, 000000, etc)
  static bool isNotAllSameDigits(String value) {
    if (value.isEmpty) return true;
    return !value.split('').every((c) => c == value[0]);
  }

  /// Valida se não tem mais de 3 dígitos iguais consecutivos
  static bool hasNoMoreThan3ConsecutiveRepeats(String value) {
    if (value.length < 4) return true;
    for (int i = 0; i < value.length - 3; i++) {
      if (value[i] == value[i + 1] &&
          value[i] == value[i + 2] &&
          value[i] == value[i + 3]) {
        return false;
      }
    }
    return true;
  }

  /// Validação completa
  static ValidationResult validate(String password) {
    if (!hasCorrectLength(password)) {
      return ValidationResult(false, 'A senha deve ter exatamente 6 dígitos');
    }
    if (!isNumericOnly(password)) {
      return ValidationResult(false, 'A senha deve conter apenas números');
    }
    if (!isNotAscendingSequence(password)) {
      return ValidationResult(false, 'A senha não pode ser uma sequência crescente (ex: 123456)');
    }
    if (!isNotDescendingSequence(password)) {
      return ValidationResult(false, 'A senha não pode ser uma sequência decrescente (ex: 654321)');
    }
    if (!isNotAllSameDigits(password)) {
      return ValidationResult(false, 'A senha não pode ter todos os dígitos iguais');
    }
    if (!hasNoMoreThan3ConsecutiveRepeats(password)) {
      return ValidationResult(false, 'A senha não pode ter mais de 3 dígitos iguais consecutivos');
    }
    return ValidationResult(true, null);
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult(this.isValid, this.errorMessage);
}
```

---

## BACKEND - Criar Endpoint de Self-Service

### Referência: Endpoint Existente (apenas para contexto)

O endpoint existente `POST /drivers/:cpf/change-password` tem a seguinte estrutura:
- Usa `ChangeDriverPasswordDto` com validações complexas
- Autoriza apenas Admin e Admin de Frota
- Valida senha com regex complexa (8+ chars, maiúscula, minúscula, número, especial)

**NÃO MODIFICAR o endpoint existente** - ele é usado pelo portal web.

### Arquivo: `zeca_site/backend/src/drivers/drivers.controller.ts`

**Adicionar NOVO endpoint após linha 350 (após o endpoint change-password existente):**

```typescript
@Post('me/change-password')
@UseGuards(AuthGuard('jwt'))
@ApiOperation({ summary: 'Alterar senha do próprio motorista' })
@ApiResponse({ status: 200, description: 'Senha alterada com sucesso' })
@ApiResponse({ status: 400, description: 'Dados inválidos' })
@ApiResponse({ status: 401, description: 'Não autorizado' })
async changeOwnPassword(
  @Body() changePasswordDto: ChangeOwnPasswordDto,
  @Request() req: any
): Promise<{ success: boolean; message: string }> {
  const userId = req.user.userId;
  const userType = req.user.type;

  // Apenas motoristas (APP_MOTORISTA) podem usar este endpoint
  if (userType !== 'APP_MOTORISTA') {
    throw new BadRequestException('Este endpoint é exclusivo para motoristas');
  }

  return this.driversService.changeOwnPassword(userId, changePasswordDto);
}
```

### Arquivo: `zeca_site/backend/src/drivers/dto/ChangeOwnPasswordDto.ts` (CRIAR)

```typescript
import { IsString, IsNotEmpty, Length, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class ChangeOwnPasswordDto {
  @ApiProperty({ description: 'Nova senha (6 dígitos numéricos)', example: '159753' })
  @IsString()
  @IsNotEmpty({ message: 'A nova senha é obrigatória' })
  @Length(6, 6, { message: 'A senha deve ter exatamente 6 dígitos' })
  @Matches(/^[0-9]{6}$/, { message: 'A senha deve conter apenas 6 dígitos numéricos' })
  new_password: string;

  @ApiProperty({ description: 'Confirmação da nova senha', example: '159753' })
  @IsString()
  @IsNotEmpty({ message: 'A confirmação de senha é obrigatória' })
  @Length(6, 6, { message: 'A confirmação deve ter exatamente 6 dígitos' })
  confirm_password: string;
}
```

### Arquivo: `zeca_site/backend/src/drivers/drivers.service.ts`

**Adicionar método:**

```typescript
async changeOwnPassword(
  userId: string,
  dto: ChangeOwnPasswordDto
): Promise<{ success: boolean; message: string }> {
  // 1. Validar se senhas coincidem
  if (dto.new_password !== dto.confirm_password) {
    throw new BadRequestException('As senhas não coincidem');
  }

  // 2. Validar regras de segurança da senha
  this.validatePasswordSecurity(dto.new_password);

  // 3. Buscar motorista pelo userId
  const driver = await this.driverRepository.findOne({
    where: { id: userId }
  });

  if (!driver) {
    throw new NotFoundException('Motorista não encontrado');
  }

  // 4. Hash da nova senha
  const hashedPassword = await bcrypt.hash(dto.new_password, 10);

  // 5. Atualizar senha
  driver.password = hashedPassword;
  driver.updated_at = new Date();
  await this.driverRepository.save(driver);

  // 6. Log de auditoria
  this.logger.log(`Senha alterada para motorista ${driver.cpf} (ID: ${userId})`);

  return {
    success: true,
    message: 'Senha alterada com sucesso. Faça login novamente.',
  };
}

private validatePasswordSecurity(password: string): void {
  // Não pode ser sequência crescente
  const isAscending = '0123456789'.includes(password);
  if (isAscending) {
    throw new BadRequestException('A senha não pode ser uma sequência crescente');
  }

  // Não pode ser sequência decrescente
  const isDescending = '9876543210'.includes(password);
  if (isDescending) {
    throw new BadRequestException('A senha não pode ser uma sequência decrescente');
  }

  // Não pode ser todos dígitos iguais
  if (password.split('').every(c => c === password[0])) {
    throw new BadRequestException('A senha não pode ter todos os dígitos iguais');
  }

  // Não pode ter mais de 3 dígitos iguais consecutivos
  for (let i = 0; i < password.length - 3; i++) {
    if (password[i] === password[i + 1] &&
        password[i] === password[i + 2] &&
        password[i] === password[i + 3]) {
      throw new BadRequestException('A senha não pode ter mais de 3 dígitos iguais consecutivos');
    }
  }
}
```

---

## FRONTEND - Nova Feature

### Estrutura de Arquivos a Criar

```
lib/features/change_password/
├── data/
│   └── repositories/
│       └── change_password_repository.dart
├── domain/
│   └── usecases/
│       └── change_password_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── change_password_bloc.dart
    │   ├── change_password_event.dart
    │   └── change_password_state.dart
    ├── pages/
    │   └── change_password_page.dart
    └── widgets/
        └── password_rules_widget.dart
```

### Arquivo: `lib/features/change_password/presentation/pages/change_password_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/common/custom_toast.dart';
import '../bloc/change_password_bloc.dart';
import '../widgets/password_rules_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    context.read<ChangePasswordBloc>().add(
      ChangePasswordValidate(
        password: _passwordController.text,
        confirmPassword: _confirmController.text,
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.zecaBlue),
            const SizedBox(width: 8),
            const Text('Senha Alterada'),
          ],
        ),
        content: const Text(
          'Sua senha foi alterada com sucesso!\n\n'
          'Você será desconectado e precisará fazer login novamente com a nova senha.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ChangePasswordBloc>().add(ChangePasswordLogout());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zecaBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('ENTENDI', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ChangePasswordBloc>().add(
        ChangePasswordSubmit(
          newPassword: _passwordController.text,
          confirmPassword: _confirmController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          _showLogoutConfirmation();
        } else if (state is ChangePasswordError) {
          CustomToast.showError(context, state.message);
        } else if (state is ChangePasswordLoggedOut) {
          context.go('/login');
        }
      },
      builder: (context, state) {
        final isLoading = state is ChangePasswordLoading;
        final validationState = state is ChangePasswordValidated ? state : null;
        final isValid = validationState?.isValid ?? false;
        final passwordsMatch = validationState?.passwordsMatch ?? true;
        final passwordError = validationState?.passwordError;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: AppColors.zecaBlue,
            foregroundColor: Colors.white,
            title: const Text('Alterar Senha'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: isLoading ? null : () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ícone e título
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.zecaBlue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_reset,
                              size: 48,
                              color: AppColors.zecaBlue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Criar Nova Senha',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Digite sua nova senha de 6 dígitos',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Regras de senha
                    const PasswordRulesWidget(),

                    const SizedBox(height: 24),

                    // Campo Nova Senha
                    Text(
                      'Nova Senha',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      onChanged: (_) => _onPasswordChanged(),
                      decoration: InputDecoration(
                        hintText: '••••••',
                        counterText: '',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.zecaBlue, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.error, width: 2),
                        ),
                        errorText: passwordError,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Campo Confirmar Senha
                    Text(
                      'Confirmar Nova Senha',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmController,
                      obscureText: !_showConfirmPassword,
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      onChanged: (_) => _onPasswordChanged(),
                      decoration: InputDecoration(
                        hintText: '••••••',
                        counterText: '',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !passwordsMatch && _confirmController.text.isNotEmpty
                                ? AppColors.error
                                : AppColors.border,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.zecaBlue, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.error, width: 2),
                        ),
                        errorText: !passwordsMatch && _confirmController.text.isNotEmpty
                            ? 'As senhas não coincidem'
                            : null,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Botão Alterar
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isValid && !isLoading ? _onSubmit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.zecaBlue,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'ALTERAR SENHA',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Aviso
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Após alterar a senha, você será desconectado e precisará fazer login novamente.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

### Arquivo: `lib/features/change_password/presentation/widgets/password_rules_widget.dart`

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PasswordRulesWidget extends StatelessWidget {
  const PasswordRulesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.zecaBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Regras de Segurança',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRule('Exatamente 6 dígitos numéricos'),
          _buildRule('Não pode ser sequência (123456 ou 654321)'),
          _buildRule('Não pode ter todos os dígitos iguais (111111)'),
          _buildRule('Máximo 3 dígitos iguais consecutivos'),
        ],
      ),
    );
  }

  Widget _buildRule(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: AppColors.zecaGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Arquivo: `lib/features/change_password/presentation/bloc/change_password_event.dart`

```dart
import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

class ChangePasswordValidate extends ChangePasswordEvent {
  final String password;
  final String confirmPassword;

  const ChangePasswordValidate({
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [password, confirmPassword];
}

class ChangePasswordSubmit extends ChangePasswordEvent {
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordSubmit({
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [newPassword, confirmPassword];
}

class ChangePasswordLogout extends ChangePasswordEvent {}
```

### Arquivo: `lib/features/change_password/presentation/bloc/change_password_state.dart`

```dart
import 'package:equatable/equatable.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordValidated extends ChangePasswordState {
  final bool isValid;
  final bool passwordsMatch;
  final String? passwordError;

  const ChangePasswordValidated({
    required this.isValid,
    required this.passwordsMatch,
    this.passwordError,
  });

  @override
  List<Object?> get props => [isValid, passwordsMatch, passwordError];
}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final String message;

  const ChangePasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChangePasswordError extends ChangePasswordState {
  final String message;

  const ChangePasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChangePasswordLoggedOut extends ChangePasswordState {}
```

### Arquivo: `lib/features/change_password/presentation/bloc/change_password_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/usecases/change_password_usecase.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

@injectable
class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;
  final AuthBloc authBloc;

  ChangePasswordBloc({
    required this.changePasswordUseCase,
    required this.authBloc,
  }) : super(ChangePasswordInitial()) {
    on<ChangePasswordValidate>(_onValidate);
    on<ChangePasswordSubmit>(_onSubmit);
    on<ChangePasswordLogout>(_onLogout);
  }

  void _onValidate(
    ChangePasswordValidate event,
    Emitter<ChangePasswordState> emit,
  ) {
    final password = event.password;
    final confirmPassword = event.confirmPassword;

    // Validar regras
    final validation = _validatePassword(password);
    final passwordsMatch = password == confirmPassword || confirmPassword.isEmpty;

    final isValid = validation.isValid &&
                    passwordsMatch &&
                    password.isNotEmpty &&
                    confirmPassword.isNotEmpty &&
                    password == confirmPassword;

    emit(ChangePasswordValidated(
      isValid: isValid,
      passwordsMatch: passwordsMatch,
      passwordError: password.length == 6 ? validation.errorMessage : null,
    ));
  }

  Future<void> _onSubmit(
    ChangePasswordSubmit event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordLoading());

    final result = await changePasswordUseCase.execute(
      newPassword: event.newPassword,
      confirmPassword: event.confirmPassword,
    );

    result.fold(
      (failure) => emit(ChangePasswordError(message: failure.message)),
      (success) => emit(ChangePasswordSuccess(message: success)),
    );
  }

  void _onLogout(
    ChangePasswordLogout event,
    Emitter<ChangePasswordState> emit,
  ) {
    authBloc.add(LogoutRequested());
    emit(ChangePasswordLoggedOut());
  }

  ValidationResult _validatePassword(String password) {
    if (password.length != 6) {
      return ValidationResult(false, 'A senha deve ter exatamente 6 dígitos');
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(password)) {
      return ValidationResult(false, 'A senha deve conter apenas números');
    }

    // Verificar sequência crescente
    bool isAscending = true;
    for (int i = 0; i < password.length - 1; i++) {
      if (int.parse(password[i + 1]) != int.parse(password[i]) + 1) {
        isAscending = false;
        break;
      }
    }
    if (isAscending) {
      return ValidationResult(false, 'Não pode ser sequência crescente');
    }

    // Verificar sequência decrescente
    bool isDescending = true;
    for (int i = 0; i < password.length - 1; i++) {
      if (int.parse(password[i + 1]) != int.parse(password[i]) - 1) {
        isDescending = false;
        break;
      }
    }
    if (isDescending) {
      return ValidationResult(false, 'Não pode ser sequência decrescente');
    }

    // Verificar todos iguais
    if (password.split('').every((c) => c == password[0])) {
      return ValidationResult(false, 'Não pode ter todos os dígitos iguais');
    }

    // Verificar mais de 3 consecutivos iguais
    for (int i = 0; i < password.length - 3; i++) {
      if (password[i] == password[i + 1] &&
          password[i] == password[i + 2] &&
          password[i] == password[i + 3]) {
        return ValidationResult(false, 'Máximo 3 dígitos iguais consecutivos');
      }
    }

    return ValidationResult(true, null);
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult(this.isValid, this.errorMessage);
}
```

---

## ATUALIZAR: Menu Lateral (AppDrawer)

### Arquivo: `lib/shared/widgets/app_drawer.dart`

**Alterar o item "Configurações" (linhas 175-186):**

**De:**
```dart
_buildMenuItem(
  icon: Icons.settings,
  title: 'Configurações',
  onTap: () {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configurações em desenvolvimento')),
    );
  },
),
```

**Para:**
```dart
_buildMenuItem(
  icon: Icons.lock_reset,
  title: 'Alterar Senha',
  onTap: () {
    Navigator.pop(context);
    context.push('/change-password');
  },
),
```

---

## ATUALIZAR: Router

### Arquivo: `lib/routes/app_router.dart`

**Adicionar import:**
```dart
import '../features/change_password/presentation/pages/change_password_page.dart';
```

**Adicionar rota (após a rota de profile):**
```dart
GoRoute(
  path: '/change-password',
  name: 'change-password',
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<ChangePasswordBloc>(),
    child: const ChangePasswordPage(),
  ),
),
```

---

## ATUALIZAR: API Constants

### Arquivo: `lib/core/constants/api_constants.dart`

**Adicionar:**
```dart
// Driver - Change Password
static const String changeOwnPassword = '/drivers/me/change-password';
```

---

## Resumo das Alterações

| # | Alteração | Arquivo | Tipo | Prioridade |
|---|-----------|---------|------|------------|
| 1 | **Criar endpoint** `/drivers/me/change-password` | `drivers.controller.ts` | 🔴 BACKEND | **CRÍTICA** |
| 2 | **Criar DTO** `ChangeOwnPasswordDto` | `ChangeOwnPasswordDto.ts` | 🔴 BACKEND | **CRÍTICA** |
| 3 | **Criar método** `changeOwnPassword` | `drivers.service.ts` | 🔴 BACKEND | **CRÍTICA** |
| 4 | **Criar feature** change_password completa | `lib/features/change_password/` | FRONTEND | **ALTA** |
| 5 | **Alterar menu** para Alterar Senha | `app_drawer.dart` | FRONTEND | MÉDIA |
| 6 | **Adicionar rota** `/change-password` | `app_router.dart` | FRONTEND | MÉDIA |
| 7 | **Adicionar constante** API | `api_constants.dart` | FRONTEND | BAIXA |

---

## Critérios de Aceite (BDD)

```gherkin
Feature: Alterar Senha do Motorista

  Background:
    Given motorista está logado no app
    And acessa o menu lateral

  @happy-path
  Scenario: Alterar senha com sucesso
    Given motorista clica em "Alterar Senha"
    When digita nova senha "159753"
    And digita confirmação "159753"
    And a senha atende todas as regras
    Then botão "ALTERAR SENHA" deve estar habilitado
    When clica no botão
    Then deve mostrar modal "Senha Alterada"
    And ao clicar "ENTENDI" deve ser deslogado
    And deve ir para tela de login

  @validation
  Scenario: Botão desabilitado quando senhas não coincidem
    Given motorista está na tela de alterar senha
    When digita nova senha "159753"
    And digita confirmação "951357"
    Then deve mostrar erro "As senhas não coincidem"
    And botão "ALTERAR SENHA" deve estar desabilitado

  @validation
  Scenario Outline: Botão desabilitado para senha inválida
    Given motorista está na tela de alterar senha
    When digita nova senha "<senha>"
    Then deve mostrar erro "<erro>"
    And botão "ALTERAR SENHA" deve estar desabilitado

    Examples:
      | senha    | erro                                        |
      | 12345    | A senha deve ter exatamente 6 dígitos       |
      | 123456   | Não pode ser sequência crescente            |
      | 654321   | Não pode ser sequência decrescente          |
      | 111111   | Não pode ter todos os dígitos iguais        |
      | 111123   | Máximo 3 dígitos iguais consecutivos        |
      | 12345a   | A senha deve conter apenas números          |

  @loading
  Scenario: Botão bloqueado durante requisição
    Given motorista preencheu senhas válidas
    When clica no botão "ALTERAR SENHA"
    Then botão deve mostrar loading
    And botão deve estar desabilitado
    And campos devem estar desabilitados

  @error
  Scenario: Mostrar erro da API
    Given motorista preencheu senhas válidas
    And API retorna erro "Erro de conexão"
    When clica no botão "ALTERAR SENHA"
    Then deve mostrar toast de erro "Erro de conexão"
    And deve permanecer na tela
    And botão deve voltar ao estado normal

  @navigation
  Scenario: Voltar sem alterar
    Given motorista está na tela de alterar senha
    When clica no botão voltar
    Then deve voltar para tela anterior
    And não deve deslogar
```

---

## Checklist de Implementação

### Backend (zeca_site)
- [ ] Criar branch `feat/alterar-senha-motorista`
- [ ] Criar `ChangeOwnPasswordDto.ts`
- [ ] Adicionar endpoint `POST /drivers/me/change-password` em `drivers.controller.ts`
- [ ] Implementar `changeOwnPassword()` em `drivers.service.ts`
- [ ] Implementar `validatePasswordSecurity()` em `drivers.service.ts`
- [ ] Testar endpoint via curl/Postman

### Frontend (zeca_app)
- [ ] Criar estrutura `lib/features/change_password/`
- [ ] Criar `change_password_page.dart`
- [ ] Criar `password_rules_widget.dart`
- [ ] Criar BLoC (bloc, event, state)
- [ ] Criar UseCase e Repository
- [ ] Adicionar rota em `app_router.dart`
- [ ] Atualizar `app_drawer.dart`
- [ ] Adicionar constante em `api_constants.dart`
- [ ] Registrar no injection container
- [ ] Testar fluxo completo

### Geral
- [ ] Commits semânticos
- [ ] PR para develop

---

## Commits Sugeridos

```bash
# Backend
git commit -m "feat(drivers): add change own password endpoint for drivers

- Create POST /drivers/me/change-password endpoint
- Add ChangeOwnPasswordDto with 6-digit numeric validation
- Implement password security rules (no sequences, no repeats)
- Requires JWT authentication for APP_MOTORISTA users"

# Frontend - Feature
git commit -m "feat(change-password): add change password feature for drivers

- Create ChangePasswordPage with 6-digit numeric input
- Add password validation rules (sequences, repeats)
- Show confirmation modal before logout
- Implement BLoC pattern with validation states"

# Frontend - Navigation
git commit -m "feat(navigation): add change password route and menu item

- Add /change-password route in app_router.dart
- Update AppDrawer with 'Alterar Senha' menu item
- Add API constant for change password endpoint"
```

---

**Prioridade:** ALTA
**Estimativa:** 3-4 horas (1.5h backend + 2.5h frontend)
**Impacto:** Segurança e autonomia do usuário
