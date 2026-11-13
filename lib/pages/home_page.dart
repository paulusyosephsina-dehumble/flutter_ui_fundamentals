import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Kartu Profil Pengguna
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade100,
                          child: const Icon(Icons.person, color: Colors.indigo),
                        ),
                        title: Text(
                          p.name.isEmpty ? p.email : p.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text('${p.email} • Role: ${p.role}'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Menu Aplikasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              // Menu 1: Semua role bisa lihat
              const Card(
                child: ListTile(
                  leading: Icon(Icons.list_alt, color: Colors.blue),
                  title: Text('Daftar Kos'),
                  subtitle: Text('Jelajahi kos yang tersedia'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),

              // Menu 2: Hanya untuk Pemilik Kos (Owner) atau Admin
              if (p.isOwner || p.isAdmin)
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.home_work, color: Colors.orange),
                    title: Text('My Kos (Kos Saya)'),
                    subtitle: Text('Kelola kos milik Anda'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),

              // Menu 3: Khusus Admin
              if (p.isAdmin)
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.admin_panel_settings, color: Colors.red),
                    title: Text('Kelola Data (Admin)'),
                    subtitle: Text('Akses manajemen data penuh'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
            ],
          ),

          // Tombol melayang "Tambah Kos": HANYA muncul untuk role OWNER dan ADMIN
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Halaman Tambah Kos (Akses diizinkan untuk Owner)'),
                  ),
                );
              },
              icon: const Icon(Icons.add_home),
              label: const Text('Tambah Kos'),
            ),
          ),
        );
      },
    );
  }
}
