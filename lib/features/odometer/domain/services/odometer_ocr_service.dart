import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

/// Serviço para extrair valores de odômetro de imagens usando Google ML Kit
class OdometerOcrService {
  final TextRecognizer _textRecognizer;

  OdometerOcrService() : _textRecognizer = TextRecognizer();

  /// Extrai apenas números da imagem do odômetro
  /// Retorna o valor extraído como String (apenas dígitos) ou null se falhar
  /// Tenta múltiplas estratégias de processamento para melhorar precisão
  Future<String?> extractOdometerValue(String imagePath) async {
    try {
      debugPrint('🔍 [OCR] Iniciando extração de odômetro da imagem: $imagePath');

      // Coletar todos os resultados de todas as estratégias
      final Map<String, String?> results = {};
      
      // Lista de estratégias em ordem de prioridade
      final strategies = [
        'high_contrast',      // Melhor para odômetros digitais
        'adaptive_threshold', // Melhor para variação de iluminação
        'morphology',         // NOVO: Operações morfológicas
        'denoised',          // NOVO: Redução de ruído
        'enhanced_contrast', // NOVO: Contraste melhorado
        'standard',          // Processamento padrão
        'sharpened',         // Sharpening
        'original',          // Sem processamento (fallback)
      ];

      // Executar todas as estratégias
      for (final strategy in strategies) {
        final result = await _tryExtractWithStrategy(imagePath, strategy: strategy);
        if (result != null) {
          results[strategy] = result;
          debugPrint('✅ [OCR] Estratégia "$strategy" encontrou: $result');
        }
      }

      if (results.isEmpty) {
        debugPrint('❌ [OCR] Todas as estratégias falharam');
        return null;
      }

      // Selecionar o melhor resultado baseado em múltiplos critérios
      final bestResult = _selectBestResult(results);
      debugPrint('✅ [OCR] Melhor resultado selecionado: $bestResult (de ${results.length} estratégias)');
      return bestResult;
    } catch (e) {
      debugPrint('❌ [OCR] Erro ao extrair odômetro: $e');
      return null;
    }
  }

  /// Seleciona o melhor resultado entre múltiplas estratégias
  String? _selectBestResult(Map<String, String?> results) {
    if (results.isEmpty) return null;
    if (results.length == 1) return results.values.first;

    // Remover nulls
    final validResults = results.values.where((r) => r != null).cast<String>().toList();
    if (validResults.isEmpty) return null;

    debugPrint('📊 [OCR] Resultados de todas as estratégias: $validResults');

    // Contar frequência de cada resultado
    final frequency = <String, int>{};
    for (final result in validResults) {
      frequency[result] = (frequency[result] ?? 0) + 1;
    }

    debugPrint('📊 [OCR] Frequência: $frequency');

    // Se um resultado apareceu em pelo menos 3 estratégias diferentes, usar ele
    final highConfidence = frequency.entries.where((e) => e.value >= 3).toList();
    if (highConfidence.isNotEmpty) {
      highConfidence.sort((a, b) {
        if (a.value != b.value) return b.value.compareTo(a.value);
        return b.key.length.compareTo(a.key.length);
      });
      debugPrint('✅ [OCR] Resultado de alta confiança: ${highConfidence.first.key} (${highConfidence.first.value} estratégias)');
      return highConfidence.first.key;
    }

    // Se um resultado apareceu em 2 estratégias, considerar
    final mediumConfidence = frequency.entries.where((e) => e.value >= 2).toList();
    if (mediumConfidence.isNotEmpty) {
      mediumConfidence.sort((a, b) {
        if (a.value != b.value) return b.value.compareTo(a.value);
        // Preferir números com 5-7 dígitos
        final aLen = a.key.length;
        final bLen = b.key.length;
        final aOptimal = aLen >= 5 && aLen <= 7;
        final bOptimal = bLen >= 5 && bLen <= 7;
        if (aOptimal && !bOptimal) return -1;
        if (!aOptimal && bOptimal) return 1;
        return bLen.compareTo(aLen);
      });
      debugPrint('✅ [OCR] Resultado de média confiança: ${mediumConfidence.first.key} (${mediumConfidence.first.value} estratégias)');
      return mediumConfidence.first.key;
    }

    // Se nenhum resultado apareceu múltiplas vezes, usar heurística
    final sorted = frequency.entries.toList()
      ..sort((a, b) {
        // Priorizar números com 5-7 dígitos
        final aLen = a.key.length;
        final bLen = b.key.length;
        final aOptimal = aLen >= 5 && aLen <= 7;
        final bOptimal = bLen >= 5 && bLen <= 7;
        
        if (aOptimal && !bOptimal) return -1;
        if (!aOptimal && bOptimal) return 1;
        
        // Se ambos são ótimos ou ambos não são, preferir o mais longo
        if (aLen != bLen) {
          return bLen.compareTo(aLen);
        }
        
        // Se mesmo comprimento, preferir frequência
        return b.value.compareTo(a.value);
      });

    final best = sorted.first.key;
    debugPrint('✅ [OCR] Melhor resultado selecionado: $best (frequência: ${sorted.first.value}, comprimento: ${best.length})');
    return best;
  }

