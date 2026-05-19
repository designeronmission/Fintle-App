import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  
  // Flow state
  int _currentSection = 0;
  
  // Company Details
  String userBusiness = "Business";
  String userEmail = "business@example.com";
  
  // Customer
  TextEditingController _customerSearchController = TextEditingController();
  String? _selectedCustomer;
  bool _showNewCustomerForm = false;
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _customerEmailController = TextEditingController();
  TextEditingController _customerPhoneController = TextEditingController();
  TextEditingController _customerAddressController = TextEditingController();
  TextEditingController _customerGstController = TextEditingController();
  
  // Invoice Details
  DateTime? _issueDate;
  DateTime? _dueDate;
  String _selectedCurrency = 'INR';
  TextEditingController _invoiceNumberController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  
  // Items
  List<InvoiceItem> _items = [];
  String? _selectedExistingItem;
  bool _showNewItemForm = false;
  int _editingItemIndex = -1;
  
  // Item Form Controllers
  TextEditingController _itemDescController = TextEditingController();
  TextEditingController _itemCodeController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _itemQtyController = TextEditingController();
  String _selectedItemUnit = 'PCS';
  double _itemTaxPercentage = 0.0;
  String _itemCurrency = 'INR';
  
  final List<String> _unitOptions = ['PCS', 'Hour', 'Day', 'Month', 'Year', 'KG', 'Ltr', 'Box', 'Set', 'Service'];
  
  final List<Map<String, String>> _customers = [
    {'name': 'ABC Corporation', 'email': 'abc@example.com', 'phone': '+91 9876543210', 'gst': 'GST: 29AAACB1234E1Z5'},
    {'name': 'XYZ Enterprises', 'email': 'xyz@example.com', 'phone': '+91 9876543211', 'gst': 'GST: 27BBBCD5678E2Z8'},
    {'name': 'Tech Solutions Ltd', 'email': 'tech@example.com', 'phone': '+91 9876543212', 'gst': 'GST: 24CCCDE9012E3Z1'},
  ];
  
  final List<Map<String, dynamic>> _existingItems = [
    {'name': 'Web Design Service', 'code': 'WEB01', 'price': 2500.0, 'unit': 'Hour', 'tax': 12.0},
    {'name': 'Cloud Hosting', 'code': 'CLD99', 'price': 4800.0, 'unit': 'Year', 'tax': 5.0},
    {'name': 'Mobile App Development', 'code': 'MOB03', 'price': 15000.0, 'unit': 'Project', 'tax': 18.0},
    {'name': 'SEO Package', 'code': 'SEO10', 'price': 8000.0, 'unit': 'Month', 'tax': 18.0},
    {'name': 'Consulting Service', 'code': 'CON05', 'price': 3000.0, 'unit': 'Hour', 'tax': 18.0},
  ];
  
  final List<String> _currencies = ['INR', 'USD', 'EUR', 'GBP', 'AED'];
  final List<double> _taxOptions = [0, 5, 12, 18, 28];
  
  double _shippingCharge = 0.0;
  double _discount = 0.0;
  TextEditingController _shippingController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _notesController = TextEditingController(text: 'Thanks for your business.');

  @override
  void initState() {
    super.initState();
    _loadCompanyDetails();
    _invoiceNumberController.text = 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    _itemQtyController.text = '1';
    _issueDate = DateTime.now();
    _dueDate = DateTime.now().add(const Duration(days: 7));
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _customerSearchController.dispose();
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _customerPhoneController.dispose();
    _customerAddressController.dispose();
    _customerGstController.dispose();
    _invoiceNumberController.dispose();
    _referenceController.dispose();
    _itemDescController.dispose();
    _itemCodeController.dispose();
    _itemPriceController.dispose();
    _itemQtyController.dispose();
    _shippingController.dispose();
    _discountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadCompanyDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userBusiness = prefs.getString('business_name') ?? 'Business';
      userEmail = prefs.getString('current_user_email') ?? 'business@example.com';
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  double _calculateSubtotal() => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  double _calculateTax() => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity * item.taxPercentage / 100));
  double _calculateTotal() => _calculateSubtotal() + _calculateTax() + _shippingCharge - _discount;

  void _clearItemForm() {
    _itemDescController.clear();
    _itemCodeController.clear();
    _itemPriceController.clear();
    _itemQtyController.text = '1';
    _selectedItemUnit = 'PCS';
    _itemTaxPercentage = 0.0;
    _itemCurrency = _selectedCurrency;
    _editingItemIndex = -1;
  }

  void _editItem(int index) {
    final item = _items[index];
    _itemDescController.text = item.description;
    _itemCodeController.text = item.code;
    _itemPriceController.text = item.price.toString();
    _itemQtyController.text = item.quantity.toString();
    _selectedItemUnit = item.unit;
    _itemTaxPercentage = item.taxPercentage;
    _itemCurrency = item.currency;
    _editingItemIndex = index;
    _showNewItemForm = true;
  }

  void _saveItem() {
    if (_itemDescController.text.isNotEmpty && _itemPriceController.text.isNotEmpty) {
      final newItem = InvoiceItem(
        description: _itemDescController.text,
        code: _itemCodeController.text,
        price: double.tryParse(_itemPriceController.text) ?? 0.0,
        quantity: int.tryParse(_itemQtyController.text) ?? 1,
        unit: _selectedItemUnit,
        taxPercentage: _itemTaxPercentage,
        currency: _itemCurrency,
      );
      
      setState(() {
        if (_editingItemIndex >= 0) {
          _items[_editingItemIndex] = newItem;
        } else {
          _items.add(newItem);
        }
        _clearItemForm();
        _showNewItemForm = false;
      });
    }
  }

  void _showSnack(String message, {Color color = AppTheme.primaryDarkBlue}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.lato(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create Invoice', 
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primaryDarkBlue)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildCustomerSection(),
                  if (_currentSection >= 1) ...[
                    const SizedBox(height: 12),
                    _buildInvoiceDetailsSection(),
                  ],
                  if (_currentSection >= 2) ...[
                    const SizedBox(height: 12),
                    _buildItemsSection(),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
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
            if (_currentSection > 0 && _currentSection < 2)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentSection--),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Back', 
                    style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray)),
                ),
              ),
            if (_currentSection > 0 && _currentSection < 2) const SizedBox(width: 12),
            
            if (_currentSection == 0)
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedCustomer != null || (_showNewCustomerForm && _customerNameController.text.isNotEmpty)) {
                      setState(() => _currentSection = 1);
                      _scrollToBottom();
                    } else {
                      _showSnack('Please select or create a customer');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDarkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue', 
                        style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                    ],
                  ),
                ),
              ),
            
            if (_currentSection == 1)
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _currentSection = 2);
                    _scrollToBottom();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDarkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Add Items', 
                        style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(width: 8),
                      const Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
                    ],
                  ),
                ),
              ),
            
            if (_currentSection == 2) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (_items.isEmpty) {
                      _showSnack('Please add at least one item to preview');
                    } else {
                      _showInvoicePreview();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppTheme.primaryDarkBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility_outlined, size: 18, color: AppTheme.primaryDarkBlue),
                      const SizedBox(width: 6),
                      Text('Preview', 
                        style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryDarkBlue)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    if (_items.isEmpty) {
                      _showSnack('Please add at least one item before saving');
                    } else {
                      _showSnack('Invoice saved successfully!', color: const Color(0xFF10B981));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDarkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, size: 18, color: Colors.white),
                      const SizedBox(width: 6),
                      Text('Save & Continue', 
                        style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection() {
    final bool isCompleted = _currentSection > 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted ? AppTheme.lightBlueBg : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [   
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDarkBlue.withOpacity(0.1), 
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.person, color: AppTheme.primaryDarkBlue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('BILL TO', 
                        style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray, letterSpacing: 0.5)),
                      if (isCompleted)
                        Text(_selectedCustomer ?? _customerNameController.text, 
                          style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                if (isCompleted) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Selected', 
                      style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() {
                      _currentSection = 0;
                      _selectedCustomer = null;
                    }),
                    child: Icon(Icons.edit, size: 18, color: AppTheme.subtitleGray),
                  ),
                ],
              ],
            ),
          ),
          if (!isCompleted) ...[
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _customerSearchController,
                    onChanged: (_) => setState(() {}),
                    decoration: _inputDeco('Search existing customers...', Icons.search),
                  ),
                  const SizedBox(height: 12),
                  ..._customers.map((c) {
                    if (_customerSearchController.text.isNotEmpty && !c['name']!.toLowerCase().contains(_customerSearchController.text.toLowerCase())) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => setState(() {
                          _selectedCustomer = c['name'];
                          _customerNameController.text = c['name']!;
                          _customerEmailController.text = c['email']!;
                          _customerPhoneController.text = c['phone']!;
                          _customerGstController.text = c['gst']!;
                          _showNewCustomerForm = false;
                        }),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _selectedCustomer == c['name'] ? AppTheme.primaryDarkBlue.withOpacity(0.05) : const Color(0xFFF8F9FC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedCustomer == c['name'] ? AppTheme.primaryDarkBlue : Colors.grey.shade200, 
                              width: _selectedCustomer == c['name'] ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryDarkBlue.withOpacity(0.1), 
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.business, color: AppTheme.primaryDarkBlue, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c['name']!, 
                                      style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                                    Text('${c['email']} • ${c['phone']}', 
                                      style: GoogleFonts.lato(fontSize: 12, color: AppTheme.subtitleGray),
                                      overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              if (_selectedCustomer == c['name']) 
                                Icon(Icons.check_circle, color: AppTheme.primaryDarkBlue, size: 22),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR', 
                            style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF94A3B8))),
                        ),
                        const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      _showNewCustomerForm = !_showNewCustomerForm;
                      _selectedCustomer = null;
                    }),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: _showNewCustomerForm ? AppTheme.primaryDarkBlue : Colors.grey.shade200, width: _showNewCustomerForm ? 1.5 : 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_showNewCustomerForm ? Icons.close : Icons.person_add, 
                            size: 18, color: _showNewCustomerForm ? AppTheme.primaryDarkBlue : AppTheme.subtitleGray),
                          const SizedBox(width: 8),
                          Text(_showNewCustomerForm ? 'Cancel' : 'Create New Customer', 
                            style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, 
                            color: _showNewCustomerForm ? AppTheme.primaryDarkBlue : AppTheme.subtitleGray)),
                        ],
                      ),
                    ),
                  ),
                  if (_showNewCustomerForm) ...[
                    const SizedBox(height: 16),
                    _buildField(controller: _customerNameController, label: 'Customer Name', hint: 'Enter customer name', icon: Icons.person),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildField(controller: _customerEmailController, label: 'Email', hint: 'email@example.com', icon: Icons.email)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildField(controller: _customerPhoneController, label: 'Phone', hint: '+91 9876543210', icon: Icons.phone)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildField(controller: _customerAddressController, label: 'Address', hint: 'Enter address', icon: Icons.location_on),
                    const SizedBox(height: 12),
                    _buildField(controller: _customerGstController, label: 'GST Number', hint: '29AAACB1234E1Z5', icon: Icons.receipt),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInvoiceDetailsSection() {
    final bool isCompleted = _currentSection > 1;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted ? AppTheme.lightBlueBg : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDarkBlue.withOpacity(0.1), 
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.receipt_long, color: AppTheme.primaryDarkBlue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('INVOICE DETAILS', 
                        style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray, letterSpacing: 0.5)),
                      if (isCompleted)
                        Text('#${_invoiceNumberController.text}', 
                          style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
                    ],
                  ),
                ),
                if (isCompleted) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Done', 
                      style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() => _currentSection = 1),
                    child: Icon(Icons.edit, size: 18, color: AppTheme.subtitleGray),
                  ),
                ],
              ],
            ),
          ),
          if (!isCompleted) ...[
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildField(controller: _invoiceNumberController, label: 'INVOICE #', hint: 'INV-001', icon: Icons.tag)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildField(controller: _referenceController, label: 'REFERENCE', hint: 'PO Number', icon: Icons.link)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildDatePicker(label: 'ISSUE DATE', selectedDate: _issueDate, onSelected: (d) => setState(() {
                        _issueDate = d;
                        if (_dueDate == null || d.isAfter(_dueDate!)) _dueDate = d.add(const Duration(days: 7));
                      }))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildDatePicker(label: 'DUE DATE', selectedDate: _dueDate, onSelected: (d) => setState(() => _dueDate = d))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(label: 'CURRENCY', value: _selectedCurrency, items: _currencies, onChanged: (v) => setState(() => _selectedCurrency = v!)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDarkBlue.withOpacity(0.1), 
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.shopping_cart, color: AppTheme.primaryDarkBlue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('LINE ITEMS', 
                        style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray, letterSpacing: 0.5)),
                      Text('${_items.length} item(s) added', 
                        style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                    ],
                  ),
                ),
                if (!_showNewItemForm)
                  ElevatedButton.icon(
                    onPressed: () {
                      _clearItemForm();
                      setState(() => _showNewItemForm = true);
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Add Item', style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDarkBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (!_showNewItemForm && _existingItems.isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    value: _selectedExistingItem,
                    isExpanded: true,
                    hint: Text('Select from existing items...', 
                      style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF94A3B8))),
                    icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryDarkBlue, size: 24),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.primaryDarkBlue, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FC),
                    ),
                    items: _existingItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['name'],
                        child: Text(
                          '${item['name']} (${item['code']}) - ${_selectedCurrency} ${item['price']} / ${item['unit']}',
                          style: GoogleFonts.lato(fontSize: 13, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final selected = _existingItems.firstWhere((item) => item['name'] == value);
                        setState(() {
                          _items.add(InvoiceItem(
                            description: selected['name'],
                            code: selected['code'],
                            price: selected['price'].toDouble(),
                            quantity: 1,
                            unit: selected['unit'],
                            taxPercentage: selected['tax'].toDouble(),
                            currency: _selectedCurrency,
                          ));
                          _selectedExistingItem = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text('— or create a new item —',
                      style: GoogleFonts.lato(fontSize: 12, color: const Color(0xFF94A3B8))),
                  ),
                ],
                
                if (_showNewItemForm) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.lightBlueBg,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              Icon(_editingItemIndex >= 0 ? Icons.edit : Icons.add_circle_outline, 
                                color: AppTheme.primaryDarkBlue, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(_editingItemIndex >= 0 ? 'Edit Item' : 'Create New Item',
                                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
                              ),
                              IconButton(
                                onPressed: () => setState(() {
                                  _showNewItemForm = false;
                                  _clearItemForm();
                                }),
                                icon: Icon(Icons.close, size: 20, color: Colors.grey.shade600),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildField(controller: _itemDescController, label: 'Item Description', hint: 'Enter item name', icon: Icons.description),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _buildField(controller: _itemCodeController, label: 'Code', hint: 'SKU-001', icon: Icons.qr_code)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildUnitDropdown()),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _buildCurrencyDropdownForItem()),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildField(controller: _itemPriceController, label: 'Price', hint: '0.00', icon: Icons.currency_rupee, keyboardType: TextInputType.number)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _buildField(controller: _itemQtyController, label: 'Quantity', hint: '1', icon: Icons.numbers, keyboardType: TextInputType.number)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildDropdown(label: 'Tax (%)', value: _itemTaxPercentage, items: _taxOptions, onChanged: (v) => setState(() => _itemTaxPercentage = v!), displayFn: (v) => '$v%')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _showNewItemForm = false;
                                          _clearItemForm();
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        side: BorderSide(color: Colors.grey.shade300),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: Text('Cancel', 
                                        style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: _saveItem,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryDarkBlue,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        elevation: 0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(_editingItemIndex >= 0 ? Icons.save : Icons.add, size: 18, color: Colors.white),
                                          const SizedBox(width: 8),
                                          Text(_editingItemIndex >= 0 ? 'Update Item' : 'Add Item',
                                            style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                if (_items.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlueBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text('Added Items', 
                          style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
                        const Spacer(),
                        Text('${_items.length} item(s)', 
                          style: GoogleFonts.lato(fontSize: 12, color: AppTheme.subtitleGray)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return _buildItemTile(index, _items[index]);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTotalsSummary(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(int index, InvoiceItem item) {
    final total = item.price * item.quantity * (1 + item.taxPercentage / 100);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryDarkBlue.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text('${index + 1}', 
              style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primaryDarkBlue))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description, 
                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text('${item.quantity} × ${item.unit}', 
                      style: GoogleFonts.lato(fontSize: 12, color: AppTheme.subtitleGray)),
                    Text('${item.currency} ${item.price.toStringAsFixed(2)}', 
                      style: GoogleFonts.lato(fontSize: 12, color: AppTheme.subtitleGray)),
                    if (item.taxPercentage > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDarkBlue.withOpacity(0.1), 
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('${item.taxPercentage}%', 
                          style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primaryDarkBlue)),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${item.currency} ${total.toStringAsFixed(2)}',
                style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => _editItem(index),
                    child: Icon(Icons.edit, size: 16, color: AppTheme.subtitleGray),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => setState(() => _items.removeAt(index)),
                    child: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFEF4444)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsSummary() {
    final subtotal = _calculateSubtotal();
    final tax = _calculateTax();
    final total = _calculateTotal();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildTotalRow('Subtotal', subtotal),
          const SizedBox(height: 8),
          _buildTotalRow('Tax', tax),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text('Shipping', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _shippingController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: GoogleFonts.lato(color: const Color(0xFF94A3B8)),
                    prefixText: '$_selectedCurrency ',
                    prefixStyle: GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (v) => setState(() => _shippingCharge = double.tryParse(v) ?? 0.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text('Discount', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: GoogleFonts.lato(color: const Color(0xFF94A3B8)),
                    prefixText: '$_selectedCurrency ',
                    prefixStyle: GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (v) => setState(() => _discount = double.tryParse(v) ?? 0.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildTotalRow('Total', total, isTotal: true),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            maxLines: 2,
            style: GoogleFonts.lato(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Terms or notes...',
              hintStyle: GoogleFonts.lato(color: const Color(0xFF94A3B8)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
              contentPadding: const EdgeInsets.all(12),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? Colors.black87 : AppTheme.subtitleGray,
          ),
        ),
        Text(
          '$_selectedCurrency ${amount.toStringAsFixed(2)}',
          style: GoogleFonts.lato(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppTheme.primaryDarkBlue : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildUnitDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('UNIT', style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: _selectedItemUnit,
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                prefixIcon: Icon(Icons.straighten, size: 18, color: Color(0xFF94A3B8)),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 20),
              items: _unitOptions.map((unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit, style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedItemUnit = value!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdownForItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('CURRENCY', style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: _itemCurrency,
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                prefixIcon: Icon(Icons.attach_money, size: 18, color: Color(0xFF94A3B8)),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 20),
              items: _currencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency, style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                );
              }).toList(),
              onChanged: (value) => setState(() => _itemCurrency = value!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.lato(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.lato(fontSize: 14, color: const Color(0xFF94A3B8)),
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryDarkBlue, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({required String label, required DateTime? selectedDate, required Function(DateTime) onSelected}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(primary: AppTheme.primaryDarkBlue),
                ),
                child: child!,
              ),
            );
            if (date != null) onSelected(date);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Color(0xFF94A3B8)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedDate != null ? DateFormat('dd MMM yyyy').format(selectedDate) : 'Select date',
                    style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, 
                      color: selectedDate != null ? Colors.black87 : const Color(0xFF94A3B8)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF94A3B8), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label, 
    required T value, 
    required List<T> items, 
    required Function(T?) onChanged, 
    String Function(T)? displayFn
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.subtitleGray, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<T>(
              value: value,
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 20),
              items: items.map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  displayFn != null ? displayFn(item) : item.toString(), 
                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)
                ),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.lato(fontSize: 14, color: const Color(0xFF94A3B8)),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryDarkBlue, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: const Color(0xFFF8F9FC),
    );
  }

  void _showInvoicePreview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          final subtotal = _calculateSubtotal();
          final tax = _calculateTax();
          final total = _calculateTotal();
          final customerName = _selectedCustomer ?? _customerNameController.text;
          final customerAddress = _customerAddressController.text;
          final customerGst = _customerGstController.text;
          final paidAmount = 0.0;
          final balanceDue = total - paidAmount;
          
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'INVOICE PREVIEW',
                        style: GoogleFonts.lato(
                          fontSize: 16, 
                          fontWeight: FontWeight.w700, 
                          color: AppTheme.primaryDarkBlue
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, size: 20, color: AppTheme.subtitleGray),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header - Company Details Left Aligned
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'INVOICE',
                              style: GoogleFonts.lato(
                                fontSize: 24, 
                                fontWeight: FontWeight.w800, 
                                color: AppTheme.primaryDarkBlue, 
                                letterSpacing: 1
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 50,
                              height: 3,
                              color: AppTheme.primaryDarkBlue,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              userBusiness,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '123 Business Street, City - 400001',
                              style: GoogleFonts.lato(
                                fontSize: 11,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                            Text(
                              'GST: 29AAACB1234E1Z5',
                              style: GoogleFonts.lato(
                                fontSize: 11,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                            Text(
                              'Email: $userEmail',
                              style: GoogleFonts.lato(
                                fontSize: 11,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Invoice Number and Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Invoice Number',
                                  style: GoogleFonts.lato(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.subtitleGray,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _invoiceNumberController.text,
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryDarkBlue,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Unpaid',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFF59E0B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Customer and Invoice Details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BILL TO',
                                    style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.subtitleGray,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    customerName,
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (customerAddress.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      customerAddress,
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: AppTheme.subtitleGray,
                                      ),
                                    ),
                                  ],
                                  if (customerGst.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      customerGst,
                                      style: GoogleFonts.lato(
                                        fontSize: 11,
                                        color: AppTheme.primaryDarkBlue,
                                      ),
                                    ),
                                  ],
                                  if (_customerEmailController.text.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      _customerEmailController.text,
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: AppTheme.subtitleGray,
                                      ),
                                    ),
                                  ],
                                  if (_customerPhoneController.text.isNotEmpty) ...[
                                    Text(
                                      _customerPhoneController.text,
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: AppTheme.subtitleGray,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'INVOICE DETAILS',
                                    style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.subtitleGray,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildPreviewDetailRow('ISSUE DATE', _issueDate != null ? DateFormat('dd MMM yyyy').format(_issueDate!) : '--'),
                                  const SizedBox(height: 6),
                                  _buildPreviewDetailRow('DUE DATE', _dueDate != null ? DateFormat('dd MMM yyyy').format(_dueDate!) : '--'),
                                  const SizedBox(height: 6),
                                  _buildPreviewDetailRow('CURRENCY', _selectedCurrency),
                                  if (_referenceController.text.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    _buildPreviewDetailRow('REFERENCE', _referenceController.text),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Items Table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightBlueBg,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'DESCRIPTION',
                                        style: GoogleFonts.lato(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryDarkBlue,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'QTY',
                                        style: GoogleFonts.lato(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryDarkBlue,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'PRICE',
                                        style: GoogleFonts.lato(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryDarkBlue,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'AMOUNT',
                                        style: GoogleFonts.lato(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryDarkBlue,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ..._items.map((item) {
                                final amount = item.price * item.quantity;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.description,
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (item.taxPercentage > 0)
                                              Text(
                                                'Tax: ${item.taxPercentage}%',
                                                style: GoogleFonts.lato(
                                                  fontSize: 10,
                                                  color: const Color(0xFF94A3B8),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${item.quantity}',
                                          style: GoogleFonts.lato(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${item.currency} ${NumberFormat('#,##0.00').format(item.price)}',
                                          style: GoogleFonts.lato(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${item.currency} ${NumberFormat('#,##0.00').format(amount)}',
                                          style: GoogleFonts.lato(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Totals Section
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 280,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _buildPreviewSummaryRow('Subtotal', subtotal),
                                const SizedBox(height: 8),
                                _buildPreviewSummaryRow('Shipping', _shippingCharge),
                                const SizedBox(height: 8),
                                _buildPreviewSummaryRow('Tax', tax),
                                const Divider(height: 24),
                                _buildPreviewSummaryRow('Total', total, isTotal: true),
                                const SizedBox(height: 8),
                                _buildPreviewSummaryRow('Paid', paidAmount),
                                const Divider(height: 24),
                                _buildPreviewSummaryRow('BALANCE DUE', balanceDue, isBalance: true),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Notes Section
                        if (_notesController.text.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TERMS & NOTES',
                                  style: GoogleFonts.lato(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.subtitleGray,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _notesController.text,
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: AppTheme.subtitleGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 24),
                        
                        Center(
                          child: Text(
                            'Thank you for your business!',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: const Color(0xFF94A3B8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Equal Size Buttons at Bottom
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSnack('Invoice saved successfully!', color: const Color(0xFF10B981));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryDarkBlue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Save Invoice',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
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
        },
      ),
    );
  }

  Widget _buildPreviewDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSummaryRow(String label, double amount, {bool isTotal = false, bool isBalance = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: isBalance ? 12 : (isTotal ? 12 : 11),
            fontWeight: isBalance ? FontWeight.w800 : (isTotal ? FontWeight.w700 : FontWeight.w500),
            color: isBalance ? AppTheme.primaryDarkBlue : (isTotal ? Colors.black87 : AppTheme.subtitleGray),
          ),
        ),
        Flexible(
          child: Text(
            '$_selectedCurrency ${NumberFormat('#,##0.00').format(amount)}',
            style: GoogleFonts.lato(
              fontSize: isBalance ? 14 : (isTotal ? 14 : 12),
              fontWeight: isBalance ? FontWeight.bold : (isTotal ? FontWeight.bold : FontWeight.w600),
              color: isBalance ? AppTheme.primaryDarkBlue : (isTotal ? Colors.black87 : AppTheme.subtitleGray),
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class InvoiceItem {
  String description;
  String code;
  double price;
  int quantity;
  String unit;
  double taxPercentage;
  String currency;

  InvoiceItem({
    required this.description,
    required this.code,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.taxPercentage,
    required this.currency,
  });
}