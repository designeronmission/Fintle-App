import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

// ==================== GENERAL LEDGER SCREEN ====================
class GeneralLedgerScreen extends StatefulWidget {
  const GeneralLedgerScreen({super.key});

  @override
  State<GeneralLedgerScreen> createState() => _GeneralLedgerScreenState();
}

class _GeneralLedgerScreenState extends State<GeneralLedgerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final TextEditingController _financialYearController =
      TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  // Selected Values
  String _selectedAccountHead = 'All';
  String _selectedAccount = 'All';
  bool _showReport = false;

  // Date Range
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 365));
  DateTime _toDate = DateTime.now();
  String _selectedFinancialYear = '2024-25';

  // Report Data
  List<LedgerEntry> _ledgerEntries = [];
  LedgerSummary? _ledgerSummary;

  // Dropdown Options
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
  }

  @override
  void dispose() {
    _financialYearController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  void _selectFromDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primaryDarkBlue,
          ),
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
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primaryDarkBlue,
          ),
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
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Report generated successfully!\n'
            'Financial Year: $_selectedFinancialYear\n'
            'Account: $_selectedAccount',
          ),
          backgroundColor: AppTheme.primaryDarkBlue,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _generateLedgerData() {
    _ledgerEntries = _getSampleLedgerEntries(_selectedAccount);
    _ledgerSummary = _calculateSummary(_ledgerEntries, _selectedAccount);
  }

  List<LedgerEntry> _getSampleLedgerEntries(String accountName) {
    List<LedgerEntry> entries = [];

    if (accountName == 'Cash in Hand') {
      entries = [
        LedgerEntry(
          date: DateTime(2024, 4, 1),
          description: 'Opening Balance',
          debit: 100000,
          credit: 0,
          voucherNo: 'OP-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 5),
          description: 'Sales Revenue',
          debit: 25000,
          credit: 0,
          voucherNo: 'SALE-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 10),
          description: 'Rent Payment',
          debit: 0,
          credit: 15000,
          voucherNo: 'RENT-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 15),
          description: 'Salary Payment',
          debit: 0,
          credit: 35000,
          voucherNo: 'SAL-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 20),
          description: 'Service Income',
          debit: 18000,
          credit: 0,
          voucherNo: 'SERV-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 25),
          description: 'Utility Bills',
          debit: 0,
          credit: 8000,
          voucherNo: 'UTIL-001',
        ),
      ];
    } else if (accountName == 'Bank Account - HDFC') {
      entries = [
        LedgerEntry(
          date: DateTime(2024, 4, 1),
          description: 'Opening Balance',
          debit: 500000,
          credit: 0,
          voucherNo: 'OP-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 7),
          description: 'Customer Payment',
          debit: 75000,
          credit: 0,
          voucherNo: 'PMT-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 12),
          description: 'Vendor Payment',
          debit: 0,
          credit: 45000,
          voucherNo: 'VND-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 18),
          description: 'Interest Received',
          debit: 5000,
          credit: 0,
          voucherNo: 'INT-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 25),
          description: 'ATM Withdrawal',
          debit: 0,
          credit: 20000,
          voucherNo: 'ATM-001',
        ),
      ];
    } else if (accountName == 'Sales Revenue') {
      entries = [
        LedgerEntry(
          date: DateTime(2024, 4, 1),
          description: 'Opening Balance',
          debit: 0,
          credit: 200000,
          voucherNo: 'OP-001',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 8),
          description: 'Product Sales - Invoice INV-001',
          debit: 0,
          credit: 85000,
          voucherNo: 'SALE-002',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 22),
          description: 'Product Sales - Invoice INV-002',
          debit: 0,
          credit: 45000,
          voucherNo: 'SALE-003',
        ),
        LedgerEntry(
          date: DateTime(2024, 4, 28),
          description: 'Product Sales - Invoice INV-003',
          debit: 0,
          credit: 35000,
          voucherNo: 'SALE-004',
        ),
      ];
    } else {
      entries = [
        LedgerEntry(
          date: _fromDate,
          description: 'Opening Balance',
          debit: 50000,
          credit: 0,
          voucherNo: 'OP-001',
        ),
        LedgerEntry(
          date: _fromDate.add(const Duration(days: 15)),
          description: 'Transaction 1',
          debit: 25000,
          credit: 0,
          voucherNo: 'TRX-001',
        ),
        LedgerEntry(
          date: _toDate.subtract(const Duration(days: 10)),
          description: 'Transaction 2',
          debit: 0,
          credit: 15000,
          voucherNo: 'TRX-002',
        ),
      ];
    }

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
      _showReport = false;
      _ledgerEntries = [];
      _ledgerSummary = null;
    });
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'General Ledger',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
        actions: [
          if (_showReport)
            IconButton(
              onPressed: _resetFilters,
              icon: const Icon(Icons.refresh,
                  color: AppTheme.primaryDarkBlue, size: 22),
            ),
          IconButton(
            onPressed: _generateReport,
            icon: const Icon(Icons.download,
                color: AppTheme.primaryDarkBlue, size: 22),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryDarkBlue,
                    AppTheme.primaryDarkBlue.withOpacity(0.8),
                  ],
                ),
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
                    child: const Icon(
                      Icons.book,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'General Ledger Report',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'View detailed ledger entries with debit/credit',
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
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
                          top: Radius.circular(16),
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
                            child: const Icon(
                              Icons.filter_list,
                              size: 20,
                              color: AppTheme.primaryDarkBlue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'FILTER OPTIONS',
                            style: GoogleFonts.lato(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.subtitleGray,
                              letterSpacing: 0.5,
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
                          // Financial Year
                          _buildDropdownField(
                            value: _selectedFinancialYear,
                            label: 'Financial Year',
                            hint: 'Select financial year',
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
                          const SizedBox(height: 16),

                          // Account Head
                          _buildDropdownField(
                            value: _selectedAccountHead,
                            label: 'Account Head',
                            hint: 'Select account head',
                            icon: Icons.category,
                            items: _accountHeads,
                            onChanged: _onAccountHeadChanged,
                          ),
                          const SizedBox(height: 16),

                          // Account
                          _buildDropdownField(
                            value: _selectedAccount,
                            label: 'Account',
                            hint: 'Select account',
                            icon: Icons.account_balance_wallet,
                            items: _accounts[_selectedAccountHead] ?? ['All'],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedAccount = value);
                              }
                            },
                          ),

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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.picture_as_pdf,
                                      size: 18, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Generate Report',
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
            ),

            const SizedBox(height: 16),

            // Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.lightBlueBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryDarkBlue.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppTheme.primaryDarkBlue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ledger shows all transactions with debit/credit entries and running balance.',
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        color: AppTheme.primaryDarkBlue,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Report Section
            if (_showReport && _ledgerSummary != null) ...[
              const SizedBox(height: 24),

              // Account Summary Card
              _buildAccountSummaryCard(),

              const SizedBox(height: 16),

              // Ledger Entries Table
              _buildLedgerTable(),
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
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
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
                Text(
                  'ACCOUNT SUMMARY',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDarkBlue,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Account Name & Type Row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlueBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Name',
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _ledgerSummary!.accountName,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryDarkBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Type',
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
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
                              child: Text(
                                _ledgerSummary!.accountType,
                                style: GoogleFonts.lato(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getAccountTypeColor(
                                      _ledgerSummary!.accountType),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Opening & Closing Balance Row
                Row(
                  children: [
                    Expanded(
                      child: _buildBalanceCard(
                        'Opening Balance',
                        _ledgerSummary!.openingBalance,
                        Icons.arrow_upward,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBalanceCard(
                        'Closing Balance',
                        _ledgerSummary!.closingBalance,
                        Icons.arrow_downward,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Total Debit & Credit Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTotalCard(
                        'Total Debit',
                        _ledgerSummary!.totalDebit,
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTotalCard(
                        'Total Credit',
                        _ledgerSummary!.totalCredit,
                        Icons.trending_down,
                        Colors.orange,
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
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  color: AppTheme.subtitleGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(amount),
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: amount >= 0 ? Colors.green.shade700 : Colors.red.shade700,
            ),
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
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(amount),
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerTable() {
    // Calculate available width and set responsive column widths
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    // Define column widths based on screen size
    final dateWidth = isSmallScreen ? 80.0 : 100.0;
    const descriptionWidth = 200.0;
    final voucherWidth = isSmallScreen ? 90.0 : 110.0;
    final amountWidth = isSmallScreen ? 110.0 : 130.0;
    final balanceWidth = isSmallScreen ? 120.0 : 140.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryDarkBlue,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    SizedBox(
                      width: dateWidth,
                      child: _buildHeaderText('Date', align: TextAlign.center),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: descriptionWidth,
                      child: _buildHeaderText('Description',
                          align: TextAlign.left),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: voucherWidth,
                      child: _buildHeaderText('Voucher No',
                          align: TextAlign.center),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: amountWidth,
                      child:
                          _buildHeaderText('Debit (₹)', align: TextAlign.right),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: amountWidth,
                      child: _buildHeaderText('Credit (₹)',
                          align: TextAlign.right),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: balanceWidth,
                      child: _buildHeaderText('Balance (₹)',
                          align: TextAlign.right),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Table Body with Horizontal Scroll
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.55,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _ledgerEntries.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.grey.shade100),
                      itemBuilder: (context, index) {
                        final entry = _ledgerEntries[index];
                        double runningBalance = _calculateRunningBalance(index);
                        final isEven = index % 2 == 0;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          color: isEven ? Colors.white : Colors.grey.shade50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: dateWidth,
                                child: _buildBodyText(
                                  DateFormat('dd/MM/yy').format(entry.date),
                                  align: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: descriptionWidth,
                                child: _buildBodyText(
                                  entry.description,
                                  fontWeight: FontWeight.w500,
                                  align: TextAlign.left,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: voucherWidth,
                                child: _buildBodyText(
                                  entry.voucherNo,
                                  align: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: amountWidth,
                                child: _buildAmountText(
                                  entry.debit,
                                  Colors.green,
                                  align: TextAlign.right,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: amountWidth,
                                child: _buildAmountText(
                                  entry.credit,
                                  Colors.orange,
                                  align: TextAlign.right,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: balanceWidth,
                                child: _buildAmountText(
                                  runningBalance,
                                  runningBalance >= 0
                                      ? Colors.blue.shade700
                                      : Colors.red,
                                  align: TextAlign.right,
                                  isBold: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Footer Total Row
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlueBg,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16)),
                        border: Border(
                            top: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: dateWidth + 8 + descriptionWidth,
                            child: _buildFooterText(
                              'TOTAL',
                              align: TextAlign.right,
                              isBold: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: voucherWidth,
                            child: _buildFooterText(
                              '',
                              align: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: amountWidth,
                            child: _buildFooterText(
                              NumberFormat.currency(
                                      symbol: '₹', decimalDigits: 2)
                                  .format(_ledgerSummary!.totalDebit),
                              align: TextAlign.right,
                              isBold: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: amountWidth,
                            child: _buildFooterText(
                              NumberFormat.currency(
                                      symbol: '₹', decimalDigits: 2)
                                  .format(_ledgerSummary!.totalCredit),
                              align: TextAlign.right,
                              isBold: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: balanceWidth,
                            child: _buildFooterText(
                              NumberFormat.currency(
                                      symbol: '₹', decimalDigits: 2)
                                  .format(_ledgerSummary!.closingBalance),
                              align: TextAlign.right,
                              isBold: true,
                            ),
                          ),
                        ],
                      ),
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

  double _calculateRunningBalance(int index) {
    double balance = _ledgerSummary!.openingBalance;
    for (int i = 0; i <= index; i++) {
      balance += _ledgerEntries[i].debit - _ledgerEntries[i].credit;
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

  Widget _buildHeaderText(String text, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildBodyText(
    String text, {
    FontWeight fontWeight = FontWeight.normal,
    TextAlign align = TextAlign.left,
  }) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: fontWeight,
        color: Colors.black87,
        height: 1.3,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _buildAmountText(
    double amount,
    Color color, {
    TextAlign align = TextAlign.left,
    bool isBold = false,
  }) {
    return Text(
      amount > 0
          ? NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(amount)
          : '-',
      textAlign: align,
      style: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _buildFooterText(
    String text, {
    TextAlign align = TextAlign.left,
    bool isBold = false,
  }) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.lato(
        fontSize: 13,
        fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
        color: AppTheme.primaryDarkBlue,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    String displayValue = items.contains(value) ? value : items.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.lato(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.subtitleGray,
            letterSpacing: 0.5,
          ),
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
              value: displayValue,
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
                      Text(
                        item,
                        style: GoogleFonts.lato(fontSize: 13),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: AppTheme.subtitleGray,
              ),
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
          label.toUpperCase(),
          style: GoogleFonts.lato(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.subtitleGray,
            letterSpacing: 0.5,
          ),
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
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.subtitleGray,
                ),
                const SizedBox(width: 10),
                Text(
                  controller.text,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
