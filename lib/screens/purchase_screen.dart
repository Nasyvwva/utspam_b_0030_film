import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utspam_b_0030_film/models/user.dart';
import 'package:utspam_b_0030_film/models/film.dart';
import 'package:utspam_b_0030_film/models/transaction.dart';
import 'package:utspam_b_0030_film/services/database_helper.dart';
import 'package:utspam_b_0030_film/screens/transaction_history_screen.dart';


class PurchaseFormScreen extends StatefulWidget {
  final User user;
  final Film film;
  final String jadwal;

  const PurchaseFormScreen({
    super.key,
    required this.user,
    required this.film,
    required this.jadwal,
  });

  @override
  State<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahCtrl = TextEditingController();
  final _tanggalCtrl = TextEditingController();
  final _nomorKartuCtrl = TextEditingController();

  String _metodePembayaran = 'Cash';
  int _totalBiaya = 0;

  @override
  void initState() {
    super.initState();
    _jumlahCtrl.addListener(_hitungTotal);
  }

  void _hitungTotal() {
    setState(() {
      int jumlah = int.tryParse(_jumlahCtrl.text) ?? 0;
      _totalBiaya = widget.film.harga * jumlah;
    });
  }

  Future<void> _pilihTanggal() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );

    if (pickedDate != null) {
      setState(() {
        _tanggalCtrl.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pembelian Tiket'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
                      Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/${widget.film.poster}',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.film.judul,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Genre: ${widget.film.genre}'),
                  Text('Jadwal: ${widget.jadwal}'),
                  Text(
                    'Harga: ${currencyFormat.format(widget.film.harga)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),

            const SizedBox(height: 20),

            TextFormField(
              initialValue: widget.user.nama,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Nama Pembeli',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

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

            TextFormField(
              controller: _tanggalCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Tanggal Pembelian',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _pilihTanggal,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal pembelian tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Biaya:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                  hintText: '16 digit angka',
                ),
                validator: (value) {
                  if (_metodePembayaran == 'Kartu') {
                    if (value == null || value.isEmpty) {
                      return 'Nomor kartu tidak boleh kosong';
                    }
                    if (value.length != 16) {
                      return 'Nomor kartu harus 16 digit';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Nomor kartu harus berupa angka';
                    }
                  }
                  return null;
                },
              ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final db = DatabaseHelper.instance;

                  String transactionId =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  Transaction newTransaction = Transaction(
                    id: transactionId,
                    judulFilm: widget.film.judul,
                    posterFilm: widget.film.poster,
                    jadwalFilm: widget.jadwal,
                    namaPembeli: widget.user.nama,
                    jumlahTiket: int.parse(_jumlahCtrl.text),
                    tanggalBeli: _tanggalCtrl.text,
                    totalBiaya: _totalBiaya,
                    metodePembayaran: _metodePembayaran,
                    nomorKartu: _metodePembayaran == 'Kartu'
                        ? _nomorKartuCtrl.text
                        : null,
                    status: 'selesai',
                  );

                  await db.createTransaction(newTransaction);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Pembelian tiket berhasil!')),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TransactionHistoryScreen(user: widget.user),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('BELI TIKET', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
