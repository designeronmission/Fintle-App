import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class BusinessSetupScreen extends StatefulWidget {
  final String businessName;
  final String email;

  const BusinessSetupScreen({
    super.key,
    required this.businessName,
    required this.email,
  });

  @override
  State<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends State<BusinessSetupScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _otherBusinessTypeController = TextEditingController();
  final TextEditingController _otherCustomerBaseController = TextEditingController();
  final TextEditingController _otherInvoicePreferenceController = TextEditingController();
  final TextEditingController _otherProductCategoryController = TextEditingController();
  final TextEditingController _otherBusinessAgeController = TextEditingController();
  
  bool _isLoading = false;
  bool _needGST = false;
  int _currentScreenIndex = 0;
  
  // Curious questions answers
  String _selectedBusinessType = '';
  String _selectedCustomerBase = '';
  String _selectedInvoicePreference = '';
  String _selectedProductCategory = '';
  String _selectedBusinessAge = '';
  
  // Other options visibility
  bool _showOtherBusinessType = false;
  bool _showOtherCustomerBase = false;
  bool _showOtherInvoicePreference = false;
  bool _showOtherProductCategory = false;
  bool _showOtherBusinessAge = false;
  
  final List<String> _businessTypes = [
    'Retail Store',
    'Wholesale Business',
    'Service Provider',
    'Manufacturing',
    'E-commerce',
    'Restaurant/Cafe',
    'Other',
  ];
  
  final List<String> _customerBases = [
    'Local Customers',
    'Within State',
    'Across India',
    'International',
    'Other',
  ];
  
  final List<String> _invoicePreferences = [
    'Digital (Email/WhatsApp)',
    'Physical Print',
    'Both',
    'Other',
  ];
  
  final List<String> _productCategories = [
    'Electronics',
    'Clothing & Fashion',
    'Food & Beverages',
    'Furniture',
    'Health & Beauty',
    'Other Products',
  ];
  
  final List<String> _businessAges = [
    'Just Started (0-6 months)',
    'Growing (6-12 months)',
    'Established (1-3 years)',
    'Well Established (3+ years)',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _businessNameController.text = widget.businessName;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _gstController.dispose();
    _otherBusinessTypeController.dispose();
    _otherCustomerBaseController.dispose();
    _otherInvoicePreferenceController.dispose();
    _otherProductCategoryController.dispose();
    _otherBusinessAgeController.dispose();
    super.dispose();
  }

  void _nextScreen() {
    if (_currentScreenIndex < 6) {
      setState(() {
        _currentScreenIndex++;
      });
    } else {
      _saveAndContinue();
    }
  }

  void _previousScreen() {
    if (_currentScreenIndex > 0) {
      setState(() {
        _currentScreenIndex--;
      });
    }
  }

  void _skipQuestion() {
    // Clear the selected value for current question
    switch (_currentScreenIndex) {
      case 2:
        setState(() {
          _selectedBusinessType = '';
          _showOtherBusinessType = false;
          _otherBusinessTypeController.clear();
        });
        break;
      case 3:
        setState(() {
          _selectedCustomerBase = '';
          _showOtherCustomerBase = false;
          _otherCustomerBaseController.clear();
        });
        break;
      case 4:
        setState(() {
          _selectedInvoicePreference = '';
          _showOtherInvoicePreference = false;
          _otherInvoicePreferenceController.clear();
        });
        break;
      case 5:
        setState(() {
          _selectedProductCategory = '';
          _showOtherProductCategory = false;
          _otherProductCategoryController.clear();
        });
        break;
      case 6:
        setState(() {
          _selectedBusinessAge = '';
          _showOtherBusinessAge = false;
          _otherBusinessAgeController.clear();
        });
        break;
    }
    
    // Move to next screen
    _nextScreen();
  }

  void _handleOptionSelection(String value, int screenIndex) {
    if (value == 'Other') {
      setState(() {
        switch (screenIndex) {
          case 2:
            _selectedBusinessType = '';
            _showOtherBusinessType = true;
            break;
          case 3:
            _selectedCustomerBase = '';
            _showOtherCustomerBase = true;
            break;
          case 4:
            _selectedInvoicePreference = '';
            _showOtherInvoicePreference = true;
            break;
          case 5:
            _selectedProductCategory = '';
            _showOtherProductCategory = true;
            break;
          case 6:
            _selectedBusinessAge = '';
            _showOtherBusinessAge = true;
            break;
        }
      });
    } else {
      setState(() {
        switch (screenIndex) {
          case 2:
            _selectedBusinessType = value;
            _showOtherBusinessType = false;
            _otherBusinessTypeController.clear();
            break;
          case 3:
            _selectedCustomerBase = value;
            _showOtherCustomerBase = false;
            _otherCustomerBaseController.clear();
            break;
          case 4:
            _selectedInvoicePreference = value;
            _showOtherInvoicePreference = false;
            _otherInvoicePreferenceController.clear();
            break;
          case 5:
            _selectedProductCategory = value;
            _showOtherProductCategory = false;
            _otherProductCategoryController.clear();
            break;
          case 6:
            _selectedBusinessAge = value;
            _showOtherBusinessAge = false;
            _otherBusinessAgeController.clear();
            break;
        }
      });
    }
  }

  String _getOtherValue(int screenIndex) {
    switch (screenIndex) {
      case 2:
        return _otherBusinessTypeController.text;
      case 3:
        return _otherCustomerBaseController.text;
      case 4:
        return _otherInvoicePreferenceController.text;
      case 5:
        return _otherProductCategoryController.text;
      case 6:
        return _otherBusinessAgeController.text;
      default:
        return '';
    }
  }

  bool _isCurrentScreenValid() {
    return true;
  }

  Future<void> _saveAndContinue() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('business_name', _businessNameController.text.isNotEmpty 
        ? _businessNameController.text 
        : widget.businessName);
    await prefs.setBool('has_gst', _needGST);
    if (_needGST && _gstController.text.isNotEmpty) {
      await prefs.setString('gst_number', _gstController.text);
    }
    
    // Save business type with "Other" value if applicable
    String businessType = _selectedBusinessType;
    if (_showOtherBusinessType && _otherBusinessTypeController.text.isNotEmpty) {
      businessType = _otherBusinessTypeController.text;
    }
    await prefs.setString('business_type', businessType.isEmpty ? 'Not specified' : businessType);
    
    // Save customer base with "Other" value if applicable
    String customerBase = _selectedCustomerBase;
    if (_showOtherCustomerBase && _otherCustomerBaseController.text.isNotEmpty) {
      customerBase = _otherCustomerBaseController.text;
    }
    await prefs.setString('customer_base', customerBase.isEmpty ? 'Not specified' : customerBase);
    
    // Save invoice preference with "Other" value if applicable
    String invoicePreference = _selectedInvoicePreference;
    if (_showOtherInvoicePreference && _otherInvoicePreferenceController.text.isNotEmpty) {
      invoicePreference = _otherInvoicePreferenceController.text;
    }
    await prefs.setString('invoice_preference', invoicePreference.isEmpty ? 'Not specified' : invoicePreference);
    
    // Save product category with "Other" value if applicable
    String productCategory = _selectedProductCategory;
    if (_showOtherProductCategory && _otherProductCategoryController.text.isNotEmpty) {
      productCategory = _otherProductCategoryController.text;
    }
    await prefs.setString('product_category', productCategory.isEmpty ? 'Not specified' : productCategory);
    
    // Save business age with "Other" value if applicable
    String businessAge = _selectedBusinessAge;
    if (_showOtherBusinessAge && _otherBusinessAgeController.text.isNotEmpty) {
      businessAge = _otherBusinessAgeController.text;
    }
    await prefs.setString('business_age', businessAge.isEmpty ? 'Not specified' : businessAge);
    
    await prefs.setBool('business_setup_completed', true);
    
    setState(() {
      _isLoading = false;
    });
    
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Progress Bar
              Container(
                padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
                child: Column(
                  children: [
                    // Back Button and Title
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _previousScreen,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppTheme.primaryDarkBlue,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _getScreenTitle(),
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Progress Indicator
                    Row(
                      children: List.generate(7, (index) {
                        bool isActive = index <= _currentScreenIndex;
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: isActive 
                                  ? AppTheme.primaryDarkBlue 
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step ${_currentScreenIndex + 1} of 7',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: AppTheme.subtitleGray,
                          ),
                        ),
                        Text(
                          '${((_currentScreenIndex + 1) / 7 * 100).toInt()}% Complete',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: AppTheme.primaryDarkBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Screen Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildCurrentScreen(),
                ),
              ),
              
              // Next and Skip Buttons
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Skip Button (only for question screens)
                    if (_currentScreenIndex >= 2 && _currentScreenIndex <= 6)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _skipQuestion,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryDarkBlue,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    
                    if (_currentScreenIndex >= 2 && _currentScreenIndex <= 6)
                      const SizedBox(width: 12),
                    
                    // Continue Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryDarkBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          _currentScreenIndex == 6 ? 'Complete Setup' : 'Continue',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    );
  }

  String _getScreenTitle() {
    switch (_currentScreenIndex) {
      case 0:
        return 'Basic Information';
      case 1:
        return 'GST Details';
      case 2:
        return 'Business Type';
      case 3:
        return 'Customer Base';
      case 4:
        return 'Invoice Preference';
      case 5:
        return 'Product Category';
      case 6:
        return 'Business Experience';
      default:
        return 'Setup';
    }
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return _buildBasicInfoScreen();
      case 1:
        return _buildGSTScreen();
      case 2:
        return _buildQuestionScreen(
          title: 'What type of business do you run?',
          icon: Icons.category,
          options: _businessTypes,
          selectedValue: _selectedBusinessType,
          showOther: _showOtherBusinessType,
          otherController: _otherBusinessTypeController,
          onChanged: (value) => _handleOptionSelection(value, 2),
        );
      case 3:
        return _buildQuestionScreen(
          title: 'Where are your customers located?',
          icon: Icons.people_outline,
          options: _customerBases,
          selectedValue: _selectedCustomerBase,
          showOther: _showOtherCustomerBase,
          otherController: _otherCustomerBaseController,
          onChanged: (value) => _handleOptionSelection(value, 3),
        );
      case 4:
        return _buildQuestionScreen(
          title: 'How would you like to send invoices?',
          icon: Icons.receipt_outlined,
          options: _invoicePreferences,
          selectedValue: _selectedInvoicePreference,
          showOther: _showOtherInvoicePreference,
          otherController: _otherInvoicePreferenceController,
          onChanged: (value) => _handleOptionSelection(value, 4),
        );
      case 5:
        return _buildQuestionScreen(
          title: 'What products/services do you offer?',
          icon: Icons.shopping_bag_outlined,
          options: _productCategories,
          selectedValue: _selectedProductCategory,
          showOther: _showOtherProductCategory,
          otherController: _otherProductCategoryController,
          onChanged: (value) => _handleOptionSelection(value, 5),
        );
      case 6:
        return _buildQuestionScreen(
          title: 'How long has your business been operating?',
          icon: Icons.timeline_outlined,
          options: _businessAges,
          selectedValue: _selectedBusinessAge,
          showOther: _showOtherBusinessAge,
          otherController: _otherBusinessAgeController,
          onChanged: (value) => _handleOptionSelection(value, 6),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.lightBlueBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront,
              size: 50,
              color: AppTheme.primaryDarkBlue,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'What should we call your business?',
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This will appear on all your invoices and bills',
          style: GoogleFonts.lato(
            fontSize: 14,
            color: AppTheme.subtitleGray,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _businessNameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter your Business Name',
              hintStyle: GoogleFonts.lato(color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              prefixIcon: const Icon(Icons.business_outlined, color: AppTheme.primaryDarkBlue),
            ),
            style: GoogleFonts.lato(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildGSTScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.lightBlueBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long,
              size: 50,
              color: AppTheme.primaryDarkBlue,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Do you need to add GST to your bills?',
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This helps us generate tax-compliant invoices',
          style: GoogleFonts.lato(
            fontSize: 14,
            color: AppTheme.subtitleGray,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: _buildRadioCard(
                title: 'Without GST',
                subtitle: 'For small businesses',
                icon: Icons.remove_circle_outline,
                isSelected: !_needGST,
                onTap: () {
                  setState(() {
                    _needGST = false;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRadioCard(
                title: 'With GST',
                subtitle: 'Registered business',
                icon: Icons.check_circle_outline,
                isSelected: _needGST,
                onTap: () {
                  setState(() {
                    _needGST = true;
                  });
                },
              ),
            ),
          ],
        ),
        if (_needGST) ...[
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextFormField(
              controller: _gstController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter GST Number (Optional)',
                hintStyle: GoogleFonts.lato(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                prefixIcon: const Icon(Icons.numbers, color: AppTheme.primaryDarkBlue),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuestionScreen({
    required String title,
    required IconData icon,
    required List<String> options,
    required String selectedValue,
    required bool showOther,
    required TextEditingController otherController,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.lightBlueBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 50,
              color: AppTheme.primaryDarkBlue,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select an option that best describes you',
          style: GoogleFonts.lato(
            fontSize: 14,
            color: AppTheme.subtitleGray,
          ),
        ),
        const SizedBox(height: 40),
        ...options.map((option) {
          bool isSelected = selectedValue == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionCard(
              title: option,
              isSelected: isSelected,
              onTap: () => onChanged(option),
            ),
          );
        }).toList(),
        
        if (showOther) ...[
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryDarkBlue, width: 1.5),
            ),
            child: TextFormField(
              controller: otherController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Please specify',
                hintStyle: GoogleFonts.lato(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                prefixIcon: Icon(Icons.edit_note, color: AppTheme.primaryDarkBlue),
              ),
              style: GoogleFonts.lato(fontSize: 16),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRadioCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryDarkBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryDarkBlue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppTheme.subtitleGray,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: isSelected ? Colors.white70 : AppTheme.subtitleGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryDarkBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryDarkBlue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Colors.white : AppTheme.subtitleGray,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}