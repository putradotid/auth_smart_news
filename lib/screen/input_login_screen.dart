import 'package:flutter/material.dart';
import 'success_login_screen.dart';
import 'package:auth_smart_news/auth_service.dart';

class InputLoginScreen extends StatefulWidget {
  const InputLoginScreen({super.key});

  @override
  State<InputLoginScreen> createState() => _InputLoginScreenState();
}

class _InputLoginScreenState extends State<InputLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool loading = false;

  bool get isFormFilled =>
      emailController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  Future<void> handleEmailLogin() async {
    if (!isFormFilled) return;

    setState(() => loading = true);

    try {
      final user = await AuthService().signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SuccessLoginScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    Center(
                      child: Image.asset("assets/logo/Frame.png", width: 80),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      "Login ke akun LensNews",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),

                    const SizedBox(height: 30),

                    _buildTextField(
                      controller: emailController,
                      hint: "Masukkan email anda",
                    ),

                    const SizedBox(height: 16),

                    _buildPasswordField(),

                    const SizedBox(height: 26),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : handleEmailLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFormFilled
                              ? const Color(0xFF1C6B4A)
                              : Colors.grey.shade300,
                          foregroundColor: isFormFilled
                              ? Colors.white
                              : Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Masuk Sekarang",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Kamu belum punya akun? "),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Daftar Sekarang",
                      style: TextStyle(
                        color: Color(0xFF1C6B4A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: _boxDecoration(),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: _boxDecoration(),
      child: TextField(
        controller: passwordController,
        obscureText: obscurePassword,
        decoration: InputDecoration(
          hintText: "Masukkan kata sandi anda",
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() => obscurePassword = !obscurePassword);
            },
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