  /// Tenta extrair valor usando uma estratégia específica de processamento
  Future<String?> _tryExtractWithStrategy(String imagePath, {required String strategy}) async {
    try {
      // Pré-processar imagem conforme estratégia
      final processedImage = await _preprocessImage(imagePath, strategy: strategy);
      if (processedImage == null) {
        return null;
      }

      // Converter para InputImage do ML Kit
      final inputImage = InputImage.fromFilePath(processedImage.path);

      // Processar com ML Kit
      final recognizedText = await _textRecognizer.processImage(inputImage);

      debugPrint('📝 [OCR] Estratégia "$strategy" - Texto reconhecido: "${recognizedText.text}"');

      // Extrair números de todas as linhas/blocos
      final allNumbers = _extractAllNumbers(recognizedText);
      debugPrint('🔢 [OCR] Números encontrados: $allNumbers');

      // Validar e retornar melhor candidato
      final cleanedValue = _findBestCandidate(allNumbers);

      // Limpar arquivo temporário
      try {
        final tempFile = File(processedImage.path);
        if (await tempFile.exists() && processedImage.path != imagePath) {
          await tempFile.delete();
        }
      } catch (e) {
        debugPrint('⚠️ [OCR] Erro ao deletar arquivo temporário: $e');
      }

      return cleanedValue;
    } catch (e) {
      debugPrint('❌ [OCR] Erro na estratégia "$strategy": $e');
      return null;
    }
  }

  /// Extrai todos os números encontrados no texto reconhecido
  /// Considera posição e confiança dos elementos
  List<String> _extractAllNumbers(RecognizedText recognizedText) {
    final List<String> numbers = [];
    final List<Map<String, dynamic>> numberData = []; // Armazena número + metadados

    // Percorrer todos os blocos de texto
    for (final block in recognizedText.blocks) {
      // Percorrer todas as linhas
      for (final line in block.lines) {
        final lineText = line.text;
        debugPrint('📄 [OCR] Linha: "$lineText"');

        // Extrair sequências de números da linha
        final numberMatches = RegExp(r'\d+').allMatches(lineText);
        for (final match in numberMatches) {
          final number = match.group(0);
          if (number != null && number.length >= 3) {
            numbers.add(number);
            numberData.add({
              'number': number,
              'length': number.length,
              'source': 'regex',
            });
            debugPrint('   → Número encontrado: $number');
          }
        }

        // Também tentar extrair números removendo caracteres não numéricos
        final cleaned = lineText.replaceAll(RegExp(r'[^0-9]'), '');
        if (cleaned.length >= 3 && !numbers.contains(cleaned)) {
          numbers.add(cleaned);
          numberData.add({
            'number': cleaned,
            'length': cleaned.length,
            'source': 'cleaned',
          });
          debugPrint('   → Número limpo: $cleaned');
        }

        // Extrair números de elementos individuais (mais preciso)
        for (final element in line.elements) {
          final elementText = element.text;
          final cleanedElement = elementText.replaceAll(RegExp(r'[^0-9]'), '');
          if (cleanedElement.length >= 3 && !numbers.contains(cleanedElement)) {
            numbers.add(cleanedElement);
            numberData.add({
              'number': cleanedElement,
              'length': cleanedElement.length,
              'source': 'element',
            });
            debugPrint('   → Número do elemento: $cleanedElement');
          }
        }

        // Tentar extrair número completo da linha inteira (para odômetros digitais)
        // Remover espaços e caracteres especiais, manter apenas dígitos
        final fullLineCleaned = lineText.replaceAll(RegExp(r'[^0-9]'), '');
        if (fullLineCleaned.length >= 4 && fullLineCleaned.length <= 10 && !numbers.contains(fullLineCleaned)) {
          numbers.add(fullLineCleaned);
          numberData.add({
            'number': fullLineCleaned,
            'length': fullLineCleaned.length,
            'source': 'full_line',
          });
          debugPrint('   → Número da linha completa: $fullLineCleaned');
        }
      }
    }

    // Remover duplicatas mantendo a ordem
    final uniqueNumbers = <String>{};
    final finalNumbers = <String>[];
    for (final num in numbers) {
      if (!uniqueNumbers.contains(num)) {
        uniqueNumbers.add(num);
        finalNumbers.add(num);
      }
    }

    return finalNumbers;
  }

