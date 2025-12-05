import 'package:flutter/material.dart';
import 'package:depd_mvvm_2025/model/model.dart';
import 'package:depd_mvvm_2025/data/response/api_response.dart';
import 'package:depd_mvvm_2025/repository/international_repository.dart'; // Pastikan import ini benar

class InternationalViewModel with ChangeNotifier {
  // Menggunakan Repository khusus Internasional
  final _interRepo = InternationalRepository();
  
  // Fungsi ini dipanggil langsung oleh widget Autocomplete di View
  Future<List<InternationalDestination>> searchDestinations(String query) async {
    try {
      // Memanggil method 'findInterDestination' dari Repository
      final list = await _interRepo.findInterDestination(query);
      return list;
    } catch (e) {
      debugPrint("Error saat mencari negara: $e");
      return []; // Kembalikan list kosong agar aplikasi tidak crash
    }
  }

  // State untuk menampung hasil ongkir (List Costs)
  ApiResponse<List<Costs>> costList = ApiResponse.notStarted();

  void setCostList(ApiResponse<List<Costs>> response) {
    costList = response;
    notifyListeners();
  }

  // State untuk loading overlay (opsional)
  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Fungsi Check Cost
  Future checkInternationalCost(String origin, String destination, int weight, String courier) async {
    setLoading(true);
    setCostList(ApiResponse.loading());
    
    // Memanggil method 'countInterCost' dengan Named Parameters (sesuai Repository)
    _interRepo.countInterCost(
      origin: origin,
      destination: destination,
      weight: weight,
      courier: courier,
    ).then((value) {
      // Sukses
      setCostList(ApiResponse.completed(value));
      setLoading(false);
    }).onError((error, _) {
      // Gagal
      setCostList(ApiResponse.error(error.toString()));
      setLoading(false);
    });
  }
}