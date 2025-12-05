part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel homeViewModel;
  final weightController = TextEditingController();
  final List<String> courierOptions = ["jne", "pos", "tiki", "lion", "sicepat"];
  String selectedCourier = "jne";

  int? selectedProvinceOriginId;
  int? selectedCityOriginId;
  int? selectedProvinceDestinationId;
  int? selectedCityDestinationId;

  @override
  void initState() {
    super.initState();
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    if (homeViewModel.provinceList.status == Status.notStarted) {
      homeViewModel.getProvinceList();
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  // --- FUNGSI UNTUK MENAMPILKAN POP-UP DETAIL (BOTTOM SHEET) ---
  void _showCostDetail(BuildContext context, Costs cost) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Agar tinggi menyesuaikan konten
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Detail Layanan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 16),
              
              // Detail Konten
              _buildDetailItem("Kurir", cost.name ?? "-"),
              _buildDetailItem("Layanan", cost.service ?? "-"),
              // INI ADALAH BAGIAN DESCRIPTION YANG DIMINTA
              _buildDetailItem("Deskripsi", cost.description ?? "-"), 
              _buildDetailItem("Biaya", "Rp${cost.cost}"),
              _buildDetailItem("Estimasi", "${cost.etd} Hari"),
              
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Card Input (Origin, Dest, Berat, Kurir)
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedCourier,
                                items: courierOptions
                                    .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(c.toUpperCase()),
                                        ))
                                    .toList(),
                                onChanged: (v) => setState(() => selectedCourier = v ?? "jne"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Berat (gr)'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Origin
                        const Align(alignment: Alignment.centerLeft, child: Text("Origin", style: TextStyle(fontWeight: FontWeight.bold))),
                        Row(
                          children: [
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  final provinces = vm.provinceList.data ?? [];
                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedProvinceOriginId,
                                    hint: const Text('Pilih provinsi'),
                                    items: provinces.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name ?? ''))).toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceOriginId = newId;
                                        selectedCityOriginId = null;
                                      });
                                      if (newId != null) vm.getCityOriginList(newId);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  final cities = vm.cityOriginList.data ?? [];
                                  final validIds = cities.map((c) => c.id).toSet();
                                  final validValue = validIds.contains(selectedCityOriginId) ? selectedCityOriginId : null;
                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: validValue,
                                    hint: const Text('Pilih kota'),
                                    items: cities.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? ''))).toList(),
                                    onChanged: (newId) => setState(() => selectedCityOriginId = newId),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Destination
                        const Align(alignment: Alignment.centerLeft, child: Text("Destination", style: TextStyle(fontWeight: FontWeight.bold))),
                        Row(
                          children: [
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  final provinces = vm.provinceList.data ?? [];
                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedProvinceDestinationId,
                                    hint: const Text('Pilih provinsi'),
                                    items: provinces.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name ?? ''))).toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceDestinationId = newId;
                                        selectedCityDestinationId = null;
                                      });
                                      if (newId != null) vm.getCityDestinationList(newId);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  final cities = vm.cityDestinationList.data ?? [];
                                  final validIds = cities.map((c) => c.id).toSet();
                                  final validValue = validIds.contains(selectedCityDestinationId) ? selectedCityDestinationId : null;
                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    value: validValue,
                                    hint: const Text('Pilih kota'),
                                    items: cities.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? ''))).toList(),
                                    onChanged: (newId) => setState(() => selectedCityDestinationId = newId),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedCityOriginId != null &&
                                  selectedCityDestinationId != null &&
                                  weightController.text.isNotEmpty &&
                                  selectedCourier.isNotEmpty) {
                                homeViewModel.checkShipmentCost(
                                  selectedCityOriginId!.toString(), "city",
                                  selectedCityDestinationId!.toString(), "city",
                                  int.tryParse(weightController.text) ?? 0,
                                  selectedCourier,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi semua field!')));
                              }
                            },
                            child: const Text("Hitung Ongkir", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // HASIL ONGKIR (DENGAN POP-UP KLIK)
                Card(
                  color: Colors.blue[50],
                  elevation: 2,
                  child: Consumer<HomeViewModel>(
                    builder: (context, vm, _) {
                      if (vm.costList.status == Status.loading) {
                        return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
                      }
                      if (vm.costList.status == Status.error) {
                        return Padding(padding: const EdgeInsets.all(16), child: Center(child: Text(vm.costList.message ?? 'Error', style: const TextStyle(color: Colors.red))));
                      }
                      if (vm.costList.status == Status.completed) {
                        if (vm.costList.data == null || vm.costList.data!.isEmpty) {
                          return const Padding(padding: EdgeInsets.all(16), child: Center(child: Text("Tidak ada data ongkir.")));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vm.costList.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final cost = vm.costList.data!.elementAt(index);
                            
                            // IMPLEMENTASI UTAMA: Bungkus CardCost dengan GestureDetector
                            // untuk memunculkan BottomSheet saat diklik.
                            return GestureDetector(
                              onTap: () {
                                _showCostDetail(context, cost);
                              },
                              child: CardCost(cost),
                            );
                          },
                        );
                      }
                      return const Padding(padding: EdgeInsets.all(16), child: Center(child: Text("Pilih kota dan klik Hitung Ongkir.")));
                    },
                  ),
                ),
              ],
            ),
          ),
          
          if (context.watch<HomeViewModel>().isLoading)
            Container(color: Colors.black45, child: const Center(child: CircularProgressIndicator(color: Colors.white))),
        ],
      ),
    );
  }
}