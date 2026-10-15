
import 'package:flutter/material.dart';

class PropDrillingDemo extends StatefulWidget {
  const PropDrillingDemo({super.key});

  @override
  State<PropDrillingDemo> createState() => _PropDrillingDemoState();
}

class _PropDrillingDemoState extends State<PropDrillingDemo> {
  static const String studentName = 'Paulus Yoseph Sina';
  static const String studentId = '2415051077';

  // Satu state favorites dimiliki oleh parent.
  final Set<String> favorites = {};

  final List<String> courses = [
    'Pemrograman Mobile',
    'Jaringan Komputer',
    'Pengolahan Citra Digital',
  ];

  // Callback dari child diterima dan diproses oleh parent.
  void toggleFavorite(String course) {
    setState(() {
      if (favorites.contains(course)) {
        favorites.remove(course);
      } else {
        favorites.add(course);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Prop Drilling'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              studentName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('NIM: $studentId'),
            const SizedBox(height: 20),

            const Text(
              'Tahap 2: Keterbatasan setState()',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Data favorites disimpan oleh parent, lalu '
              'diteruskan ke dua child melalui constructor. '
              'Child mengirim perubahan melalui callback.',
            ),
            const SizedBox(height: 20),

            // CHILD 1
            CourseListChild(
              courses: courses,
              favorites: favorites,
              onToggleFavorite: toggleFavorite,
            ),

            const SizedBox(height: 20),

            // CHILD 2
            FavoriteChild(
              favorites: favorites,
              onToggleFavorite: toggleFavorite,
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Analisis: Parent harus meneruskan favorites '
                'dan callback ke child yang membutuhkan data. '
                'Jika hierarki widget semakin dalam, proses '
                'penerusan ini dapat menjadi berulang.',
                style: TextStyle(color: Colors.orange.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CHILD 1: menampilkan seluruh mata kuliah.
class CourseListChild extends StatelessWidget {
  final List<String> courses;
  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;

  const CourseListChild({
    super.key,
    required this.courses,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Child 1: Daftar Mata Kuliah',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            for (final course in courses)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(course),
                trailing: IconButton(
                  icon: Icon(
                    favorites.contains(course)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favorites.contains(course)
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () => onToggleFavorite(course),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// CHILD 2: menampilkan daftar favorit.
class FavoriteChild extends StatelessWidget {
  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;

  const FavoriteChild({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.pink.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Child 2: Mata Kuliah Favorit',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            if (favorites.isEmpty)
              const Text('Belum ada mata kuliah favorit.'),

            for (final course in favorites.toList())
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(course),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  tooltip: 'Hapus dari favorit',
                  onPressed: () => onToggleFavorite(course),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
