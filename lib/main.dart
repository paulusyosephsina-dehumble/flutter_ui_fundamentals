import 'package:flutter/material.dart';
import 'screens/local_state_demo.dart';
import 'screens/prop_drilling_demo.dart';
import 'screens/lifting_state_demo.dart';
import 'screens/value_notifier_demo.dart';
import 'screens/course_state_demo.dart';
import 'package:provider/provider.dart';
import 'providers/course_state.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'models/course.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'screens/favorites_page.dart';




Future<List<Course>> loadCourses() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  final Map<String, dynamic> data = jsonDecode(jsonString);

  final List<dynamic> coursesJson = data['courses'];

  return coursesJson
      .map(
        (item) => Course.fromJson(
          item as Map<String, dynamic>,
        ),
      )
      .toList();
}

void main() {
  runApp(
    ChangeNotifierProvider<CourseState>(
      create: (_) => CourseState(
        CourseRepository(CourseService()),
      ),
      child: const MyApp(),
    ),
  );
}

const String studentName = 'Paulus Yoseph Sina';
const String studentNim = '2415051077';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 16 Debugging',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const DebuggingPage(),
    );
  }
}

class DebuggingPage extends StatefulWidget {
  const DebuggingPage({super.key});

  @override
  State<DebuggingPage> createState() => _DebuggingPageState();
}

class _DebuggingPageState extends State<DebuggingPage> {
  bool isNavigating = false;

  // ==========================================================
  // KASUS D - Mencegah navigasi ganda
  // ==========================================================

  Future<void> openDetail() async {
    // Jika sedang melakukan navigasi, jangan jalankan lagi.
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
            // =================================================
            // IDENTITAS
            // =================================================

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
                subtitle: const Text(
                  'NIM: 2415051077',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // NAVIGASI DEMO TAHAP 1 DAN TAHAP 2
            // =================================================

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
                            builder: (context) => const LocalStateDemo(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('Buka Demo Tahap 1 - Local State'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PropDrillingDemo(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite),
                      label: const Text('Buka Demo Tahap 2 - Prop Drilling'),
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

            // =================================================
            // KASUS A
            // =================================================

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

                    // Expanded memberikan batas lebar
                    // kepada Text agar tidak keluar layar.
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
              'Solusi: gunakan Expanded agar Text menggunakan '
              'ruang yang tersedia dan dapat melakukan wrapping.',
            ),

            const SizedBox(height: 24),

            // =================================================
            // KASUS B
            // =================================================

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

                  // Expanded memberikan batas tinggi
                  // kepada ListView.
                  Expanded(
                    child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(
                            Icons.check_circle_outline,
                          ),
                          title: Text(
                            'Item ${index + 1}',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Solusi: gunakan Expanded ketika ListView '
              'berada di dalam Column agar ListView memiliki '
              'tinggi yang terbatas.',
            ),

            const SizedBox(height: 24),

            // =================================================
            // KASUS C
            // =================================================

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
                      'Form dibuat scrollable agar tetap '
                      'dapat diakses ketika keyboard muncul.',
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
              'Solusi: halaman utama menggunakan '
              'SingleChildScrollView sehingga konten dapat '
              'di-scroll ketika keyboard mengurangi ruang layar.',
            ),

            const SizedBox(height: 24),

            // =================================================
            // KASUS D
            // =================================================

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
                        onPressed:
                            isNavigating ? null : openDetail,
                        icon: const Icon(Icons.open_in_new),
                        label: Text(
                          isNavigating
                              ? 'Membuka...'
                              : 'Buka Detail',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Solusi: gunakan flag isNavigating untuk '
              'mencegah tombol melakukan push berkali-kali.',
            ),

            const SizedBox(height: 30),

            const SizedBox(height: 16),

const Text(
  'Praktikum State Management',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 8),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LiftingStateDemo(),
        ),
      );
    },
    icon: const Icon(Icons.sync_alt),
    label: const Text('Buka Demo Tahap 3'),
  ),
),

const SizedBox(height: 16),

const SizedBox(height: 8),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ValueNotifierDemo(),
        ),
      );
    },
    icon: const Icon(Icons.exposure_plus_1),
    label: const Text('Buka Demo Tahap 4'),
  ),
),

const SizedBox(height: 16),


const SizedBox(height: 8),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CourseStateDemo(),
        ),
      );
    },
    icon: const Icon(Icons.notifications_active),
    label: const Text('Buka Demo Tahap 5'),
  ),
),

const SizedBox(height: 16),

ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CourseStateDemo(),
      ),
    );
  },
  child: const Text('Buka Demo Tahap 7'),
),

ElevatedButton.icon(
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


const SizedBox(height: 12),


ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CourseJsonDemo(),
      ),
    );
  },
  icon: const Icon(Icons.menu_book),
  label: const Text('Buka Demo Tahap 8 - Model Course'),
),

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
              'Paulus Yoseph Sina',
              style: TextStyle(fontSize: 16),
            ),

            const Text(
              '2415051077',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL PAGE
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
              child: Text('Gagal memuat data: ${state.error}'),
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
