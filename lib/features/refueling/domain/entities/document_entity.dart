import 'package:equatable/equatable.dart';

class DocumentEntity extends Equatable {
  final String id;
  final String nomeOriginal;
  final String nomeArquivo;
  final String tipo;
  final int tamanhoBytes;
  final String mimeType;
  final String url;
  final String? urlThumbnail;
  final DateTime uploadadoEm;
  final DocumentUserEntity uploadadoPor;
  final String? refuelingId;

  const DocumentEntity({
    required this.id,
    required this.nomeOriginal,
    required this.nomeArquivo,
    required this.tipo,
    required this.tamanhoBytes,
    required this.mimeType,
    required this.url,
    this.urlThumbnail,
    required this.uploadadoEm,
    required this.uploadadoPor,
    this.refuelingId,
  });

  @override
  List<Object?> get props => [
        id,
        nomeOriginal,
        nomeArquivo,
        tipo,
        tamanhoBytes,
        mimeType,
        url,
        urlThumbnail,
        uploadadoEm,
        uploadadoPor,
        refuelingId,
      ];

  bool get isImage => mimeType.startsWith('image/');
  bool get isPdf => mimeType == 'application/pdf';
  String get tamanhoFormatado {
    if (tamanhoBytes < 1024) return '${tamanhoBytes}B';
    if (tamanhoBytes < 1024 * 1024) return '${(tamanhoBytes / 1024).toStringAsFixed(1)}KB';
    return '${(tamanhoBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

class DocumentUserEntity extends Equatable {
  final String id;
  final String nome;

  const DocumentUserEntity({
    required this.id,
    required this.nome,
  });

  @override
  List<Object?> get props => [id, nome];
}

enum DocumentType {
  notaFiscal('nota_fiscal', 'Nota Fiscal'),
  fotoBomba('foto_bomba', 'Foto da Bomba'),
  fotoOdometro('foto_odometro', 'Foto do Odômetro'),
  comprovantePagamento('comprovante_pagamento', 'Comprovante de Pagamento');

  const DocumentType(this.value, this.label);
  
  final String value;
  final String label;

  static DocumentType? fromString(String value) {
    for (final type in DocumentType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
