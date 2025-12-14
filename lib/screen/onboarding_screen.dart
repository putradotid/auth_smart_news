import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> data = [
    {
      "image": "assets/img/onboard.png",
      "title": "Berita terkini",
      "subtitle":
          "Tetap terhubung dengan berita terbaru dari berbagai penjuru setiap hari.",
    },
    {
      "image": "assets/img/onboard2.png",
      "title": "Personalisasi konten",
      "subtitle":
          "Pilih topik favoritmu dan nikmati pengalaman membaca yang lebih relevan.",
    },
    {
      "image": "assets/img/onboard3.png",
      "title": "In-depth context",
      "subtitle":
          "Dapatkan perspektif mendalam dari analisis berbagai sumber dunia.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: data.length,
              onPageChanged: (i) => setState(() => currentPage = i),
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    const SizedBox(height: 60),

                    // gambar onboarding
                    Container(
                      height: 350,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(data[i]["image"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Text(
                      data[i]["title"]!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        data[i]["subtitle"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // indikator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              data.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: currentPage == index ? 20 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: currentPage == index ? Colors.black : Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // tombol bawah
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Lewati
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Lewati"),
                  ),
                ),

                const SizedBox(width: 12),

                // Lanjut atau Mulai
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentPage == data.length - 1) {
                        // halaman terakhir → pindah ke login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      } else {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      currentPage == data.length - 1 ? "Mulai" : "Lanjut",
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
