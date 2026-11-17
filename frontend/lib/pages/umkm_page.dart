import 'package:flutter/material.dart';
import '../models/umkm.dart';
import '../services/umkm_service.dart';
import 'umkm_form_page.dart';

class UmkmPage extends StatefulWidget {
  const UmkmPage({super.key});

  @override
  State<UmkmPage> createState() => _UmkmPageState();
}

class _UmkmPageState extends State<UmkmPage> {
  final service = UmkmService();
  late Future<List<Umkm>> future;

  @override
  void initState() {
    super.initState();
    future = service.getAll();
  }

  void reload() {
    setState(() {
      future = service.getAll();
    });
  }

  Future<void> bukaForm([Umkm? umkm]) async {
    final berhasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => UmkmFormPage(umkm: umkm)),
    );
    if (berhasil == true) reload();
  }

  Future<void> hapus(Umkm umkm) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus Data'),
        content: Text('Hapus ${umkm.namaUmkm}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ya != true) return;

    String pesan;
    try {
      final res = await service.delete(umkm.id!);
      pesan = res['message'].toString();
    } catch (e) {
      pesan = 'Gagal terhubung ke server';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
    reload();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data UMKM'),
        backgroundColor: warna.primaryContainer,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => bukaForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: FutureBuilder<List<Umkm>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48),
                  const SizedBox(height: 8),
                  const Text('Gagal mengambil data'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: reload,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final list = snapshot.data!;
          if (list.isEmpty) {
            return const Center(child: Text('Belum ada data UMKM'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              reload();
              await future;
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final u = list[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: warna.primaryContainer,
                      child: Text(u.namaUmkm[0].toUpperCase()),
                    ),
                    title: Text(
                      u.namaUmkm,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${u.kategori} • ${u.pemilik}\n${u.alamat}\n${u.kontak}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'edit') bukaForm(u);
                        if (v == 'hapus') hapus(u);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Ubah')),
                        PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}