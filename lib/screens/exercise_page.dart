import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exercises = [
      {
        'title': 'Tebak Kata',
        'description': 'Tebak arti kata dalam bahasa lain',
        'icon': Icons.question_answer,
        'color': Colors.blue,
        'route': '/word-guess',
      },
      {
        'title': 'Pilihan Ganda',
        'description': 'Pilih jawaban yang benar',
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
        'route': '/multiple-choice',
      },
      {
        'title': 'Mendengarkan',
        'description': 'Dengar dan pilih kata yang benar',
        'icon': Icons.headphones,
        'color': Colors.purple,
        'route': '/listening',
      },
      {
        'title': 'Memasangkan',
        'description': 'Pasangkan kata dengan artinya',
        'icon': Icons.connect_without_contact,
        'color': Colors.orange,
        'route': '/matching',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan Seru'),
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Latihan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ayo berlatih dan dapatkan bintang!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () {
                          // TODO: Navigate to specific exercise
                          Navigator.pushNamed(context, exercise['route']);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: exercise['color'].withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  exercise['icon'],
                                  size: 32,
                                  color: exercise['color'],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      exercise['description'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: exercise['color'],
                              ),
                            ],
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
    );
  }
}
