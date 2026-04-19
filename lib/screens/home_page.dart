import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.grey[400],
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Icon(Icons.more_horiz, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2 CARD GAMBAR ATAS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: imageCard()),
                  const SizedBox(width: 12),
                  Expanded(child: imageCard()),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3 CARD KECIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  smallCard(),
                  smallCard(),
                  smallCard(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // TEXT DESKRIPSI
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                    "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  // CARD GAMBAR BESAR
  Widget imageCard() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: const Center(
        child: Icon(Icons.image, size: 40, color: Colors.grey),
      ),
    );
  }

  // CARD KECIL (PINK + TEXT)
  Widget smallCard() {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          color: Colors.pink,
        ),
        const SizedBox(height: 6),
        const Text("Judul", style: TextStyle(fontWeight: FontWeight.bold)),
        const Text(
          "Deskripsi singkat",
          style: TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

