import 'package:flutter/material.dart';
import 'package:pascapanen_mobile/database/db_helper.dart';
import 'package:pascapanen_mobile/model/user_model.dart';
import 'package:pascapanen_mobile/pages/home_screen.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final db = DbHelper.instance;
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      final user = await db.getPetani(username, password);

      if (user != null) {
        _showMessage("Login berhasil!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(userName: user.username)),
        );
      } else {
        _showMessage("Username atau password salah.");
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                const Text("Masuk", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 8),
                const Text("Silakan masuk untuk melanjutkan", style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 30),

                _buildTextField(icon: Icons.account_circle, hint: "Username", controller: _usernameController),
                _buildPasswordField(
                  hint: "Password",
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("MASUK", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum Punya Akun? "),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                      child: const Text("Daftar", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) => value == null || value.isEmpty ? "$hint tidak boleh kosong" : null,
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
