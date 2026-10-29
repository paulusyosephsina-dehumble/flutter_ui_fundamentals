
import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  final CourseDataSource service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }

  Future<Course> createCourse(Course course) {
    return service.createCourse(course);
  }

  Future<void> updateCourse(int id, Course course) {
    return service.updateCourse(id, course);
  }

  Future<void> deleteCourse(int id) {
    return service.deleteCourse(id);
  }
}