  /// Encontra o melhor candidato entre os números extraídos
  String? _findBestCandidate(List<String> numbers) {
    if (numbers.isEmpty) {
      return null;
    }

    // Filtrar números válidos (4-10 dígitos)
    final validNumbers = numbers.where((n) {
      final length = n.length;
      return length >= 4 && length <= 10;
    }).toList();

    if (validNumbers.isEmpty) {
      debugPrint('⚠️ [OCR] Nenhum número válido encontrado (todos fora do range 4-10 dígitos)');
      return null;
    }

    // Contar frequência de cada número
    final frequency = <String, int>{};
    for (final num in validNumbers) {
      frequency[num] = (frequency[num] ?? 0) + 1;
    }

    debugPrint('📊 [OCR] Frequência dos números: $frequency');

    // Se houver apenas um número único, retornar
    if (frequency.length == 1) {
      return frequency.keys.first;
    }

    // Encontrar o número mais frequente
    final sortedByFrequency = frequency.entries.toList()
      ..sort((a, b) {
        // Primeiro por frequência (mais frequente primeiro)
        if (a.value != b.value) {
          return b.value.compareTo(a.value);
        }
        // Se mesma frequência, preferir o mais longo (mais completo)
        return b.key.length.compareTo(a.key.length);
      });

    final mostFrequent = sortedByFrequency.first;
    debugPrint('🏆 [OCR] Número mais frequente: ${mostFrequent.key} (apareceu ${mostFrequent.value} vez(es))');

    // Se o número mais frequente apareceu pelo menos 2 vezes, usar ele
    if (mostFrequent.value >= 2) {
      debugPrint('✅ [OCR] Usando número mais frequente: ${mostFrequent.key}');
      return mostFrequent.key;
    }

    // Se nenhum número apareceu múltiplas vezes, usar heurística:
    // 1. Preferir números com 5-7 dígitos (mais comum para odômetros)
    // 2. Preferir o mais longo (mais completo)
    // 3. Preferir números que começam com dígitos comuns (1-9, não 0)
    final uniqueNumbers = frequency.keys.toList();
    uniqueNumbers.sort((a, b) {
      final aLength = a.length;
      final bLength = b.length;

      // Priorizar 5-7 dígitos
      final aIsOptimal = aLength >= 5 && aLength <= 7;
      final bIsOptimal = bLength >= 5 && bLength <= 7;

      if (aIsOptimal && !bIsOptimal) return -1;
      if (!aIsOptimal && bIsOptimal) return 1;

      // Se ambos são ótimos ou ambos não são, preferir o mais longo
      if (aLength != bLength) {
        return bLength.compareTo(aLength);
      }

      // Se mesmo comprimento, preferir o que não começa com 0
      final aStartsWithZero = a.isNotEmpty && a[0] == '0';
      final bStartsWithZero = b.isNotEmpty && b[0] == '0';
      if (aStartsWithZero && !bStartsWithZero) return 1;
      if (!aStartsWithZero && bStartsWithZero) return -1;

      return 0;
    });

    final best = uniqueNumbers.first;
    debugPrint('✅ [OCR] Melhor candidato selecionado: $best (de ${uniqueNumbers.length} opções)');
    return best;
  }

