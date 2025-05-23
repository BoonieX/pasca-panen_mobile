import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pascapanen_mobile/screens/login_page.dart';
import 'package:pascapanen_mobile/pages/Profil/edit_profil_screen.dart';
import 'package:pascapanen_mobile/services/profile_service.dart';
import 'package:pascapanen_mobile/model/profile_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pascapanen_mobile/services/logo_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? _profile;
  bool _isLoading = true;

  File? _imageFile; // file gambar sementara

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await ProfileService.fetchProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      print('Gagal memuat profil: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Ambil token dari shared preferences (sesuaikan)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      // Upload ke server
      final success = await LogoProfile.uploadProfileImage(
        _imageFile!,
        token,
      );

      if (success) {
        print('Upload gambar berhasil');
        // Refresh profil setelah upload
        await _loadProfile();
      } else {
        print('Upload gambar gagal');
        // Bisa tampilkan pesan error di UI
      }
    }
  }

  void _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Konfirmasi Logout", style: GoogleFonts.poppins()),
            content: Text(
              "Apakah Anda yakin ingin logout?",
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                child: Text("Batal", style: GoogleFonts.poppins()),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text(
                  "Logout",
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  Widget _profileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(label, style: GoogleFonts.poppins(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF166534),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _profile == null
                ? Center(
                  child: Text(
                    "Gagal memuat data",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EditProfilePage(),
                                  ),
                                );

                                if (result == true) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await _loadProfile();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              onPressed: () => _logout(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : (_profile != null &&
                                                _profile!.loogo.isNotEmpty
                                            ? NetworkImage(_profile!.loogo)
                                            : null)
                                        as ImageProvider<Object>?,
                            child:
                                (_profile == null ||
                                        (_profile!.loogo.isEmpty &&
                                            _imageFile == null))
                                    ? const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    )
                                    : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                await _pickImage();
                                // Jika mau reload data dari server setelah upload,
                                // panggil _loadProfile();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _profile!.namaLengkap,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _profile!.noTelp,
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _profileItem(
                              Icons.person,
                              'Nama Lengkap',
                              _profile!.namaLengkap,
                            ),
                            _profileItem(
                              Icons.account_circle,
                              'Username',
                              _profile!.username,
                            ),
                            _profileItem(Icons.email, 'Email', _profile!.email),
                            _profileItem(
                              Icons.phone,
                              'Nomor HP',
                              _profile!.noTelp,
                            ),
                            _profileItem(
                              Icons.male,
                              'Jenis Kelamin',
                              _profile!.gender,
                            ),
                            _profileItem(
                              Icons.location_on,
                              'Alamat',
                              _profile!.alamat,
                            ),
                            _profileItem(
                              Icons.store,
                              'Jenis Akun',
                              _profile!.role,
                            ),
                            _profileItem(
                              Icons.date_range,
                              'Bergabung Sejak',
                              _profile!.createdAt,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
