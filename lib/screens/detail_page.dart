
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_state.dart';
import 'course_form_page.dart';

class DetailPage extends StatelessWidget {
  final String code;

  const DetailPage({
    super.key,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();

    final matchingCourses =
        state.courses.where((item) => item.code == code);

    if (matchingCourses.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Mata Kuliah'),
        ),
        body: const Center(
          child: Text('Data mata kuliah tidak ditemukan.'),
        ),
      );
    }

    final course = matchingCourses.first;
    final isFavorite = state.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mata Kuliah'),
        actions: [
          IconButton(
            tooltip: 'Edit Mata Kuliah',
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(
                    course: course,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text('Kode: ${course.code}'),
                Text('SKS: ${course.credits}'),
                Text('Status: ${course.status}'),
                const Divider(height: 28),
                Row(
                  children: [
                    Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isFavorite
                            ? 'Mata kuliah ini adalah favorit'
                            : 'Mata kuliah ini bukan favorit',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<CourseState>()
                          .toggleFavorite(course.code);
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_border
                          : Icons.favorite,
                    ),
                    label: Text(
                      isFavorite
                          ? 'Hapus dari Favorit'
                          : 'Tambahkan ke Favorit',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
