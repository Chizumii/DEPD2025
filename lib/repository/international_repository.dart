import 'package:depd_mvvm_2025/model/model.dart';

class InternationalRepository {
  // Tidak perlu NetworkApiServices karena kita pakai Dummy Data (Bypass API Starter)

  Future<List<InternationalDestination>> fetchInternationalDestinationList([String search = '']) async {
    // Simulasi loading
    await Future.delayed(const Duration(seconds: 1));

    // Data Dummy sesuai JSON Anda
    final List<Map<String, dynamic>> dummyData = [
      {"country_id": "108", "country_name": "Malaysia"},
      {"country_id": "109", "country_name": "Singapore"},
      {"country_id": "110", "country_name": "Japan"},
      {"country_id": "111", "country_name": "South Korea"},
      {"country_id": "112", "country_name": "United States"},
    ];

    // Logika Filter (Search) Manual
    final filteredData = dummyData.where((element) {
      final name = element['country_name'].toString().toLowerCase();
      return name.contains(search.toLowerCase());
    }).toList();

    return filteredData.map((e) => InternationalDestination.fromJson(e)).toList();
  }

  Future<List<Costs>> checkInternationalCost(String origin, String destination, int weight, String courier) async {
    await Future.delayed(const Duration(seconds: 2));

    final List<Map<String, dynamic>> dummyData = [
        {
            "name": "Rayspeed Indonesia",
            "code": "ray",
            "service": "Regular Service",
            "description": "Retail",
            "currency": "IDR",
            "cost": 55000,
            "etd": ""
        },
        {
            "name": "Rayspeed Indonesia",
            "code": "ray",
            "service": "Express Service",
            "description": "Retail",
            "currency": "IDR",
            "cost": 95000,
            "etd": ""
        },
        {
            "name": "Lion Parcel",
            "code": "lion",
            "service": "INTERPACK",
            "description": "Active",
            "currency": "IDR",
            "cost": 110000,
            "etd": "3-5 day"
        },
        {
            "name": "Jalur Nugraha Ekakurir (JNE)",
            "code": "jne",
            "service": "INTL Service",
            "description": "Paket",
            "currency": "IDR",
            "cost": 133000,
            "etd": "2-3 day"
        },
        {
            "name": "Citra Van Titipan Kilat (TIKI)",
            "code": "tiki",
            "service": "WPX",
            "description": "World Parcel Express",
            "currency": "IDR",
            "cost": 133168,
            "etd": "-"
        },
        {
            "name": "POS Indonesia (POS)",
            "code": "pos",
            "service": "PAKETPOS BIASA LN",
            "description": "332",
            "currency": "IDR",
            "cost": 167321,
            "etd": "30 day"
        }
    ];

    return dummyData.map((e) => Costs.fromJson(e)).toList();
  }
}