import 'package:flutter/material.dart';

class LiftingStateDemo extends StatefulWidget {
  const LiftingStateDemo({super.key});

  @override
  State<LiftingStateDemo> createState() => _LiftingStateDemoState();
}

class _LiftingStateDemoState extends State<LiftingStateDemo> {
  static const String studentName = 'Paulus Yoseph Sina';
  static const String studentNim = '2415051077';

  // Single source of truth: parent menjadi satu-satunya pemilik state.
  bool isFavorite = false;

  // Child meminta perubahan; parent yang mengubah state.
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3 - Lifting State Up'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text(
                  studentName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('NIM: 2415051077'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Single Source of Truth',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Status favorit disimpan satu kali di parent. '
              'CourseCard dan FavoriteSummary menerima nilai yang sama '
              'melalui constructor.',
            ),
            const SizedBox(height: 20),

            // Child pertama menerima data dan callback.
            CourseCard(
              isFavorite: isFavorite,
              onFavoriteChanged: toggleFavorite,
            ),
            const SizedBox(height: 16),

            // Child kedua menerima state yang sama dari parent.
            FavoriteSummary(isFavorite: isFavorite),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: const Text(
                'Analisis: CourseCard tidak menyimpan salinan state favorit. '
                'Child hanya menampilkan nilai yang diterima dan mengirim '
                'aksi ke parent melalui callback. Dengan demikian, '
                'kedua widget menggunakan satu sumber data yang konsisten.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Child 1: CourseCard',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.school, size: 36, color: Colors.indigo),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pemrograman Mobile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Mata kuliah pengembangan aplikasi Flutter.'),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite
                      ? 'Hapus dari favorit'
                      : 'Tambahkan ke favorit',
                  onPressed: onFavoriteChanged,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isFavorite
                  ? 'Status pada CourseCard: Favorit'
                  : 'Status pada CourseCard: Bukan favorit',
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteSummary extends StatelessWidget {
  final bool isFavorite;

  const FavoriteSummary({
    super.key,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isFavorite ? Colors.pink.shade50 : Colors.grey.shade100,
      child: ListTile(
        leading: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey,
          size: 30,
        ),
        title: const Text(
          'Child 2: FavoriteSummary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          isFavorite
              ? 'Pemrograman Mobile tersimpan sebagai favorit.'
              : 'Belum ada mata kuliah yang difavoritkan.',
        ),
        trailing: Text(
          isFavorite ? 'Favorit' : 'Tidak',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isFavorite ? Colors.red : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
