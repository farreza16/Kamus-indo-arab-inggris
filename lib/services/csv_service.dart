import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/word.dart';

class CSVService {
  static const String CSV_PATH = 'assets/dictionary.csv';

  /// **📥 Memuat data dari CSV dan mengonversinya ke daftar objek `Word`**
  Future<List<Word>> loadCSVData() async {
    try {
      // Baca file CSV dari assets
      final String csvData = await rootBundle.loadString(CSV_PATH);
      print('📄 CSV file loaded successfully');

      // Konversi CSV menjadi daftar baris
      List<List<dynamic>> rows = const CsvToListConverter()
          .convert(csvData, shouldParseNumbers: false);

      if (rows.isEmpty) {
        print('⚠️ No data found in CSV.');
        return [];
      }

      print('📊 CSV contains ${rows.length} rows');

      // Pastikan header dihapus
      if (rows.isNotEmpty &&
          rows[0].length > 0 &&
          rows[0][0].toString().toLowerCase() == 'category') {
        rows.removeAt(0); // Remove header
      }

      // Konversi setiap baris menjadi objek `Word`
      List<Word> words = rows
          .map((row) {
            if (row.length >= 7) {
              return Word(
                id: 0, // ID akan di-generate saat dimasukkan ke database
                category: row[0]?.toString().trim() ?? '',
                indonesia: row[1]?.toString().trim() ?? '',
                indonesiaAudio: row[2]?.toString().trim() ?? '',
                arabic: row[3]?.toString().trim() ?? '',
                arabicAudio: row[4]?.toString().trim() ?? '',
                english: row[5]?.toString().trim() ?? '',
                englishAudio: row[6]?.toString().trim() ?? '',
              );
            }
            return null;
          })
          .whereType<Word>()
          .toList();

      print('✅ CSV parsed successfully with ${words.length} words');

      // Validasi data
      _validateCSVData(words);

      return words;
    } catch (e) {
      print('❌ Error loading CSV: $e');
      return [];
    }
  }

  /// **🔍 Validasi data CSV**
  void _validateCSVData(List<Word> words) {
    // Periksa kategori
    final categories = words.map((word) => word.category).toSet();
    print('📊 Categories found in CSV: $categories');

    // Periksa jumlah kata per kategori
    for (var category in categories) {
      final count = words.where((word) => word.category == category).length;
      print('📊 Category $category has $count words in CSV');
    }

    // Periksa data audio
    final missingAudio = words
        .where((word) =>
            word.indonesiaAudio.isEmpty ||
            word.arabicAudio.isEmpty ||
            word.englishAudio.isEmpty)
        .length;

    if (missingAudio > 0) {
      print('⚠️ Found $missingAudio words with missing audio files');
    }
  }

  /// **🔄 Reimport data CSV ke database**
  Future<List<Word>> getCSVDataForCategory(String category) async {
    final words = await loadCSVData();
    return words.where((word) => word.category == category).toList();
  }
}
