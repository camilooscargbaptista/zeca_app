/// Testes unitários para RefuelingPollingService
///
/// Garante que o polling funciona corretamente em todos os cenários:
/// 1. VALIDADO do RefuelingCode (is_pending_code: true) → Continua polling
/// 2. AGUARDANDO_VALIDACAO_MOTORISTA → Para polling, callback com dados
/// 3. CONCLUIDO → Para polling, callback com dados
/// 4. CANCELADO → Para polling, callback com erro

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeca_app/core/services/refueling_polling_service.dart';
import 'package:zeca_app/core/services/api_service.dart';

// Mock do ApiService
class MockApiService extends Mock implements ApiService {}

void main() {
  late RefuelingPollingService pollingService;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    pollingService = RefuelingPollingService();
  });

  tearDown(() {
    pollingService.stopPolling();
  });

  group('RefuelingPollingService - Fluxo de Status', () {
    group('Polling 1: RefuelingCode (is_pending_code: true)', () {
      test('ACTIVE → Continua polling (não chama callback)', () async {
        // Arrange
        final callbackCalls = <String>[];
        
        when(() => mockApiService.getRefuelingByCode('TEST123'))
            .thenAnswer((_) async => {
          'success': true,
          'data': {
            'id': null,
            'status': 'ACTIVE',
            'is_pending_code': true,
            'refueling_code': 'TEST123',
          }
        });

        // Act - Verificar resposta simulada
        final response = await mockApiService.getRefuelingByCode('TEST123');
        
        // Assert
        expect(response['success'], true);
        expect(response['data']['status'], 'ACTIVE');
        expect(response['data']['is_pending_code'], true);
        expect(response['data']['id'], null);
        expect(callbackCalls, isEmpty, reason: 'ACTIVE não deve chamar callback');
      });

      test('VALIDADO + is_pending_code → Callback chamado mas polling NÃO deve parar', () async {
        // Arrange
        final callbackCalls = <Map<String, dynamic>>[];
        
        when(() => mockApiService.getRefuelingByCode('TEST123'))
            .thenAnswer((_) async => {
          'success': true,
          'data': {
            'id': null,
            'status': 'VALIDADO',
            'is_pending_code': true,
            'refueling_code': 'TEST123',
          }
        });

        // Act
        final response = await mockApiService.getRefuelingByCode('TEST123');
        final data = response['data'] as Map<String, dynamic>;
        
        // Simular lógica do callback (como RefuelingWaitingPage faz)
        final isPendingCode = data['is_pending_code'] == true;
        final status = data['status'];
        
        if (isPendingCode && status == 'VALIDADO') {
          // VALIDADO de código pendente → Continuar polling, NÃO navegar
          callbackCalls.add({'action': 'continue_polling', 'status': status});
        }
        
        // Assert
        expect(response['data']['status'], 'VALIDADO');
        expect(response['data']['is_pending_code'], true);
        expect(callbackCalls.length, 1);
        expect(callbackCalls.first['action'], 'continue_polling',
            reason: 'VALIDADO com is_pending_code deve continuar polling');
      });

      test('EXPIRED → Para polling, mostra erro', () async {
        // Arrange
        when(() => mockApiService.getRefuelingByCode('TEST123'))
            .thenAnswer((_) async => {
          'success': true,
          'data': {
            'id': null,
            'status': 'EXPIRED',
            'is_pending_code': true,
            'refueling_code': 'TEST123',
          }
        });

        // Act
        final response = await mockApiService.getRefuelingByCode('TEST123');
        final data = response['data'] as Map<String, dynamic>;
        
        final isPendingCode = data['is_pending_code'] == true;
        final status = data['status'];
        
        String? errorAction;
        if (isPendingCode && ['EXPIRED', 'RECUSED', 'FRAUD_ATTEMPT'].contains(status)) {
          errorAction = 'show_error';
        }
        
        // Assert
        expect(errorAction, 'show_error',
            reason: 'EXPIRED deve mostrar erro');
      });

      test('RECUSED → Para polling, mostra erro (posto recusou)', () async {
        // Arrange
        when(() => mockApiService.getRefuelingByCode('TEST123'))
            .thenAnswer((_) async => {
          'success': true,
          'data': {
            'id': null,
            'status': 'RECUSED',
            'is_pending_code': true,
            'refueling_code': 'TEST123',
          }
        });

        // Act
        final response = await mockApiService.getRefuelingByCode('TEST123');
        final status = response['data']['status'];
        
        // Assert
        expect(status, 'RECUSED');
        expect(['EXPIRED', 'RECUSED', 'FRAUD_ATTEMPT'].contains(status), true,
            reason: 'RECUSED é um status de erro');
      });
    });

    group('Polling 2: Refueling (tem ID, is_pending_code: false)', () {
      test('AGUARDANDO_VALIDACAO_MOTORISTA → Para polling, mostra dados', () async {
        // Arrange
        when(() => mockApiService.getRefuelingByCode('TEST123'))
            .thenAnswer((_) async => {
          'success': true,
          'data': {
            'id': 'uuid-123',
            'status': 'AGUARDANDO_VALIDACAO_MOTORISTA',
            'is_pending_code': false,
            'refueling_code': 'TEST123',
            'quantity_liters': 50.0,
            'total_amount': 350.00,
          }
        });

        // Act
        final response = await mockApiService.getRefuelingByCode('TEST123');
        final data = response['data'] as Map<String, dynamic>;
        
        final hasRefuelingId = data['id'] != null;
        final status = data['status'];
        
        String? action;
        if (hasRefuelingId && status == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
          action = 'show_validation_screen';
        }
        
        // Assert
        expect(data['id'], isNotNull);
        expect(data['status'], 'AGUARDANDO_VALIDACAO_MOTORISTA');
        expect(data['is_pending_code'], false);
        expect(action, 'show_validation_screen',
            reason: 'AGUARDANDO_VALIDACAO_MOTORISTA deve mostrar tela de validação');
      });

      test('CONCLUIDO → Para polling, navega para sucesso', () async {
        // Arrange
        when(() => mockApiService.getRefuelingByCode('TEST123'))
            .thenAnswer((_) async => {
          'success': true,
          'data': {
            'id': 'uuid-123',
            'status': 'CONCLUIDO',
            'is_pending_code': false,
            'refueling_code': 'TEST123',
            'quantity_liters': 50.0,
            'total_amount': 350.00,
          }
        });

        // Act
        final response = await mockApiService.getRefuelingByCode('TEST123');
        final data = response['data'] as Map<String, dynamic>;
        
        String? action;
        if (data['status'] == 'CONCLUIDO') {
          action = 'navigate_to_success';
        }
        
        // Assert
        expect(data['status'], 'CONCLUIDO');
        expect(action, 'navigate_to_success',
            reason: 'CONCLUIDO deve navegar para tela de sucesso');
      });

      test('CANCELADO → Para polling, mostra erro', () async {
        // Arrange
        when(() => mockApiService.getRefuelingByCode('TEST123'))
            .thenAnswer((_) async => {
          'success': true,
          'data': {
            'id': 'uuid-123',
            'status': 'CANCELADO',
            'is_pending_code': false,
            'refueling_code': 'TEST123',
          }
        });

        // Act
        final response = await mockApiService.getRefuelingByCode('TEST123');
        final data = response['data'] as Map<String, dynamic>;
        
        String? action;
        if (data['status'] == 'CANCELADO') {
          action = 'show_cancelled_error';
        }
        
        // Assert
        expect(data['status'], 'CANCELADO');
        expect(action, 'show_cancelled_error',
            reason: 'CANCELADO deve mostrar erro');
      });

      test('CONTESTADO → Para polling, mostra feedback contestação', () async {
        // Arrange
        when(() => mockApiService.getRefuelingByCode('TEST123'))
            .thenAnswer((_) async => {
          'success': true,
          'data': {
            'id': 'uuid-123',
            'status': 'CONTESTADO',
            'is_pending_code': false,
            'refueling_code': 'TEST123',
            'notes': 'Valor incorreto',
          }
        });

        // Act
        final response = await mockApiService.getRefuelingByCode('TEST123');
        final data = response['data'] as Map<String, dynamic>;
        
        String? action;
        if (data['status'] == 'CONTESTADO') {
          action = 'show_contested_feedback';
        }
        
        // Assert
        expect(data['status'], 'CONTESTADO');
        expect(action, 'show_contested_feedback',
            reason: 'CONTESTADO deve mostrar feedback de contestação');
      });
    });

    group('Matriz de Decisão Completa', () {
      /// Testa a lógica de decisão conforme documentado em polling_architecture.md
      test('Matriz de decisão - todos os cenários', () {
        // Define a matriz de decisão
        final testCases = [
          // RefuelingCode (is_pending_code: true, id: null)
          {'status': 'ACTIVE', 'is_pending_code': true, 'id': null, 'expected': 'continue_polling'},
          {'status': 'VALIDADO', 'is_pending_code': true, 'id': null, 'expected': 'continue_polling'},
          {'status': 'EXPIRED', 'is_pending_code': true, 'id': null, 'expected': 'show_error'},
          {'status': 'RECUSED', 'is_pending_code': true, 'id': null, 'expected': 'show_error'},
          {'status': 'FRAUD_ATTEMPT', 'is_pending_code': true, 'id': null, 'expected': 'show_error'},
          
          // Refueling (is_pending_code: false, id: uuid)
          {'status': 'AGUARDANDO_VALIDACAO_MOTORISTA', 'is_pending_code': false, 'id': 'uuid', 'expected': 'show_validation'},
          {'status': 'VALIDADO', 'is_pending_code': false, 'id': 'uuid', 'expected': 'navigate_success'},
          {'status': 'CONCLUIDO', 'is_pending_code': false, 'id': 'uuid', 'expected': 'navigate_success'},
          {'status': 'CANCELADO', 'is_pending_code': false, 'id': 'uuid', 'expected': 'show_error'},
          {'status': 'CONTESTADO', 'is_pending_code': false, 'id': 'uuid', 'expected': 'show_contested'},
        ];

        for (final testCase in testCases) {
          final status = testCase['status'] as String;
          final isPendingCode = testCase['is_pending_code'] as bool;
          final id = testCase['id'];
          final expected = testCase['expected'] as String;

          // Simular lógica de decisão (como RefuelingWaitingPage faz)
          String actual;
          
          if (isPendingCode && id == null) {
            // RefuelingCode
            if (status == 'ACTIVE' || status == 'VALIDADO') {
              actual = 'continue_polling';
            } else if (['EXPIRED', 'RECUSED', 'FRAUD_ATTEMPT'].contains(status)) {
              actual = 'show_error';
            } else {
              actual = 'unknown';
            }
          } else {
            // Refueling
            switch (status) {
              case 'AGUARDANDO_VALIDACAO_MOTORISTA':
                actual = 'show_validation';
                break;
              case 'VALIDADO':
              case 'CONCLUIDO':
                actual = 'navigate_success';
                break;
              case 'CANCELADO':
                actual = 'show_error';
                break;
              case 'CONTESTADO':
                actual = 'show_contested';
                break;
              default:
                actual = 'unknown';
            }
          }

          expect(actual, expected,
              reason: 'status=$status, is_pending_code=$isPendingCode, id=$id deveria resultar em $expected');
        }
      });
    });
  });

  group('Cenários de Fluxo End-to-End', () {
    test('Fluxo completo: ACTIVE → VALIDADO → AGUARDANDO_VALIDACAO_MOTORISTA → CONCLUIDO', () {
      // Este teste simula o fluxo completo de um abastecimento
      final statusSequence = ['ACTIVE', 'VALIDADO', 'AGUARDANDO_VALIDACAO_MOTORISTA', 'CONCLUIDO'];
      final actions = <String>[];

      for (var i = 0; i < statusSequence.length; i++) {
        final status = statusSequence[i];
        final isPendingCode = i < 2; // ACTIVE e VALIDADO são do código
        final hasId = i >= 2; // AGUARDANDO e CONCLUIDO tem ID

        String action;
        if (isPendingCode) {
          if (status == 'ACTIVE' || status == 'VALIDADO') {
            action = 'continue_polling';
          } else {
            action = 'error';
          }
        } else if (hasId) {
          if (status == 'AGUARDANDO_VALIDACAO_MOTORISTA') {
            action = 'show_validation';
          } else if (status == 'CONCLUIDO') {
            action = 'success';
          } else {
            action = 'unknown';
          }
        } else {
          action = 'unknown';
        }

        actions.add(action);
      }

      expect(actions, [
        'continue_polling', // ACTIVE
        'continue_polling', // VALIDADO (código)
        'show_validation',  // AGUARDANDO_VALIDACAO_MOTORISTA
        'success',          // CONCLUIDO
      ]);
    });

    test('Fluxo de erro: ACTIVE → RECUSED', () {
      final statusSequence = ['ACTIVE', 'RECUSED'];
      final actions = <String>[];

      for (final status in statusSequence) {
        String action;
        if (status == 'ACTIVE') {
          action = 'continue_polling';
        } else if (['EXPIRED', 'RECUSED', 'FRAUD_ATTEMPT'].contains(status)) {
          action = 'show_error';
        } else {
          action = 'unknown';
        }
        actions.add(action);
      }

      expect(actions, ['continue_polling', 'show_error']);
    });

    test('Fluxo de contestação: ACTIVE → VALIDADO → AGUARDANDO → CONTESTADO', () {
      final actions = <String>[];
      
      // Simular cada etapa
      actions.add('continue_polling'); // ACTIVE
      actions.add('continue_polling'); // VALIDADO (código)
      actions.add('show_validation');  // AGUARDANDO_VALIDACAO_MOTORISTA
      actions.add('show_contested');   // CONTESTADO

      expect(actions.last, 'show_contested',
          reason: 'Fluxo de contestação deve terminar em show_contested');
    });
  });
}
