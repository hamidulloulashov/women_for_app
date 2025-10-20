
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:women_for_app/features/auth/managers/aut_bloc.dart';
import 'package:women_for_app/features/auth/managers/auth_event.dart';
import 'package:women_for_app/features/auth/managers/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  
  bool _obscurePassword = true;
  int _codeResendTimer = 0;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () => context.go('/login'),
        ),
        title: const Text(
          "Ro'yxatdan o'tish",
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Muvaffaqiyatli ro\'yxatdan o\'tdingiz!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/homePage');
          } else if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Xatolik yuz berdi'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state.verificationCodeSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SMS kod yuborildi! Kodni kutib oling.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Xush kelibsiz!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Davom etish uchun ro\'yxatdan o\'ting',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9E9E9E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    _buildLabel('Login'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _usernameController,
                      hintText: 'username',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username kiriting';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    _buildLabel('Telefon raqami'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: '+998976770604',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Telefon raqam kiriting';
                        }
                        if (!value.startsWith('+')) {
                          return 'Telefon raqam \'+\' bilan boshlanishi kerak';
                        }
                        return null;
                      },
                      enabled: !state.verificationCodeSent,
                    ),
                    const SizedBox(height: 16),
                    
                    if (!state.verificationCodeSent)
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  final phone = _phoneController.text.trim();
                                  if (phone.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Telefon raqamini kiriting'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                    return;
                                  }
                                  
                                  context.read<AuthBloc>().add(
                                        SendVerificationCodeRequested(phone),
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('SMS kod yuborish'),
                        ),
                      ),
                    
                    // SMS Code field (shown after code sent)
                    if (state.verificationCodeSent) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'SMS kod ${_phoneController.text} raqamiga yuborildi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('SMS kod (6 ta raqam)'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _codeController,
                        hintText: '000000',
                        prefixIcon: Icons.sms_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'SMS kodni kiriting';
                          }
                          if (value.length != 6) {
                            return 'SMS kod 6 ta raqamdan iborat bo\'lishi kerak';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  final code = _codeController.text.trim();
                                  final phone = _phoneController.text.trim();
                                  
                                  if (code.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('SMS kodni kiriting'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                    return;
                                  }
                                  
                                  context.read<AuthBloc>().add(
                                        VerifyCodeRequested(
                                          phoneNumber: phone,
                                          code: code,
                                        ),
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Kodni tasdiqlash'),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    
                    // Ism va Familiya - o'chirish (Backend Register endpoint yo'q)
                    // _buildLabel('Ism'),
                    // const SizedBox(height: 8),
                    // _buildTextField(...),
                    
                    _buildLabel('Parol'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF9E9E9E),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Parol kiriting';
                        }
                        if (value.length < 6) {
                          return 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (value) {},
                          activeColor: const Color(0xFFE91E63),
                        ),
                        const Expanded(
                          child: Text(
                            'Maxfiylik siyosatini qabul qilaman',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (state.verificationCodeSent)
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                          LoginRequested(
                                            username: _usernameController.text.trim(),
                                            password: _passwordController.text,
                                          ),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Kirish",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Akkauntingiz bormi? ',
                          style: TextStyle(
                            color: Color(0xFF2D3142),
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text(
                            'Kirish',
                            style: TextStyle(
                              color: Color(0xFFE91E63),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF2D3142),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF9E9E9E)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE91E63)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
    );
  }
}