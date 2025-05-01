import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/word.dart';

class DatabaseService {
  static Database? _database;
  static const String CSV_PATH = 'assets/dictionary.csv';
  static const String DB_NAME = 'dictionary.db';
  static const int DB_VERSION = 3; // Tingkatkan versi untuk memaksa upgrade
  static const bool ALWAYS_RESET_ON_START =
      true; // Selalu reset saat aplikasi dibuka

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  /// **🔄 Reset Database - Hapus dan Buat Ulang**
  Future<void> resetDatabase() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    print('🗑 Deleting old database at: $path');
    await deleteDatabase(path); // Hapus database lama
    _database = null; // Reset instance database

    // Initialize without recursive call
    _database = await _initDatabase();

    // Import data directly
    await _importCsvData(await database);
    print('✅ Database reset and reloaded successfully');
  }

  /// **🛠 Inisialisasi Database**
  Future<void> initialize() async {
    try {
      print('🚀 Starting database initialization...');

      // Jika ALWAYS_RESET_ON_START aktif, selalu reset database
      if (ALWAYS_RESET_ON_START) {
        print('🔄 Auto reset enabled - Creating fresh database on app start');
        await resetDatabase();
      } else {
        if (_database != null) return;
        _database = await _initDatabase();
        // Check if database needs initial data load (without reset)
        await _checkAndLoadInitialData();
      }

      print('✅ Database initialization completed');
    } catch (e) {
      print('❌ Error initializing database: $e');
      rethrow;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), DB_NAME);

    print('📁 Initializing database at: $path');
    return await openDatabase(
      path,
      version: DB_VERSION,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
      onOpen: (db) async {
        print('✅ Database opened');
        var count = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM words'));
        print('📊 Current word count: $count');
      },
    );
  }

  /// **🔄 Upgrade Database**
  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    print('🔄 Upgrading database from version $oldVersion to $newVersion');

    // Hapus tabel lama dan buat ulang
    await db.execute('DROP TABLE IF EXISTS words');
    await _createDb(db, newVersion);
  }

  /// **📌 Membuat Database Baru**
  Future<void> _createDb(Database db, int version) async {
    print('📌 Creating database tables...');

    await db.execute('''
      CREATE TABLE words(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        indonesia TEXT NOT NULL,
        indonesia_audio TEXT,
        arabic TEXT NOT NULL,
        arabic_audio TEXT,
        english TEXT NOT NULL,
        english_audio TEXT
      )
    ''');

    print('✅ Database schema created successfully');
  }

  /// **📥 Import Data dari CSV ke Database**
  Future<void> _importCsvData(Database db) async {
    try {
      print('📥 Starting CSV import...');

      final String csvData = await rootBundle.loadString(CSV_PATH);
      print('📄 CSV file loaded successfully');

      List<List<dynamic>> rows = const CsvToListConverter()
          .convert(csvData, shouldParseNumbers: false);

      if (rows.isEmpty) {
        print('⚠️ No data found in CSV.');
        return;
      }

      print('📊 CSV contains ${rows.length} rows');

      // Hapus semua data lama sebelum mengimpor
      await db.delete('words');
      print('🗑 Deleted all existing words before import');

      // Periksa apakah baris pertama adalah header
      if (rows.isNotEmpty &&
          rows[0].length > 0 &&
          rows[0][0].toString().toLowerCase() == 'category') {
        rows.removeAt(0); // Remove header
        print('🏷️ Header row removed');
      }

      int importedCount = 0;
      int errorCount = 0;

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var row in rows) {
          try {
            // Validasi baris memiliki minimal 7 kolom
            if (row.length >= 7) {
              batch.insert('words', {
                'category': row[0]?.toString().trim() ?? '',
                'indonesia': row[1]?.toString().trim() ?? '',
                'indonesia_audio': row[2]?.toString().trim() ?? '',
                'arabic': row[3]?.toString().trim() ?? '',
                'arabic_audio': row[4]?.toString().trim() ?? '',
                'english': row[5]?.toString().trim() ?? '',
                'english_audio': row[6]?.toString().trim() ?? '',
              });
              importedCount++;
            } else {
              print('⚠️ Skipping invalid row (insufficient columns): $row');
              errorCount++;
            }
          } catch (e) {
            print('❌ Error processing row: $row. Error: $e');
            errorCount++;
          }
        }

        try {
          await batch.commit();
          print(
              '✅ Batch committed. Imported $importedCount words with $errorCount errors');
        } catch (e) {
          print('❌ Error committing batch: $e');
        }
      });

      final wordCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM words'));

      print('📊 Total words in database after import: $wordCount');

      // Verifikasi data per kategori
      final categories =
          await db.rawQuery('SELECT DISTINCT category FROM words');
      for (var cat in categories) {
        final catName = cat['category'] as String;
        final count = Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM words WHERE category = ?', [catName]));
        print('📊 Category "$catName" has $count words');
      }
    } catch (e) {
      print('❌ Error importing CSV data: $e');
      rethrow; // Throw error agar kita tahu ada masalah
    }
  }

  /// **🔍 Check and load initial data without recursion**
  Future<void> _checkAndLoadInitialData() async {
    final db = await database;

    // Check total word count
    final totalCount =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM words'));

    if (totalCount == 0) {
      print('⚠️ Database is empty! Importing data...');
      await _importCsvData(db);
      return;
    }

    // Log category counts but don't trigger reset
    final categoryList = ['KATA SAPAAN', 'HARI'];
    bool needsUpdate = false;

    for (var category in categoryList) {
      final count = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM words WHERE category = ?', [category]));
      print('📊 Category $category has $count words');

      if (count == 0) {
        print('⚠️ Category $category is empty!');
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      print('🔄 Missing categories detected. Importing data again...');
      await _importCsvData(db);
    }
  }

  /// **📊 Dapatkan Laporan Kesehatan Database**
  Future<Map<String, dynamic>> getDatabaseHealthReport() async {
    final db = await database;
    final Map<String, dynamic> report = {};

    // Periksa total kata
    final totalCount =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM words'));
    report['totalWords'] = totalCount;

    // Periksa per kategori
    final categoryQuery =
        await db.rawQuery('SELECT DISTINCT category FROM words');
    List<String> categories = [];
    for (var cat in categoryQuery) {
      categories.add(cat['category'] as String);
    }

    Map<String, int> categoryStats = {};

    for (var category in categories) {
      final count = Sqflite.firstIntValue(await db.rawQuery(
          'SELECT COUNT(*) FROM words WHERE category = ?', [category]));
      categoryStats[category] = count ?? 0;
    }
    report['categoryStats'] = categoryStats;

    return report;
  }

  /// **🔍 Ambil Data Berdasarkan Kategori**
  Future<List<Word>> getWordsByCategory(String category) async {
    final db = await database;
    print('🔍 Fetching words for category: $category');

    final List<Map<String, dynamic>> maps = await db.query(
      'words',
      where: 'category = ?',
      whereArgs: [category],
    );

    print('📊 Found ${maps.length} words in category: $category');
    return List.generate(maps.length, (i) => Word.fromMap(maps[i]));
  }

  /// **🔎 Pencarian Kata**
  Future<List<Word>> searchWords(String query, String category) async {
    final db = await database;
    print('🔎 Searching for "$query" in category: $category');

    final List<Map<String, dynamic>> maps = await db.query(
      'words',
      where:
          'category = ? AND (indonesia LIKE ? OR arabic LIKE ? OR english LIKE ?)',
      whereArgs: [category, '%$query%', '%$query%', '%$query%'],
    );

    print('📊 Found ${maps.length} results for query: $query');
    return List.generate(maps.length, (i) => Word.fromMap(maps[i]));
  }

  /// **➕ Insert Kata Baru**
  Future<int> insertWord(Word word) async {
    final db = await database;
    return await db.insert(
      'words',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// **✏️ Update Kata**
  Future<int> updateWord(Word word) async {
    final db = await database;
    return await db.update(
      'words',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  /// **🗑 Hapus Kata**
  Future<int> deleteWord(int id) async {
    final db = await database;
    return await db.delete(
      'words',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// **📴 Tutup Database**
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
