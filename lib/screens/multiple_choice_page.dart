import 'package:flutter/material.dart';

class MultipleChoicePage extends StatefulWidget {
  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  State<MultipleChoicePage> createState() => _MultipleChoicePageState();
}

class _MultipleChoicePageState extends State<MultipleChoicePage> {
  int _currentScore = 0;
  int _currentQuestionIndex = 0;
  bool _hasAnswered = false;

  // Contoh soal-soal sederhana
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Apa bahasa Arabnya "Selamat Pagi"?',
      'options': [
        'صباح الخير',
        'مساء الخير',
        'السلام عليكم',
        'شكرا لك',
      ],
      'correctIndex': 0,
    },
    {
      'question': 'Manakah yang berarti "Thank You"?',
      'options': [
        'Good Morning',
        'Hello',
        'Thank You',
        'Good Night',
      ],
      'correctIndex': 2,
    },
    // Tambahkan lebih banyak soal di sini
  ];

  void _checkAnswer(int selectedIndex) {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
      if (selectedIndex == _questions[_currentQuestionIndex]['correctIndex']) {
        _currentScore += 10;
      }
    });

    // Tunda sebentar sebelum pindah ke soal berikutnya
    Future.delayed(const Duration(seconds: 1), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _hasAnswered = false;
        });
      } else {
        // Tampilkan dialog selesai
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.asset('assets/trophy.png', height: 40),
              const SizedBox(width: 10),
              const Text('Selamat!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nilai kamu: $_currentScore',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Kamu sudah menyelesaikan semua soal!'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Main Lagi'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentQuestionIndex = 0;
                  _currentScore = 0;
                  _hasAnswered = false;
                });
              },
            ),
            TextButton(
              child: const Text('Kembali'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.star, color: Colors.yellow),
            const SizedBox(width: 8),
            Text('Skor: $_currentScore'),
          ],
        ),
        backgroundColor: const Color(0xFF3B82F6),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.yellow),
                ),
                const SizedBox(height: 20),

                // Question
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      currentQuestion['question'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Options
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion['options'].length,
                    itemBuilder: (context, index) {
                      final isCorrect =
                          index == currentQuestion['correctIndex'];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: _hasAnswered
                              ? (isCorrect ? Colors.green[100] : Colors.white)
                              : Colors.white,
                          child: InkWell(
                            onTap: () => _checkAnswer(index),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: _hasAnswered && isCorrect
                                        ? Colors.green
                                        : const Color(0xFF3B82F6),
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      currentQuestion['options'][index],
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _hasAnswered && isCorrect
                                            ? Colors.green[800]
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (_hasAnswered && isCorrect)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
