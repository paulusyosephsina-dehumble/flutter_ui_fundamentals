import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_state.dart';
import '../widgets/course_card.dart';
import 'detail_page.dart';
import 'favorites_page.dart';

class CourseStateDemo extends StatefulWidget {
  const CourseStateDemo({super.key});

  @override
  State<CourseStateDemo> createState() => _CourseStateDemoState();
}

class _CourseStateDemoState extends State<CourseStateDemo> {
  static const String studentName = 'Paulus Yoseph Sina';
  static const String studentNim = '2415051077';

  @override
  void initState() {
    super.initState();

    // Muat data JSON jika belum tersedia.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final state = context.read<CourseState>();

      if (state.courses.isEmpty && !state.isLoading) {
        state.loadCourses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 13 - Shared Favorites'),
        actions: [
          IconButton(
            tooltip: 'Mata Kuliah Favorit',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
          ),
        ],
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
          const Text('Nama: $studentName'),
          const Text('NIM: $studentNim'),
          const Divider(height: 28),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Jumlah favorit: ${state.favoriteCount}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Daftar Mata Kuliah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          if (state.isLoading && state.courses.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (state.error != null && state.courses.isEmpty)
            Column(
              children: [
                Text('Gagal memuat data: ${state.error}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<CourseState>().loadCourses();
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            )
          else if (state.courses.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Belum ada data mata kuliah.'),
            )
          else
            ...state.courses.map(
              (course) => CourseCard(
                code: course.code,
                name: course.title,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(
                        code: course.code,
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
            label: const Text('Lihat Mata Kuliah Favorit'),
          ),

          const SizedBox(height: 16),

          const Text(
            'Pengamatan: tekan ikon hati untuk menambah atau '
            'menghapus favorit. Status favorit diperbarui '
            'pada daftar, detail, dan halaman favorit.',
          ),
        ],
      ),
    );
  }
}