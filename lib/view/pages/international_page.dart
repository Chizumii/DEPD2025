part of 'pages.dart';

class InternationalPage extends StatefulWidget {
  const InternationalPage({super.key});

  @override
  State<InternationalPage> createState() => _InternationalPageState();
}

class _InternationalPageState extends State<InternationalPage> {
  // ViewModel
  late HomeViewModel homeViewModel;
  late InternationalViewModel internationalViewModel;

  final weightController = TextEditingController();
  
  // Opsi Kurir
  final List<String> courierOptions = ["pos", "tiki", "jne", "expedito"];
  String selectedCourier = "pos";

  // Variabel State Pilihan User
  int? selectedProvinceOriginId;
  int? selectedCityOriginId;
  String? selectedCountryDestinationId; // ID Negara bentuknya String ("108")

  @override
  void initState() {
    super.initState();
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    internationalViewModel = Provider.of<InternationalViewModel>(context, listen: false);

    // Load data provinsi saat halaman dibuka
    if (homeViewModel.provinceList.status == Status.notStarted) {
      homeViewModel.getProvinceList();
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  void _checkInternationalCost() {
    // Validasi semua input terisi
    if (selectedCityOriginId == null ||
        selectedCountryDestinationId == null ||
        weightController.text.isEmpty ||
        selectedCourier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi Origin, Negara Tujuan, dan Berat!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Validasi berat
    final weight = int.tryParse(weightController.text) ?? 0;
    if (weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berat harus lebih dari 0')),
      );
      return;
    }

    // Panggil ViewModel untuk hitung ongkir
    internationalViewModel.checkInternationalCost(
      selectedCityOriginId!.toString(), // Origin ID (Kota)
      selectedCountryDestinationId!,    // Destination ID (Negara)
      weight,
      selectedCourier,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- INPUT 1: KURIR & BERAT ---
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedCourier,
                                decoration: const InputDecoration(
                                  labelText: 'Kurir',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                                items: courierOptions.map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase()))).toList(),
                                onChanged: (v) => setState(() => selectedCourier = v ?? "pos"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Berat (gram)',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // --- INPUT 2: ORIGIN (PROVINSI & KOTA) ---
                        const Text("Asal Pengiriman (Indonesia)", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Dropdown Provinsi
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  final provinces = vm.provinceList.data ?? [];
                                  return DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    value: selectedProvinceOriginId,
                                    decoration: const InputDecoration(labelText: 'Provinsi', border: OutlineInputBorder()),
                                    items: provinces.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name ?? '', overflow: TextOverflow.ellipsis))).toList(),
                                    onChanged: (newId) {
                                      setState(() {
                                        selectedProvinceOriginId = newId;
                                        selectedCityOriginId = null; // Reset kota saat ganti provinsi
                                      });
                                      if (newId != null) vm.getCityOriginList(newId);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Dropdown Kota
                            Expanded(
                              child: Consumer<HomeViewModel>(
                                builder: (context, vm, _) {
                                  final cities = vm.cityOriginList.data ?? [];
                                  // Pastikan value yang dipilih ada di list
                                  final validValue = cities.any((c) => c.id == selectedCityOriginId) ? selectedCityOriginId : null;
                                  
                                  return DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    value: validValue,
                                    decoration: const InputDecoration(labelText: 'Kota', border: OutlineInputBorder()),
                                    items: cities.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? '', overflow: TextOverflow.ellipsis))).toList(),
                                    onChanged: (newId) => setState(() => selectedCityOriginId = newId),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // --- INPUT 3: DESTINATION (AUTOCOMPLETE NEGARA) ---
                        const Text("Tujuan Pengiriman (Luar Negeri)", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        
                        Autocomplete<InternationalDestination>(
                          // Menampilkan Nama Negara di List
                          displayStringForOption: (InternationalDestination option) => option.name ?? '',
                          
                          // Logika Pencarian
                          optionsBuilder: (TextEditingValue textEditingValue) async {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<InternationalDestination>.empty();
                            }
                            // Panggil fungsi search di ViewModel
                            return await internationalViewModel.searchDestinations(textEditingValue.text);
                          },
                          
                          // Saat User Memilih Salah Satu Negara
                          onSelected: (InternationalDestination selection) {
                            setState(() {
                              selectedCountryDestinationId = selection.id; // Simpan ID Negara ("108")
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Negara terpilih: ${selection.name}"), duration: const Duration(milliseconds: 500)),
                            );
                          },
                          
                          // Tampilan Field Input
                          fieldViewBuilder: (context, textEditingController, focusNode, onEditingComplete) {
                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              onEditingComplete: onEditingComplete,
                              decoration: InputDecoration(
                                labelText: 'Ketik Nama Negara (misal: Malaysia)',
                                border: const OutlineInputBorder(),
                                // PERUBAHAN: Ikon diganti menjadi pesawat
                                prefixIcon: const Icon(Icons.flight),
                                suffixIcon: selectedCountryDestinationId != null 
                                  ? const Icon(Icons.check_circle, color: Colors.green) 
                                  : null,
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 20),

                        // --- TOMBOL HITUNG ---
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _checkInternationalCost,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text("Hitung Ongkir", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // --- HASIL ONGKIR ---
                const SizedBox(height: 16),
                Consumer<InternationalViewModel>(
                  builder: (context, vm, _) {
                    if (vm.costList.status == Status.loading) {
                      return const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()));
                    }
                    if (vm.costList.status == Status.error) {
                      return Center(child: Text("Error: ${vm.costList.message}", style: const TextStyle(color: Colors.red)));
                    }
                    if (vm.costList.status == Status.completed) {
                      final costs = vm.costList.data ?? [];
                      if (costs.isEmpty) return const Center(child: Text("Data ongkir tidak ditemukan."));
                      
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: costs.length,
                        itemBuilder: (ctx, i) => CardCost(costs[i]), // Widget CardCost harus sudah ada
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          
          // Overlay Loading Global
          Consumer<InternationalViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}