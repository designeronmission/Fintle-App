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
  String _selectedCustomer = 'All Customers';
  String _searchQuery = '';
  String _customerSearchQuery = '';
  bool _showReport = false;

  // Toggle for Customer Ledger vs Normal Ledger
  bool _isCustomerLedger = false;

  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 365));
  DateTime _toDate = DateTime.now();
  String _selectedFinancialYear = '2024-25';

  List<LedgerEntry> _ledgerEntries = [];
  List<LedgerEntry> _filteredEntries = [];
  LedgerSummary? _ledgerSummary;

  // Customer List
  final List<String> _customers = [
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

    entries.add(LedgerEntry(
      date: _fromDate,
      description: 'Opening Balance',
      debit: 50000,
      credit: 0,
      voucherNo: 'OP-001',
    ));

    if (customerName == 'ABC Corporation') {
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
        LedgerEntry(
            date: DateTime(2024, 5, 10),
            description: 'Sales Invoice',
            debit: 45000,
            credit: 0,
            voucherNo: 'INV-005'),
        LedgerEntry(
            date: DateTime(2024, 5, 20),
            description: 'Payment Received',
            debit: 0,
            credit: 35000,
            voucherNo: 'REC-006'),
      ]);
    } else if (customerName == 'XYZ Ltd') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 8),
            description: 'Sales Invoice',
            debit: 125000,
            credit: 0,
            voucherNo: 'INV-002'),
        LedgerEntry(
            date: DateTime(2024, 4, 20),
            description: 'Payment Received',
            debit: 0,
            credit: 75000,
            voucherNo: 'REC-002'),
        LedgerEntry(
            date: DateTime(2024, 5, 15),
            description: 'Sales Invoice',
            debit: 55000,
            credit: 0,
            voucherNo: 'INV-008'),
      ]);
    } else if (customerName == 'PQR Enterprises') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 12),
            description: 'Sales Invoice',
            debit: 65000,
            credit: 0,
            voucherNo: 'INV-003'),
        LedgerEntry(
            date: DateTime(2024, 5, 5),
            description: 'Payment Received',
            debit: 0,
            credit: 65000,
            voucherNo: 'REC-003'),
      ]);
    } else if (customerName == 'LMN Industries') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 18),
            description: 'Sales Invoice',
            debit: 95000,
            credit: 0,
            voucherNo: 'INV-004'),
        LedgerEntry(
            date: DateTime(2024, 5, 12),
            description: 'Partial Payment',
            debit: 0,
            credit: 50000,
            voucherNo: 'REC-004'),
        LedgerEntry(
            date: DateTime(2024, 5, 25),
            description: 'Balance Payment',
            debit: 0,
            credit: 45000,
            voucherNo: 'REC-007'),
      ]);
    } else if (customerName == 'DEF Solutions') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 22),
            description: 'Service Invoice',
            debit: 35000,
            credit: 0,
            voucherNo: 'INV-006'),
        LedgerEntry(
            date: DateTime(2024, 5, 8),
            description: 'Payment Received',
            debit: 0,
            credit: 35000,
            voucherNo: 'REC-005'),
      ]);
    } else if (customerName == 'GHI Traders') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 28),
            description: 'Sales Invoice',
            debit: 55000,
            credit: 0,
            voucherNo: 'INV-007'),
        LedgerEntry(
            date: DateTime(2024, 5, 18),
            description: 'Payment Received',
            debit: 0,
            credit: 30000,
            voucherNo: 'REC-008'),
      ]);
    } else if (customerName == 'MNO Group') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 10),
            description: 'Sales Invoice',
            debit: 75000,
            credit: 0,
            voucherNo: 'INV-009'),
        LedgerEntry(
            date: DateTime(2024, 4, 30),
            description: 'Payment Received',
            debit: 0,
            credit: 75000,
            voucherNo: 'REC-009'),
      ]);
    } else if (customerName == 'RST Ventures') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 14),
            description: 'Sales Invoice',
            debit: 45000,
            credit: 0,
            voucherNo: 'INV-010'),
        LedgerEntry(
            date: DateTime(2024, 5, 2),
            description: 'Payment Received',
            debit: 0,
            credit: 25000,
            voucherNo: 'REC-010'),
      ]);
    } else if (customerName == 'UVW Associates') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 25),
            description: 'Service Invoice',
            debit: 28000,
            credit: 0,
            voucherNo: 'INV-011'),
        LedgerEntry(
            date: DateTime(2024, 5, 14),
            description: 'Payment Received',
            debit: 0,
            credit: 28000,
            voucherNo: 'REC-011'),
      ]);
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
        LedgerEntry(
            date: DateTime(2024, 4, 15),
            description: 'Salary Payment',
            debit: 0,
            credit: 35000,
            voucherNo: 'SAL-001'),
        LedgerEntry(
            date: DateTime(2024, 4, 20),
            description: 'Service Income',
            debit: 18000,
            credit: 0,
            voucherNo: 'SERV-001'),
      ]);
    } else if (accountName == 'Bank Account - HDFC') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 7),
            description: 'Customer Payment',
            debit: 75000,
            credit: 0,
            voucherNo: 'PMT-001'),
        LedgerEntry(
            date: DateTime(2024, 4, 12),
            description: 'Vendor Payment',
            debit: 0,
            credit: 45000,
            voucherNo: 'VND-001'),
        LedgerEntry(
            date: DateTime(2024, 4, 18),
            description: 'Interest Received',
            debit: 5000,
            credit: 0,
            voucherNo: 'INT-001'),
      ]);
    } else if (accountName == 'Sales Revenue') {
      entries.addAll([
        LedgerEntry(
            date: DateTime(2024, 4, 8),
            description: 'Product Sales',
            debit: 0,
            credit: 85000,
            voucherNo: 'SALE-002'),
        LedgerEntry(
            date: DateTime(2024, 4, 22),
            description: 'Product Sales',
            debit: 0,
            credit: 45000,
            voucherNo: 'SALE-003'),
        LedgerEntry(
            date: DateTime(2024, 4, 28),
            description: 'Product Sales',
            debit: 0,
            credit: 35000,
            voucherNo: 'SALE-004'),
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
      _selectedCustomer = 'All Customers';
      _searchQuery = '';
      _customerSearchQuery = '';
      _searchController.clear();
      _customerSearchController.clear();
      _showReport = false;
      _isCustomerLedger = false;
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryDarkBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        const Icon(Icons.book, size: 24, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('General Ledger Report',
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('View detailed ledger entries with debit/credit',
                            style: GoogleFonts.lato(
                                fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filter Form Card
            Form(
              key: _formKey,
              child: Container(
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
                        color: AppTheme.primaryDarkBlue.withOpacity(0.03),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
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
                                size: 20, color: AppTheme.primaryDarkBlue),
                          ),
                          const SizedBox(width: 12),
                          Text('FILTER OPTIONS',
                              style: GoogleFonts.lato(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.subtitleGray)),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Toggle Button for Customer Ledger vs Normal Ledger
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.lightBlueBg,
                              borderRadius: BorderRadius.circular(12),
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
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: !_isCustomerLedger
                                            ? AppTheme.primaryDarkBlue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'General Ledger',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
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
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: _isCustomerLedger
                                            ? AppTheme.primaryDarkBlue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Customer Ledger',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
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
                          ),
                          const SizedBox(height: 16),

                          // Financial Year
                          _buildDropdownField(
                            value: _selectedFinancialYear,
                            label: 'Financial Year',
                            icon: Icons.calendar_today,
                            items: _financialYears,
                            onChanged: _onFinancialYearChanged,
                          ),
                          const SizedBox(height: 16),

                          // From Date & To Date Row
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

                          // Conditional Fields based on Toggle
                          if (_isCustomerLedger) ...[
                            // Customer Selection Button
                            InkWell(
                              onTap: _showCustomerSelector,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryDarkBlue
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.people,
                                          size: 20,
                                          color: AppTheme.primaryDarkBlue),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('SELECT CUSTOMER',
                                              style: GoogleFonts.lato(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppTheme.subtitleGray)),
                                          const SizedBox(height: 2),
                                          Text(_selectedCustomer,
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87)),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        size: 16, color: AppTheme.subtitleGray),
                                  ],
                                ),
                              ),
                            ),
                          ] else ...[
                            // Account Head
                            _buildDropdownField(
                              value: _selectedAccountHead,
                              label: 'Account Head',
                              icon: Icons.category,
                              items: _accountHeads,
                              onChanged: _onAccountHeadChanged,
                            ),
                            const SizedBox(height: 16),

                            // Account
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

                          const SizedBox(height: 20),

                          // Generate Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _generateReport,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryDarkBlue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('Generate Report',
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.lightBlueBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryDarkBlue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 18, color: AppTheme.primaryDarkBlue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isCustomerLedger
                          ? 'Customer ledger shows all transactions for the selected customer.'
                          : 'Ledger shows all transactions with debit/credit entries and running balance.',
                      style: GoogleFonts.lato(
                          fontSize: 11, color: AppTheme.primaryDarkBlue),
                    ),
                  ),
                ],
              ),
            ),

            // Report Section
            if (_showReport && _ledgerSummary != null) ...[
              const SizedBox(height: 24),

              // Customer Banner (only for Customer Ledger)
              if (_isCustomerLedger && _selectedCustomer != 'All Customers')
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.blue.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.business,
                            size: 24, color: Colors.blue.shade700),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer Ledger',
                                style: GoogleFonts.lato(
                                    fontSize: 12, color: Colors.blue.shade700)),
                            Text(_selectedCustomer,
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Search Bar
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by description, voucher no, or amount...',
                    hintStyle: GoogleFonts.lato(
                        fontSize: 13, color: Colors.grey.shade400),
                    prefixIcon:
                        const Icon(Icons.search, color: AppTheme.subtitleGray),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: AppTheme.subtitleGray),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
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
                      borderSide:
                          const BorderSide(color: AppTheme.primaryDarkBlue),
                    ),
                  ),
                ),
              ),

              // Search Results Count
              if (_searchQuery.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlueBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Found ${_filteredEntries.length} entries matching "$_searchQuery"',
                    style: GoogleFonts.lato(
                        fontSize: 12, color: AppTheme.primaryDarkBlue),
                  ),
                ),

              _buildAccountSummaryCard(),
              const SizedBox(height: 16),
              _buildLedgerEntriesList(),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
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
                Icon(Icons.account_balance,
                    color: AppTheme.primaryDarkBlue, size: 20),
                const SizedBox(width: 8),
                Text(_isCustomerLedger ? 'CUSTOMER SUMMARY' : 'ACCOUNT SUMMARY',
                    style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryDarkBlue)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppTheme.lightBlueBg,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                _isCustomerLedger
                                    ? 'Customer Name'
                                    : 'Account Name',
                                style: GoogleFonts.lato(
                                    fontSize: 10,
                                    color: AppTheme.subtitleGray)),
                            const SizedBox(height: 4),
                            Text(_ledgerSummary!.accountName,
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryDarkBlue)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type',
                                style: GoogleFonts.lato(
                                    fontSize: 10,
                                    color: AppTheme.subtitleGray)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getAccountTypeColor(
                                        _ledgerSummary!.accountType)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(_ledgerSummary!.accountType,
                                  style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _getAccountTypeColor(
                                          _ledgerSummary!.accountType))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildBalanceCard(
                            'Opening Balance',
                            _ledgerSummary!.openingBalance,
                            Icons.arrow_upward)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildBalanceCard(
                            'Closing Balance',
                            _ledgerSummary!.closingBalance,
                            Icons.arrow_downward)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _buildTotalCard(
                            'Total Debit',
                            _ledgerSummary!.totalDebit,
                            Icons.trending_up,
                            Colors.green)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildTotalCard(
                            'Total Credit',
                            _ledgerSummary!.totalCredit,
                            Icons.trending_down,
                            Colors.orange)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String title, double amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppTheme.subtitleGray),
              const SizedBox(width: 4),
              Text(title,
                  style: GoogleFonts.lato(
                      fontSize: 10, color: AppTheme.subtitleGray)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _formatAmount(amount),
            style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color:
                    amount >= 0 ? Colors.green.shade700 : Colors.red.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(
      String title, double amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(title,
                  style: GoogleFonts.lato(
                      fontSize: 10, color: color, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Text(_formatAmount(amount),
              style: GoogleFonts.lato(
                  fontSize: 16, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

// Update the _buildLedgerEntriesList method with this code:

  Widget _buildLedgerEntriesList() {
    if (_filteredEntries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('No matching entries found',
                style: GoogleFonts.lato(
                    fontSize: 14, color: AppTheme.subtitleGray)),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredEntries.length,
      itemBuilder: (context, index) {
        final entry = _filteredEntries[index];
        double runningBalance = _calculateRunningBalanceForFiltered(index);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and Voucher Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: AppTheme.subtitleGray),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd MMM yyyy').format(entry.date),
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.voucherNo,
                      style: GoogleFonts.lato(
                          fontSize: 10, color: AppTheme.subtitleGray),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description with icon
              Row(
                children: [
                  Icon(Icons.receipt, size: 16, color: AppTheme.subtitleGray),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.description,
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Debit and Credit Row - No background
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.arrow_downward,
                            size: 14, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'DEBIT',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          entry.debit > 0 ? _formatAmount(entry.debit) : '-',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.arrow_upward,
                            size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'CREDIT',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          entry.credit > 0 ? _formatAmount(entry.credit) : '-',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Running Balance - No background
              if (!_isCustomerLedger) ...[
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade100),
                const SizedBox(height: 8),
                Row(
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
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700),
                        ),
                      ],
                    ),
                    Text(
                      _formatAmount(runningBalance),
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: runningBalance >= 0
                            ? Colors.blue.shade700
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  double _calculateRunningBalanceForFiltered(int index) {
    double balance = _ledgerSummary!.openingBalance;
    for (int i = 0; i <= index; i++) {
      balance += _filteredEntries[i].debit - _filteredEntries[i].credit;
    }
    return balance;
  }

  Color _getAccountTypeColor(String type) {
    switch (type) {
      case 'Assets':
        return Colors.blue;
      case 'Liabilities':
        return Colors.purple;
      case 'Equity':
        return Colors.teal;
      case 'Income':
        return Colors.green;
      case 'Expenses':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
        Text(label.toUpperCase(),
            style: GoogleFonts.lato(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              style: GoogleFonts.lato(fontSize: 13, color: Colors.black87),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Row(
                          children: [
                            Icon(icon, size: 16, color: AppTheme.subtitleGray),
                            const SizedBox(width: 8),
                            Text(item, style: GoogleFonts.lato(fontSize: 13)),
                          ],
                        ),
                      ))
                  .toList(),
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
        Text(label.toUpperCase(),
            style: GoogleFonts.lato(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray)),
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
                Text(controller.text,
                    style: GoogleFonts.lato(
                        fontSize: 13,
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
