import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_state.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';
import 'services/course_data_source.dart';

import 'screens/local_state_demo.dart';
import 'screens/prop_drilling_demo.dart';
import 'screens/lifting_state_demo.dart';
import 'screens/value_notifier_demo.dart';
import 'screens/course_state_demo.dart';
import 'screens/favorites_page.dart';
import 'screens/course_explorer_page.dart';

// ============================================================
// KONFIGURASI API DAN IDENTITAS MAHASISWA
// ============================================================

const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';

const String studentName = 'Paulus Yoseph Sina';
const String studentNim = '2415051077';

// ============================================================
// MAIN - SERVICE -> REPOSITORY -> PROVIDER
// ============================================================

void main() {
  final CourseDataSource dataSource = CourseApiService(apiBaseUrl);

  final CourseRepository repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider<CourseState>(
      create: (_) => CourseState(repository),
      child: const MyApp(),
    ),
  );
}

// ============================================================
// APLIKASI UTAMA
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const CourseExplorerPage(),
    );
  }
}

// ============================================================
// DEBUGGING PAGE
// ============================================================

class DebuggingPage extends StatefulWidget {
  const DebuggingPage({super.key});

  @override
  State<DebuggingPage> createState() => _DebuggingPageState();
}

class _DebuggingPageState extends State<DebuggingPage> {
  bool isNavigating = false;

  // Mencegah navigasi ganda.
Future<void> openDetail() async {
  if (isNavigating) {
    return;
  }

  setState(() {
    isNavigating = true;
  });

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const DetailPage(),
    ),
  );

  if (!mounted) return;

  setState(() {
    isNavigating = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16 - Debugging'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IDENTITAS MAHASISWA
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text(
                  studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('NIM: 2415051077'),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Praktikum State Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Pilih demo untuk menguji local state dan shared state.',
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LocalStateDemo(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text(
                        'Buka Demo Tahap 1 - Local State',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PropDrillingDemo(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite),
                      label: const Text(
                        'Buka Demo Tahap 2 - Prop Drilling',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Debugging Challenge',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // KASUS A: RENDERFLEX OVERFLOW
            const Text(
              'Kasus A - RenderFlex Overflow',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.info),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$studentNim - $studentName - '
                        'teks sangat panjang yang dapat '
                        'menyebabkan RenderFlex overflow '
                        'jika tidak diberikan batas ruang.',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Solusi: gunakan Expanded agar teks menggunakan '
              'ruang yang tersedia dan dapat melakukan wrapping.',
            ),

            const SizedBox(height: 24),

            // KASUS B: LISTVIEW DALAM COLUMN
            const Text(
              'Kasus B - ListView dan Column',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'ListView diperbaiki dengan Expanded',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(
                            Icons.check_circle_outline,
                          ),
                          title: Text('Item ${index + 1}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Solusi: gunakan Expanded ketika ListView berada '
              'di dalam Column agar ListView memiliki tinggi terbatas.',
            ),

            const SizedBox(height: 24),

            // KASUS C: KEYBOARD OVERFLOW
            const Text(
              'Kasus C - Keyboard Overflow',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Form dibuat scrollable agar tetap dapat '
                      'diakses ketika keyboard muncul.',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Komentar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Coba tekan field komentar dan buka keyboard.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Solusi: gunakan SingleChildScrollView agar konten '
              'dapat digulir ketika keyboard mengurangi ruang layar.',
            ),

            const SizedBox(height: 24),

            // KASUS D: NAVIGASI GANDA
            const Text(
              'Kasus D - Navigasi Ganda',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Tekan tombol untuk membuka halaman detail.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isNavigating ? null : openDetail,
                        icon: const Icon(Icons.open_in_new),
                        label: Text(
                          isNavigating ? 'Membuka...' : 'Buka Detail',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Solusi: gunakan flag isNavigating untuk mencegah '
              'tombol melakukan push berkali-kali.',
            ),

            const SizedBox(height: 30),

            // NAVIGASI DEMO LAIN
            const Text(
              'Praktikum State Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // FIX: hapus const karena constructor
                      // LiftingStateDemo bukan const.
                      builder: (_) => LiftingStateDemo(),
                    ),
                  );
                },
                icon: const Icon(Icons.sync_alt),
                label: const Text('Buka Demo Tahap 3'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // FIX: hapus const karena constructor
                      // ValueNotifierDemo bukan const.
                      builder: (_) => ValueNotifierDemo(),
                    ),
                  );
                },
                icon: const Icon(Icons.exposure_plus_1),
                label: const Text('Buka Demo Tahap 4'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CourseStateDemo(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_active),
                label: const Text('Buka Demo Tahap 5'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CourseStateDemo(),
                    ),
                  );
                },
                child: const Text('Buka Demo Tahap 7'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoritesPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite),
                label: const Text('Buka Mata Kuliah Favorit'),
              ),
            ),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 12),

            const Text(
              'Identitas Mahasiswa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              studentName,
              style: TextStyle(fontSize: 16),
            ),

            const Text(
              'NIM: 2415051077',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL PAGE UNTUK DEBUGGING
// ============================================================

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 70,
              ),
              const SizedBox(height: 16),
              const Text(
                'Navigasi berhasil!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Halaman ini hanya akan dibuka satu kali '
                'meskipun tombol ditekan berulang kali.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DEMO PROVIDER ASYNC STATE
// ============================================================

class CourseJsonDemo extends StatefulWidget {
  const CourseJsonDemo({super.key});

  @override
  State<CourseJsonDemo> createState() => _CourseJsonDemoState();
}

class _CourseJsonDemoState extends State<CourseJsonDemo> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CourseState>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 11 - Provider Async State'),
      ),
      body: Consumer<CourseState>(
        builder: (context, state, child) {
          if (state.isLoading && state.courses.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.error != null && state.courses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Gagal memuat data: ${state.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Card(
                child: ListTile(
                  title: Text(
                    studentName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('NIM: 2415051077'),
                ),
              ),
              const SizedBox(height: 8),
              ...state.courses.map(
                (course) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: Text(course.title),
                    subtitle: Text(
                      'Kode: ${course.code}\n'
                      'SKS: ${course.credits}\n'
                      'Status: ${course.status}',
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
