import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/models.dart';
import '../widgets/custom_widgets.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _status = 'all';

  @override
  Widget build(BuildContext context) {
    final transactions = TransactionRepository.transactions.where((tx) {
      if (_status == 'all') return true;
      return tx.status.name == _status;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _StatusFilter(label: 'Semua', selected: _status == 'all', onTap: () => setState(() => _status = 'all')),
                  _StatusFilter(label: 'Berhasil', selected: _status == 'success', onTap: () => setState(() => _status = 'success')),
                  _StatusFilter(label: 'Pending', selected: _status == 'pending', onTap: () => setState(() => _status = 'pending')),
                  _StatusFilter(label: 'Gagal', selected: _status == 'failed', onTap: () => setState(() => _status = 'failed')),
                ],
              ),
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada transaksi pada filter ini.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TransactionListTile(
                          transaction: transaction,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/transaction-detail',
                            arguments: transaction,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: UltraBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          final routes = ['/home', '/promo', '/history', '/cart', '/profile'];
          if (index == 2) return;
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
