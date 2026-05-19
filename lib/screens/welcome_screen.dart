import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Manage your business easily',
      description: 'All your business tools in one place to manage invoices, track sales, and grow your business',
      imagePath: 'assets/images/signup_illustration.png',
    ),
    OnboardingData(
      title: 'Smart Billing System',
      description: 'Create professional invoices and manage your inventory with just a few clicks',
      imagePath: 'assets/images/signup_illustration.png',
    ),
    OnboardingData(
      title: 'Real-time Analytics',
      description: 'Track your business performance with detailed reports and insights',
      imagePath: 'assets/images/signup_illustration.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryDarkBlue,
                  ),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDarkBlue,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page View
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingData[index]);
                },
              ),
            ),
            
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentPage == index 
                        ? AppTheme.primaryDarkBlue 
                        : AppTheme.lightBlueBg,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlueBg,
                      borderRadius: BorderRadius.circular(190),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        // Sign In Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SigninScreen()),
                              );
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryDarkBlue,
                                borderRadius: BorderRadius.circular(190),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        // Sign Up Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignupScreen()),
                              );
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(190),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryDarkBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Join thousands of business owners managing their finances',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: AppTheme.subtitleGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              color: AppTheme.lightBlueBg,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                data.imagePath,
                fit: BoxFit.cover,
                width: 260,
                height: 260,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image not found - show colored container with icon
                  return Container(
                    color: AppTheme.lightBlueBg,
                    child: Icon(
                      _getFallbackIcon(data.imagePath),
                      size: 100,
                      color: AppTheme.primaryDarkBlue,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: GoogleFonts.lato(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.subtitleGray,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Fallback icons in case images are missing
  IconData _getFallbackIcon(String imagePath) {
    if (imagePath.contains('manage')) {
      return Icons.business_center_outlined;
    } else if (imagePath.contains('billing')) {
      return Icons.receipt_long_outlined;
    } else {
      return Icons.analytics_outlined;
    }
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}