import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utspam_b_0030_film/models/user.dart';
import 'package:utspam_b_0030_film/models/transaction.dart';
import 'package:utspam_b_0030_film/services/database_helper.dart';
import 'package:utspam_b_0030_film/screens/edit_transaction_screen.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Transaction transaction;
  final User user;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
    required this.user,
  });

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late Transaction _transaction;

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    String? sensoredCard;
    if (_transaction.nomorKartu != null) {
      sensoredCard = '**** **** **** ${_transaction.nomorKartu!.substring(12)}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pembelian'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'lib/assets/${_transaction.posterFilm}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.deepPurple.shade100,
                        child: const Center(
                          child: Icon(Icons.movie, size: 80, color: Colors.deepPurple),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Judul Film', _transaction.judulFilm),
                    _buildDetailRow('Jadwal', _transaction.jadwalFilm),
                    _buildDetailRow('Nama Pembeli', _transaction.namaPembeli),
                    _buildDetailRow('Jumlah Tiket', '${_transaction.jumlahTiket} tiket'),
                    _buildDetailRow('Tanggal Beli', _transaction.tanggalBeli),
                    _buildDetailRow('Total Biaya', currencyFormat.format(_transaction.totalBiaya)),
                    _buildDetailRow('Metode Pembayaran', _transaction.metodePembayaran),
                    if (sensoredCard != null)
                      _buildDetailRow('Nomor Kartu', sensoredCard),
                    _buildDetailRow('Status', _transaction.status.toUpperCase()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (_transaction.status == 'selesai')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTransactionScreen(transaction: _transaction),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _transaction = result;
                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('EDIT TRANSAKSI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showCancelDialog();
                },
                icon: const Icon(Icons.cancel),
                label: const Text('BATALKAN TRANSAKSI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Batalkan Transaksi'),
          content: const Text('Apakah Anda yakin ingin membatalkan transaksi ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                final db = DatabaseHelper.instance;
                await db.deleteTransaction(_transaction.id);

                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transaksi dibatalkan')),
                );
              },
              child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}