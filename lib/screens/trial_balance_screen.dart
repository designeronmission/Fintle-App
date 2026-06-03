// trial_balance_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class TrialBalanceScreen extends StatefulWidget {
  const TrialBalanceScreen({super.key});

  @override
  State<TrialBalanceScreen> createState() => _TrialBalanceScreenState();
}

class _TrialBalanceScreenState extends State<TrialBalanceScreen> {
  String _selectedFinancialYear = '2024-25';
  String _selectedAsOnDate = '31 March 2027';
  String _selectedGroup = 'All';

  List<TrialBalanceEntry> _trialBalanceData = [];
  List<TrialBalanceEntry> _filteredData = [];
  double _totalDebits = 0;
  double _totalCredits = 0;
  double _difference = 0;

  final List<String> _groups = [
    'All',
    'Current Assets',
    'Fixed Assets',
    'Non-Current Liabilities',
    'Current Liabilities',
    "Shareholder's Equity",
    'Operating Income',
    'Other Income',
    'Direct Expenses',
    'Operating Expenses',
    'Non-Operating Expenses'
  ];

  @override
  void initState() {
    super.initState();
    _loadTrialBalanceData();
    _calculateTotals();
  }

  void _loadTrialBalanceData() {
    _trialBalanceData = [
      TrialBalanceEntry(
          id: 1,
          accountCode: "1101",
          accountName: "Cash in Hand",
          group: "Current Assets",
          debit: 125000,
          credit: 0),
      TrialBalanceEntry(
          id: 2,
          accountCode: "1102",
          accountName: "Bank Account - HDFC",
          group: "Current Assets",
          debit: 845000,
          credit: 0),
      TrialBalanceEntry(
          id: 3,
          accountCode: "1103",
          accountName: "Bank Account - SBI",
          group: "Current Assets",
          debit: 425000,
          credit: 0),
      TrialBalanceEntry(
          id: 4,
          accountCode: "1201",
          accountName: "Inventory - Raw Materials",
          group: "Current Assets",
          debit: 350000,
          credit: 0),
      TrialBalanceEntry(
          id: 5,
          accountCode: "1202",
          accountName: "Inventory - Finished Goods",
          group: "Current Assets",
          debit: 215000,
          credit: 0),
      TrialBalanceEntry(
          id: 6,
          accountCode: "1301",
          accountName: "Trade Receivables - ABC Corp",
          group: "Current Assets",
          debit: 95000,
          credit: 0),
      TrialBalanceEntry(
          id: 7,
          accountCode: "1302",
          accountName: "Trade Receivables - XYZ Ltd",
          group: "Current Assets",
          debit: 125000,
          credit: 0),
      TrialBalanceEntry(
          id: 8,
          accountCode: "1401",
          accountName: "Property, Plant & Equipment",
          group: "Fixed Assets",
          debit: 1500000,
          credit: 0),
      TrialBalanceEntry(
          id: 9,
          accountCode: "1402",
          accountName: "Accumulated Depreciation",
          group: "Fixed Assets",
          debit: 0,
          credit: 250000),
      TrialBalanceEntry(
          id: 10,
          accountCode: "1501",
          accountName: "Intangible Assets",
          group: "Fixed Assets",
          debit: 125000,
          credit: 0),
      TrialBalanceEntry(
          id: 11,
          accountCode: "2201",
          accountName: "Long Term Borrowings",
          group: "Non-Current Liabilities",
          debit: 0,
          credit: 500000),
      TrialBalanceEntry(
          id: 12,
          accountCode: "2301",
          accountName: "Trade Payables - Suppliers",
          group: "Current Liabilities",
          debit: 0,
          credit: 185000),
      TrialBalanceEntry(
          id: 13,
          accountCode: "2302",
          accountName: "Accrued Expenses",
          group: "Current Liabilities",
          debit: 0,
          credit: 45000),
      TrialBalanceEntry(
          id: 14,
          accountCode: "2303",
          accountName: "Statutory Dues Payable",
          group: "Current Liabilities",
          debit: 0,
          credit: 35000),
      TrialBalanceEntry(
          id: 15,
          accountCode: "2304",
          accountName: "Short Term Provisions",
          group: "Current Liabilities",
          debit: 0,
          credit: 28000),
      TrialBalanceEntry(
          id: 16,
          accountCode: "2101",
          accountName: "Equity Share Capital",
          group: "Shareholder's Equity",
          debit: 0,
          credit: 1000000),
      TrialBalanceEntry(
          id: 17,
          accountCode: "2102",
          accountName: "Reserves & Surplus",
          group: "Shareholder's Equity",
          debit: 0,
          credit: 425000),
      TrialBalanceEntry(
          id: 18,
          accountCode: "4101",
          accountName: "Sales Revenue",
          group: "Operating Income",
          debit: 0,
          credit: 1250000),
      TrialBalanceEntry(
          id: 19,
          accountCode: "4102",
          accountName: "Service Revenue",
          group: "Operating Income",
          debit: 0,
          credit: 325000),
      TrialBalanceEntry(
          id: 20,
          accountCode: "4201",
          accountName: "Discount Received",
          group: "Other Income",
          debit: 0,
          credit: 15000),
      TrialBalanceEntry(
          id: 21,
          accountCode: "5101",
          accountName: "Cost of Goods Sold",
          group: "Direct Expenses",
          debit: 685000,
          credit: 0),
      TrialBalanceEntry(
          id: 22,
          accountCode: "5201",
          accountName: "Salaries & Wages",
          group: "Operating Expenses",
          debit: 125000,
          credit: 0),
      TrialBalanceEntry(
          id: 23,
          accountCode: "5202",
          accountName: "Rent & Utilities",
          group: "Operating Expenses",
          debit: 85000,
          credit: 0),
      TrialBalanceEntry(
          id: 24,
          accountCode: "5203",
          accountName: "Marketing & Advertising",
          group: "Operating Expenses",
          debit: 45000,
          credit: 0),
      TrialBalanceEntry(
          id: 25,
          accountCode: "5204",
          accountName: "Office Supplies",
          group: "Operating Expenses",
          debit: 12000,
          credit: 0),
      TrialBalanceEntry(
          id: 26,
          accountCode: "5301",
          accountName: "Depreciation Expense",
          group: "Non-Operating Expenses",
          debit: 25000,
          credit: 0),
      TrialBalanceEntry(
          id: 27,
          accountCode: "5302",
          accountName: "Interest Expense",
          group: "Non-Operating Expenses",
          debit: 18000,
          credit: 0),
    ];
    _filteredData = _trialBalanceData;
  }

