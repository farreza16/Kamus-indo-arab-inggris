import 'package:flutter/material.dart';
import 'package:kidzmeal/screens/dashboard.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  // Define brand colors
  static const primaryGreen = Color(0xFF4CAF50);
  static const secondaryGreen = Color(0xFF388E3C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Logo with decoration
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/welcome.png',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 32),

                // Title with styled container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryGreen.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Sepatah Kata',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Introduction text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "Segala puji bagi Allah Subhanahu wa Ta'ala atas rahmat dan hidayah-Nya. Aplikasi tiga bahasa ini kami hadirkan sebagai sarana belajar yang inovatif bagi siswa-siswi MI Al-Ma'had Al-Islamy. Dengan fitur bahasa Indonesia, Arab, dan Inggris, aplikasi ini diharapkan dapat membantu meningkatkan kemampuan bahasa dan pemahaman ilmu agama secara interaktif.",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF2E2E2E),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Semoga aplikasi ini memberikan manfaat besar bagi para pengguna dan menjadi bagian dari pengembangan pendidikan yang lebih baik di madrasah kita.",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF2E2E2E),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Developer signature
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Tim Pengembang",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Start Learning Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Mulai Belajar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
