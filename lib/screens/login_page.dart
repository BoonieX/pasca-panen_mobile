import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pascapanen_mobile/pages/main_screen.dart';
import 'package:pascapanen_mobile/screens/forgot_password.dart';
import 'package:pascapanen_mobile/screens/register_page.dart';
import 'package:pascapanen_mobile/services/api_service.dart';
import 'package:pascapanen_mobile/model/login_request.dart';
import 'package:pascapanen_mobile/model/user_model.dart';
import 'package:pascapanen_mobile/database/db_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final lastLoginStr = prefs.getString('last_login');

    if (token != null && lastLoginStr != null) {
      final lastLogin = DateTime.tryParse(lastLoginStr);
      if (lastLogin != null) {
        final now = DateTime.now();
        final difference = now.difference(lastLogin);

        if (difference.inDays <= 1) {
          // Langsung redirect ke MainScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen()),
          );
        } else {
          // Token expired, hapus data
          await prefs.remove('token');
          await prefs.remove('last_login');
        }
      }
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final login = _identifierController.text.trim();
      final password = _passwordController.text.trim();

      final loginRequest = LoginRequest(identifier: login, password: password);

      try {
        final user = await AuthService().login(loginRequest);
        if (user != null) {
          final dbHelper = DbHelper();
          final userModel = UserModel(
            id: user.id,
            namaLengkap: user.namaLengkap,
            username: user.username,
            gender: user.gender,
            email: user.email,
            noTelp: user.noTelp,
            alamat: user.alamat,
            token: user.token,
          );
          await dbHelper.insertUser(userModel);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', user.token ?? '');
          await prefs.setString('last_login', DateTime.now().toIso8601String());

          _showMessage("Login berhasil!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen()),
          );
        } else {
          _showMessage("Login gagal. Cek username atau password.");
        }
      } catch (e) {
        _showMessage("Terjadi kesalahan: ${e.toString()}");
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                const Text(
                  "Masuk",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Silakan masuk untuk melanjutkan",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  icon: Icons.account_circle,
                  hint: "Username atau Email",
                  controller: _identifierController,
                ),
                _buildPasswordField(
                  hint: "Password",
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value!),
                          activeColor: Colors.green,
                        ),
                        const Text("Ingat Saya"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                        );
                      },
                      child: const Text(
                        "Lupa Password?",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "MASUK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum Punya Akun? "),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      ),
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (value) =>
            value == null || value.isEmpty ? "$hint tidak boleh kosong" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
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
        validator: (value) =>
            value == null || value.isEmpty ? "$hint tidak boleh kosong" : null,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          hintText: hint,
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }
}