  void _calculateTotals() {
    _totalDebits = _filteredData.fold(0, (sum, item) => sum + item.debit);
    _totalCredits = _filteredData.fold(0, (sum, item) => sum + item.credit);
    _difference = _totalDebits - _totalCredits;
  }

  void _filterByGroup(String group) {
    setState(() {
      _selectedGroup = group;
      if (group == 'All') {
        _filteredData = _trialBalanceData;
      } else {
        _filteredData =
            _trialBalanceData.where((item) => item.group == group).toList();
      }
      _calculateTotals();
    });
  }

  String _formatAmount(double amount) {
    return NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(amount);
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
        title: Text(
          'Trial Balance',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search,
                color: AppTheme.primaryDarkBlue, size: 22),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryDarkBlue),
            onSelected: (value) {
              if (value == 'export') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Exporting...'),
                      backgroundColor: AppTheme.primaryDarkBlue),
                );
              } else if (value == 'print') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Printing...'),
                      backgroundColor: AppTheme.primaryDarkBlue),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.download, size: 20),
                      SizedBox(width: 12),
                      Text('Export')
                    ],
                  )),
              const PopupMenuItem(
                  value: 'print',
                  child: Row(
                    children: [
                      Icon(Icons.print, size: 20),
                      SizedBox(width: 12),
                      Text('Print')
                    ],
                  )),
            ],
          ),
        ],
      ),
      body: Column(children: [
        // Filter Chips
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and Year Row
              Row(
                children: [
                  Expanded(
                    child: _buildFilterChip(
                      label: 'FY $_selectedFinancialYear',
                      icon: Icons.calendar_today,
                      onTap: () => _showFinancialYearDialog(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFilterChip(
                      label: _selectedAsOnDate,
                      icon: Icons.date_range,
                      onTap: () => _showAsOnDateDialog(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Group Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _groups
                      .map((group) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(group,
                                  style: GoogleFonts.lato(fontSize: 12)),
                              selected: _selectedGroup == group,
                              onSelected: (selected) => _filterByGroup(group),
                              selectedColor: AppTheme.primaryDarkBlue,
                              checkmarkColor: Colors.white,
                              labelStyle: GoogleFonts.lato(
                                color: _selectedGroup == group
                                    ? Colors.white
                                    : AppTheme.subtitleGray,
                              ),
                              shape: StadiumBorder(
                                side: BorderSide(
                                    color: _selectedGroup == group
                                        ? AppTheme.primaryDarkBlue
                                        : Colors.grey.shade300),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),

        // Stats Cards
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Debit',
                  _formatAmount(_totalDebits),
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Credit',
                  _formatAmount(_totalCredits),
                  Icons.trending_down,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Difference',
                  _formatAmount(_difference.abs()),
                  Icons.compare_arrows,
                  _difference == 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),

        // List View
        Expanded(
          child: _filteredData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text('No entries found',
                          style:
                              GoogleFonts.lato(color: AppTheme.subtitleGray)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredData.length,
                  itemBuilder: (context, index) {
                    final item = _filteredData[index];
                    return _buildEntryCard(item, index);
                  },
                ),
        ),

        // Bottom Summary
        // Bottom Summary - Updated Version
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Entries',
                      style: GoogleFonts.lato(
                          fontSize: 11, color: AppTheme.subtitleGray)),
                  Text('${_filteredData.length}',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue)),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 16, right: 16), // Custom left and right spacing
                child: Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey.shade200,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 2), // Added left spacing here
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Net Balance',
                          style: GoogleFonts.lato(
                              fontSize: 11, color: AppTheme.subtitleGray)),
                      Text(
                        _formatAmount(_totalDebits - _totalCredits),
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: (_totalDebits - _totalCredits) >= 0
                                ? Colors.green.shade700
                                : Colors.red.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              // Share Icon Button
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sharing report...'),
                      backgroundColor: AppTheme.primaryDarkBlue,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDarkBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildFilterChip(
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.lightBlueBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppTheme.primaryDarkBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryDarkBlue),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down,
                size: 16, color: AppTheme.primaryDarkBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.lato(
                      fontSize: 10, color: AppTheme.subtitleGray)),
              Icon(icon, size: 14, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(amount,
              style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildEntryCard(TrialBalanceEntry item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header with Account Code and Group
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.lightBlueBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('${item.id}',
                            style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDarkBlue)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.accountCode,
                            style: GoogleFonts.lato(
                                fontSize: 11, color: AppTheme.subtitleGray)),
                        Text(item.accountName,
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDarkBlue)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(item.group.split(' ').last,
                      style: GoogleFonts.lato(
                          fontSize: 10, color: AppTheme.subtitleGray)),
                ),
              ],
            ),
          ),

          // Amounts Row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DEBIT',
                          style: GoogleFonts.lato(
                              fontSize: 10, color: AppTheme.subtitleGray)),
                      const SizedBox(height: 4),
                      Text(
                        item.debit > 0 ? _formatAmount(item.debit) : '-',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: item.debit > 0
                              ? Colors.green.shade700
                              : AppTheme.subtitleGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('CREDIT',
                          style: GoogleFonts.lato(
                              fontSize: 10, color: AppTheme.subtitleGray)),
                      const SizedBox(height: 4),
                      Text(
                        item.credit > 0 ? _formatAmount(item.credit) : '-',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: item.credit > 0
                              ? Colors.orange.shade700
                              : AppTheme.subtitleGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('BALANCE',
                          style: GoogleFonts.lato(
                              fontSize: 10, color: AppTheme.subtitleGray)),
                      const SizedBox(height: 4),
                      Text(
                        _formatAmount((item.debit - item.credit).abs()),
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: (item.debit - item.credit) >= 0
                              ? Colors.blue.shade700
                              : Colors.purple.shade700,
                        ),
                        textAlign: TextAlign.end,
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

  void _showFinancialYearDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Select Financial Year',
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkBlue)),
            const SizedBox(height: 16),
            ...['2024-25', '2023-24', '2022-23', '2021-22']
                .map((year) => ListTile(
                      leading: Icon(Icons.calendar_today,
                          size: 20,
                          color: _selectedFinancialYear == year
                              ? AppTheme.primaryDarkBlue
                              : AppTheme.subtitleGray),
                      title: Text(year,
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: _selectedFinancialYear == year
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                      trailing: _selectedFinancialYear == year
                          ? const Icon(Icons.check_circle,
                              color: AppTheme.primaryDarkBlue, size: 20)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedFinancialYear = year;
                        });
                        Navigator.pop(context);
                      },
                    )),
          ],
        ),
      ),
    );
  }

  void _showAsOnDateDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Select As On Date',
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkBlue)),
            const SizedBox(height: 16),
            ...['31 March 2027', '31 March 2026', '31 March 2025']
                .map((date) => ListTile(
                      leading: Icon(Icons.date_range,
                          size: 20,
                          color: _selectedAsOnDate == date
                              ? AppTheme.primaryDarkBlue
                              : AppTheme.subtitleGray),
                      title: Text(date,
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: _selectedAsOnDate == date
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                      trailing: _selectedAsOnDate == date
                          ? const Icon(Icons.check_circle,
                              color: AppTheme.primaryDarkBlue, size: 20)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedAsOnDate = date;
                        });
                        Navigator.pop(context);
                      },
                    )),
          ],
        ),
      ),
    );
  }
}

class TrialBalanceEntry {
  final int id;
  final String accountCode;
  final String accountName;
  final String group;
  final double debit;
  final double credit;

  TrialBalanceEntry({
    required this.id,
    required this.accountCode,
    required this.accountName,
    required this.group,
    required this.debit,
    required this.credit,
  });
}
