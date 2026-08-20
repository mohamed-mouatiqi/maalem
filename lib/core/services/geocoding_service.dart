import 'dart:convert';

import 'package:http/http.dart' as http;

/// One place returned by [GeocodingService.search] — a city/town/place name
/// plus the country it's in, and its coordinates.
class LocationSuggestion {
  const LocationSuggestion({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  /// e.g. "Marrakech, Morocco" — what's shown in the dropdown and filled
  /// into the text field once picked.
  final String label;
  final double latitude;
  final double longitude;
}

/// Looks up place names via OpenStreetMap's Nominatim API (free, no API
/// key). Used to power the location autocomplete on the Sign Up flow.
class GeocodingService {
  static const _baseUrl = 'https://nominatim.openstreetmap.org/search';

  /// Returns up to 5 place suggestions matching [query]. Empty list if the
  /// query is blank or the request fails — callers just show no dropdown.
  Future<List<LocationSuggestion>> search(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'q': query,
      'format': 'json',
      'addressdetails': '1',
      'limit': '5',
    });

    try {
      // Nominatim's usage policy requires a descriptive User-Agent instead
      // of an API key.
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'maalem-flutter-app'},
      );
      if (response.statusCode != 200) return [];

      final results = jsonDecode(response.body) as List<dynamic>;
      return results.map((result) {
        final address = result['address'] as Map<String, dynamic>? ?? {};
        final place = address['city'] ??
            address['town'] ??
            address['village'] ??
            address['county'] ??
            result['display_name'];
        final country = address['country'];
        final label = country != null ? '$place, $country' : '$place';

        return LocationSuggestion(
          label: label,
          latitude: double.parse(result['lat'] as String),
          longitude: double.parse(result['lon'] as String),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
