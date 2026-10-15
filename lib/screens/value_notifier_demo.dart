import 'package:flutter/material.dart';

class ValueNotifierDemo extends StatefulWidget {
  const ValueNotifierDemo({super.key});

  @override
  State<ValueNotifierDemo> createState() => _ValueNotifierDemoState();
}

class _ValueNotifierDemoState extends State<ValueNotifierDemo> {
  static const String studentName = 'Paulus Yoseph Sina';
  static const String studentNim = '2415051077';

  late final ValueNotifier<int> favoriteCount;

  @override
  void initState() {
    super.initState();
    favoriteCount = ValueNotifier<int>(0);
  }

  void increaseFavorite() {
    favoriteCount.value++;
  }

  void decreaseFavorite() {
    if (favoriteCount.value > 0) {
      favoriteCount.value--;
    }
  }

  @override
  void dispose() {
    favoriteCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4 - ValueNotifier'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text(
                  studentName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('NIM: 2415051077'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ValueNotifier dan ValueListenableBuilder',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gunakan tombol tambah dan kurang untuk mengubah jumlah '
              'favorit. Angka diperbarui oleh ValueListenableBuilder '
              'tanpa memanggil setState() pada setiap perubahan nilai.',
            ),
            const SizedBox(height: 24),
            Center(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      const Text(
                        'Jumlah Mata Kuliah Favorit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<int>(
                        valueListenable: favoriteCount,
                        builder: (context, value, child) {
                          return Text(
                            '$value',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
                            tooltip: 'Kurangi jumlah favorit',
                            onPressed: decreaseFavorite,
                            icon: const Icon(Icons.remove),
                          ),
                          const SizedBox(width: 20),
                          IconButton.filled(
                            tooltip: 'Tambah jumlah favorit',
                            onPressed: increaseFavorite,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Jumlah tidak dapat dikurangi hingga negatif.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Perbandingan dengan setState()',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dengan setState(), pemanggilan pada State menjadwalkan '
              'pembangunan ulang subtree yang dibuat oleh metode build. '
              'Dengan ValueNotifier, perubahan nilai memberi tahu listener; '
              'ValueListenableBuilder membangun ulang bagian UI yang '
              'mendengarkan nilai tersebut. ValueNotifier cocok untuk state '
              'sederhana, tetapi bukan pengganti otomatis untuk semua '
              'kebutuhan shared state.',
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade100),
              ),
              child: const Text(
                'Catatan: favoriteCount hanya digunakan pada halaman demo ini. '
                'Jika data perlu digunakan bersama di banyak halaman, '
                'pertimbangkan arsitektur state management yang lebih '
                'terstruktur.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  