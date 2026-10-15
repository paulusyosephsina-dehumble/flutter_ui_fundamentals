
import 'package:flutter/material.dart';

class LocalStateDemo extends StatefulWidget {
  const LocalStateDemo({super.key});

  @override
  State<LocalStateDemo> createState() => _LocalStateDemoState();
}

class _LocalStateDemoState extends State<LocalStateDemo> {
  // Identitas mahasiswa
  static const String studentName = 'Paulus Yoseph Sina';
  static const String studentId = '2415051077';

  // Local state untuk mengatur visibilitas detail mata kuliah
  bool isDetailVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Local State'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas mahasiswa
            const Text(
              studentName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'NIM: $studentId',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Judul demonstrasi
            const Text(
              'Contoh Local State',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tekan tombol di bawah untuk menampilkan '
              'atau menyembunyikan detail mata kuliah.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Kartu mata kuliah
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.school,
                          size: 32,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pemrograman Mobile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Mata kuliah pengembangan aplikasi '
                      'mobile menggunakan Flutter dan Dart.',
                    ),
                    const SizedBox(height: 16),

                    // Detail muncul hanya jika state bernilai true
                    if (isDetailVisible) ...[
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Detail Mata Kuliah',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Kode: PTI601'),
                      const Text('SKS: 3'),
                      const Text('Status: Sedang dipelajari'),
                      const SizedBox(height: 8),
                    ],

                    // Tombol untuk mengubah local state
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isDetailVisible = !isDetailVisible;
                          });
                        },
                        icon: Icon(
                          isDetailVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        label: Text(
                          isDetailVisible
                              ? 'Sembunyikan Detail'
                              : 'Tampilkan Detail',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Penjelasan konsep
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.shade200,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analisis State',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Variabel isDetailVisible merupakan local state '
                    'karena hanya mengatur tampilan detail pada '
                    'widget ini.',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Perubahan nilai dilakukan melalui setState() '
                    'agar Flutter membangun ulang bagian UI yang '
                    'bergantung pada nilai tersebut.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
