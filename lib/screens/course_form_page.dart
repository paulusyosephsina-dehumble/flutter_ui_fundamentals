
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_state.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;

  const CourseFormPage({
    super.key,
    this.course,
  });

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  String _status = 'planned';

  bool get _isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();

    final course = widget.course;

    if (course != null) {
      _codeController.text = course.code;
      _titleController.text = course.title;
      _creditsController.text = course.credits.toString();
      _status = course.status;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;

    final state = context.read<CourseState>();

    final course = Course(
      id: widget.course?.id,
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );

    try {
      if (_isEditing) {
        final id = widget.course!.id;

        if (id == null) {
          throw Exception(
            'ID course tidak tersedia sehingga data tidak dapat diperbarui.',
          );
        }

        await state.updateCourse(id, course);
      } else {
        await state.createCourse(course);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Permintaan pembaruan mata kuliah berhasil.'
                : 'Permintaan tambah mata kuliah berhasil.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal ${_isEditing ? 'memperbarui' : 'menambahkan'} '
            'mata kuliah: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? 'Edit Mata Kuliah'
              : 'Tambah Mata Kuliah',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _codeController,
                readOnly: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                  hintText: 'Contoh: PTI104',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.code),
                  helperText: _isEditing
                      ? 'Kode tidak dapat diubah saat mengedit.'
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode mata kuliah wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  hintText: 'Contoh: Pemrograman Web',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.menu_book),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama mata kuliah wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah SKS',
                  hintText: 'Contoh: 3',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah SKS wajib diisi.';
                  }

                  final credits = int.tryParse(value.trim());

                  if (credits == null || credits <= 0) {
                    return 'Masukkan jumlah SKS berupa angka positif.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status Mata Kuliah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'planned',
                    child: Text('Planned'),
                  ),
                  DropdownMenuItem(
                    value: 'active',
                    child: Text('Active'),
                  ),
                  DropdownMenuItem(
                    value: 'done',
                    child: Text('Done'),
                  ),
                ],
                onChanged: state.isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _status = value);
                        }
                      },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: state.isSaving ? null : _saveCourse,
                icon: state.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        _isEditing ? Icons.edit : Icons.save,
                      ),
                label: Text(
                  state.isSaving
                      ? 'Menyimpan...'
                      : _isEditing
                          ? 'Simpan Perubahan'
                          : 'Simpan Mata Kuliah',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
