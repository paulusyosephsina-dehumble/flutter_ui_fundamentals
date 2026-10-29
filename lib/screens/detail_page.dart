
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_state.dart';
import 'course_form_page.dart';

class DetailPage extends StatelessWidget {
  final String code;

  const DetailPage({
    super.key,
    required this.code,
  });

  Future<void> _deleteCourse(
    BuildContext context,
    Course course,
  ) async {
    // Dialog konfirmasi sebelum menghapus
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Mata Kuliah?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '${course.title} (${course.code})?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final state = context.read<CourseState>();
      final courseId = course.id;

      if (courseId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID mata kuliah tidak ditemukan.'),
          ),
        );
        return;
      }

      await state.deleteCourse(courseId, course.code);

      if (!context.mounted) return;

      // Kembali ke halaman sebelumnya setelah berhasil
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mata kuliah berhasil dihapus.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus mata kuliah: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();

    final matchingCourses = state.courses
        .where((item) => item.code == code)
        .toList();

    if (matchingCourses.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Mata Kuliah'),
        ),
        body: const Center(
          child: Text('Mata kuliah tidak ditemukan.'),
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
            tooltip: 'Edit mata kuliah',
            icon: const Icon(Icons.edit),
            onPressed: state.isSaving
                ? null
                : () {
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
                    onPressed: state.isSaving
                        ? null
                        : () {
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
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: state.isSaving
                        ? null
                        : () => _deleteCourse(context, course),
                    icon: const Icon(Icons.delete),
                    label: Text(
                      state.isSaving
                          ? 'Sedang memproses...'
                          : 'Hapus Mata Kuliah',
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
