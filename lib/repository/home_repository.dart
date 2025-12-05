import 'package:depd_mvvm_2025/data/network/network_api_service.dart';
import 'package:depd_mvvm_2025/model/model.dart';

class HomeRepository {
  final _apiServices = NetworkApiServices();

  // --- DOMESTIK (Menggunakan API Asli) ---

  Future<List<Province>> fetchProvinceList() async {
    final response = await _apiServices.getApiResponse('destination/province');
    if (response['meta'] == null || response['meta']['status'] != 'success') {
      throw Exception("API Error");
    }
    return (response['data'] as List).map((e) => Province.fromJson(e)).toList();
  }

  Future<List<City>> fetchCityList(var provId) async {
    final response = await _apiServices.getApiResponse('destination/city/$provId');
    if (response['meta'] == null || response['meta']['status'] != 'success') {
      throw Exception("API Error");
    }
    return (response['data'] as List).map((e) => City.fromJson(e)).toList();
  }

  Future<List<Costs>> checkShipmentCost(String origin, String originType, String destination, String destinationType, int weight, String courier) async {
    final response = await _apiServices.postApiResponse('calculate/domestic-cost', {
      "origin": origin,
      "destination": destination,
      "weight": weight.toString(),
      "courier": courier,
    });
    if (response['meta'] == null || response['meta']['status'] != 'success') {
      throw Exception("API Error");
    }
    return (response['data'] as List).map((e) => Costs.fromJson(e)).toList();
  }
}