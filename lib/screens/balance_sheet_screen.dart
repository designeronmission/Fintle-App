// balance_sheet_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class BalanceSheetScreen extends StatefulWidget {
  const BalanceSheetScreen({super.key});

  @override
  State<BalanceSheetScreen> createState() => _BalanceSheetScreenState();
}

class _BalanceSheetScreenState extends State<BalanceSheetScreen> {
  String _selectedAsOnDate = '31 March 2027';
  String _selectedFinancialYear = '2024-25';
  bool _showLiabilities = true;
  bool _showAssets = true;

  // Balance Sheet Data - Using double values
  final Map<String, dynamic> _balanceSheetData = {
    'Shareholder\'s Funds': {
      'total': 1250000.0,
      'items': [
        {'name': 'Equity Share Capital', 'amount': 1000000.0},
        {'name': 'Reserves & Surplus', 'amount': 250000.0},
      ]
    },
    'Non-Current Liabilities': {
      'total': 540000.0,
      'items': [
        {'name': 'Long Term Borrowings', 'amount': 500000.0},
        {'name': 'Deferred Tax Liabilities', 'amount': 25000.0},
        {'name': 'Other Long Term Liabilities', 'amount': 15000.0},
      ]
    },
    'Current Liabilities': {
      'total': 230000.0,
      'items': [
        {'name': 'Short Term Borrowings', 'amount': 100000.0},
        {'name': 'Trade Payables', 'amount': 75000.0},
        {'name': 'Other Current Liabilities', 'amount': 35000.0},
        {'name': 'Short Term Provisions', 'amount': 20000.0},
      ]
    },
    'Non-Current Assets': {
      'total': 980000.0,
      'items': [
        {'name': 'Property, Plant & Equipment', 'amount': 800000.0},
        {'name': 'Capital Work-in-Progress', 'amount': 50000.0},
        {'name': 'Intangible Assets', 'amount': 30000.0},
        {'name': 'Non-Current Investments', 'amount': 100000.0},
      ]
    },
    'Current Assets': {
      'total': 425000.0,
      'items': [
        {'name': 'Inventories', 'amount': 150000.0},
        {'name': 'Trade Receivables', 'amount': 125000.0},
        {'name': 'Cash & Bank Balances', 'amount': 80000.0},
        {'name': 'Short Term Loans & Advances', 'amount': 45000.0},
        {'name': 'Other Current Assets', 'amount': 25000.0},
      ]
    },
  };

  double get _totalLiabilities {
    return (_balanceSheetData['Shareholder\'s Funds']!['total'] as double) +
        (_balanceSheetData['Non-Current Liabilities']!['total'] as double) +
        (_balanceSheetData['Current Liabilities']!['total'] as double);
  }

