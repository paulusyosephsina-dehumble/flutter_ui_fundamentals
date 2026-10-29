
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

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
      itemCount = null;
      errorMessage = null;
      statusCode = null;
    });

    try {
      final service = CourseApiService(
        'https://jsonplaceholder.typicode.com',
      );

      final courses = await service.getCourses();

      if (!mounted) return;

      setState(() {
        itemCount = courses.length;
        statusCode = 200;
        isLoading = false;
      });

      debugPrint('HTTP status: $statusCode');
      debugPrint('Jumlah data: ${courses.length}');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });

      debugPrint('Gagal mengambil data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2 - HTTP GET'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
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
            const SelectableText('Endpoint: $apiUrl'),
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
            if (statusCode != null)
              Text('Status HTTP: $statusCode'),
            if (itemCount != null)
              Text(
                'Jumlah data berhasil diambil: $itemCount',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            if (errorMessage != null)
              Text(
                'Terjadi kesalahan: $errorMessage',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
