import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/brand_themes/brand_a_theme.dart';
import '../theme/brand_themes/brand_b_theme.dart';

enum Flavor {
  brandA,
  brandB,
  dev,
  staging,
  prod,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String appName;
  final String baseUrl;
  final Color primaryColor;
  final String logoPath;
  final ThemeData theme;
  
  static FlavorConfig? _instance;
  
  FlavorConfig._({
    required this.flavor,
    required this.name,
    required this.appName,
    required this.baseUrl,
    required this.primaryColor,
    required this.logoPath,
    required this.theme,
  });
  
  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorConfig not initialized');
    }
    return _instance!;
  }
  
  static void initialize(Flavor flavor) {
    switch (flavor) {
      case Flavor.brandA:
        _instance = FlavorConfig._(
          flavor: flavor,
          name: 'brandA',
          appName: 'ZECA A',
          baseUrl: 'https://api-branda.zeca.com',
          primaryColor: const Color(0xFF2E86AB), // Azul médio do logo
          logoPath: 'assets/images/brand_a/logo.png',
          theme: BrandATheme.theme,
        );
        break;
        
      case Flavor.brandB:
        _instance = FlavorConfig._(
          flavor: flavor,
          name: 'brandB',
          appName: 'ZECA B',
          baseUrl: 'https://api-brandb.zeca.com',
          primaryColor: const Color(0xFFE74C3C), // Vermelho alternativo
          logoPath: 'assets/images/brand_b/logo.png',
          theme: BrandBTheme.theme,
        );
        break;
        
      case Flavor.dev:
        _instance = FlavorConfig._(
          flavor: flavor,
          name: 'dev',
          appName: 'ZECA DEV',
          baseUrl: 'https://api-dev.zeca.com',
          primaryColor: const Color(0xFF2E86AB), // Azul do logo
          logoPath: 'assets/images/common/logo.png',
          theme: BrandATheme.theme,
        );
        break;
        
      case Flavor.staging:
        _instance = FlavorConfig._(
          flavor: flavor,
          name: 'staging',
          appName: 'ZECA STAGING',
          baseUrl: 'https://api-staging.zeca.com',
          primaryColor: const Color(0xFF2E86AB), // Azul do logo
          logoPath: 'assets/images/common/logo.png',
          theme: BrandATheme.theme,
        );
        break;
        
      case Flavor.prod:
        _instance = FlavorConfig._(
          flavor: flavor,
          name: 'prod',
          appName: 'ZECA',
          baseUrl: 'https://api.zeca.com',
          primaryColor: const Color(0xFF2E86AB), // Azul médio do logo
          logoPath: 'assets/images/common/logo.png',
          theme: BrandATheme.theme,
        );
        break;
    }
  }
  
  bool get isDevelopment => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProduction => flavor == Flavor.prod;
}
