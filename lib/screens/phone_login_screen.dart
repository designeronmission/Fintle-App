import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_theme.dart';
import 'business_setup_screen.dart';
import 'dashboard_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  bool _isLoading = false;
  bool _otpSent = false;
  int _resendTimer = 0;
  String _generatedOtp = '';
  String? _phoneError;
  String? _otpError;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 30;
    });
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
          }
        });
      }
      return _resendTimer > 0;
    });
  }

  void _validatePhoneAndSendOtp() {
    setState(() {
      if (_phoneController.text.isEmpty) {
        _phoneError = 'Please enter your phone number';
      } else if (_phoneController.text.length < 10) {
        _phoneError = 'Please enter a valid 10-digit phone number';
      } else {
        _phoneError = null;
        _sendOtp();
      }
    });
  }

  void _sendOtp() {
    setState(() {
      _isLoading = true;
    });
    
    _generatedOtp = (100000 + Random().nextInt(900000)).toString();
    
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _otpSent = true;
      });
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('OTP Sent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sms, size: 50, color: AppTheme.primaryDarkBlue),
              const SizedBox(height: 10),
              Text(
                'Demo OTP: $_generatedOtp',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter this code to verify',
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: AppTheme.subtitleGray,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      
      _startResendTimer();
    });
  }

  void _resendOtp() {
    if (_resendTimer > 0) return;
    
    setState(() {
      _isLoading = true;
    });
    
    _generatedOtp = (100000 + Random().nextInt(900000)).toString();
    
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('OTP Resent'),
          content: Text('New OTP: $_generatedOtp'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      
      _startResendTimer();
    });
  }

  void _validateOtpAndVerify() {
    setState(() {
      if (_otpController.text.isEmpty) {
        _otpError = 'Please enter the OTP';
      } else if (_otpController.text.length != 6) {
        _otpError = 'OTP must be 6 digits';
      } else if (_otpController.text != _generatedOtp) {
        _otpError = 'Invalid OTP. Please try again.';
      } else {
        _otpError = null;
        _verifyOtp();
      }
    });
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_phone', _phoneController.text);
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('login_method', 'phone');
    await prefs.setString('last_login', DateTime.now().toString());
    
    setState(() {
      _isLoading = false;
    });
    
    if (mounted) {
      final isBusinessSetup = prefs.getBool('business_setup_completed') ?? false;
      
      if (isBusinessSetup) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessSetupScreen(
              businessName: '',
              email: '',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          
                          Text(
                            'Sign In with Phone',
                            style: GoogleFonts.lato(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'ll send a verification code to your phone',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: AppTheme.subtitleGray,
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Phone Input
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _phoneError != null ? Colors.red : Colors.grey.shade200,
                                    width: _phoneError != null ? 1.5 : 1,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: GoogleFonts.lato(fontSize: 16),
                                  enabled: !_otpSent,
                                  decoration: InputDecoration(
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/india_flag.png',
                                            height: 20,
                                            width: 20,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Text(
                                                '🇮🇳',
                                                style: TextStyle(fontSize: 18),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            '+91',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            height: 24,
                                            width: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                        ],
                                      ),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(minWidth: 90),
                                    hintText: '123 456 7890',
                                    hintStyle: GoogleFonts.lato(
                                      color: Colors.grey.shade400,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              ),
                              if (_phoneError != null) ...[
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline, color: Colors.red, size: 16),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          _phoneError!,
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          if (!_otpSent) ...[
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _validatePhoneAndSendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryDarkBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Send OTP',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            // OTP Input Section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enter Verification Code',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryDarkBlue,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _otpError != null ? Colors.red : Colors.grey.shade200,
                                      width: _otpError != null ? 1.5 : 1,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _otpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    style: GoogleFonts.lato(fontSize: 16),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Enter 6-digit OTP',
                                      hintStyle: GoogleFonts.lato(
                                        color: Colors.grey.shade400,
                                      ),
                                      border: InputBorder.none,
                                      counterText: '',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    ),
                                  ),
                                ),
                                if (_otpError != null) ...[
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.error_outline, color: Colors.red, size: 16),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            _otpError!,
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 20),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Didn\'t receive OTP?',
                                      style: GoogleFonts.lato(
                                        color: AppTheme.subtitleGray,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _resendTimer > 0 ? null : _resendOtp,
                                      child: Text(
                                        _resendTimer > 0 
                                            ? 'Resend OTP (${_resendTimer}s)'
                                            : 'Resend OTP',
                                        style: GoogleFonts.lato(
                                          color: _resendTimer > 0 
                                              ? Colors.grey 
                                              : AppTheme.primaryDarkBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 30),
                                
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _validateOtpAndVerify,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryDarkBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Continue',
                                      style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: SpinKitFadingCircle(
                    color: AppTheme.primaryDarkBlue,
                    size: 50,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}