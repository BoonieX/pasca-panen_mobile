import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/database/db_helper.dart';
import 'package:pascapanen_mobile/model/user_model.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final DbHelper _dbHelper = DbHelper();

  final namaController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final alamatController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? selectedGender;
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logoapk.png', height: 150),
              const SizedBox(height: 16),
              const Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Langkah pertama dimulai di sini !',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 24),

              // Nama Lengkap
              _buildTextField(
                controller: namaController,
                hintText: 'Nama Lengkap',
                icon: Icons.person,
                validatorText: 'Nama Lengkap Tidak Boleh Kosong',
              ),

              // Username
              _buildTextField(
                controller: usernameController,
                hintText: 'Username',
                icon: Icons.person_pin,
                validatorText: 'Username Tidak Boleh Kosong',
              ),

              // Gender
              DropdownButtonFormField<String>(
                decoration: _buildInputDecoration(
                  hintText: 'Gender',
                  icon: Icons.male,
                ),
                value: selectedGender,
                items: ['Laki-laki', 'Perempuan']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Gender Tidak Boleh Kosong'
                    : null,
                isExpanded: true,
              ),
              const SizedBox(height: 16),

              // Email
              _buildTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email Tidak Boleh Kosong';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),

              // No Telepon
              _buildTextField(
                controller: phoneController,
                hintText: 'No Telepon',
                icon: Icons.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No Telepon Tidak Boleh Kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'No Telepon harus berupa angka';
                  }
                  return null;
                },
              ),

              // Alamat
              _buildTextField(
                controller: alamatController,
                hintText: 'Alamat',
                icon: Icons.home,
                validatorText: 'Alamat Tidak Boleh Kosong',
              ),

              // Password
              _buildPasswordField(
                controller: passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: _isObscuredPassword,
                toggleVisibility: () {
                  setState(() {
                    _isObscuredPassword = !_isObscuredPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password Tidak Boleh Kosong';
                  }
                  if (value.length < 8) {
                    return 'Password minimal 8 karakter';
                  }
                  if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'Password harus mengandung huruf besar';
                  }
                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'Password harus mengandung angka';
                  }
                  return null;
                },
              ),

              // Konfirmasi Password
              _buildPasswordField(
                controller: confirmPasswordController,
                hintText: 'Konfirmasi Password',
                icon: Icons.lock_outline,
                obscureText: _isObscuredConfirmPassword,
                toggleVisibility: () {
                  setState(() {
                    _isObscuredConfirmPassword = !_isObscuredConfirmPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi Password Tidak Boleh Kosong';
                  } else if (value != passwordController.text) {
                    return 'Password Tidak Sama';
                  }
                  return null;
                },
              ),

              // Tombol Daftar
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('DAFTAR'),
              ),
              const SizedBox(height: 16),

              // Link ke Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah Punya Akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text('Masuk'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && selectedGender != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Cek apakah username sudah terdaftar
        final existingUser = await _dbHelper.getUserByUsernameAndPassword(
          usernameController.text.trim(), 
          passwordController.text.trim()
        );

        if (existingUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username sudah terdaftar')),
          );
          return;
        }

        // Buat user baru
        final newUser = UserModel(
          namaLengkap: namaController.text.trim(),
          username: usernameController.text.trim(),
          gender: selectedGender!,
          email: emailController.text.trim(),
          noTelp: phoneController.text.trim(),
          alamat: alamatController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Simpan ke database
        await _dbHelper.insertUser(newUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Input decoration builder
  InputDecoration _buildInputDecoration({required String hintText, required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      fillColor: Colors.green[100],
      filled: true,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Reusable text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? validatorText,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: _buildInputDecoration(hintText: hintText, icon: icon),
          validator: validator ?? 
              (value) => value == null || value.isEmpty ? validatorText : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Reusable password field
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.green[100],
            filled: true,
            prefixIcon: Icon(icon),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: toggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}