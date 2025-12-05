import 'package:flutter/material.dart';
import 'package:depd_mvvm_2025/model/model.dart';
import 'package:depd_mvvm_2025/data/response/api_response.dart';
import 'package:depd_mvvm_2025/data/response/status.dart';
// Import Repository Baru
import 'package:depd_mvvm_2025/repository/international_repository.dart'; 

class InternationalViewModel with ChangeNotifier {
  // Ganti HomeRepository dengan InternationalRepository
  final _interRepo = InternationalRepository();

  // --- 1. SEARCH DESTINATION ---
  
  ApiResponse<List<InternationalDestination>> internationalDestinationList = ApiResponse.notStarted();

  void setInternationalDestinationList(ApiResponse<List<InternationalDestination>> response) {
    internationalDestinationList = response;
    notifyListeners();
  }

  Future<List<InternationalDestination>> searchDestinations(String query) async {
    try {
      // Panggil dari InternationalRepository
      final list = await _interRepo.fetchInternationalDestinationList(query);
      return list;
    } catch (e) {
      debugPrint("Error saat mencari negara: $e");
      return [];
    }
  }

  // --- 2. CEK ONGKIR ---

  ApiResponse<List<Costs>> costList = ApiResponse.notStarted();

  void setCostList(ApiResponse<List<Costs>> response) {
    costList = response;
    notifyListeners();
  }

  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future checkInternationalCost(String origin, String destination, int weight, String courier) async {
    setLoading(true);
    setCostList(ApiResponse.loading());
    
    // Panggil dari InternationalRepository
    _interRepo.checkInternationalCost(origin, destination, weight, courier)
      .then((value) {
        setCostList(ApiResponse.completed(value));
        setLoading(false);
      })
      .onError((error, _) {
        setCostList(ApiResponse.error(error.toString()));
        setLoading(false);
      });
  }
}