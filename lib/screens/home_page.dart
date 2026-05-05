import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.grey[400],
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.more_horiz, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _imageCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _imageCard()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _SmallCard(
                    title: 'Judul 1',
                    description: 'Deskripsi',
                    color: Colors.pink,
                  ),
                  _SmallCard(
                    title: 'Judul 2',
                    description: 'Deskripsi',
                    color: Colors.purple,
                  ),
                  _SmallCard(
                    title: 'Judul 3',
                    description: 'Deskripsi',
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageCard() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: const Center(
        child: Icon(Icons.image, size: 40, color: Colors.grey),
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  const _SmallCard({
    required this.title,
    required this.description,
    required this.color,
  });

  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          description,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
