import 'package:flutter/material.dart';
import 'dictionary_page.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'KATA SAPAAN',
        'icon': Icons.record_voice_over_rounded,
        'color': const Color(0xFFFF6B6B),
        'description':
            'Belajar tata cara mengucapkan salam dan ungkapan sehari-hari',
      },
      {
        'name': 'HARI',
        'icon': Icons.calendar_today_rounded,
        'color': const Color(0xFF4ECDC4),
        'description': 'Mengenal nama-nama hari dalam seminggu',
      },
      {
        'name': 'BULAN HIJRIAH',
        'icon': Icons.mosque_rounded,
        'color': const Color(0xFF9B5DE5),
        'description': 'Mengenal nama-nama bulan dalam kalender Hijriah',
      },
      {
        'name': 'NAMA BULAN MASEHI',
        'icon': Icons.event_available_rounded,
        'color': const Color(0xFFFFBE0B),
        'description': 'Mengenal nama-nama bulan dalam kalender Masehi',
      },
      {
        'name': 'WARNA',
        'icon': Icons.palette_rounded,
        'color': const Color(0xFFFF9F1C),
        'description': 'Belajar nama-nama warna dalam bahasa Arab',
      },
      {
        'name': 'ANGKA SATUAN',
        'icon': Icons.looks_one_rounded,
        'color': const Color(0xFF2EC4B6),
        'description': 'Mengenal angka dasar satuan 0-10',
      },
      {
        'name': 'ANGKA BELASAN',
        'icon': Icons.filter_2_rounded,
        'color': const Color(0xFF3D5A80),
        'description': 'Mempelajari angka belasan',
      },
      {
        'name': 'PULUHAN DIMULAI DENGAN SATUAN',
        'icon': Icons.numbers_rounded,
        'color': const Color(0xFFE76F51),
        'description': 'Belajar angka kombinasi puluhan dan satuan',
      },
      {
        'name': 'ANGKA RATUSAN',
        'icon': Icons.filter_3_rounded,
        'color': const Color(0xFF2A9D8F),
        'description': 'Mempelajari angka ratusan hingga jutaan',
      },
      {
        'name': 'PAKAIAN',
        'icon': Icons.checkroom_rounded,
        'color': const Color(0xFFE63946),
        'description': 'Mengenal nama-nama pakaian dan aksesoris',
      },
      {
        'name': 'BUAH-BUAHAN',
        'icon': Icons.food_bank_rounded,
        'color': const Color(0xFF43AA8B),
        'description': 'Belajar nama berbagai jenis buah-buahan',
      },
      {
        'name': 'SAYURAN',
        'icon': Icons.eco_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal nama-nama sayuran dalam bahasa Arab',
      },
      {
        'name': 'REMPAH-REMPAH',
        'icon': Icons.spa_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal nama-nama rempah-rempah dalam bahasa Arab',
      },
      {
        'name': 'FASILITAS UMUM',
        'icon': Icons.location_city_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal nama-nama fasilitas umum dalam bahasa Arab',
      },
      {
        'name': 'ANGGOTA TUBUH',
        'icon': Icons.accessibility_new_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal nama-nama anggota tubuh dalam bahasa Arab',
      },
      {
        'name': 'ANGGOTA KELUARGA',
        'icon': Icons.family_restroom,
        'color': const Color(0xFF577590),
        'description': 'Mengenal nama-nama anggota keluarga dalam bahasa Arab',
      },
      {
        'name': 'ALAT TRANSPORTASI',
        'icon': Icons.directions_car_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal nama-nama alat transportasi dalam bahasa Arab',
      },
      {
        'name': 'KAMAR TIDUR',
        'icon': Icons.bed_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal benda-benda di kamar tidur dalam bahasa Arab',
      },
      {
        'name': 'KAMAR MANDI',
        'icon': Icons.bathroom_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal benda-benda di kamar mandi dalam bahasa Arab',
      },
      {
        'name': 'DAPUR',
        'icon': Icons.kitchen_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal peralatan dapur dalam bahasa Arab',
      },
      {
        'name': 'RUANG KELUARGA',
        'icon': Icons.living_rounded,
        'color': const Color(0xFF577590),
        'description':
            'Mengenal benda-benda di ruang keluarga dalam bahasa Arab',
      },
      {
        'name': 'TAMAN',
        'icon': Icons.park_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal lingkungan taman dalam bahasa Arab',
      },
      {
        'name': 'LAPANGAN',
        'icon': Icons.sports_soccer_rounded,
        'color': const Color(0xFF577590),
        'description':
            'Mengenal istilah lapangan dan olahraga dalam bahasa Arab',
      },
      {
        'name': 'SEKOLAH',
        'icon': Icons.school_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal lingkungan sekolah dalam bahasa Arab',
      },
      {
        'name': 'KANTIN',
        'icon': Icons.restaurant_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal kosakata kantin dalam bahasa Arab',
      },
      {
        'name': 'MAKANAN',
        'icon': Icons.dinner_dining_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal nama-nama makanan dalam bahasa Arab',
      },
      {
        'name': 'BUAH',
        'icon': Icons.apple_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal nama-nama buah dalam bahasa Arab',
      },
      {
        'name': 'HEWAN-HEWAN',
        'icon': Icons.pets_rounded,
        'color': const Color(0xFF577590),
        'description': 'Mengenal nama-nama hewan dalam bahasa Arab',
      },
      {
        'name': 'PROFESI',
        'icon': Icons.work_rounded,
        'color': const Color(0xFF90BE6D),
        'description': 'Mempelajari nama berbagai macam pekerjaan',
      },
      {
        'name': 'KAMAR TIDUR (KATA KERJA)',
        'icon': Icons.bed_rounded,
        'color': const Color(0xFF6D597A),
        'description': 'Kata kerja aktivitas di kamar tidur',
      },
      {
        'name': 'KAMAR MANDI (KATA KERJA)',
        'icon': Icons.bathroom_rounded,
        'color': const Color(0xFF355070),
        'description': 'Kata kerja aktivitas di kamar mandi',
      },
      {
        'name': 'DAPUR (KATA KERJA)',
        'icon': Icons.kitchen_rounded,
        'color': const Color(0xFFB56576),
        'description': 'Kata kerja aktivitas memasak dan di dapur',
      },
      {
        'name': 'BELAJAR (KATA KERJA)',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFFE56B6F),
        'description': 'Kata kerja aktivitas belajar dan membaca',
      },
      {
        'name': 'KELAS (KATA KERJA)',
        'icon': Icons.class_rounded,
        'color': const Color(0xFFE56B6F),
        'description': 'Kata kerja aktivitas belajar di kelas',
      },
      {
        'name': 'IBADAH (KATA KERJA)',
        'icon': Icons.mosque_rounded,
        'color': const Color(0xFF497174),
        'description': 'Kata kerja terkait ibadah dan aktivitas keagamaan',
      },
      {
        'name': 'MASJID (KATA KERJA)',
        'icon': Icons.mosque_rounded,
        'color': const Color(0xFF497174),
        'description': 'Kata kerja terkait aktivitas di masjid',
      },
      {
        'name': 'MAKANAN (KATA KERJA)',
        'icon': Icons.restaurant_menu_rounded,
        'color': const Color(0xFF497174),
        'description': 'Kata kerja terkait persiapan makanan hingga selesai',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text(
          'Pilih Kategori',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              'Pilih kategori yang ingin kamu pelajari!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DictionaryPage(
                            category: category['name'],
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: category['color'].withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: category['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              color: category['color'] as Color,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category['description'],
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
                            color: category['color'] as Color,
                            size: 20,
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
    );
  }
}
