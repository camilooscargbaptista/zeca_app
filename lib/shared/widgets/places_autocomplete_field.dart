import 'package:flutter/material.dart';
import '../../core/services/places_service.dart';

/// Widget de campo de texto com autocomplete de lugares (Google Places)
class PlacesAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final ValueChanged<Place>? onPlaceSelected;
  final InputDecoration? decoration;

  const PlacesAutocompleteField({
    Key? key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.onPlaceSelected,
    this.decoration,
  }) : super(key: key);

  @override
  State<PlacesAutocompleteField> createState() => _PlacesAutocompleteFieldState();
}

class _PlacesAutocompleteFieldState extends State<PlacesAutocompleteField> {
  final PlacesService _placesService = PlacesService();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<Place> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  bool _isSelectingPlace = false; // Flag para evitar busca durante seleção

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    // Não buscar se estiver selecionando um lugar
    if (_isSelectingPlace) {
      return;
    }
    
    final text = widget.controller.text;
    
    // Se o texto foi limpo ou está vazio, remover overlay
    if (text.isEmpty) {
      _removeOverlay();
      return;
    }

    // Debounce: aguardar um pouco antes de buscar
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && widget.controller.text == text && text.isNotEmpty && !_isSelectingPlace) {
        _searchPlaces(text);
      }
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.length < 2) {
      _removeOverlay();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final places = await _placesService.searchPlaces(query);
      
      if (mounted) {
        setState(() {
          _suggestions = places;
          _isLoading = false;
          _showSuggestions = places.isNotEmpty;
        });
        
        if (_showSuggestions) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuggestions = false;
        });
        _removeOverlay();
      }
    }
  }

  void _showOverlay() {
    _removeOverlay();

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : _suggestions.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Nenhum lugar encontrado',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: _suggestions.length,
                          itemBuilder: (context, index) {
                            final place = _suggestions[index];
                            return ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 20,
                              ),
                              title: Text(
                                place.mainText ?? place.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: place.secondaryText != null
                                  ? Text(
                                      place.secondaryText!,
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  : null,
                              onTap: () => _selectPlace(place),
                            );
                          },
                        ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _selectPlace(Place place) async {
    // Marcar que estamos selecionando para evitar busca automática
    _isSelectingPlace = true;
    
    // Fechar overlay ANTES de qualquer outra coisa
    _removeOverlay();
    
    // Limpar sugestões para evitar que apareçam novamente
    setState(() {
      _suggestions = [];
      _showSuggestions = false;
    });
    
    // Remover listener temporariamente para evitar que seja acionado
    widget.controller.removeListener(_onTextChanged);
    
    // Obter coordenadas e endereço completo do lugar
    final placeDetails = await _placesService.getPlaceDetails(place.placeId);
    
    if (placeDetails != null) {
      // Usar endereço completo (formatted_address) ao invés de apenas description
      widget.controller.text = placeDetails.description;
      
      if (widget.onPlaceSelected != null) {
        // Criar Place com coordenadas e endereço completo
        final placeWithCoords = Place(
          placeId: placeDetails.placeId,
          description: placeDetails.description, // Endereço completo
          mainText: place.mainText,
          secondaryText: place.secondaryText,
          latitude: placeDetails.latitude,
          longitude: placeDetails.longitude,
        );
        
        widget.onPlaceSelected!(placeWithCoords);
      }
    } else {
      // Fallback: usar description original se não conseguir detalhes
      widget.controller.text = place.description;
      
      if (widget.onPlaceSelected != null) {
        widget.onPlaceSelected!(place);
      }
    }
    
    // Re-adicionar listener após um pequeno delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _isSelectingPlace = false;
        widget.controller.addListener(_onTextChanged);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        decoration: widget.decoration ??
            InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: Colors.grey)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
        onTap: () {
          if (_suggestions.isNotEmpty) {
            _showOverlay();
          }
        },
        onChanged: (value) {
          // O listener já cuida da busca
        },
      ),
    );
  }
}

