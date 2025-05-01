import 'package:flutter_tts/flutter_tts.dart';
import 'package:logger/logger.dart';
import '../models/word.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  final Logger _logger = Logger();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  String? _currentLanguage;

  final Map<String, String> _languageMap = {
    'id': 'id-ID',
    'en': 'en-US',
    'ar': 'ar-SA',
  };

  // Pre-configure TTS
  Future<void> _configureTTS() async {
    try {
      await Future.wait([
        _flutterTts.awaitSpeakCompletion(true),
        _flutterTts.setVolume(1.0),
        _flutterTts.setPitch(1.0),
      ]);
      _isInitialized = true;
    } catch (e) {
      _logger.e('Failed to configure TTS: $e');
    }
  }

  Future<bool> speak(Word word, String language) async {
    if (_isSpeaking) {
      await stop();
    }

    try {
      _isSpeaking = true;

      // Initialize if needed
      if (!_isInitialized) {
        await _configureTTS();
      }

      // Set language and speech rate
      if (_currentLanguage != language) {
        // Sedikit perlambatan untuk setiap bahasa
        double speechRate;
        if (language == 'ar') {
          speechRate = 0.25; // Diperlambat dari 0.3
        } else if (language == 'en') {
          speechRate = 0.35; // Diperlambat dari 0.4
        } else {
          speechRate = 0.35; // Untuk bahasa Indonesia
        }

        await Future.wait([
          _flutterTts.setLanguage(_languageMap[language] ?? 'id-ID'),
          _flutterTts.setSpeechRate(speechRate),
        ]);
        _currentLanguage = language;
      }

      // Speak the text
      String textToSpeak = _getTextForLanguage(word, language);
      final result = await _flutterTts.speak(textToSpeak) == 1;
      _isSpeaking = false;
      return result;
    } catch (e) {
      _logger.e('Error speaking text: $e');
      _isSpeaking = false;
      return false;
    }
  }

  String _getTextForLanguage(Word word, String language) {
    switch (language) {
      case 'en':
        return word.english;
      case 'ar':
        return word.arabic;
      default:
        return word.indonesia;
    }
  }

  Future<void> stop() async {
    try {
      _isSpeaking = false;
      await _flutterTts.stop();
    } catch (e) {
      _logger.e('Error stopping TTS: $e');
    }
  }

  void dispose() {
    stop();
  }
}
