import 'package:supabase_flutter/supabase_flutter.dart';

class KosService {
  final SupabaseClient _client = Supabase.instance.client;

  String get _uid => _client.auth.currentUser!.id;

  /// Mengambil semua data kos dari database
  Future<List<Map<String, dynamic>>> fetchAll() async {
    final data = await _client
        .from('kos')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  /// Menambah data kos baru (owner_id otomatis menggunakan UID pengguna saat ini)
  Future<void> add({
    required String name,
    required String address,
    required int price,
  }) async {
    await _client.from('kos').insert({
      'owner_id': _uid,
      'name': name,
      'address': address,
      'price': price,
    });
  }

  /// Mengubah data kos
  /// Return true jika baris berhasil diubah.
  /// Return false jika ditolak oleh RLS (bukan pemilik data).
  Future<bool> update(String id, Map<String, dynamic> values) async {
    final rows =
        await _client.from('kos').update(values).eq('id', id).select();
    return rows.isNotEmpty;
  }

  /// Menghapus data kos
  /// Return true jika baris berhasil dihapus.
  /// Return false jika ditolak oleh RLS (bukan pemilik data).
  Future<bool> delete(String id) async {
    final rows = await _client.from('kos').delete().eq('id', id).select();
    return rows.isNotEmpty;
  }
}
