import 'package:flutter/material.dart';
import 'package:utspam_b_0030_film/models/user.dart';
import 'package:utspam_b_0030_film/services/storage_service.dart';
import 'login_screen.dart';
import 'package:utspam_b_0030_film/screens/film_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${widget.user.nama}'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Menu Utama',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            Card(
              child: ListTile(
                leading: const Icon(Icons.movie, color: Colors.deepPurple, size: 40),
                title: const Text('Daftar Film', style: TextStyle(fontSize: 18)),
                subtitle: const Text('Lihat film yang sedang tayang'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilmListScreen(user: widget.user),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.deepPurple, size: 40),
                title: const Text('Riwayat Pembelian', style: TextStyle(fontSize: 18)),
                subtitle: const Text('Lihat transaksi pembelian tiket'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionHistoryScreen(user: widget.user),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.deepPurple, size: 40),
                title: const Text('Profil Pengguna', style: TextStyle(fontSize: 18)),
                subtitle: const Text('Lihat informasi profil'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showProfile();
                },
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red, size: 40),
                title: const Text('Logout', style: TextStyle(fontSize: 18, color: Colors.red)),
                subtitle: const Text('Keluar dari aplikasi'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showLogoutDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Profil Pengguna'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama: ${widget.user.nama}'),
              const SizedBox(height: 8),
              Text('Email: ${widget.user.email}'),
              const SizedBox(height: 8),
              Text('Username: ${widget.user.username}'),
              const SizedBox(height: 8),
              Text('Alamat: ${widget.user.alamat}'),
              const SizedBox(height: 8),
              Text('No. Telepon: ${widget.user.noTelepon}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await StorageService.removeCurrentUser();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}