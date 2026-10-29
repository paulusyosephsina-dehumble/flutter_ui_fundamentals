
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase
        .from('courses')
        .select()
        .order('id');

    return (data as List<dynamic>)
        .map(
          (item) => Course.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    throw UnimplementedError(
      'Tambah mata kuliah belum diterapkan pada tahap ini.',
    );
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    throw UnimplementedError(
      'Ubah mata kuliah belum diterapkan pada tahap ini.',
    );
  }

  @override
  Future<void> deleteCourse(int id) async {
    throw UnimplementedError(
      'Hapus mata kuliah belum diterapkan pada tahap ini.',
    );
  }
}
