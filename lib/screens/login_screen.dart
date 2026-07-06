// ================================================================
// Nama Sistem  : Aqualyze - Smart Water Monitoring System
// Author       : Refan Rustoni Putra
// NIM          : 10824005
// Versi        : 1.3.0
// Tahun        : 2026
// Ownership    : Capstone Project - Universitas
// Deskripsi    : Sistem monitoring kualitas air berbasis IoT
//                yang menampilkan data suhu, pH, dan kekeruhan
//                secara realtime melalui aplikasi mobile dan web.
// ================================================================

// ======================= Library ================================
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'zaki@aqualyze.io');
  final _passwordCtrl = TextEditingController(text: 'password123');
  bool _showPassword = false;
  bool _rememberMe = true;
  bool _isLoading = false;
  bool _loginDone = false;

  Future<void> _handleLogin() async {
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await ApiService.login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result != null) {
      setState(() => _loginDone = true);

      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      widget.onLoginSuccess(result["user"]);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email atau Password salah"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AquaColors.bg,
      body: Stack(
        children: [
          // Wave bg at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AquaColors.primary.withOpacity(0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Brand
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AquaColors.primary,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: AquaColors.primary.withOpacity(0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.water_drop_rounded,
                              color: Colors.white, size: 44),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Aqualyze',
                          style: TextStyle(
                            fontFamily: AquaText.font,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AquaColors.primary,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KECERDASAN ALIRAN PRESISI',
                          style: AquaText.micro.copyWith(
                            color: Colors.grey[500],
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // Card
                    GlassCard(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Welcome
                          const Text(
                            'Selamat Datang Kembali',
                            style: TextStyle(
                              fontFamily: AquaText.font,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AquaColors.textMain,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Masukkan kredensial Anda untuk mengakses platform.',
                            style: AquaText.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),

                          // Email
                          AquaTextField(
                            label: 'Alamat Email',
                            hint: 'nama@perusahaan.com',
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            prefix: const Icon(Icons.mail_outline_rounded,
                                color: AquaColors.textSubtle, size: 20),
                          ),
                          const SizedBox(height: 18),

                          // Password
                          AquaTextField(
                            label: 'Kata Sandi',
                            hint: '••••••••',
                            controller: _passwordCtrl,
                            obscureText: !_showPassword,
                            prefix: const Icon(Icons.lock_outline_rounded,
                                color: AquaColors.textSubtle, size: 20),
                            suffix: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _showPassword = !_showPassword),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Remember me + forgot
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (v) =>
                                    setState(() => _rememberMe = v ?? true),
                                activeColor: AquaColors.primary,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Text(
                                'Ingat perangkat ini selama 30 hari',
                                style: AquaText.body.copyWith(fontSize: 12),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Lupa Kata Sandi?',
                                  style: TextStyle(
                                    fontFamily: AquaText.font,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AquaColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Login button
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: _loginDone
                                  ? const Color(0xFF16A34A)
                                  : AquaColors.primary,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AquaColors.primary.withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                minimumSize: const Size(double.infinity, 52),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5),
                                    )
                                  : _loginDone
                                      ? const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check_circle_rounded,
                                                size: 20, color: Colors.white),
                                            SizedBox(width: 8),
                                            Text('Berhasil Masuk',
                                                style: TextStyle(
                                                    fontFamily: AquaText.font,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                          ],
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Masuk',
                                                style: TextStyle(
                                                    fontFamily: AquaText.font,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                            SizedBox(width: 6),
                                            Icon(Icons.arrow_forward_rounded,
                                                size: 16, color: Colors.white),
                                          ],
                                        ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Belum punya akun? ',
                                  style: AquaText.body.copyWith(fontSize: 12)),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Daftar Sekarang',
                                  style: TextStyle(
                                    fontFamily: AquaText.font,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AquaColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final label in [
                          'Kebijakan Privasi',
                          'Ketentuan Layanan',
                          'Bantuan'
                        ])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              label,
                              style: AquaText.micro
                                  .copyWith(color: Colors.grey[400]),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
