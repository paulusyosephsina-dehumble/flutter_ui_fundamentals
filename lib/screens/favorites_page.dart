import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_state.dart';
import '../widgets/course_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();

    final favoriteCourses = state.courses
        .where((course) => state.isFavorite(course.code))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Kuliah Favorit'),
      ),
      body: state.isLoading && state.courses.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : favoriteCourses.isEmpty
              ? const Center(
                  child: Text('Belum ada mata kuliah favorit.'),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Jumlah favorit: ${state.favoriteCount}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...favoriteCourses.map(
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
                  ],
                ),
    );
  }
}
