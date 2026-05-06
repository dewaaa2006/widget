import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../config/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  List<String> _results = [];

  void _search(String query) {
    final terms = ['Pulsa', 'Paket Data', 'Voucher', 'Transfer', 'Promo', 'Top Up'];
    setState(() {
      _query = query;
      _results = terms
          .where((term) => term.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Layanan'),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: _search,
                decoration: const InputDecoration(
                  hintText: 'Cari layanan, promo, atau transaksi',
                  prefixIcon: Icon(Iconsax.search_normal),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_query.isEmpty)
                Text(
                  'Mulai mencari layanan fintech, paket data, voucher, dan lain-lain.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                )
              else if (_results.isEmpty)
                Text(
                  'Tidak ditemukan hasil untuk "$_query"',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Iconsax.flash_1, color: AppColors.primary),
                        title: Text(_results[index]),
                        trailing: const Icon(Iconsax.arrow_right_3),
                        onTap: () {},
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
