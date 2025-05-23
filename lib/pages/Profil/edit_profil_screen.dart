import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:pascapanen_mobile/model/profile_model.dart';
import 'package:pascapanen_mobile/services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  String selectedGender = 'Laki-laki';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    whatsappController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await ProfileService.fetchProfile();
      setState(() {
        nameController.text = profile.namaLengkap;
        usernameController.text = profile.username;
        emailController.text = profile.email;
        whatsappController.text = profile.noTelp;
        selectedGender = profile.gender;
        alamatController.text = profile.alamat;
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memuat profil: $e',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Layanan lokasi tidak aktif');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Izin lokasi ditolak');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Izin lokasi ditolak permanen');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          alamatController.text =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
        });
      }

      final googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',
      );

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar('Tidak dapat membuka Google Maps');
      }
    } catch (e) {
      _showSnackBar('Gagal mendapatkan lokasi: $e');
    }
  }

  void _showSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final profile = Profile(
      namaLengkap: nameController.text.trim(),
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      noTelp: whatsappController.text.trim(),
      gender: selectedGender,
      alamat: alamatController.text.trim(),
      role: '',
      logo: '',
      createdAt: '',
    );

    try {
      await ProfileService.updateProfile(profile);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profil berhasil disimpan',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar('Gagal menyimpan: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: const Color(0xFF166534),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(Icons.person, 'Nama Lengkap', nameController),
                  _buildTextField(
                    Icons.email,
                    'Email',
                    emailController,
                    enabled: false,
                    inputType: TextInputType.emailAddress,
                  ),
                  _buildTextField(
                    Icons.account_circle,
                    'Username',
                    usernameController,
                  ),
                  _buildTextField(
                    Icons.phone,
                    'Nomor WhatsApp/Telp',
                    whatsappController,
                    inputType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tidak boleh kosong';
                      }
                      if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                        return 'Nomor tidak valid';
                      }
                      return null;
                    },
                  ),
                  _buildDropdown(
                    Icons.person,
                    'Jenis Kelamin',
                    selectedGender,
                    ['Laki-laki', 'Perempuan'],
                    (value) => setState(() => selectedGender = value!),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.location_on),
                    label: const Text(
                      'Ambil Lokasi Sekarang',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF166534),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _getCurrentLocation,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    Icons.home,
                    'Alamat (Otomatis dari GPS)',
                    alamatController,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF166534),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isSaving ? null : _saveProfile,
                      child: const Text(
                        'SIMPAN',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isSaving)
            Container(
              color: Colors.white.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String label,
    TextEditingController controller, {
    bool enabled = true,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: inputType,
        validator:
            validator ??
            (value) =>
                value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Poppins'),
          border: const OutlineInputBorder(),
        ),
        style: const TextStyle(fontFamily: 'Poppins'),
      ),
    );
  }

  Widget _buildDropdown(
    IconData icon,
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Poppins'),
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            onChanged: onChanged,
            style: const TextStyle(fontFamily: 'Poppins', color: Colors.black),
            items:
                items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
