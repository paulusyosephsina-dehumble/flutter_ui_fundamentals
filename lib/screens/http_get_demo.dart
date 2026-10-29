
import 'package:flutter/material.dart';
import '../services/course_api_service.dart';

const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
const String studentName = 'Paulus Yoseph Sina';
const String studentNim = '2415051077';

class HttpGetDemo extends StatefulWidget {
  const HttpGetDemo({super.key});

  @override
  State<HttpGetDemo> createState() => _HttpGetDemoState();
}

class _HttpGetDemoState extends State<HttpGetDemo> {
  bool isLoading = false;
  int? itemCount;
  String? errorMessage;
  int? statusCode;

  // Endpoint sengaja dibuat salah untuk menguji HTTP 404.
  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
      itemCount = null;
      errorMessage = null;
      statusCode = null;
    });

    try {
      final service = CourseApiService(
        'https://jsonplaceholder.typicode.com/endpoint-salah',
      );

      final courses = await service.getCourses();

      if (!mounted) return;

      setState(() {
        itemCount = courses.length;
        statusCode = 200;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2 - HTTP GET'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  studentName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('NIM: $studentNim'),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Pengujian REST API',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            const Text('Endpoint normal:'),
            const SelectableText(apiUrl),
            const SizedBox(height: 8),

            const Text('Endpoint pengujian (sengaja salah):'),
            const SelectableText(
              'https://jsonplaceholder.typicode.com/endpoint-salah/posts',
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: isLoading ? null : fetchPosts,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Ambil Data (HTTP GET)'),
            ),
            const SizedBox(height: 16),

            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (statusCode != null) ...[
              Text('Status HTTP: $statusCode'),
              const SizedBox(height: 8),
              Text(
                'Jumlah data berhasil diambil: $itemCount',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],

            if (errorMessage != null) ...[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 36,
              ),
              const SizedBox(height: 8),
              const Text(
                'Permintaan gagal',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: isLoading ? null : fetchPosts,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