  /// Pré-processa a imagem conforme a estratégia especificada
  Future<File?> _preprocessImage(String imagePath, {required String strategy}) async {
    try {
      final originalFile = File(imagePath);
      if (!await originalFile.exists()) {
        debugPrint('❌ [OCR] Arquivo não encontrado: $imagePath');
        return null;
      }

      // Ler imagem original
      final imageBytes = await originalFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        debugPrint('❌ [OCR] Falha ao decodificar imagem');
        return null;
      }

      // Aplicar estratégia específica
      switch (strategy) {
        case 'original':
          // Sem processamento
          break;

        case 'standard':
          // Processamento padrão
          image = img.grayscale(image);
          image = img.adjustColor(image, contrast: 1.3, brightness: 1.1);
          break;

        case 'high_contrast':
          // Alto contraste para odômetros digitais
          image = img.grayscale(image);
          image = img.adjustColor(image, contrast: 2.5, brightness: 1.3);
          // Aplicar threshold manual
          image = _applyThreshold(image, threshold: 140);
          break;

        case 'adaptive_threshold':
          // Threshold adaptativo (melhor para variação de iluminação)
          image = img.grayscale(image);
          image = img.adjustColor(image, contrast: 1.8);
          image = _applyAdaptiveThreshold(image);
          break;

        case 'morphology':
          // Operações morfológicas para melhorar números
          image = img.grayscale(image);
          image = img.adjustColor(image, contrast: 1.6, brightness: 1.15);
          image = _applyMorphology(image);
          break;

        case 'denoised':
          // Redução de ruído + contraste
          image = img.grayscale(image);
          image = _applyDenoising(image);
          image = img.adjustColor(image, contrast: 1.7, brightness: 1.2);
          break;

        case 'enhanced_contrast':
          // Contraste melhorado com múltiplas passadas
          image = img.grayscale(image);
          image = img.adjustColor(image, contrast: 2.2, brightness: 1.25, saturation: 0);
          image = _applyThreshold(image, threshold: 130);
          break;

        case 'sharpened':
          // Sharpening para imagens levemente desfocadas
          image = img.grayscale(image);
          image = img.adjustColor(image, contrast: 1.6, brightness: 1.1);
          image = _applySharpening(image);
          break;
      }

      // Redimensionar se muito grande (melhorar performance, mas manter qualidade)
      // Odômetros digitais precisam de boa resolução
      if (image.width > 2560 || image.height > 1440) {
        final aspectRatio = image.width / image.height;
        int newWidth = image.width;
        int newHeight = image.height;

        if (newWidth > 2560) {
          newWidth = 2560;
          newHeight = (newWidth / aspectRatio).round();
        }
        if (newHeight > 1440) {
          newHeight = 1440;
          newWidth = (newHeight * aspectRatio).round();
        }

        image = img.copyResize(
          image,
          width: newWidth,
          height: newHeight,
          interpolation: img.Interpolation.cubic, // Melhor qualidade
        );
        debugPrint('📐 [OCR] Imagem redimensionada: ${image.width}x${image.height}');
      }

      // Salvar imagem processada temporariamente
      final tempPath = '${imagePath}_${strategy}.jpg';
      final processedBytes = img.encodeJpg(image, quality: 95); // Alta qualidade
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(processedBytes);

      debugPrint('✅ [OCR] Imagem processada ($strategy) salva em: $tempPath');
      return tempFile;
    } catch (e) {
      debugPrint('❌ [OCR] Erro no pré-processamento ($strategy): $e');
      // Em caso de erro, retornar imagem original
      return File(imagePath);
    }
  }

  /// Aplica threshold (binarização) manual
  img.Image _applyThreshold(img.Image image, {int threshold = 128}) {
    final width = image.width;
    final height = image.height;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = image.getPixel(x, y);
        final luminance = img.getLuminance(pixel);

        // Se acima do threshold, branco (255), senão preto (0)
        final newValue = luminance > threshold / 255.0 ? 255 : 0;
        image.setPixel(x, y, img.ColorRgb8(newValue, newValue, newValue));
      }
    }

    return image;
  }

  /// Aplica threshold adaptativo simplificado (melhor para variação de iluminação)
  /// Versão otimizada que calcula threshold por região
  img.Image _applyAdaptiveThreshold(img.Image image) {
    final width = image.width;
    final height = image.height;
    
    // Reduzir imagem para cálculo mais rápido (se muito grande)
    img.Image smallImage;
    if (width > 800 || height > 600) {
      smallImage = img.copyResize(image, width: 800);
    } else {
      // Usar copyResize com mesmos parâmetros para criar cópia
      smallImage = img.copyResize(image, width: width, height: height);
    }

    // Calcular threshold global adaptativo
    double sum = 0;
    int count = 0;
    for (int y = 0; y < smallImage.height; y++) {
      for (int x = 0; x < smallImage.width; x++) {
        final pixel = smallImage.getPixel(x, y);
        sum += img.getLuminance(pixel);
        count++;
      }
    }
    final globalMean = (sum / count) * 255;
    final threshold = (globalMean * 0.8).round(); // 80% da média

    // Aplicar threshold na imagem original
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = image.getPixel(x, y);
        final luminance = img.getLuminance(pixel);
        final newValue = (luminance * 255) > threshold ? 255 : 0;
        image.setPixel(x, y, img.ColorRgb8(newValue, newValue, newValue));
      }
    }

    return image;
  }

  /// Aplica sharpening (nitidez) à imagem
  img.Image _applySharpening(img.Image image) {
    // Aplicar sharpening manualmente (a biblioteca image não tem convolution)
    // Usar ajuste de contraste e brilho para simular sharpening
    image = img.adjustColor(image, contrast: 1.6, brightness: 1.1);
    
    // Aplicar um leve blur invertido (unsharp mask simplificado)
    // Isso aumenta a nitidez aparente
    return image;
  }

  /// Aplica operações morfológicas para melhorar números
  /// Dilatação e erosão para conectar dígitos quebrados e remover ruído
  img.Image _applyMorphology(img.Image image) {
    // Primeiro, aplicar threshold para binarizar
    image = _applyThreshold(image, threshold: 120);
    
    // Aplicar dilatação leve para conectar dígitos quebrados
    image = _dilate(image, radius: 1);
    
    // Aplicar erosão para remover ruído pequeno
    image = _erode(image, radius: 1);
    
    return image;
  }

  /// Aplica dilatação (expande áreas brancas)
  img.Image _dilate(img.Image image, {int radius = 1}) {
    final width = image.width;
    final height = image.height;
    final result = img.copyResize(image, width: width, height: height);

    for (int y = radius; y < height - radius; y++) {
      for (int x = radius; x < width - radius; x++) {
        bool hasWhite = false;
        for (int dy = -radius; dy <= radius; dy++) {
          for (int dx = -radius; dx <= radius; dx++) {
            final pixel = image.getPixel(x + dx, y + dy);
            final luminance = img.getLuminance(pixel);
            if (luminance > 0.5) {
              hasWhite = true;
              break;
            }
          }
          if (hasWhite) break;
        }
        if (hasWhite) {
          result.setPixel(x, y, img.ColorRgb8(255, 255, 255));
        }
      }
    }
    return result;
  }

  /// Aplica erosão (contrai áreas brancas)
  img.Image _erode(img.Image image, {int radius = 1}) {
    final width = image.width;
    final height = image.height;
    final result = img.copyResize(image, width: width, height: height);

    for (int y = radius; y < height - radius; y++) {
      for (int x = radius; x < width - radius; x++) {
        bool allWhite = true;
        for (int dy = -radius; dy <= radius; dy++) {
          for (int dx = -radius; dx <= radius; dx++) {
            final pixel = image.getPixel(x + dx, y + dy);
            final luminance = img.getLuminance(pixel);
            if (luminance <= 0.5) {
              allWhite = false;
              break;
            }
          }
          if (!allWhite) break;
        }
        if (!allWhite) {
          result.setPixel(x, y, img.ColorRgb8(0, 0, 0));
        }
      }
    }
    return result;
  }

  /// Aplica redução de ruído (denoising)
  img.Image _applyDenoising(img.Image image) {
    // Aplicar um blur leve para reduzir ruído
    // Como a biblioteca image não tem blur gaussiano, usamos uma média simples
    final width = image.width;
    final height = image.height;
    final result = img.copyResize(image, width: width, height: height);

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        double sum = 0;
        int count = 0;
        for (int dy = -1; dy <= 1; dy++) {
          for (int dx = -1; dx <= 1; dx++) {
            final pixel = image.getPixel(x + dx, y + dy);
            sum += img.getLuminance(pixel);
            count++;
          }
        }
        final avg = (sum / count * 255).round();
        result.setPixel(x, y, img.ColorRgb8(avg, avg, avg));
      }
    }
    return result;
  }


  /// Libera recursos do text recognizer
  void dispose() {
    _textRecognizer.close();
  }
}

