// lib/services/tts_handler.dart

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TTSHandler {
  static const String _prefKey = 'tts_checked';
  static FlutterTts? _flutterTts;

  static Future<FlutterTts> get tts async {
    _flutterTts ??= FlutterTts();
    return _flutterTts!;
  }

  // Mendapatkan informasi engine TTS
  static Future<Map<String, String>> getTTSInfo() async {
    try {
      final FlutterTts ttsInstance = await tts;
      final engines = await ttsInstance.getEngines;
      final defaultEngine = await ttsInstance.getDefaultEngine;
      final defaultVoice = await ttsInstance.getDefaultVoice;
      final languages = await ttsInstance.getLanguages;

      return {
        'engines': engines.join(', '),
        'defaultEngine': defaultEngine ?? 'Unknown',
        'defaultVoice': defaultVoice?.toString() ?? 'Unknown',
        'languages': languages.toString()
      };
    } catch (e) {
      debugPrint('Error getting TTS info: $e');
      return {
        'engines': 'Error',
        'defaultEngine': 'Error',
        'defaultVoice': 'Error',
        'languages': 'Error'
      };
    }
  }

  // Cek apakah device Samsung
  static Future<bool> isSamsungDevice() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer.toLowerCase().contains('samsung');
    } catch (e) {
      debugPrint('Error checking device manufacturer: $e');
      return false;
    }
  }

  // Cek ketersediaan TTS bahasa Arab
  static Future<bool> isArabicTTSAvailable() async {
    try {
      final FlutterTts ttsInstance = await tts;
      var languages = await ttsInstance.getLanguages;
      return languages.contains('ar-SA') || languages.contains('ar');
    } catch (e) {
      debugPrint('Error checking TTS availability: $e');
      return false;
    }
  }

  // Coba buka pengaturan dengan berbagai metode
  static Future<void> openTTSSettings() async {
    final List<String> settingsUrls = [
      'package://com.android.settings/com.android.settings.TextToSpeechSettings',
      'package://com.android.settings/.TextToSpeechSettings',
      'android-app://com.android.settings/com.android.settings.TTS_SETTINGS',
      'package://com.samsung.android.tts',
      'package://com.android.settings/com.android.settings.ACCESSIBILITY_SETTINGS'
    ];

    bool launched = false;

    for (String urlString in settingsUrls) {
      if (!launched) {
        try {
          final Uri url = Uri.parse(urlString);
          if (await canLaunchUrl(url)) {
            launched = await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
            if (launched) break;
          }
        } catch (e) {
          debugPrint('Error launching $urlString: $e');
          continue;
        }
      }
    }

    if (!launched) {
      debugPrint('Failed to open TTS settings with all methods');
    }
  }

  // Fungsi untuk mengecek status dan menangani TTS
  static Future<void> checkAndHandleTTS(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool alreadyChecked = prefs.getBool(_prefKey) ?? false;

      if (!alreadyChecked) {
        bool isSamsung = await isSamsungDevice();
        if (isSamsung) {
          bool hasArabicTTS = await isArabicTTSAvailable();
          if (!hasArabicTTS) {
            if (context.mounted) {
              await showTTSInstallDialog(context);
            }
          }
        }
        await prefs.setBool(_prefKey, true);
      }
    } catch (e) {
      debugPrint('Error in TTS check: $e');
    }
  }

  // Reset status pengecekan
  static Future<void> resetTTSCheck() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKey);
      debugPrint('TTS check status reset successfully');
    } catch (e) {
      debugPrint('Error resetting TTS check: $e');
    }
  }

  // Dialog untuk instalasi TTS
  static Future<void> showTTSInstallDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Instalasi Suara Bahasa Arab'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Untuk menggunakan fitur text-to-speech bahasa Arab, '
                  'Anda perlu menginstal paket suara bahasa Arab di pengaturan Samsung.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Langkah instalasi:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Buka Pengaturan HP\n'
                  '2. Pilih Manajemen Umum\n'
                  '3. Pilih Bahasa dan masukan\n'
                  '4. Pilih Teks-ke-ucapan\n'
                  '5. Instal paket bahasa Arab',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await openTTSSettings();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Buka Pengaturan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Nanti Saja'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengatur dan menginisialisasi TTS
  static Future<void> initTTS() async {
    try {
      final FlutterTts ttsInstance = await tts;
      await ttsInstance.setLanguage('ar-SA');
      await ttsInstance.setSpeechRate(0.5);
      await ttsInstance.setVolume(1.0);
      await ttsInstance.setPitch(1.0);
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  // Fungsi untuk berbicara
  static Future<void> speak(String text) async {
    try {
      final FlutterTts ttsInstance = await tts;
      await ttsInstance.speak(text);
    } catch (e) {
      debugPrint('Error speaking: $e');
    }
  }

  // Fungsi untuk menghentikan pembacaan
  static Future<void> stop() async {
    try {
      final FlutterTts ttsInstance = await tts;
      await ttsInstance.stop();
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }
}
