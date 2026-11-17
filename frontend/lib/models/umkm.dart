class Umkm {
  final int? id;
  final String namaUmkm;
  final String pemilik;
  final String alamat;
  final String kategori;
  final String kontak;

  Umkm({
    this.id,
    required this.namaUmkm,
    required this.pemilik,
    required this.alamat,
    required this.kategori,
    required this.kontak,
  });

  factory Umkm.fromJson(Map<String, dynamic> json) {
    return Umkm(
      id: int.tryParse(json['id'].toString()),
      namaUmkm: json['nama_umkm'].toString(),
      pemilik: json['pemilik'].toString(),
      alamat: json['alamat'].toString(),
      kategori: json['kategori'].toString(),
      kontak: json['kontak'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_umkm': namaUmkm,
      'pemilik': pemilik,
      'alamat': alamat,
      'kategori': kategori,
      'kontak': kontak,
    };
  }
}