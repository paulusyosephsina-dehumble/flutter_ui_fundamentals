import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_state.dart';

class CourseCard extends StatelessWidget {
  final String code;
  final String name;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.code,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<CourseState>().isFavorite(code);

    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('Kode: $code'),
        onTap: onTap,
        trailing: IconButton(
          tooltip: isFavorite
              ? 'Hapus dari favorit'
              : 'Tambahkan ke favorit',
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            context.read<CourseState>().toggleFavorite(code);
          },
        ),
      ),
    );
  }
}