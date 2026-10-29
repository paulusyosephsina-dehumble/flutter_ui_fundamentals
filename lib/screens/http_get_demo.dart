
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      final response = await http.get(Uri.parse(apiUrl));
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        final List<dynamic> posts =
            jsonDecode(response.body) as List<dynamic>;

        setState(() {
          itemCount = posts.length;
          isLoading = false;
        });

        debugPrint('HTTP status: ${response.statusCode}');
        debugPrint('Jumlah data: ${posts.length}');
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
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
      appBar: AppBar(title: const Text('Tahap 2 - HTTP GET')),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('NIM: 2415051077'),
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
              const Center(child: CircularProgressIndicator()),
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
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
