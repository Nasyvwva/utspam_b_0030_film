import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utspam_b_0030_film/models/transaction.dart';
import 'package:utspam_b_0030_film/services/database_helper.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jumlahCtrl;
  late TextEditingController _nomorKartuCtrl;
  late String _metodePembayaran;
  late int _hargaSatuan;
  int _totalBiaya = 0;

  @override
  void initState() {
    super.initState();
    _jumlahCtrl = TextEditingController(text: widget.transaction.jumlahTiket.toString());
    _nomorKartuCtrl = TextEditingController(text: widget.transaction.nomorKartu ?? '');
    _metodePembayaran = widget.transaction.metodePembayaran;
    _hargaSatuan = widget.transaction.totalBiaya ~/ widget.transaction.jumlahTiket;
    _hitungTotal();
    _jumlahCtrl.addListener(_hitungTotal);
  }

  void _hitungTotal() {
    setState(() {
      int jumlah = int.tryParse(_jumlahCtrl.text) ?? 0;
      _totalBiaya = _hargaSatuan * jumlah;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaksi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset(
                      'lib/assets/${widget.transaction.posterFilm}',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.transaction.judulFilm,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _jumlahCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Tiket',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah tiket tidak boleh kosong';
                }
                int? jumlah = int.tryParse(value);
                if (jumlah == null || jumlah <= 0) {
                  return 'Jumlah tiket harus berupa angka positif';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Biaya:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currencyFormat.format(_totalBiaya),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Metode Pembayaran:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('Cash'),
              value: 'Cash',
              groupValue: _metodePembayaran,
              onChanged: (value) {
                setState(() {
                  _metodePembayaran = value!;
                  _nomorKartuCtrl.clear();
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Kartu Debit/Kredit'),
              value: 'Kartu',
              groupValue: _metodePembayaran,
              onChanged: (value) {
                setState(() {
                  _metodePembayaran = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            if (_metodePembayaran == 'Kartu')
              TextFormField(
                controller: _nomorKartuCtrl,
                keyboardType: TextInputType.number,
                maxLength: 16,
                decoration: const InputDecoration(
                  labelText: 'Nomor Kartu Debit/Kredit',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) {
                  if (_metodePembayaran == 'Kartu') {
                    if (value == null || value.isEmpty) {
                      return 'Nomor kartu tidak boleh kosong';
                    }
                    if (value.length != 16) {
                      return 'Nomor kartu harus 16 digit';
                    }
                  }
                  return null;
                },
              ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  widget.transaction.jumlahTiket = int.parse(_jumlahCtrl.text);
                  widget.transaction.totalBiaya = _totalBiaya;
                  widget.transaction.metodePembayaran = _metodePembayaran;
                  widget.transaction.nomorKartu = _metodePembayaran == 'Kartu' ? _nomorKartuCtrl.text : null;

                  final db = DatabaseHelper.instance;
                  await db.updateTransaction(widget.transaction);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaksi berhasil diupdate')),
                  );

                  Navigator.pop(context, widget.transaction);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('SIMPAN', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('BATAL', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _jumlahCtrl.dispose();
    _nomorKartuCtrl.dispose();
    super.dispose();
  }
}