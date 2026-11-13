import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../services/kos_service.dart';
import '../widgets/role_guard.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;
  final KosService _kosService = KosService();
  List<Map<String, dynamic>> _kosList = [];
  bool _loadingKos = true;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
    _loadKosData();
  }

  Future<void> _loadKosData() async {
    setState(() => _loadingKos = true);
    try {
      final data = await _kosService.fetchAll();
      if (mounted) {
        setState(() {
          _kosList = data;
          _loadingKos = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingKos = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // Dialog Tambah Kos (Khusus Owner)
  void _showAddKosDialog() {
    final nameC = TextEditingController();
    final addressC = TextEditingController();
    final priceC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Data Kos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: 'Nama Kos'),
            ),
            TextField(
              controller: addressC,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: priceC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga / bulan'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameC.text.isEmpty) return;
              Navigator.pop(ctx);
              await _kosService.add(
                name: nameC.text.trim(),
                address: addressC.text.trim(),
                price: int.tryParse(priceC.text.trim()) ?? 0,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kos berhasil ditambahkan!')),
              );
              _loadKosData();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Praktik 6: Security Testing - Membuktikan proteksi RLS
  Future<void> _runSecurityTest(Map<String, dynamic> targetKos) async {
    final kosId = targetKos['id'] as String;
    final kosName = targetKos['name'] as String;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Security Testing (Praktik 6)'),
        content: Text(
          'Mencoba mengubah data "$kosName" milik User lain secara paksa lewat API...',
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _kosService.update(
                kosId,
                {'name': '$kosName [DIBAJAK]'},
              );

              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      '[FAIL] Data berhasil diubah! (RLS belum berfungsi)',
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      '[PASS - DITOLAK RLS] Access Denied! Anda bukan pemilik data.',
                    ),
                  ),
                );
              }
              _loadKosData();
            },
            child: const Text('Jalankan Pengujian'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myUid = AuthService.instance.currentUser?.id;

    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final p = snap.data;
        if (snap.hasError || p == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('KosFinder')),
            body: const Center(child: Text('Gagal memuat profil')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('KosFinder (${p.role.toUpperCase()})'),
            actions: [
              IconButton(
                tooltip: 'Refresh Data',
                icon: const Icon(Icons.refresh),
                onPressed: _loadKosData,
              ),
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Kartu Profil Pengguna
              Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(Icons.person, color: Colors.indigo),
                  ),
                  title: Text(
                    p.name.isEmpty ? p.email : p.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${p.email} • Role: ${p.role}'),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Judul Daftar Kos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Kos (Database Supabase)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('${_kosList.length} Kos'),
                ],
              ),
              const SizedBox(height: 8),

              // 3. Daftar Kos
              if (_loadingKos)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_kosList.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'Belum ada data kos.\nJika Anda Owner, klik tombol "Tambah Kos" di bawah.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                ..._kosList.map((kos) {
                  final isMine = kos['owner_id'] == myUid;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: isMine ? Colors.green : Colors.grey,
                      ),
                      title: Text(
                        kos['name'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${kos['address'] ?? '-'} • Rp ${kos['price'] ?? 0}\n'
                        'Status: ${isMine ? "Milik Anda (Owner)" : "Milik Pengguna Lain"}',
                      ),
                      isThreeLine: true,
                      trailing: isMine
                          ? IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Hapus Kos Milik Sendiri (Diizinkan)',
                              onPressed: () async {
                                final ok = await _kosService.delete(kos['id']);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      ok
                                          ? '[OPERASI DIIZINKAN] Data berhasil dihapus!'
                                          : 'Gagal menghapus.',
                                    ),
                                  ),
                                );
                                _loadKosData();
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.security, color: Colors.deepOrange),
                              tooltip: 'Security Test: Coba ubah data user lain',
                              onPressed: () => _runSecurityTest(kos),
                            ),
                    ),
                  );
                }),
            ],
          ),

          // Tombol Tambah Kos (Hanya untuk Owner)
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: _showAddKosDialog,
              icon: const Icon(Icons.add_home),
              label: const Text('Tambah Kos'),
            ),
          ),
        );
      },
    );
  }
}
