import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('KosFinder'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<UserProfile?>(
        future: _profileFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null) {
            return const Center(child: Text('Gagal memuat profil'));
          }
          final p = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: const Text('Nama Pengguna'),
                        subtitle: Text(p.name.isEmpty ? '-' : p.name,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.email)),
                        title: const Text('Email'),
                        subtitle: Text(p.email),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.badge)),
                        title: const Text('Role (Hak Akses)'),
                        subtitle: Chip(
                          label: Text(
                            p.role.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: p.isOwner
                              ? Colors.orange
                              : (p.isAdmin ? Colors.red : Colors.indigo),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
