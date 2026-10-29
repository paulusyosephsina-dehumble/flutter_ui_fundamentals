
import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository repository;

  CourseState(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  // Shared Favorites
  final Set<String> favorites = <String>{};

  bool isFavorite(String code) {
    return favorites.contains(code);
  }

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }

    notifyListeners();
  }

  int get favoriteCount => favorites.length;

  // GET: Memuat daftar course
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // POST: Membuat course baru
  Future<void> createCourse(Course course) async {
    if (isSaving) return;

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.createCourse(course);
      await loadCourses();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // PUT: Memperbarui course
  Future<void> updateCourse(int id, Course course) async {
    if (isSaving) return;

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);
      await loadCourses();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // DELETE: Menghapus course berdasarkan ID
  Future<void> deleteCourse(int id, String code) async {
    if (isSaving) return;

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      // Hapus course melalui REST API
      await repository.deleteCourse(id);

      // Hapus course dari daftar favorit
      favorites.remove(code);

      // Muat ulang daftar course
      await loadCourses();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
