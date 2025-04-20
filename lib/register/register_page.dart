import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/database/db_helper.dart'; // ganti sesuai path-mu
import 'package:pascapanen_mobile/model/user_model.dart'; // ganti sesuai path-mu
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
final db = DbHelper.instance;
      final user = UserModel(
        nama: _namaController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        telepon: _teleponController.text.trim(),
        alamat: _alamatController.text.trim(),
        gender: _selectedGender!,
        password: _passwordController.text.trim(),
      );

      await db.insertUser(user);

      // Navigasi ke login setelah berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil! Silakan masuk.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/logoapk.png', height: 180),
                const SizedBox(height: 20),
                const Text("Daftar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 8),
                const Text("Langkah pertama dimulai di sini !", style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 30),

                _buildTextField(icon: Icons.person, hint: "Nama Lengkap", controller: _namaController),
                _buildTextField(icon: Icons.account_circle, hint: "Username", controller: _usernameController),

                // Gender
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(icon: Icon(Icons.male), border: InputBorder.none),
                    hint: const Text("Pilih Gender"),
                    value: _selectedGender,
                    validator: (value) => value == null ? "Pilih gender!" : null,
                    items: ["Laki-laki", "Perempuan"].map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
                    onChanged: (value) => setState(() => _selectedGender = value),
                  ),
                ),

                _buildTextField(icon: Icons.email, hint: "Email", controller: _emailController, type: TextInputType.emailAddress),
                _buildTextField(icon: Icons.phone, hint: "No Telepon", controller: _teleponController, type: TextInputType.phone),
                _buildTextField(icon: Icons.location_on, hint: "Alamat", controller: _alamatController),

                // Password
                _buildPasswordField(
                  hint: "Password",
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                ),

                // Konfirmasi Password
                _buildPasswordField(
                  hint: "Konfirmasi Password",
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  isConfirmation: true,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("DAFTAR", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah Punya Akun? "),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                      child: const Text("Masuk", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required IconData icon, required String hint, required TextEditingController controller, TextInputType type = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (value) => value == null || value.isEmpty ? "$hint tidak boleh kosong" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggle,
    bool isConfirmation = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) return "$hint tidak boleh kosong";
          if (isConfirmation && value != _passwordController.text) return "Password tidak cocok";
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          hintText: hint,
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }
}
