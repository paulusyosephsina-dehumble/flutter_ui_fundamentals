import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_state.dart';
import '../widgets/course_card.dart';
import 'detail_page.dart';

class CourseExplorerPage extends StatefulWidget {
  const CourseExplorerPage({super.key});

  @override
  State<CourseExplorerPage> createState() => _CourseExplorerPageState();
}

class _CourseExplorerPageState extends State<CourseExplorerPage> {
  static const String studentName = 'Paulus Yoseph Sina';
  static const String studentNim = '2415051077';

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final state = context.read<CourseState>();

      if (state.courses.isEmpty && !state.isLoading) {
        state.loadCourses();
      }
    });
  }

  void selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 700;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Explorer'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red),
                      const SizedBox(width: 6),
                      Text('${state.favoriteCount}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Row(
            children: [
              if (isWideScreen)
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: selectPage,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book),
                      label: Text('Mata Kuliah'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favorit'),
                    ),
                  ],
                ),
              if (isWideScreen) const VerticalDivider(width: 1),
              Expanded(child: _buildContent(context, state)),
            ],
          ),
          bottomNavigationBar: isWideScreen
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: selectPage,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book),
                      label: 'Mata Kuliah',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: 'Favorit',
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, CourseState state) {
    if (state.isLoading && state.courses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.courses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              const Text('Gagal memuat data mata kuliah.'),
              const SizedBox(height: 8),
              Text(state.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<CourseState>().loadCourses();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final displayedCourses = selectedIndex == 0
        ? state.courses
        : state.courses
              .where((course) => state.isFavorite(course.code))
              .toList();

    final emptyMessage = selectedIndex == 0
        ? 'Belum ada data mata kuliah.'
        : 'Belum ada mata kuliah favorit.';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text(
              studentName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('NIM: $studentNim'),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          selectedIndex == 0 ? 'Daftar Mata Kuliah' : 'Mata Kuliah Favorit',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (displayedCourses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text(emptyMessage)),
          )
        else
          ...displayedCourses.map(
            (course) => CourseCard(
              code: course.code,
              name: course.title,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(code: course.code),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
