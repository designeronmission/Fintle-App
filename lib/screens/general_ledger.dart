// general_ledger.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class GeneralLedgerScreen extends StatefulWidget {
  const GeneralLedgerScreen({super.key});

  @override
  State<GeneralLedgerScreen> createState() => _GeneralLedgerScreenState();
}

class _GeneralLedgerScreenState extends State<GeneralLedgerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customerSearchController =
      TextEditingController();

  final TextEditingController _financialYearController =
      TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  // Scroll controller for auto-scrolling to report
  final ScrollController _scrollController = ScrollController();

  String _selectedAccountHead = 'All';
  String _selectedAccount = 'All';
  String _selectedCustomer = 'Suriya';
  String _searchQuery = '';
  String _customerSearchQuery = '';
  bool _showReport = false;

  // Toggle for Customer Ledger vs Normal Ledger
  bool _isCustomerLedger = true;

  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 365));
  DateTime _toDate = DateTime.now();
  String _selectedFinancialYear = '2024-25';

  List<LedgerEntry> _ledgerEntries = [];
  List<LedgerEntry> _filteredEntries = [];
  LedgerSummary? _ledgerSummary;

  // Customer List
  final List<String> _customers = [
    'Suriya',
    'ABC Corporation',
    'XYZ Ltd',
    'PQR Enterprises',
    'LMN Industries',
    'DEF Solutions',
    'GHI Traders',
    'MNO Group',
    'RST Ventures',
    'UVW Associates',
  ];

  List<String> get _filteredCustomers {
    if (_customerSearchQuery.isEmpty) {
      return _customers;
    }
    return _customers
        .where((customer) =>
            customer.toLowerCase().contains(_customerSearchQuery.toLowerCase()))
        .toList();
  }

  final List<String> _financialYears = [
    '2024-25',
    '2023-24',
    '2022-23',
    '2021-22',
    '2020-21',
  ];

  final List<String> _accountHeads = [
    'All',
    'Assets',
    'Liabilities',
    'Equity',
    'Income',
    'Expenses',
  ];

  final Map<String, List<String>> _accounts = {
    'All': [
      'Cash in Hand',
      'Bank Account - HDFC',
      'Bank Account - ICICI',
      'Accounts Receivable',
      'Inventory',
      'Office Equipment',
      'Accounts Payable',
      'Share Capital',
      'Sales Revenue',
      'Rent Expense',
      'Salary Expense',
    ],
    'Assets': [
      'Cash in Hand',
      'Bank Account - HDFC',
      'Bank Account - ICICI',
      'Accounts Receivable',
      'Inventory',
      'Office Equipment',
      'Furniture & Fixtures',
      'Vehicles',
      'Investments',
    ],
    'Liabilities': [
      'Accounts Payable',
      'Short-term Loans',
      'Tax Payable',
      'Bank Loan',
    ],
    'Equity': [
      'Share Capital',
      'Retained Earnings',
    ],
    'Income': [
      'Sales Revenue',
      'Service Income',
      'Interest Income',
      'Dividend Income',
    ],
    'Expenses': [
      'Rent Expense',
      'Salary Expense',
      'Utility Expense',
      'Office Supplies',
      'Legal Fees',
      'Insurance Expense',
    ],
  };

  @override
  void initState() {
    super.initState();
    _financialYearController.text = _selectedFinancialYear;
    _fromDateController.text = DateFormat('dd MMM yyyy').format(_fromDate);
    _toDateController.text = DateFormat('dd MMM yyyy').format(_toDate);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _financialYearController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _customerSearchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterEntries();
    });
  }

  void _filterEntries() {
    if (_searchQuery.isEmpty) {
      _filteredEntries = List.from(_ledgerEntries);
    } else {
      _filteredEntries = _ledgerEntries.where((entry) {
        return entry.description.toLowerCase().contains(_searchQuery) ||
            entry.voucherNo.toLowerCase().contains(_searchQuery) ||
            _formatAmount(entry.debit).contains(_searchQuery) ||
            _formatAmount(entry.credit).contains(_searchQuery);
      }).toList();
    }
    _updateSummary();
  }

  void _updateSummary() {
    if (_filteredEntries.isNotEmpty) {
      double totalDebit = 0;
      double totalCredit = 0;
      double openingBalance = 0;

      for (var entry in _filteredEntries) {
        totalDebit += entry.debit;
        totalCredit += entry.credit;
        if (entry.description == 'Opening Balance') {
          openingBalance = entry.debit - entry.credit;
        }
      }

      double closingBalance = openingBalance + totalDebit - totalCredit;

      _ledgerSummary = LedgerSummary(
        accountName: _isCustomerLedger ? _selectedCustomer : _selectedAccount,
        accountType: _ledgerSummary?.accountType ?? 'Assets',
        openingBalance: openingBalance,
        closingBalance: closingBalance,
        totalDebit: totalDebit,
        totalCredit: totalCredit,
      );
    }
  }

  void _selectFromDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _fromDate,
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
        _fromDate = date;
        _fromDateController.text = DateFormat('dd MMM yyyy').format(_fromDate);
      });
    }
  }

  void _selectToDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _toDate,
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
        _toDate = date;
        _toDateController.text = DateFormat('dd MMM yyyy').format(_toDate);
      });
    }
  }

  void _onFinancialYearChanged(String? year) {
    if (year != null) {
      setState(() {
        _selectedFinancialYear = year;
        _financialYearController.text = year;
        final yearParts = year.split('-');
        final startYear = int.parse(yearParts[0]);
        final endYear = int.parse(yearParts[1]);
        _fromDate = DateTime(startYear, 4, 1);
        _toDate = DateTime(endYear, 3, 31);
        _fromDateController.text = DateFormat('dd MMM yyyy').format(_fromDate);
        _toDateController.text = DateFormat('dd MMM yyyy').format(_toDate);
      });
    }
  }

  void _onAccountHeadChanged(String? head) {
    if (head != null) {
      setState(() {
        _selectedAccountHead = head;
        _selectedAccount = _accounts[head]?.first ?? 'All';
      });
    }
  }

  void _generateReport() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showReport = true;
        _generateLedgerData();
        _filterEntries();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isCustomerLedger
              ? 'Customer Ledger generated for $_selectedCustomer'
              : 'General Ledger generated for $_selectedAccount'),
          backgroundColor: AppTheme.primaryDarkBlue,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      // Auto-scroll to report section after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _generateLedgerData() {
    if (_isCustomerLedger) {
      _ledgerEntries = _getCustomerLedgerEntries(_selectedCustomer);
    } else {
      _ledgerEntries = _getNormalLedgerEntries(_selectedAccount);
    }
    _filteredEntries = List.from(_ledgerEntries);
    _ledgerSummary = _calculateSummary(_ledgerEntries,
        _isCustomerLedger ? _selectedCustomer : _selectedAccount);
  }

  List<LedgerEntry> _getCustomerLedgerEntries(String customerName) {
    List<LedgerEntry> entries = [];

    if (customerName == 'Suriya') {
      entries.add(LedgerEntry(
        date: _fromDate,
        description: 'Opening Balance',
        debit: 800,
        credit: 0,
        voucherNo: 'OP-001',
      ));
    } else if (customerName == 'ABC Corporation') {
      entries.add(LedgerEntry(
        date: _fromDate,
        description: 'Opening Balance',
        debit: 50000,
        credit: 0,
        voucherNo: 'OP-001',
      ));
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 5),
            description: 'Sales Invoice',
            debit: 85000,
            credit: 0,
            voucherNo: 'INV-001'),
        LedgerEntry(
            date: DateTime(2024, 4, 15),
            description: 'Payment Received',
            debit: 0,
            credit: 50000,
            voucherNo: 'REC-001'),
      ]);
    } else if (customerName == 'XYZ Ltd') {
      entries.add(LedgerEntry(
        date: _fromDate,
        description: 'Opening Balance',
        debit: 125000,
        credit: 0,
        voucherNo: 'OP-001',
      ));
    } else {
      entries.add(LedgerEntry(
        date: _fromDate,
        description: 'Opening Balance',
        debit: 10000,
        credit: 0,
        voucherNo: 'OP-001',
      ));
    }

    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  List<LedgerEntry> _getNormalLedgerEntries(String accountName) {
    List<LedgerEntry> entries = [];

    entries.add(LedgerEntry(
      date: _fromDate,
      description: 'Opening Balance',
      debit: 50000,
      credit: 0,
      voucherNo: 'OP-001',
    ));

    if (accountName == 'Cash in Hand') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 5),
            description: 'Sales Revenue',
            debit: 25000,
            credit: 0,
            voucherNo: 'SALE-001'),
        LedgerEntry(
            date: DateTime(2024, 4, 10),
            description: 'Rent Payment',
            debit: 0,
            credit: 15000,
            voucherNo: 'RENT-001'),
      ]);
    } else {
      entries.addAll([
        LedgerEntry(
            date: _fromDate.add(const Duration(days: 15)),
            description: 'Transaction 1',
            debit: 25000,
            credit: 0,
            voucherNo: 'TRX-001'),
        LedgerEntry(
            date: _toDate.subtract(const Duration(days: 10)),
            description: 'Transaction 2',
            debit: 0,
            credit: 15000,
            voucherNo: 'TRX-002'),
      ]);
    }

    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  LedgerSummary _calculateSummary(
      List<LedgerEntry> entries, String accountName) {
    double openingBalance = 0;
    double totalDebit = 0;
    double totalCredit = 0;

    for (var entry in entries) {
      totalDebit += entry.debit;
      totalCredit += entry.credit;
      if (entry.description == 'Opening Balance') {
        openingBalance = entry.debit - entry.credit;
      }
    }

    double closingBalance = openingBalance + totalDebit - totalCredit;

    String accountType = 'Assets';
    if (accountName.contains('Revenue') ||
        accountName.contains('Income') ||
        accountName.contains('Sales')) {
      accountType = 'Income';
    } else if (accountName.contains('Expense')) {
      accountType = 'Expenses';
    } else if (accountName.contains('Payable') ||
        accountName.contains('Loan')) {
      accountType = 'Liabilities';
    } else if (accountName.contains('Capital') ||
        accountName.contains('Earnings')) {
      accountType = 'Equity';
    }

    return LedgerSummary(
      accountName: accountName,
      accountType: accountType,
      openingBalance: openingBalance,
      closingBalance: closingBalance,
      totalDebit: totalDebit,
      totalCredit: totalCredit,
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedAccountHead = 'All';
      _selectedAccount = 'All';
      _selectedCustomer = 'Suriya';
      _searchQuery = '';
      _customerSearchQuery = '';
      _searchController.clear();
      _customerSearchController.clear();
      _showReport = false;
      _isCustomerLedger = true;
      _ledgerEntries = [];
      _filteredEntries = [];
      _ledgerSummary = null;
    });
  }

  String _formatAmount(double amount) {
    return NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(amount);
  }

  void _showCustomerSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Customer',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _customerSearchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search customer...',
                        hintStyle: GoogleFonts.lato(
                            fontSize: 14, color: Colors.grey.shade400),
                        prefixIcon: const Icon(Icons.search,
                            color: AppTheme.subtitleGray),
                        suffixIcon: _customerSearchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppTheme.subtitleGray),
                                onPressed: () {
                                  _customerSearchController.clear();
                                  setStateBottomSheet(() {
                                    _customerSearchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: (value) {
                        setStateBottomSheet(() {
                          _customerSearchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _filteredCustomers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off,
                                    size: 64, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  'No customers found',
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: AppTheme.subtitleGray,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredCustomers.length,
                            itemBuilder: (context, index) {
                              final customer = _filteredCustomers[index];
                              final isSelected = _selectedCustomer == customer;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryDarkBlue
                                          .withOpacity(0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primaryDarkBlue
                                        : Colors.grey.shade200,
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: isSelected
                                        ? AppTheme.primaryDarkBlue
                                        : Colors.grey.shade200,
                                    child: Icon(
                                      Icons.business,
                                      size: 20,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.subtitleGray,
                                    ),
                                  ),
                                  title: Text(
                                    customer,
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? AppTheme.primaryDarkBlue
                                          : Colors.black87,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check_circle,
                                          color: AppTheme.primaryDarkBlue,
                                          size: 22)
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedCustomer = customer;
                                      _customerSearchQuery = '';
                                      _customerSearchController.clear();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openFullReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullLedgerReportScreen(
          customerName: _selectedCustomer,
          fromDate: _fromDate,
          toDate: _toDate,
          ledgerEntries: _ledgerEntries,
          ledgerSummary: _ledgerSummary!,
          isCustomerLedger: _isCustomerLedger,
          selectedAccount: _selectedAccount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.primaryDarkBlue, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('General Ledger',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
        actions: [
          if (_showReport)
            IconButton(
                onPressed: _resetFilters,
                icon: const Icon(Icons.refresh,
                    color: AppTheme.primaryDarkBlue, size: 22)),
          IconButton(
              onPressed: _generateReport,
              icon: const Icon(Icons.download,
                  color: AppTheme.primaryDarkBlue, size: 22)),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(),
            const SizedBox(height: 20),

            // Filter Form Card
            _buildFilterCard(),
            const SizedBox(height: 20),

            // Report Section
            if (_showReport && _ledgerSummary != null) ...[
              const SizedBox(height: 8),
              _buildModernReportCard(),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryDarkBlue,
            AppTheme.primaryDarkBlue.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDarkBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child:
                const Icon(Icons.receipt_long, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ledger Statement',
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text('View complete transaction history',
                    style: GoogleFonts.lato(
                        fontSize: 12, color: Colors.white.withOpacity(0.9))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard() {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.primaryDarkBlue.withOpacity(0.05),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.tune,
                        size: 20, color: AppTheme.primaryDarkBlue),
                  ),
                  const SizedBox(width: 12),
                  Text('FILTER OPTIONS',
                      style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppTheme.primaryDarkBlue)),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Toggle Button
                  _buildToggleSwitch(),
                  const SizedBox(height: 20),

                  // Financial Year
                  _buildDropdownField(
                    value: _selectedFinancialYear,
                    label: 'Financial Year',
                    icon: Icons.calendar_today,
                    items: _financialYears,
                    onChanged: _onFinancialYearChanged,
                  ),
                  const SizedBox(height: 16),

                  // Date Range
                  Row(
                    children: [
                      Expanded(
                          child: _buildDateField(
                              controller: _fromDateController,
                              label: 'From Date',
                              onTap: _selectFromDate)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildDateField(
                              controller: _toDateController,
                              label: 'To Date',
                              onTap: _selectToDate)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Conditional Fields
                  if (_isCustomerLedger) ...[
                    _buildCustomerSelector(),
                  ] else ...[
                    _buildDropdownField(
                      value: _selectedAccountHead,
                      label: 'Account Head',
                      icon: Icons.category,
                      items: _accountHeads,
                      onChanged: _onAccountHeadChanged,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      value: _selectedAccount,
                      label: 'Account',
                      icon: Icons.account_balance_wallet,
                      items: _accounts[_selectedAccountHead] ?? ['All'],
                      onChanged: (value) {
                        if (value != null)
                          setState(() => _selectedAccount = value);
                      },
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _generateReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDarkBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.file_download,
                              size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('Generate Statement',
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
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
    );
  }

  Widget _buildToggleSwitch() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.lightBlueBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isCustomerLedger = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isCustomerLedger
                      ? AppTheme.primaryDarkBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'General Ledger',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: !_isCustomerLedger
                          ? Colors.white
                          : AppTheme.subtitleGray,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isCustomerLedger = true;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isCustomerLedger
                      ? AppTheme.primaryDarkBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Customer Ledger',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _isCustomerLedger
                          ? Colors.white
                          : AppTheme.subtitleGray,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSelector() {
    return InkWell(
      onTap: _showCustomerSelector,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_outline,
                  size: 20, color: AppTheme.primaryDarkBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SELECT CUSTOMER',
                      style: GoogleFonts.lato(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppTheme.subtitleGray)),
                  const SizedBox(height: 4),
                  Text(_selectedCustomer,
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppTheme.subtitleGray),
          ],
        ),
      ),
    );
  }

  // Modern Report Card with View Full Report button
  Widget _buildModernReportCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryDarkBlue,
                  AppTheme.primaryDarkBlue.withOpacity(0.9),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.receipt,
                          size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'PARTY STATEMENT',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${DateFormat('dd MMM yyyy').format(_fromDate)} - ${DateFormat('dd MMM yyyy').format(_toDate)}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Customer Info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Details',
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppTheme.subtitleGray,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.person,
                          size: 18, color: AppTheme.primaryDarkBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedCustomer,
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Total Receivables Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade50,
                  Colors.green.shade100.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Receivables',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatAmount(_ledgerSummary!.closingBalance),
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.currency_rupee,
                      size: 28, color: Colors.green.shade600),
                ),
              ],
            ),
          ),

          // View Full Report Button - Click to open detailed report
          Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: _openFullReport,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryDarkBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.primaryDarkBlue.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'VIEW FULL REPORT',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward,
                        size: 16, color: AppTheme.primaryDarkBlue),
                  ],
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          // Transactions Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'TRANSACTIONS SUMMARY',
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppTheme.subtitleGray,
              ),
            ),
          ),

          // Transaction Items
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildTransactionItem(
                  title: 'Opening Balance',
                  amount: _ledgerSummary!.openingBalance,
                  type: 'debit',
                  showTypeLabel: true,
                ),
                _buildDivider(),
                _buildTransactionItem(
                  title: 'Total Debit',
                  amount: _ledgerSummary!.totalDebit,
                  type: 'debit',
                  showTypeLabel: true,
                ),
                _buildDivider(),
                _buildTransactionItem(
                  title: 'Total Credit',
                  amount: _ledgerSummary!.totalCredit,
                  type: 'credit',
                  showTypeLabel: true,
                ),
                _buildDivider(),
                _buildTransactionItem(
                  title: 'Closing Balance',
                  amount: _ledgerSummary!.closingBalance,
                  type:
                      _ledgerSummary!.closingBalance >= 0 ? 'credit' : 'debit',
                  showTypeLabel: true,
                  isHighlighted: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showReport = false;
                      });
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: Text('CHANGE',
                        style: GoogleFonts.lato(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryDarkBlue,
                      side: BorderSide(color: AppTheme.primaryDarkBlue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Download feature coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download,
                        size: 18, color: Colors.white),
                    label: Text('DOWNLOAD',
                        style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDarkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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

  Widget _buildTransactionItem({
    required String title,
    required double amount,
    required String type,
    bool showTypeLabel = true,
    bool isHighlighted = false,
  }) {
    final isDebit = type == 'debit';
    final color = isDebit ? Colors.orange : Colors.green;
    final typeLabel = isDebit ? 'Debit' : 'Credit';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppTheme.primaryDarkBlue.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isDebit ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight:
                          isHighlighted ? FontWeight.w700 : FontWeight.w600,
                      color: isHighlighted
                          ? AppTheme.primaryDarkBlue
                          : Colors.black87,
                    ),
                  ),
                  if (showTypeLabel)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        typeLabel,
                        style: GoogleFonts.lato(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Text(
            _formatAmount(amount),
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
              color: isHighlighted ? AppTheme.primaryDarkBlue : color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppTheme.subtitleGray)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              style: GoogleFonts.lato(fontSize: 14, color: Colors.black87),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Row(
                          children: [
                            Icon(icon, size: 18, color: AppTheme.subtitleGray),
                            const SizedBox(width: 10),
                            Text(item, style: GoogleFonts.lato(fontSize: 14)),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 20, color: AppTheme.subtitleGray),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppTheme.subtitleGray)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 18, color: AppTheme.subtitleGray),
                const SizedBox(width: 10),
                Text(controller.text,
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Full Ledger Report Screen - Complete Working Version
class FullLedgerReportScreen extends StatelessWidget {
  final String customerName;
  final DateTime fromDate;
  final DateTime toDate;
  final List<LedgerEntry> ledgerEntries;
  final LedgerSummary ledgerSummary;
  final bool isCustomerLedger;
  final String selectedAccount;

  const FullLedgerReportScreen({
    super.key,
    required this.customerName,
    required this.fromDate,
    required this.toDate,
    required this.ledgerEntries,
    required this.ledgerSummary,
    required this.isCustomerLedger,
    required this.selectedAccount,
  });

  String _formatAmount(double amount) {
    return NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Filter out opening balance entries for transaction list
    final transactionEntries =
        ledgerEntries.where((e) => e.description != 'Opening Balance').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.primaryDarkBlue, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Full Ledger Report',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppTheme.primaryDarkBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppTheme.primaryDarkBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Party Statement (Ledger)',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isCustomerLedger ? customerName : 'Business Name',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (isCustomerLedger)
                    Text(
                      'Party Ledger',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'Phone no: 9092218189',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'To,',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCustomerLedger ? customerName : 'Cash Sale',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Phone no: 9092218189',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlueBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${DateFormat('dd/MM/yyyy').format(fromDate)} - ${DateFormat('dd/MM/yyyy').format(toDate)}',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total Receivable',
                              style: GoogleFonts.lato(
                                fontSize: 11,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                            Text(
                              _formatAmount(ledgerSummary.closingBalance),
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            size: 28,
                            color: AppTheme.primaryDarkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Table Title
            Text(
              'TRANSACTION DETAILS',
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppTheme.subtitleGray,
              ),
            ),
            const SizedBox(height: 12),

            // Table Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  // Horizontal Scroll for Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      width: 900, // Fixed total width for all columns
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryDarkBlue.withOpacity(0.05),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                _buildHeaderCell('Date', width: 100),
                                _buildHeaderCell('Voucher', width: 100),
                                _buildHeaderCell('Sr No', width: 60),
                                _buildHeaderCell('Credit', width: 100),
                                _buildHeaderCell('Debit', width: 100),
                                _buildHeaderCell('Original Invoice No',
                                    width: 150),
                                _buildHeaderCell('Payment Mode', width: 130),
                                _buildHeaderCell('Balance',
                                    width: 100, alignRight: true),
                              ],
                            ),
                          ),

                          // Opening Balance Row
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade100)),
                            ),
                            child: Row(
                              children: [
                                _buildDataCell('-', width: 100),
                                _buildDataCell('-', width: 100),
                                _buildDataCell('-', width: 60),
                                _buildDataCell('-', width: 100),
                                _buildDataCell('0.0', width: 100),
                                _buildDataCell('-', width: 150),
                                _buildDataCell('-', width: 130),
                                _buildDataCell('0.0',
                                    width: 100, alignRight: true),
                              ],
                            ),
                          ),

                          // Opening Balance Label
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            color: Colors.grey.shade50,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Opening Balance',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                Text('0.0',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),

                          // Transaction Entries
                          ...transactionEntries.asMap().entries.map((entry) {
                            int idx = entry.key;
                            LedgerEntry e = entry.value;
                            double runningBalance =
                                _calculateRunningBalance(idx);
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade100),
                                ),
                              ),
                              child: Row(
                                children: [
                                  _buildDataCell(
                                      DateFormat('dd/MM/yyyy').format(e.date),
                                      width: 100),
                                  _buildDataCell(e.voucherNo, width: 100),
                                  _buildDataCell('${idx + 1}', width: 60),
                                  _buildDataCell(
                                      e.credit > 0
                                          ? _formatAmount(e.credit)
                                          : '-',
                                      width: 100),
                                  _buildDataCell(
                                      e.debit > 0
                                          ? _formatAmount(e.debit)
                                          : '-',
                                      width: 100,
                                      textColor: Colors.orange.shade700),
                                  _buildDataCell('-', width: 150),
                                  _buildDataCell('-', width: 130),
                                  _buildDataCell(_formatAmount(runningBalance),
                                      width: 100,
                                      alignRight: true,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Closing Balance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightBlueBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryDarkBlue.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Closing Balance',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryDarkBlue)),
                  Text(_formatAmount(ledgerSummary.closingBalance),
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Total Outstanding Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Outstanding',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  Text(_formatAmount(ledgerSummary.closingBalance),
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700)),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  double _calculateRunningBalance(int index) {
    double balance = ledgerSummary.openingBalance;
    final transactionEntries =
        ledgerEntries.where((e) => e.description != 'Opening Balance').toList();

    for (int i = 0; i <= index; i++) {
      if (i < transactionEntries.length) {
        balance += transactionEntries[i].debit - transactionEntries[i].credit;
      }
    }
    return balance;
  }

  Widget _buildHeaderCell(String text,
      {required double width, bool alignRight = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryDarkBlue,
        ),
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  Widget _buildDataCell(String text,
      {required double width,
      bool alignRight = false,
      Color? textColor,
      FontWeight? fontWeight}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 11,
          color: textColor ?? Colors.black87,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// Data Models
class LedgerEntry {
  final DateTime date;
  final String description;
  final double debit;
  final double credit;
  final String voucherNo;

  LedgerEntry({
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.voucherNo,
  });
}

class LedgerSummary {
  final String accountName;
  final String accountType;
  final double openingBalance;
  final double closingBalance;
  final double totalDebit;
  final double totalCredit;

  LedgerSummary({
    required this.accountName,
    required this.accountType,
    required this.openingBalance,
    required this.closingBalance,
    required this.totalDebit,
    required this.totalCredit,
  });
}