  double get _totalAssets {
    return (_balanceSheetData['Non-Current Assets']!['total'] as double) +
        (_balanceSheetData['Current Assets']!['total'] as double);
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
          'Balance Sheet',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share,
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
      body: Column(
        children: [
          // Header Card - Removed Gradient
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryDarkBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.account_balance,
                          size: 24, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Balance Sheet',
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(
                              'As on $_selectedAsOnDate | FY: $_selectedFinancialYear',
                              style: GoogleFonts.lato(
                                  fontSize: 11, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text('Total Assets',
                                style: GoogleFonts.lato(
                                    fontSize: 10, color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text(_formatAmount(_totalAssets),
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text('Total Liabilities',
                                style: GoogleFonts.lato(
                                    fontSize: 10, color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text(_formatAmount(_totalLiabilities),
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (_totalAssets - _totalLiabilities).abs() < 1000
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (_totalAssets - _totalLiabilities).abs() < 1000
                            ? Icons.check_circle
                            : Icons.warning,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        (_totalAssets - _totalLiabilities).abs() < 1000
                            ? 'Balance Sheet Matched'
                            : 'Balance Sheet Not Matched',
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Row
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _showFinancialYearDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: AppTheme.primaryDarkBlue),
                              const SizedBox(width: 8),
                              Text('FY $_selectedFinancialYear',
                                  style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.primaryDarkBlue)),
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              size: 16, color: AppTheme.primaryDarkBlue),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _showAsOnDateDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.date_range,
                                  size: 16, color: AppTheme.primaryDarkBlue),
                              const SizedBox(width: 8),
                              Text(_selectedAsOnDate,
                                  style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.primaryDarkBlue)),
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              size: 16, color: AppTheme.primaryDarkBlue),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Balance Sheet Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Liabilities & Equity Section
                _buildSectionHeader(
                  'Liabilities & Equity',
                  _totalLiabilities,
                  Icons.account_balance,
                  _showLiabilities,
                  () => setState(() => _showLiabilities = !_showLiabilities),
                ),
                if (_showLiabilities) ...[
                  _buildCategoryCard(
                    "Shareholder's Funds",
                    (_balanceSheetData['Shareholder\'s Funds']!['total']
                        as double),
                    (_balanceSheetData['Shareholder\'s Funds']!['items']
                        as List<Map<String, dynamic>>),
                    Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryCard(
                    'Non-Current Liabilities',
                    (_balanceSheetData['Non-Current Liabilities']!['total']
                        as double),
                    (_balanceSheetData['Non-Current Liabilities']!['items']
                        as List<Map<String, dynamic>>),
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryCard(
                    'Current Liabilities',
                    (_balanceSheetData['Current Liabilities']!['total']
                        as double),
                    (_balanceSheetData['Current Liabilities']!['items']
                        as List<Map<String, dynamic>>),
                    Colors.red,
                  ),
                  const SizedBox(height: 12),
                  _buildTotalCard('Total Liabilities', _totalLiabilities,
                      Colors.red.shade700),
                ],

                const SizedBox(height: 20),

                // Assets Section
                _buildSectionHeader(
                  'Assets',
                  _totalAssets,
                  Icons.account_balance_wallet,
                  _showAssets,
                  () => setState(() => _showAssets = !_showAssets),
                ),
                if (_showAssets) ...[
                  _buildCategoryCard(
                    'Non-Current Assets',
                    (_balanceSheetData['Non-Current Assets']!['total']
                        as double),
                    (_balanceSheetData['Non-Current Assets']!['items']
                        as List<Map<String, dynamic>>),
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryCard(
                    'Current Assets',
                    (_balanceSheetData['Current Assets']!['total'] as double),
                    (_balanceSheetData['Current Assets']!['items']
                        as List<Map<String, dynamic>>),
                    Colors.teal,
                  ),
                  const SizedBox(height: 12),
                  _buildTotalCard(
                      'Total Assets', _totalAssets, Colors.green.shade700),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),

          // Bottom Summary
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
                    Text('Total Assets',
                        style: GoogleFonts.lato(
                            fontSize: 11, color: AppTheme.subtitleGray)),
                    Text(_formatAmount(_totalAssets),
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                      width: 1, height: 30, color: Colors.grey.shade200),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Liabilities',
                        style: GoogleFonts.lato(
                            fontSize: 11, color: AppTheme.subtitleGray)),
                    Text(_formatAmount(_totalLiabilities),
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sharing balance sheet...'),
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
                    child:
                        const Icon(Icons.share, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, double total, IconData icon,
      bool isExpanded, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: AppTheme.primaryDarkBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDarkBlue)),
                    const SizedBox(height: 4),
                    Text(_formatAmount(total),
                        style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.subtitleGray)),
                  ],
                ),
              ),
              Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppTheme.subtitleGray),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, double total,
      List<Map<String, dynamic>> items, Color color) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color)),
                Text(_formatAmount(total),
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            ),
          ),

          // Category Items
          ...items.map((item) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['name'] as String,
                        style: GoogleFonts.lato(
                            fontSize: 13, color: AppTheme.subtitleGray)),
                    Text(_formatAmount(item['amount'] as double),
                        style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                  ],
                ),
              )),

          // Divider after items
          if (items.isNotEmpty)
            const Divider(
                height: 1, indent: 16, endIndent: 16, color: Color(0xFFE2E8F0)),

          // Subtotal
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total $title',
                    style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDarkBlue)),
                Text(_formatAmount(total),
                    style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(String title, double total, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.summarize, size: 20, color: color),
              const SizedBox(width: 8),
              Text(title,
                  style: GoogleFonts.lato(
                      fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          Text(_formatAmount(total),
              style: GoogleFonts.lato(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
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
