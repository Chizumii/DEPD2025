part of 'model.dart';

class InternationalDestination extends Equatable {
  final String? id;
  final String? name;

  const InternationalDestination({this.id, this.name});

  factory InternationalDestination.fromJson(Map<String, dynamic> json) {
    return InternationalDestination(
      // Mengambil key sesuai JSON RajaOngkir untuk Internasional
      id: json['country_id'], 
      name: json['country_name'],
    );
  }

  @override
  List<Object?> get props => [id, name];

  // Override toString agar mudah dibaca saat debug atau autocomplete default
  @override
  String toString() => name ?? '';
}