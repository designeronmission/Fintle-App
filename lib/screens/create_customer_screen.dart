import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class CreateCustomerScreen extends StatefulWidget {
  const CreateCustomerScreen({super.key});

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  // Step management
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Form controllers
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _openingBalanceController =
      TextEditingController(text: '0');
  final TextEditingController _gstinController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _creditPeriodController = TextEditingController();
  final TextEditingController _creditLimitController = TextEditingController();

  // Billing Address controllers
  final TextEditingController _billingAddressLine1Controller =
      TextEditingController();
  final TextEditingController _billingAddressLine2Controller =
      TextEditingController();
  final TextEditingController _billingCityController = TextEditingController();
  final TextEditingController _billingStateController = TextEditingController();
  final TextEditingController _billingZipController = TextEditingController();

  // Shipping Address controllers
  final TextEditingController _shippingAddressLine1Controller =
      TextEditingController();
  final TextEditingController _shippingAddressLine2Controller =
      TextEditingController();
  final TextEditingController _shippingCityController = TextEditingController();
  final TextEditingController _shippingStateController =
      TextEditingController();
  final TextEditingController _shippingZipController = TextEditingController();

  // Dropdown values
  String _selectedBalanceType = 'to_collect';
  String _selectedCountry = 'IN';
  String _selectedCustomerType = 'customer';
  String _selectedCustomerCategory = 'Retail';
  String _selectedShippingCountry = 'IN';

  bool _sameAsBilling = false;

  // Accordion expansion states
  bool _basicInfoExpanded = true;
  bool _billingAddressExpanded = true;
  bool _shippingAddressExpanded = false;
  bool _creditInfoExpanded = true;
  bool _bankAccountsExpanded = true;

  // Bank accounts list
  List<Map<String, dynamic>> _bankAccounts = [];
  int _bankIdCounter = 1;

  @override
  void dispose() {
    _customerNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _openingBalanceController.dispose();
    _gstinController.dispose();
    _panController.dispose();
    _creditPeriodController.dispose();
    _creditLimitController.dispose();
    _billingAddressLine1Controller.dispose();
    _billingAddressLine2Controller.dispose();
    _billingCityController.dispose();
    _billingStateController.dispose();
    _billingZipController.dispose();
    _shippingAddressLine1Controller.dispose();
    _shippingAddressLine2Controller.dispose();
    _shippingCityController.dispose();
    _shippingStateController.dispose();
    _shippingZipController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _addBankAccount() {
    setState(() {
      _bankAccounts.add({
        'id': _bankIdCounter++,
        'bankName': '',
        'holderName': '',
        'accountNo': '',
        'ifsc': '',
      });
    });
  }

  void _removeBankAccount(int id) {
    setState(() {
      _bankAccounts.removeWhere((acc) => acc['id'] == id);
    });
  }

  void _updateBankAccount(int id, String field, String value) {
    final index = _bankAccounts.indexWhere((acc) => acc['id'] == id);
    if (index != -1) {
      setState(() {
        _bankAccounts[index][field] = value;
      });
    }
  }

  void _syncShippingAddress() {
    if (_sameAsBilling) {
      _shippingAddressLine1Controller.text =
          _billingAddressLine1Controller.text;
      _shippingAddressLine2Controller.text =
          _billingAddressLine2Controller.text;
      _shippingCityController.text = _billingCityController.text;
      _shippingStateController.text = _billingStateController.text;
      _shippingZipController.text = _billingZipController.text;
      _selectedShippingCountry = _selectedCountry;
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveCustomer() {
    if (_customerNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter customer name')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Customer "${_customerNameController.text}" created successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  void _getGstDetails() {
    final gst = _gstinController.text.trim();
    if (gst.length >= 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fetching details for GST: $gst')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid GSTIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.primaryDarkBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Customer',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveCustomer,
            child: Text(
              'Save',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDarkBlue,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step Indicator
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepIndicator(0, 'General Info'),
                _buildStepLine(),
                _buildStepIndicator(1, 'Address Details'),
                _buildStepLine(),
                _buildStepIndicator(2, 'Credit & Bank'),
              ],
            ),
          ),
          // Page View
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildGeneralInfoStep(),
                _buildAddressDetailsStep(),
                _buildCreditBankStep(),
              ],
            ),
          ),
          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chevron_left, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              'Previous',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: _currentStep == 0 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: _currentStep == 2 ? _saveCustomer : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDarkBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentStep == 2 ? 'Save Customer' : 'Next',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          if (_currentStep != 2) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right,
                                size: 18, color: Colors.white),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive || isCompleted
                ? AppTheme.primaryDarkBlue
                : Colors.grey.shade200,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive || isCompleted
                          ? Colors.white
                          : Colors.grey.shade500,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppTheme.primaryDarkBlue : AppTheme.subtitleGray,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 40,
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.grey.shade300,
    );
  }

  // ==================== STEP 1: GENERAL INFO ====================
  Widget _buildGeneralInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAccordionSection(
            title: 'Basic Information',
            icon: Icons.person_outline,
            expanded: _basicInfoExpanded,
            onTap: () {
              setState(() {
                _basicInfoExpanded = !_basicInfoExpanded;
              });
            },
            content: Column(
              children: [
                _buildTextField(
                  controller: _customerNameController,
                  label: 'Customer Name',
                  hint: 'Enter customer name',
                  required: true,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _mobileController,
                  label: 'Cell Phone Number',
                  hint: 'Enter cell phone number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter email address',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildTextField(
                        controller: _openingBalanceController,
                        label: 'Opening Balance',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        prefix: '₹',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedBalanceType,
                        decoration: _inputDecoration('Type'),
                        items: const [
                          DropdownMenuItem(
                              value: 'to_collect', child: Text('To Collect')),
                          DropdownMenuItem(
                              value: 'to_pay', child: Text('To Pay')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedBalanceType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _gstinController,
                        label: 'GSTIN',
                        hint: 'Enter GST number',
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _getGstDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: AppTheme.primaryDarkBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                      child: Text(
                        'Get Details',
                        style: GoogleFonts.lato(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _panController,
                        label: 'PAN Number',
                        hint: 'Enter PAN number',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCustomerType,
                        decoration: _inputDecoration('Customer Type'),
                        items: const [
                          DropdownMenuItem(
                              value: 'customer', child: Text('Customer')),
                          DropdownMenuItem(
                              value: 'supplier', child: Text('Supplier')),
                          DropdownMenuItem(value: 'both', child: Text('Both')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCustomerType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _selectedCustomerCategory,
                  decoration: _inputDecoration('Customer Category'),
                  items: const [
                    DropdownMenuItem(value: 'Retail', child: Text('Retail')),
                    DropdownMenuItem(
                        value: 'Wholesale', child: Text('Wholesale')),
                    DropdownMenuItem(
                        value: 'Corporate', child: Text('Corporate')),
                    DropdownMenuItem(value: 'Regular', child: Text('Regular')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCustomerCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STEP 2: ADDRESS DETAILS ====================
  Widget _buildAddressDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAccordionSection(
            title: 'Billing Address',
            icon: Icons.location_on_outlined,
            expanded: _billingAddressExpanded,
            onTap: () {
              setState(() {
                _billingAddressExpanded = !_billingAddressExpanded;
              });
            },
            content: Column(
              children: [
                _buildTextField(
                  controller: _billingAddressLine1Controller,
                  label: 'Address Line 1',
                  hint: 'House number, building, street',
                  onChanged: (_) => _syncShippingAddress(),
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _billingAddressLine2Controller,
                  label: 'Address Line 2',
                  hint: 'Apartment, suite, unit (optional)',
                  onChanged: (_) => _syncShippingAddress(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCountry,
                        decoration: _inputDecoration('Country'),
                        items: const [
                          DropdownMenuItem(value: 'IN', child: Text('India')),
                          DropdownMenuItem(
                              value: 'US', child: Text('United States')),
                          DropdownMenuItem(
                              value: 'UK', child: Text('United Kingdom')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value!;
                          });
                          _syncShippingAddress();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _billingStateController,
                        label: 'State',
                        hint: 'State',
                        onChanged: (_) => _syncShippingAddress(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _billingCityController,
                        label: 'City',
                        hint: 'City',
                        onChanged: (_) => _syncShippingAddress(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _billingZipController,
                        label: 'ZIP Code',
                        hint: 'ZIP code',
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _syncShippingAddress(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildAccordionSection(
            title: 'Shipping Address',
            icon: Icons.local_shipping_outlined,
            expanded: _shippingAddressExpanded,
            onTap: () {
              setState(() {
                _shippingAddressExpanded = !_shippingAddressExpanded;
              });
            },
            content: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Checkbox(
                        value: _sameAsBilling,
                        onChanged: (value) {
                          setState(() {
                            _sameAsBilling = value!;
                            if (_sameAsBilling) {
                              _syncShippingAddress();
                            }
                          });
                        },
                        activeColor: AppTheme.primaryDarkBlue,
                      ),
                    ),
                    Text(
                      'Same as Billing Address',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _shippingAddressLine1Controller,
                  label: 'Address Line 1',
                  hint: 'House number, building, street',
                  enabled: !_sameAsBilling,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _shippingAddressLine2Controller,
                  label: 'Address Line 2',
                  hint: 'Apartment, suite, unit (optional)',
                  enabled: !_sameAsBilling,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedShippingCountry,
                        decoration: _inputDecoration('Country'),
                        items: const [
                          DropdownMenuItem(value: 'IN', child: Text('India')),
                          DropdownMenuItem(
                              value: 'US', child: Text('United States')),
                          DropdownMenuItem(
                              value: 'UK', child: Text('United Kingdom')),
                        ],
                        onChanged: _sameAsBilling
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedShippingCountry = value!;
                                });
                              },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _shippingStateController,
                        label: 'State',
                        hint: 'State',
                        enabled: !_sameAsBilling,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _shippingCityController,
                        label: 'City',
                        hint: 'City',
                        enabled: !_sameAsBilling,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _shippingZipController,
                        label: 'ZIP Code',
                        hint: 'ZIP code',
                        keyboardType: TextInputType.number,
                        enabled: !_sameAsBilling,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STEP 3: CREDIT & BANK ====================
  Widget _buildCreditBankStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAccordionSection(
            title: 'Credit Information',
            icon: Icons.credit_card_outlined,
            expanded: _creditInfoExpanded,
            onTap: () {
              setState(() {
                _creditInfoExpanded = !_creditInfoExpanded;
              });
            },
            content: Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _creditPeriodController,
                    label: 'Credit Period (Days)',
                    hint: 'e.g., 30 days',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _creditLimitController,
                    label: 'Credit Limit (₹)',
                    hint: 'Max credit amount',
                    keyboardType: TextInputType.number,
                    prefix: '₹',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildAccordionSection(
            title: 'Bank Accounts',
            icon: Icons.account_balance_outlined,
            expanded: _bankAccountsExpanded,
            onTap: () {
              setState(() {
                _bankAccountsExpanded = !_bankAccountsExpanded;
              });
            },
            content: Column(
              children: [
                ..._bankAccounts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final account = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Account ${index + 1}',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDarkBlue,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _removeBankAccount(account['id']),
                              child: Text(
                                'Remove',
                                style: GoogleFonts.lato(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildBankTextField(
                          controller: null,
                          label: 'Bank Name',
                          hint: 'Enter bank name',
                          initialValue: account['bankName'],
                          onChanged: (value) => _updateBankAccount(
                              account['id'], 'bankName', value),
                        ),
                        const SizedBox(height: 12),
                        _buildBankTextField(
                          controller: null,
                          label: 'Account Holder Name',
                          hint: 'Enter account holder name',
                          initialValue: account['holderName'],
                          onChanged: (value) => _updateBankAccount(
                              account['id'], 'holderName', value),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildBankTextField(
                                controller: null,
                                label: 'Account Number',
                                hint: 'Enter account number',
                                initialValue: account['accountNo'],
                                onChanged: (value) => _updateBankAccount(
                                    account['id'], 'accountNo', value),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildBankTextField(
                                controller: null,
                                label: 'IFSC Code',
                                hint: 'Enter IFSC code',
                                initialValue: account['ifsc'],
                                onChanged: (value) => _updateBankAccount(
                                    account['id'], 'ifsc', value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _addBankAccount,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add,
                            size: 18, color: AppTheme.primaryDarkBlue),
                        const SizedBox(width: 8),
                        Text(
                          'Add Bank Account',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryDarkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== ACCORDION SECTION WIDGET ====================
  Widget _buildAccordionSection({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlueBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Icon(icon, size: 18, color: AppTheme.primaryDarkBlue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.subtitleGray,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: content,
            ),
        ],
      ),
    );
  }

  // ==================== TEXT FIELD WIDGET ====================
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
    bool enabled = true,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: GoogleFonts.lato(fontSize: 14),
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        labelStyle:
            GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
        hintText: hint,
        hintStyle: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400),
        prefixText: prefix != null ? '$prefix ' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primaryDarkBlue),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
    );
  }

  Widget _buildBankTextField({
    TextEditingController? controller,
    required String label,
    required String hint,
    String? initialValue,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.lato(fontSize: 14),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            GoogleFonts.lato(fontSize: 12, color: AppTheme.subtitleGray),
        hintText: hint,
        hintStyle: GoogleFonts.lato(fontSize: 11, color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primaryDarkBlue),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primaryDarkBlue),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    );
  }
}
