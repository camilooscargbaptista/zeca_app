import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/document_entity.dart';
import '../bloc/document_bloc.dart';
import '../../../../core/config/flavor_config.dart';

class DocumentUploadSection extends StatefulWidget {
  final String refuelingId;
  final List<DocumentEntity> documents;
  final Function(DocumentEntity)? onDocumentUploaded;

  const DocumentUploadSection({
    Key? key,
    required this.refuelingId,
    required this.documents,
    this.onDocumentUploaded,
  }) : super(key: key);

  @override
  State<DocumentUploadSection> createState() => _DocumentUploadSectionState();
}

class _DocumentUploadSectionState extends State<DocumentUploadSection> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentBloc, DocumentState>(
      listener: (context, state) {
        if (state is DocumentUploaded) {
          widget.onDocumentUploaded?.call(state.document);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Documento enviado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is DocumentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao enviar documento: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comprovantes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Lista de documentos
              if (widget.documents.isNotEmpty) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.documents.length,
                  itemBuilder: (context, index) {
                    final document = widget.documents[index];
                    return _buildDocumentItem(context, document);
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Botões de upload
              _buildUploadButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, DocumentEntity document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            document.isImage ? Icons.image : Icons.description,
            color: FlavorConfig.instance.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.nomeOriginal,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${document.tamanhoFormatado} • ${_formatDocumentType(document.tipo)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _deleteDocument(document.id),
            icon: const Icon(Icons.delete, color: Colors.red),
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButtons(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildUploadButton(
          context,
          'Nota Fiscal',
          Icons.receipt,
          DocumentType.notaFiscal,
        ),
        _buildUploadButton(
          context,
          'Foto da Bomba',
          Icons.camera_alt,
          DocumentType.fotoBomba,
        ),
        _buildUploadButton(
          context,
          'Foto do Odômetro',
          Icons.speed,
          DocumentType.fotoOdometro,
        ),
        _buildUploadButton(
          context,
          'Comprovante',
          Icons.payment,
          DocumentType.comprovantePagamento,
        ),
      ],
    );
  }

  Widget _buildUploadButton(
    BuildContext context,
    String label,
    IconData icon,
    DocumentType tipo,
  ) {
    return OutlinedButton.icon(
      onPressed: () => _showImageSourceDialog(tipo),
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: FlavorConfig.instance.primaryColor,
        side: BorderSide(color: FlavorConfig.instance.primaryColor),
      ),
    );
  }

  void _showImageSourceDialog(DocumentType tipo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, tipo);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, tipo);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, DocumentType tipo) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        context.read<DocumentBloc>().add(
          UploadDocument(
            filePath: image.path,
            refuelingId: widget.refuelingId,
            tipo: tipo,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar imagem: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteDocument(String documentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Documento'),
        content: const Text('Tem certeza que deseja excluir este documento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DocumentBloc>().add(DeleteDocument(documentId));
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDocumentType(String tipo) {
    switch (tipo) {
      case 'nota_fiscal':
        return 'Nota Fiscal';
      case 'foto_bomba':
        return 'Foto da Bomba';
      case 'foto_odometro':
        return 'Foto do Odômetro';
      case 'comprovante_pagamento':
        return 'Comprovante';
      default:
        return tipo;
    }
  }
}
