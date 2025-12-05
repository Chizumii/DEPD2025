import 'package:depd_mvvm_2025/data/network/network_api_service.dart';
import 'package:depd_mvvm_2025/model/model.dart';

class InternationalRepository {
  // Instance Network Service untuk melakukan request HTTP
  final _apiServices = NetworkApiServices();

  /// Mencari Negara Tujuan (Menggunakan API GET)
  Future<List<InternationalDestination>> findInterDestination(String keyword) async {
    // Request ke API RajaOngkir (Endpoint International Destination)
    // keyword kosong akan menampilkan semua negara (atau sesuai default API)
    final response = await _apiServices.getApiResponse(
      'destination/international-destination?search=$keyword&limit=99&offset=0',
    );

    // Validasi Meta Response
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parsing Data ke List Model
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => InternationalDestination.fromJson(e)).toList();
  }

  /// Menghitung Ongkir Internasional (Menggunakan API POST)
  Future<List<Costs>> countInterCost({
    required String origin,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    // Body Request sesuai dokumentasi RajaOngkir
    final body = {
      "origin": origin,
      "destination": destination,
      "weight": weight.toString(),
      "courier": courier,
    };

    // Kirim Request POST
    final response = await _apiServices.postApiResponse(
      'calculate/international-cost',
      body,
    );

    // Validasi Meta Response
    final meta = response['meta'];
    if (meta == null || meta['status'] != 'success') {
      throw Exception("API Error: ${meta?['message'] ?? 'Unknown error'}");
    }

    // Parsing Data ke List Model Costs
    final data = response['data'];
    if (data is! List) return [];

    return data.map((e) => Costs.fromJson(e)).toList();
  }
}