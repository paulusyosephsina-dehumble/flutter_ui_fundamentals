import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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