
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_state.dart';

class CourseStateDemo extends StatelessWidget {
  const CourseStateDemo({super.key});

  static const String studentName = 'Paulus Yoseph Sina';
  static const String studentNim = '2415051077';

  static const List<Map<String, String>> courses = [
    {
      'code': 'PTI101',
      'name': 'Pemrograman Mobile',
    },
    {
      'code': 'PTI102',
      'name': 'Jaringan Komputer',
    },
    {
      'code': 'PTI103',
      'name': 'Pengolahan Citra Digital',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // WATCH: mendengarkan perubahan state dan memicu rebuild.
    final provider = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 7 - Provider'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Identitas Mahasiswa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text('Nama: Paulus Yoseph Sina'),
          const Text('NIM: 2415051077'),
          const Divider(height: 28),

          const Text(
            'Demo context.watch(), context.read(), dan Consumer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Nilai jumlah favorit dibaca menggunakan watch().
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Jumlah favorit: ${provider.favoriteCount}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Consumer membatasi rebuild pada bagian jumlah favorit ini.
          Consumer<CourseState>(
            builder: (context, courseState, child) {
              return Card(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(
                    Icons.refresh,
                    color: Colors.blue,
                  ),
                  title: const Text('Area Consumer'),
                  subtitle: Text(
                    'Consumer memperbarui bagian ini. '
                    'Total favorit: ${courseState.favoriteCount}',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),
          const Text(
            'Daftar Mata Kuliah',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          ...courses.map((course) {
            final code = course['code']!;
            final name = course['name']!;
            final isFavorite = provider.isFavorite(code);

            return Card(
              child: ListTile(
                title: Text(name),
                subtitle: Text('Kode: $code'),
                trailing: IconButton(
                  // READ: menjalankan aksi tanpa listen pada tombol.
                  onPressed: () {
                    context.read<CourseState>().toggleFavorite(code);
                  },
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  tooltip: isFavorite
                      ? 'Hapus dari favorit'
                      : 'Tambahkan ke favorit',
                ),
              ),
            );
          }),

          const SizedBox(height: 16),
          const Text(
            'Pengamatan: tekan ikon hati. '
            'Jumlah favorit dan status ikon akan diperbarui.',
          ),
        ],
      ),
    );
  }
}
