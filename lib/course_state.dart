
import 'package:flutter/foundation.dart';

class CourseState extends ChangeNotifier {
  // Satu sumber state untuk daftar course favorit.
  final Set<String> favorites = <String>{};

  bool isFavorite(String id) {
    return favorites.contains(id);
  }

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    // Memberi tahu listener bahwa state sudah berubah.
    notifyListeners();
  }

  int get favoriteCount => favorites.length;
}
