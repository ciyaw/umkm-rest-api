import 'package:flutter/material.dart';
import '../models/umkm.dart';
import '../services/umkm_service.dart';

class UmkmFormPage extends StatefulWidget {
  final Umkm? umkm;

  const UmkmFormPage({super.key, this.umkm});

  @override
  State<UmkmFormPage> createState() => _UmkmFormPageState();
}

class _UmkmFormPageState extends State<UmkmFormPage> {
  final formKey = GlobalKey<FormState>();
  final service = UmkmService();
  final kategoriList = [
    'Kuliner',
    'Fashion',
    'Kerajinan',
    'Jasa',
    'Pertanian',
    'Lainnya',
  ];

  late final nama = TextEditingController(text: widget.umkm?.namaUmkm);
  late final pemilik = TextEditingController(text: widget.umkm?.pemilik);
  late final alamat = TextEditingController(text: widget.umkm?.alamat);
  late final kontak = TextEditingController(text: widget.umkm?.kontak);
  late String? kategori = widget.umkm?.kategori;
  bool loading = false;

  @override
  void dispose() {
    nama.dispose();
    pemilik.dispose();
    alamat.dispose();
    kontak.dispose();
    super.dispose();
  }

  void tampilPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<void> simpan() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => loading = true);

    final data = Umkm(
      id: widget.umkm?.id,
      namaUmkm: nama.text.trim(),
      pemilik: pemilik.text.trim(),
      alamat: alamat.text.trim(),
      kategori: kategori!,
      kontak: kontak.text.trim(),
    );

    try {
      final res = widget.umkm == null
          ? await service.create(data)
          : await service.update(widget.umkm!.id!, data);

      if (!mounted) return;
      if (res['success'] == true) {
        tampilPesan(res['message'].toString());
        Navigator.pop(context, true);
        return;
      }
      final errors = res['errors'];
      if (errors is Map) {
        tampilPesan(errors.values.join('\n'));
      } else {
        tampilPesan(res['message'].toString());
      }
    } catch (e) {
      if (mounted) tampilPesan('Gagal terhubung ke server');
    }

    if (mounted) setState(() => loading = false);
  }

  InputDecoration dekorasi(String label, IconData ikon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(ikon),
      border: const OutlineInputBorder(),
    );
  }

  String? wajib(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.umkm != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(edit ? 'Ubah UMKM' : 'Tambah UMKM'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nama,
                decoration: dekorasi('Nama UMKM', Icons.store),
                validator: (v) => wajib(v, 'Nama UMKM'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: pemilik,
                decoration: dekorasi('Pemilik', Icons.person),
                validator: (v) => wajib(v, 'Pemilik'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: alamat,
                decoration: dekorasi('Alamat', Icons.location_on),
                maxLines: 2,
                validator: (v) => wajib(v, 'Alamat'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: kategori,
                decoration: dekorasi('Kategori', Icons.category),
                items: kategoriList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => kategori = v,
                validator: (v) => v == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: kontak,
                decoration: dekorasi('Kontak', Icons.phone),
                keyboardType: TextInputType.phone,
                validator: (v) => wajib(v, 'Kontak'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : simpan,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(edit ? 'Simpan Perubahan' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}