import 'package:flutter/material.dart';
import 'course_state.dart';

class CourseStateDemo extends StatefulWidget {
  const CourseStateDemo({super.key});

  @override
  State<CourseStateDemo> createState() => _CourseStateDemoState();
}

class _CourseStateDemoState extends State<CourseStateDemo> {
  static const String studentName = 'Paulus Yoseph Sina';
  static const String studentNim = '2415051077';

  late final CourseState courseState;

  final List<Map<String, String>> courses = const [
    {'id': 'mobile', 'title': 'Pemrograman Mobile'},
    {'id': 'network', 'title': 'Jaringan Komputer'},
    {'id': 'image', 'title': 'Pengolahan Citra Digital'},
  ];

  @override
  void initState() {
    super.initState();
    courseState = CourseState();
  }

  @override
  void dispose() {
    courseState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5 - ChangeNotifier'),
        backgroundColor: Colors.deepPurple,
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
              'ChangeNotifier dan notifyListeners()',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tekan ikon hati untuk menambahkan atau menghapus mata kuliah '
              'dari favorit. CourseState mengelola datanya, lalu '
              'notifyListeners() memberi tahu widget yang mendengarkan.',
            ),
            const SizedBox(height: 16),

            // AnimatedBuilder mendengarkan CourseState tanpa Provider.
            AnimatedBuilder(
              animation: courseState,
              builder: (context, child) {
                return Card(
                  color: Colors.deepPurple.shade50,
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.deepPurple,
                    ),
                    title: const Text(
                      'Jumlah Favorit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${courseState.favoriteCount}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            for (final course in courses)
              AnimatedBuilder(
                animation: courseState,
                builder: (context, child) {
                  final id = course['id']!;
                  final title = course['title']!;
                  final favorite = courseState.isFavorite(id);

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.school),
                      title: Text(title),
                      trailing: IconButton(
                        tooltip: favorite
                            ? 'Hapus dari favorit'
                            : 'Tambahkan ke favorit',
                        onPressed: () => courseState.toggleFavorite(id),
                        icon: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          color: favorite ? Colors.red : Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        favorite ? 'Status: Favorit' : 'Status: Bukan favorit',
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.shade100),
              ),
              child: const Text(
                'Pengamatan: logika favorites berada di CourseState, bukan '
                'di setiap widget. Setelah toggleFavorite mengubah data, '
                'notifyListeners() membuat AnimatedBuilder membangun ulang '
                'bagian UI yang mendengarkan CourseState.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
