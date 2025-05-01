import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/word.dart';
import '../services/database_service.dart';
import 'dart:developer' as developer;

class DictionaryPage extends StatefulWidget {
  final String category;

  const DictionaryPage({super.key, required this.category});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Word> _words = [];
  bool _isLoading = false;
  String? _currentlyPlayingAudio;

  // No need for display category mapping anymore since "KATA UCAPAN" doesn't exist
  String get displayCategory {
    return widget.category;
  }

  @override
  void initState() {
    super.initState();
    developer.log(
        'DictionaryPage initialized with category: ${widget.category}',
        name: 'DictionaryPage');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      developer.log('Post frame callback triggered, loading initial data',
          name: 'DictionaryPage');
      _loadInitialData();
    });
    _setupAudioPlayerListeners();
  }

  void _setupAudioPlayerListeners() {
    developer.log('Setting up audio player listeners', name: 'DictionaryPage');
    _audioPlayer.onPlayerComplete.listen((event) {
      developer.log('Audio playback completed', name: 'DictionaryPage:Audio');
      setState(() => _currentlyPlayingAudio = null);
    });

    // Add more audio player state listeners for debugging
    _audioPlayer.onPlayerStateChanged.listen((state) {
      developer.log('Audio player state changed to: $state',
          name: 'DictionaryPage:Audio');
    });

    _audioPlayer.onPositionChanged.listen((position) {
      // Log less frequently to avoid spam
      if (position.inSeconds % 5 == 0) {
        developer.log('Audio position: ${position.inSeconds}s',
            name: 'DictionaryPage:Audio');
      }
    });

    _audioPlayer.onLog.listen((msg) {
      developer.log('AudioPlayer log: $msg', name: 'DictionaryPage:Audio');
    });
  }

  Future<void> _loadInitialData() async {
    developer.log('Loading initial data for category: ${widget.category}',
        name: 'DictionaryPage:Data');
    setState(() => _isLoading = true);
    try {
      developer.log('Calling database service to get words',
          name: 'DictionaryPage:Data');
      final words = await _databaseService.getWordsByCategory(widget.category);
      developer.log('Retrieved ${words.length} words from database',
          name: 'DictionaryPage:Data');

      if (mounted) {
        setState(() {
          _words = words;
          _isLoading = false;
        });
        developer.log('State updated with words data',
            name: 'DictionaryPage:Data');
      } else {
        developer.log('Widget no longer mounted, state update skipped',
            name: 'DictionaryPage:Data');
      }
    } catch (e, stackTrace) {
      developer.log('Error loading words: $e\nStack trace: $stackTrace',
          name: 'DictionaryPage:Error', error: e, stackTrace: stackTrace);
      _handleError(e, 'Error loading words');
    }
  }

  Future<void> _searchWords(String query) async {
    developer.log('Searching for words with query: "$query"',
        name: 'DictionaryPage:Search');
    setState(() => _isLoading = true);
    try {
      final List<Word> words;
      if (query.isEmpty) {
        developer.log('Empty query, fetching all words for category',
            name: 'DictionaryPage:Search');
        words = await _databaseService.getWordsByCategory(widget.category);
      } else {
        developer.log(
            'Searching for query: "$query" in category: ${widget.category}',
            name: 'DictionaryPage:Search');
        words = await _databaseService.searchWords(query, widget.category);
      }

      developer.log('Search returned ${words.length} results',
          name: 'DictionaryPage:Search');

      if (mounted) {
        setState(() {
          _words = words;
          _isLoading = false;
        });
        developer.log('State updated with search results',
            name: 'DictionaryPage:Search');
      } else {
        developer.log('Widget no longer mounted, state update skipped',
            name: 'DictionaryPage:Search');
      }
    } catch (e, stackTrace) {
      developer.log('Error searching words: $e\nStack trace: $stackTrace',
          name: 'DictionaryPage:Error', error: e, stackTrace: stackTrace);
      _handleError(e, 'Error searching words');
    }
  }

  void _handleError(dynamic e, String message) {
    developer.log('Handling error: $message - $e',
        name: 'DictionaryPage:Error', error: e);
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$message: $e')),
      );
      developer.log('Error shown to user via SnackBar',
          name: 'DictionaryPage:Error');
    } else {
      developer.log('Widget no longer mounted, error handling skipped',
          name: 'DictionaryPage:Error');
    }
  }

  Future<void> _playAudio(String audioPath) async {
    if (audioPath.isEmpty) {
      developer.log('Audio path is empty, skipping playback',
          name: 'DictionaryPage:Audio');
      return;
    }

    try {
      // Updated folder selection logic
      String folder;
      if (widget.category == "HARI") {
        folder = "hari";
      } else if (widget.category == "BULAN HIJRIAH") {
        folder = "bulan_hijriah";
      } else if (widget.category == "WARNA") {
        folder = "warna";
      } else if (widget.category == "NAMA BULAN MASEHI") {
        folder = "bulan_masehi";
      } else if (widget.category == "ANGKA SATUAN") {
        folder = "angka_satuan";
      } else if (widget.category == "ANGKA BELASAN") {
        folder = "angka_belasan";
      } else if (widget.category == "ANGKA RATUSAN") {
        folder = "angka_ratusan";
      } else if (widget.category == "PAKAIAN") {
        folder = "pakaian";
      } else if (widget.category == "SAYURAN") {
        folder = "sayuran";
      } else if (widget.category == "BUAH-BUAHAN") {
        folder = "buah_buahan1";
      } else if (widget.category == "REMPAH-REMPAH") {
        folder = "rempah_rempah";
      } else if (widget.category == "FASILITAS UMUM") {
        folder = "fasilitas_umum";
      } else if (widget.category == "ANGGOTA TUBUH") {
        folder = "anggota_tubuh";
      } else if (widget.category == "ALAT TRANSPORTASI") {
        folder = "alat_transportasi";
      } else if (widget.category == "KAMAR TIDUR") {
        folder = "kamar_tidur";
      } else if (widget.category == "KAMAR MANDI") {
        folder = "kamar_mandi";
      } else if (widget.category == "DAPUR") {
        folder = "dapur";
      } else if (widget.category == "RUANG KELUARGA") {
        folder = "ruang_keluarga";
      } else if (widget.category == "TAMAN") {
        folder = "taman";
      } else if (widget.category == "LAPANGAN") {
        folder = "lapangan";
      } else if (widget.category == "SEKOLAH") {
        folder = "sekolah";
      } else if (widget.category == "KANTIN") {
        folder = "kantin";
      } else if (widget.category == "MAKANAN") {
        folder = "makanan";
      } else if (widget.category == "ANGGOTA KELUARGA") {
        folder = "anggota_keluarga";
      } else if (widget.category == "BUAH") {
        folder = "buah_buahan2";
      } else if (widget.category == "HEWAN-HEWAN") {
        folder = "hewan_hewan";
      } else if (widget.category == "PROFESI") {
        folder = "profesi";
      } else if (widget.category == "KAMAR TIDUR (KATA KERJA)") {
        folder = "bab_2_part_1";
      } else if (widget.category == "KAMAR MANDI (KATA KERJA)") {
        folder = "bab_2_part_2";
      } else if (widget.category == "BELAJAR (KATA KERJA)") {
        folder = "bab_2_part_3";
      } else if (widget.category == "KELAS (KATA KERJA)") {
        folder = "bab_2_part_4";
      } else if (widget.category == "DAPUR (KATA KERJA)") {
        folder = "bab_2_part_5";
      } else if (widget.category == "IBADAH (KATA KERJA)") {
        folder = "bab_2_part_6";
      } else if (widget.category == "MASJID (KATA KERJA)") {
        folder = "bab_2_part_7";
      } else if (widget.category == "MAKANAN (KATA KERJA)") {
        folder = "bab_2_part_8";
      } else if (widget.category == "PULUHAN DIMULAI DENGAN SATUAN") {
        folder = "puluhan_dimulai_dengan_satuan";
      } else if (widget.category == "KATA SAPAAN") {
        // Updated to use new folder name
        folder = "kata_sapaan";
      } else {
        // Default case - using kata_sapaan as the fallback
        folder = "kata_sapaan";
      }

      // Ensure we're using MP3 extension
      String fileName = audioPath;
      if (fileName.endsWith('.wav')) {
        // Replace .wav with .mp3 if needed
        fileName = fileName.replaceAll('.wav', '.mp3');
      } else if (!fileName.endsWith('.mp3')) {
        // Add .mp3 extension if no extension exists
        fileName = '$fileName.mp3';
      }

      final fullAudioPath = '$folder/$fileName';

      developer.log('Attempting to play audio: $fullAudioPath',
          name: 'DictionaryPage:Audio');
      developer.log('Audio source type: AssetSource',
          name: 'DictionaryPage:Audio');
      developer.log('Current playing audio: $_currentlyPlayingAudio',
          name: 'DictionaryPage:Audio');

      if (_currentlyPlayingAudio == fullAudioPath) {
        developer.log('Already playing this audio file, stopping playback',
            name: 'DictionaryPage:Audio');
        await _audioPlayer.stop();
        setState(() => _currentlyPlayingAudio = null);
        return;
      }

      developer.log('Stopping any currently playing audio',
          name: 'DictionaryPage:Audio');
      await _audioPlayer.stop();

      developer.log('Starting playback of: $fullAudioPath',
          name: 'DictionaryPage:Audio');
      await _audioPlayer.play(AssetSource(fullAudioPath));
      developer.log('Audio playback started', name: 'DictionaryPage:Audio');

      setState(() => _currentlyPlayingAudio = fullAudioPath);
      developer.log('Set currentlyPlayingAudio to: $fullAudioPath',
          name: 'DictionaryPage:Audio');
    } catch (e, stackTrace) {
      developer.log('Audio error: $e\nStack trace: $stackTrace',
          name: 'DictionaryPage:Audio', error: e, stackTrace: stackTrace);
      _handleError(e, 'Error playing audio');
    }
  }

  @override
  Widget build(BuildContext context) {
    developer.log('Building DictionaryPage UI with ${_words.length} words',
        name: 'DictionaryPage:UI');
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildWordsList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    developer.log('Building app bar for category: ${displayCategory}',
        name: 'DictionaryPage:UI');
    return AppBar(
      title: Text(displayCategory,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColor: const Color(0xFF3B82F6),
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    developer.log('Building search bar', name: 'DictionaryPage:UI');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF3B82F6),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari kata...',
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIcon: const Icon(Icons.search, color: Colors.white60),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
        onChanged: (value) {
          developer.log('Search text changed to: "$value"',
              name: 'DictionaryPage:Search');
          _searchWords(value);
        },
      ),
    );
  }

  Widget _buildWordsList() {
    developer.log(
        'Building words list, isLoading: $_isLoading, word count: ${_words.length}',
        name: 'DictionaryPage:UI');
    if (_isLoading) {
      developer.log('Showing loading indicator', name: 'DictionaryPage:UI');
      return const Center(child: CircularProgressIndicator());
    }
    if (_words.isEmpty) {
      developer.log('No words found, showing empty state',
          name: 'DictionaryPage:UI');
      return const Center(
          child: Text('Tidak ada kata yang ditemukan',
              style: TextStyle(fontSize: 16, color: Colors.grey)));
    }
    developer.log('Rendering ListView with ${_words.length} items',
        name: 'DictionaryPage:UI');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _words.length,
      itemBuilder: (context, index) {
        developer.log(
            'Building card for word index: $index, ID: ${_words[index].id}',
            name: 'DictionaryPage:UI');
        return _buildWordCard(_words[index]);
      },
    );
  }

  Widget _buildWordCard(Word word) {
    developer.log('Building card for word: ${word.indonesia} (ID: ${word.id})',
        name: 'DictionaryPage:UI');
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLanguageRow(word.indonesia, 'Indonesia', word.indonesiaAudio,
                const Color(0xFFFF6B6B), FontWeight.bold),
            const Divider(height: 24),
            _buildLanguageRow(word.arabic, 'العربية', word.arabicAudio,
                const Color(0xFF4ECDC4), FontWeight.normal,
                isArabic: true),
            const Divider(height: 24),
            _buildLanguageRow(word.english, 'English', word.englishAudio,
                const Color(0xFF9B5DE5), FontWeight.normal),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageRow(String text, String label, String audioPath,
      Color color, FontWeight weight,
      {bool isArabic = false}) {
    // Update folder selection logic to match _playAudio method
    String folder;
    if (widget.category == "HARI") {
      folder = "hari";
    } else if (widget.category == "BULAN HIJRIAH") {
      folder = "bulan_hijriah";
    } else if (widget.category == "WARNA") {
      folder = "warna";
    } else if (widget.category == "NAMA BULAN MASEHI") {
      folder = "bulan_masehi";
    } else if (widget.category == "ANGKA SATUAN") {
      folder = "angka_satuan";
    } else if (widget.category == "ANGKA BELASAN") {
      folder = "angka_belasan";
    } else if (widget.category == "ANGKA RATUSAN") {
      folder = "angka_ratusan";
    } else if (widget.category == "PAKAIAN") {
      folder = "pakaian";
    } else if (widget.category == "ANGGOTA KELUARGA") {
      folder = "anggota_keluarga";
    } else if (widget.category == "BUAH-BUAHAN") {
      folder = "buah_buahan1";
    } else if (widget.category == "SAYURAN") {
      folder = "sayuran";
    } else if (widget.category == "REMPAH-REMPAH") {
      folder = "rempah_rempah";
    } else if (widget.category == "FASILITAS UMUM") {
      folder = "fasilitas_umum";
    } else if (widget.category == "ANGGOTA TUBUH") {
      folder = "anggota_tubuh";
    } else if (widget.category == "ALAT TRANSPORTASI") {
      folder = "alat_transportasi";
    } else if (widget.category == "KAMAR TIDUR") {
      folder = "kamar_tidur";
    } else if (widget.category == "KAMAR MANDI") {
      folder = "kamar_mandi";
    } else if (widget.category == "DAPUR") {
      folder = "dapur";
    } else if (widget.category == "RUANG KELUARGA") {
      folder = "ruang_keluarga";
    } else if (widget.category == "TAMAN") {
      folder = "taman";
    } else if (widget.category == "LAPANGAN") {
      folder = "lapangan";
    } else if (widget.category == "SEKOLAH") {
      folder = "sekolah";
    } else if (widget.category == "KANTIN") {
      folder = "kantin";
    } else if (widget.category == "MAKANAN") {
      folder = "makanan";
    } else if (widget.category == "BUAH") {
      folder = "buah_buahan2";
    } else if (widget.category == "HEWAN-HEWAN") {
      folder = "hewan_hewan";
    } else if (widget.category == "PROFESI") {
      folder = "profesi";
    } else if (widget.category == "KAMAR TIDUR (KATA KERJA)") {
      folder = "bab_2_part_1";
    } else if (widget.category == "KAMAR MANDI (KATA KERJA)") {
      folder = "bab_2_part_2";
    } else if (widget.category == "BELAJAR (KATA KERJA)") {
      folder = "bab_2_part_3";
    } else if (widget.category == "KELAS (KATA KERJA)") {
      folder = "bab_2_part_4";
    } else if (widget.category == "DAPUR (KATA KERJA)") {
      folder = "bab_2_part_5";
    } else if (widget.category == "IBADAH (KATA KERJA)") {
      folder = "bab_2_part_6";
    } else if (widget.category == "MASJID (KATA KERJA)") {
      folder = "bab_2_part_7";
    } else if (widget.category == "MAKANAN (KATA KERJA)") {
      folder = "bab_2_part_8";
    } else if (widget.category == "PULUHAN DIMULAI DENGAN SATUAN") {
      folder = "puluhan_dimulai_dengan_satuan";
    } else if (widget.category == "KATA SAPAAN") {
      // Updated to use new folder name
      folder = "kata_sapaan";
    } else {
      // Default case - using kata_sapaan as the fallback
      folder = "kata_sapaan";
    }

    // Ensure we're using MP3 extension for the comparison
    String fileName = audioPath;
    if (fileName.endsWith('.wav')) {
      fileName = fileName.replaceAll('.wav', '.mp3');
    } else if (!fileName.endsWith('.mp3') && fileName.isNotEmpty) {
      fileName = '$fileName.mp3';
    }

    final bool isPlaying = _currentlyPlayingAudio == '$folder/$fileName';

    developer.log(
        'Building language row: $label, text: $text, audioPath: $audioPath, isPlaying: $isPlaying',
        name: 'DictionaryPage:UI');

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Text(label,
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Text(text,
                style:
                    TextStyle(fontSize: isArabic ? 20 : 16, fontWeight: weight),
                textDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr)),
        if (audioPath.isNotEmpty)
          IconButton(
              icon: Icon(isPlaying ? Icons.stop : Icons.volume_up,
                  color: isPlaying ? Colors.red : Colors.blue),
              onPressed: () {
                developer.log(
                    'Audio button pressed for: $label, audioPath: $audioPath',
                    name: 'DictionaryPage:Audio');
                _playAudio(audioPath);
              }),
      ],
    );
  }

  @override
  void dispose() {
    developer.log('Disposing DictionaryPage resources', name: 'DictionaryPage');
    _searchController.dispose();
    developer.log('Disposed search controller', name: 'DictionaryPage');

    developer.log('Stopping any playing audio before disposal',
        name: 'DictionaryPage:Audio');
    _audioPlayer.stop().then((_) {
      developer.log('Disposing audio player', name: 'DictionaryPage:Audio');
      _audioPlayer.dispose();
      developer.log('Audio player disposed', name: 'DictionaryPage:Audio');
    });

    super.dispose();
    developer.log('DictionaryPage completely disposed', name: 'DictionaryPage');
  }
}
