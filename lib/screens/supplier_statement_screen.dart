// supplier_statement_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class SupplierStatementScreen extends StatefulWidget {
  const SupplierStatementScreen({super.key});

  @override
  State<SupplierStatementScreen> createState() =>
      _SupplierStatementScreenState();
}

class _SupplierStatementScreenState extends State<SupplierStatementScreen> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  String _selectedSupplier = '';
  String _statementType = 'Both';
  String _statusFilter = 'All';

  bool _showStatement = false;
  bool _showFilters = true;

  final List<String> _suppliers = [
    'Reliance Industries Ltd',
    'Tata Motors Ltd',
    'Infosys Technologies',
    'HDFC Bank Ltd',
    'Wipro Enterprises',
    'Adani Group',
    'Bharat Petroleum',
    'Mahindra & Mahindra',
    'Hindustan Unilever',
  ];

  final List<String> _statementTypes = [
    'Both',
    'Purchases Only',
    'Payments Only'
  ];
  final List<String> _statusOptions = ['All', 'Paid', 'Pending', 'Overdue'];

  List<Map<String, dynamic>> _transactions = [];
  Map<String, dynamic> _supplierInfo = {};
  double _openingBalance = 0.0;
  double _totalPurchases = 0.0;
  double _totalPayments = 0.0;
  double _closingBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fromDateController.text = DateFormat('dd MMM yyyy')
        .format(DateTime.now().subtract(const Duration(days: 30)));
    _toDateController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  void _selectFromDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppTheme.primaryDarkBlue),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      setState(() {
        _fromDateController.text = DateFormat('dd MMM yyyy').format(date);
      });
    }
  }

  void _selectToDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppTheme.primaryDarkBlue),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      setState(() {
        _toDateController.text = DateFormat('dd MMM yyyy').format(date);
      });
    }
  }

  void _generateStatement() {
    if (_selectedSupplier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a supplier'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _generateSampleData();
      _showStatement = true;
      _showFilters = false;
    });
  }

  void _generateSampleData() {
    _supplierInfo = {
      'name': _selectedSupplier,
      'code': 'SUP-00${_suppliers.indexOf(_selectedSupplier) + 1}',
      'gst': '27AAACR1234E1Z5',
      'email':
          'accounts@${_selectedSupplier.toLowerCase().replaceAll(' ', '')}.com',
      'phone': '+91 98765 43210',
      'address': 'Corporate Office, Mumbai',
      'pan': 'AAACR1234E',
    };

    _openingBalance = 50000.0;

    _transactions = [
      {
        'date': DateTime(2024, 4, 1),
        'billNo': 'PO-001',
        'type': 'Purchase',
        'description': 'Raw Materials Purchase',
        'debit': 25000.0,
        'credit': 0.0,
        'status': 'Paid'
      },
      {
        'date': DateTime(2024, 4, 5),
        'billNo': 'PO-002',
        'type': 'Purchase',
        'description': 'Office Supplies',
        'debit': 15000.0,
        'credit': 0.0,
        'status': 'Paid'
      },
      {
        'date': DateTime(2024, 4, 10),
        'billNo': 'PMT-001',
        'type': 'Payment',
        'description': 'Payment against PO-001',
        'debit': 0.0,
        'credit': 20000.0,
        'status': 'Completed'
      },
      {
        'date': DateTime(2024, 4, 15),
        'billNo': 'PO-003',
        'type': 'Purchase',
        'description': 'Equipment Purchase',
        'debit': 45000.0,
        'credit': 0.0,
        'status': 'Pending'
      },
      {
        'date': DateTime(2024, 4, 20),
        'billNo': 'PMT-002',
        'type': 'Payment',
        'description': 'Partial Payment PO-003',
        'debit': 0.0,
        'credit': 20000.0,
        'status': 'Completed'
      },
      {
        'date': DateTime(2024, 4, 25),
        'billNo': 'PO-004',
        'type': 'Purchase',
        'description': 'Inventory Stock',
        'debit': 35000.0,
        'credit': 0.0,
        'status': 'Overdue'
      },
      {
        'date': DateTime(2024, 5, 1),
        'billNo': 'PO-005',
        'type': 'Purchase',
        'description': 'Raw Materials',
        'debit': 28000.0,
        'credit': 0.0,
        'status': 'Pending'
      },
      {
        'date': DateTime(2024, 5, 5),
        'billNo': 'PMT-003',
        'type': 'Payment',
        'description': 'Full Payment PO-002',
        'debit': 0.0,
        'credit': 15000.0,
        'status': 'Completed'
      },
    ];

    if (_statementType == 'Purchases Only') {
      _transactions =
          _transactions.where((t) => t['type'] == 'Purchase').toList();
    } else if (_statementType == 'Payments Only') {
      _transactions =
          _transactions.where((t) => t['type'] == 'Payment').toList();
    }

    if (_statusFilter != 'All') {
      _transactions =
          _transactions.where((t) => t['status'] == _statusFilter).toList();
    }

    _transactions.sort((a, b) => a['date'].compareTo(b['date']));

    _totalPurchases =
        _transactions.fold(0.0, (sum, t) => sum + (t['debit'] as double));
    _totalPayments =
        _transactions.fold(0.0, (sum, t) => sum + (t['credit'] as double));
    _closingBalance = _openingBalance + _totalPurchases - _totalPayments;
  }

  void _backToFilters() {
    setState(() {
      _showStatement = false;
      _showFilters = true;
    });
  }

  void _exportPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preparing PDF statement...'),
        backgroundColor: AppTheme.primaryDarkBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preparing Excel statement...'),
        backgroundColor: AppTheme.primaryDarkBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _emailStatement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Email Statement',
            style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Recipient Email',
                hintText: 'Enter email address',
                prefixIcon: const Icon(Icons.email),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Subject',
                hintText: 'Supplier Statement',
                prefixIcon: const Icon(Icons.subject),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text('Cancel', style: TextStyle(color: AppTheme.subtitleGray)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Statement sent via email successfully!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryDarkBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Send'),
          ),
        ],
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
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.primaryDarkBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Supplier Statement',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue),
        ),
        actions: [
          if (_showStatement)
            IconButton(
              onPressed: _backToFilters,
              icon: const Icon(Icons.edit, color: AppTheme.primaryDarkBlue),
              tooltip: 'Edit Filters',
            ),
        ],
      ),
      body: _showFilters ? _buildFilterSection() : _buildStatementView(),
    );
  }

  Widget _buildFilterSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryDarkBlue,
                  AppTheme.primaryDarkBlue.withOpacity(0.8)
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.receipt_long, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  'Supplier Statement',
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  'Generate detailed statement for your suppliers',
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
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
                    color: AppTheme.primaryDarkBlue.withOpacity(0.05),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.filter_list,
                            size: 18, color: AppTheme.primaryDarkBlue),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Filter Criteria',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDropdownField(
                        value: _selectedSupplier.isEmpty
                            ? null
                            : _selectedSupplier,
                        label: 'Select Supplier',
                        hint: 'Choose supplier',
                        icon: Icons.business,
                        items: _suppliers,
                        onChanged: (value) {
                          setState(() {
                            _selectedSupplier = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      _buildDropdownField(
                        value: _statementType,
                        label: 'Statement Type',
                        hint: 'Select type',
                        icon: Icons.receipt,
                        items: _statementTypes,
                        onChanged: (value) {
                          setState(() {
                            _statementType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                              controller: _fromDateController,
                              label: 'From Date',
                              onTap: _selectFromDate,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDateField(
                              controller: _toDateController,
                              label: 'To Date',
                              onTap: _selectToDate,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildDropdownField(
                        value: _statusFilter,
                        label: 'Status Filter',
                        hint: 'Filter by status',
                        icon: Icons.flag,
                        items: _statusOptions,
                        onChanged: (value) {
                          setState(() {
                            _statusFilter = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _generateStatement,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryDarkBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.file_download,
                                  size: 18, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Generate Statement',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatementView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Company Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryDarkBlue,
                  AppTheme.primaryDarkBlue.withOpacity(0.8)
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'SUPPLIER STATEMENT',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Statement Period: ${_fromDateController.text} - ${_toDateController.text}',
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  'Generated on: ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())}',
                  style: GoogleFonts.lato(fontSize: 11, color: Colors.white54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Supplier Information Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.business,
                          size: 18, color: AppTheme.primaryDarkBlue),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Supplier Information',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Supplier Name:', _supplierInfo['name'] ?? ''),
                const SizedBox(height: 10),
                _buildInfoRow('Supplier Code:', _supplierInfo['code'] ?? ''),
                const SizedBox(height: 10),
                _buildInfoRow('GST Number:', _supplierInfo['gst'] ?? ''),
                const SizedBox(height: 10),
                _buildInfoRow('PAN Number:', _supplierInfo['pan'] ?? ''),
                const SizedBox(height: 10),
                _buildInfoRow('Email:', _supplierInfo['email'] ?? ''),
                const SizedBox(height: 10),
                _buildInfoRow('Phone:', _supplierInfo['phone'] ?? ''),
                const SizedBox(height: 10),
                _buildInfoRow('Address:', _supplierInfo['address'] ?? ''),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Statement Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Opening Balance',
                  _openingBalance,
                  Icons.account_balance_wallet,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Total Purchases',
                  _totalPurchases,
                  Icons.shopping_cart,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Payments',
                  _totalPayments,
                  Icons.payment,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Closing Balance',
                  _closingBalance,
                  Icons.trending_up,
                  AppTheme.primaryDarkBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Transaction Details - Mobile Card Design
          Container(
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
                    color: AppTheme.primaryDarkBlue.withOpacity(0.05),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.receipt,
                            size: 18, color: AppTheme.primaryDarkBlue),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Transaction Details',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                // Opening Balance Card
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance,
                              size: 20, color: Colors.blue.shade700),
                          const SizedBox(width: 10),
                          Text(
                            'Opening Balance',
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        NumberFormat.currency(symbol: '₹', decimalDigits: 0)
                            .format(_openingBalance),
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Transaction Cards
                ..._transactions.asMap().entries.map((entry) {
                  int index = entry.key;
                  var transaction = entry.value;
                  double runningBalance = _openingBalance;
                  for (int i = 0; i <= index; i++) {
                    runningBalance += (_transactions[i]['debit'] as double) -
                        (_transactions[i]['credit'] as double);
                  }

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header Row - Date and Bill No
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 14, color: AppTheme.subtitleGray),
                                const SizedBox(width: 6),
                                Text(
                                  DateFormat('dd MMM yyyy')
                                      .format(transaction['date']),
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                transaction['billNo'],
                                style: GoogleFonts.lato(
                                    fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Description
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.description,
                                  size: 16, color: AppTheme.subtitleGray),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  transaction['description'],
                                  style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Type and Status Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: transaction['type'] == 'Purchase'
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    transaction['type'] == 'Purchase'
                                        ? Icons.shopping_cart
                                        : Icons.payment,
                                    size: 12,
                                    color: transaction['type'] == 'Purchase'
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    transaction['type'],
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: transaction['type'] == 'Purchase'
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(transaction['status'])
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                transaction['status'],
                                style: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(transaction['status']),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Debit and Credit Row
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.orange.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DEBIT',
                                      style: GoogleFonts.lato(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (transaction['debit'] as double) > 0
                                          ? NumberFormat.currency(
                                                  symbol: '₹', decimalDigits: 0)
                                              .format(transaction['debit'])
                                          : '₹ 0',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.green.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CREDIT',
                                      style: GoogleFonts.lato(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (transaction['credit'] as double) > 0
                                          ? NumberFormat.currency(
                                                  symbol: '₹', decimalDigits: 0)
                                              .format(transaction['credit'])
                                          : '₹ 0',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Running Balance
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.account_balance_wallet,
                                      size: 14, color: Colors.blue.shade700),
                                  const SizedBox(width: 6),
                                  Text(
                                    'RUNNING BALANCE',
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                NumberFormat.currency(
                                        symbol: '₹', decimalDigits: 0)
                                    .format(runningBalance),
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: runningBalance >= 0
                                      ? Colors.blue.shade700
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                // Footer Total Card
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlueBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppTheme.primaryDarkBlue.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Purchases',
                            style: GoogleFonts.lato(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            NumberFormat.currency(symbol: '₹', decimalDigits: 0)
                                .format(_totalPurchases),
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Payments',
                            style: GoogleFonts.lato(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            NumberFormat.currency(symbol: '₹', decimalDigits: 0)
                                .format(_totalPayments),
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Closing Balance',
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(symbol: '₹', decimalDigits: 0)
                                .format(_closingBalance),
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue,
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

          const SizedBox(height: 16),

          // Export Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportPDF,
                    icon: const Icon(Icons.picture_as_pdf,
                        size: 18, color: Colors.red),
                    label: Text('PDF',
                        style:
                            GoogleFonts.lato(fontSize: 13, color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportExcel,
                    icon: const Icon(Icons.table_chart,
                        size: 18, color: Colors.green),
                    label: Text('Excel',
                        style: GoogleFonts.lato(
                            fontSize: 13, color: Colors.green)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _emailStatement,
                    icon: const Icon(Icons.email, size: 18),
                    label: Text('Email', style: GoogleFonts.lato(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDarkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: GoogleFonts.lato(fontSize: 11, color: AppTheme.subtitleGray),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, double amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.lato(
                    fontSize: 10, color: AppTheme.subtitleGray),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(amount),
            style: GoogleFonts.lato(
                fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Overdue':
        return Colors.red;
      case 'Completed':
        return Colors.green;
      default:
        return AppTheme.subtitleGray;
    }
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.subtitleGray),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(hint,
                    style: GoogleFonts.lato(
                        fontSize: 13, color: Colors.grey.shade400)),
              ),
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              style: GoogleFonts.lato(fontSize: 13, color: Colors.black87),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, size: 16, color: AppTheme.subtitleGray),
                      const SizedBox(width: 8),
                      Text(item, style: GoogleFonts.lato(fontSize: 13)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 20, color: AppTheme.subtitleGray),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.subtitleGray),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: AppTheme.subtitleGray),
                const SizedBox(width: 10),
                Text(
                  controller.text,
                  style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
