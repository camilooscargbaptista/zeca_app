import 'dart:async';
import 'package:flutter/material.dart';

/// Diálogo de contagem regressiva antes de iniciar navegação
class NavigationCountdownDialog extends StatefulWidget {
  final VoidCallback onComplete;
  final int seconds;

  const NavigationCountdownDialog({
    Key? key,
    required this.onComplete,
    this.seconds = 5,
  }) : super(key: key);

  @override
  State<NavigationCountdownDialog> createState() => _NavigationCountdownDialogState();
}

class _NavigationCountdownDialogState extends State<NavigationCountdownDialog> {
  late int _remainingSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _remainingSeconds--;
        });

        if (_remainingSeconds <= 0) {
          timer.cancel();
          Navigator.of(context).pop();
          widget.onComplete();
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          _timer.cancel();
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Iniciando Navegação',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              // Círculo com número
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[50],
                  border: Border.all(
                    color: Colors.green,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$_remainingSeconds',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Barra de progresso
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: (widget.seconds - _remainingSeconds) / widget.seconds,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  _timer.cancel();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

