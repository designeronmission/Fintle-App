import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

// ==================== THEME COLORS ====================
class AppColors {
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF1E3A8A);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF8B5CF6);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color cardShadow = Color(0x0D000000);
}

// ==================== ACCOUNT MASTER SCREEN ====================
class AccountMasterScreen extends StatefulWidget {
  const AccountMasterScreen({super.key});

  @override
  State<AccountMasterScreen> createState() => _AccountMasterScreenState();
}

class _AccountMasterScreenState extends State<AccountMasterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchActive = false;
  final ScrollController _scrollController = ScrollController();
  bool _isSearchSticky = false;

  List<AccountNode> _allAccounts = [];
  List<AccountNode> _filteredAccounts = [];
  Set<String> _expandedSections = {};

  @override
  void initState() {
    super.initState();
    _initializeAccounts();
    _filteredAccounts = List.from(_allAccounts);
    _expandedSections.addAll(_allAccounts.map((e) => e.id));
    _searchController.addListener(_filterAccounts);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAccounts);
    _scrollController.removeListener(_scrollListener);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    const kpiHeight = 180.0;
    setState(() {
      _isSearchSticky = _scrollController.offset >= kpiHeight;
    });
  }

  void _initializeAccounts() {
    _allAccounts = [
      AccountNode(
        id: '1',
        name: 'Assets',
        code: '1000',
        type: AccountType.assets,
        openingBalance: 0,
        description: 'All company assets',
        isExpanded: true,
        children: [
          AccountNode(
            id: '1.1',
            name: 'Current Assets',
            code: '1100',
            type: AccountType.assets,
            openingBalance: 0,
            description: 'Short-term assets',
            isExpanded: false,
            children: [
              AccountNode(
                  id: '1.1.1',
                  name: 'Cash in Hand',
                  code: '1101',
                  type: AccountType.assets,
                  openingBalance: 50000,
                  description: 'Physical cash available'),
              AccountNode(
                  id: '1.1.2',
                  name: 'Bank Account - HDFC',
                  code: '1102',
                  type: AccountType.assets,
                  openingBalance: 250000,
                  description: 'Main business account'),
              AccountNode(
                  id: '1.1.3',
                  name: 'Bank Account - ICICI',
                  code: '1103',
                  type: AccountType.assets,
                  openingBalance: 150000,
                  description: 'Secondary business account'),
              AccountNode(
                  id: '1.1.4',
                  name: 'Accounts Receivable',
                  code: '1104',
                  type: AccountType.assets,
                  openingBalance: 75000,
                  description: 'Money owed by customers'),
              AccountNode(
                  id: '1.1.5',
                  name: 'Inventory',
                  code: '1105',
                  type: AccountType.assets,
                  openingBalance: 320000,
                  description: 'Stock of goods'),
            ],
          ),
          AccountNode(
            id: '1.20',
            name: 'Fixed Assets',
            code: '1200',
            type: AccountType.assets,
            openingBalance: 0,
            description: 'Long-term assets',
            children: [
              AccountNode(
                  id: '1.2.1',
                  name: 'Office Equipment',
                  code: '1201',
                  type: AccountType.assets,
                  openingBalance: 180000,
                  description: 'Computers, printers, etc.'),
              AccountNode(
                  id: '1.2.2',
                  name: 'Furniture & Fixtures',
                  code: '1202',
                  type: AccountType.assets,
                  openingBalance: 120000,
                  description: 'Office furniture'),
              AccountNode(
                  id: '1.2.3',
                  name: 'Vehicles',
                  code: '1203',
                  type: AccountType.assets,
                  openingBalance: 500000,
                  description: 'Company vehicles'),
            ],
          ),
          AccountNode(
              id: '1.3',
              name: 'Investments',
              code: '1300',
              type: AccountType.assets,
              openingBalance: 200000,
              description: 'Long-term investments'),
        ],
      ),
      AccountNode(
        id: '2',
        name: 'Liabilities',
        code: '2000',
        type: AccountType.liabilities,
        openingBalance: 0,
        description: 'All company liabilities',
        children: [
          AccountNode(
            id: '2.1',
            name: 'Current Liabilities',
            code: '2100',
            type: AccountType.liabilities,
            openingBalance: 0,
            description: 'Short-term obligations',
            children: [
              AccountNode(
                  id: '2.1.1',
                  name: 'Accounts Payable',
                  code: '2101',
                  type: AccountType.liabilities,
                  openingBalance: 85000,
                  description: 'Money owed to suppliers'),
              AccountNode(
                  id: '2.1.2',
                  name: 'Short-term Loans',
                  code: '2102',
                  type: AccountType.liabilities,
                  openingBalance: 100000,
                  description: 'Loans due within 1 year'),
              AccountNode(
                  id: '2.1.3',
                  name: 'Tax Payable',
                  code: '2103',
                  type: AccountType.liabilities,
                  openingBalance: 45000,
                  description: 'Taxes due'),
            ],
          ),
          AccountNode(
            id: '2.2',
            name: 'Long-term Liabilities',
            code: '2200',
            type: AccountType.liabilities,
            openingBalance: 0,
            description: 'Long-term obligations',
            children: [
              AccountNode(
                  id: '2.2.1',
                  name: 'Bank Loan',
                  code: '2201',
                  type: AccountType.liabilities,
                  openingBalance: 500000,
                  description: 'Long-term bank loan'),
            ],
          ),
        ],
      ),
      AccountNode(
        id: '3',
        name: 'Equity',
        code: '3000',
        type: AccountType.equity,
        openingBalance: 0,
        description: 'Owner\'s equity',
        children: [
          AccountNode(
              id: '3.1',
              name: 'Share Capital',
              code: '3100',
              type: AccountType.equity,
              openingBalance: 1000000,
              description: 'Initial investment'),
          AccountNode(
              id: '3.2',
              name: 'Retained Earnings',
              code: '3200',
              type: AccountType.equity,
              openingBalance: 350000,
              description: 'Accumulated profits'),
        ],
      ),
      AccountNode(
        id: '4',
        name: 'Income',
        code: '4000',
        type: AccountType.income,
        openingBalance: 0,
        description: 'All income sources',
        isExpanded: true,
        children: [
          AccountNode(
            id: '4.1',
            name: 'Operating Income',
            code: '4100',
            type: AccountType.income,
            openingBalance: 0,
            description: 'Income from operations',
            children: [
              AccountNode(
                  id: '4.1.1',
                  name: 'Sales Revenue',
                  code: '4101',
                  type: AccountType.income,
                  openingBalance: 0,
                  description: 'Revenue from sales'),
              AccountNode(
                  id: '4.1.2',
                  name: 'Service Income',
                  code: '4102',
                  type: AccountType.income,
                  openingBalance: 0,
                  description: 'Income from services'),
            ],
          ),
          AccountNode(
            id: '4.2',
            name: 'Other Income',
            code: '4200',
            type: AccountType.income,
            openingBalance: 0,
            description: 'Non-operating income',
            children: [
              AccountNode(
                  id: '4.2.1',
                  name: 'Interest Income',
                  code: '4201',
                  type: AccountType.income,
                  openingBalance: 0,
                  description: 'Interest earned'),
              AccountNode(
                  id: '4.2.2',
                  name: 'Dividend Income',
                  code: '4202',
                  type: AccountType.income,
                  openingBalance: 0,
                  description: 'Dividends received'),
            ],
          ),
        ],
      ),
      AccountNode(
        id: '5',
        name: 'Expenses',
        code: '5000',
        type: AccountType.expenses,
        openingBalance: 0,
        description: 'All expenses',
        children: [
          AccountNode(
            id: '5.1',
            name: 'Operating Expenses',
            code: '5100',
            type: AccountType.expenses,
            openingBalance: 0,
            description: 'Day-to-day expenses',
            children: [
              AccountNode(
                  id: '5.1.1',
                  name: 'Rent Expense',
                  code: '5101',
                  type: AccountType.expenses,
                  openingBalance: 0,
                  description: 'Office rent'),
              AccountNode(
                  id: '5.1.2',
                  name: 'Salary Expense',
                  code: '5102',
                  type: AccountType.expenses,
                  openingBalance: 0,
                  description: 'Employee salaries'),
              AccountNode(
                  id: '5.1.3',
                  name: 'Utility Expense',
                  code: '5103',
                  type: AccountType.expenses,
                  openingBalance: 0,
                  description: 'Electricity, water, etc.'),
              AccountNode(
                  id: '5.1.4',
                  name: 'Office Supplies',
                  code: '5104',
                  type: AccountType.expenses,
                  openingBalance: 0,
                  description: 'Stationery and supplies'),
            ],
          ),
          AccountNode(
            id: '5.2',
            name: 'Administrative Expenses',
            code: '5200',
            type: AccountType.expenses,
            openingBalance: 0,
            description: 'Admin-related expenses',
            children: [
              AccountNode(
                  id: '5.2.1',
                  name: 'Legal Fees',
                  code: '5201',
                  type: AccountType.expenses,
                  openingBalance: 0,
                  description: 'Legal consultation charges'),
              AccountNode(
                  id: '5.2.2',
                  name: 'Insurance Expense',
                  code: '5202',
                  type: AccountType.expenses,
                  openingBalance: 0,
                  description: 'Insurance premiums'),
            ],
          ),
        ],
      ),
    ];
  }

  void _filterAccounts() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _isSearchActive = _searchQuery.isNotEmpty;
      if (_searchQuery.isEmpty) {
        _filteredAccounts = List.from(_allAccounts);
      } else {
        _filteredAccounts = _filterAccountsRecursive(_allAccounts);
      }
    });
  }

  List<AccountNode> _filterAccountsRecursive(List<AccountNode> nodes) {
    List<AccountNode> filteredNodes = [];
    for (var node in nodes) {
      bool matches = node.name.toLowerCase().contains(_searchQuery) ||
          node.code.toLowerCase().contains(_searchQuery) ||
          node.description.toLowerCase().contains(_searchQuery);
      List<AccountNode>? filteredChildren;
      if (node.children != null) {
        filteredChildren = _filterAccountsRecursive(node.children!);
      }
      if (matches ||
          (filteredChildren != null && filteredChildren.isNotEmpty)) {
        AccountNode filteredNode = AccountNode(
          id: node.id,
          name: node.name,
          code: node.code,
          type: node.type,
          openingBalance: node.openingBalance,
          description: node.description,
          isExpanded: true,
          children: filteredChildren ?? node.children,
        );
        filteredNodes.add(filteredNode);
      }
    }
    return filteredNodes;
  }

  void _toggleExpansion(String id) {
    setState(() {
      if (_expandedSections.contains(id)) {
        _expandedSections.remove(id);
      } else {
        _expandedSections.add(id);
      }
    });
  }

  void _showEditAccountDialog(
      {AccountNode? parentNode, AccountNode? existingAccount}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditAccountForm(
        parentNode: parentNode,
        existingAccount: existingAccount,
        onSave: (account) {
          if (existingAccount != null) {
            setState(() {
              existingAccount.name = account.name;
              existingAccount.code = account.code;
              existingAccount.type = account.type;
              existingAccount.openingBalance = account.openingBalance;
              existingAccount.description = account.description;
            });
            _showSnackBar('Account updated successfully!');
          } else {
            setState(() {
              AccountNode newNode = AccountNode(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: account.name,
                code: account.code,
                type: account.type,
                openingBalance: account.openingBalance,
                description: account.description,
              );
              if (parentNode != null) {
                parentNode.children ??= [];
                parentNode.children!.add(newNode);
              } else {
                _allAccounts.add(newNode);
              }
            });
            _showSnackBar('Account created successfully!');
          }
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalAccounts = _countAllAccounts(_filteredAccounts);
    final totalAssets = _calculateTypeTotal(AccountType.assets);
    final totalLiabilities = _calculateTypeTotal(AccountType.liabilities);
    final totalEquity = _calculateTypeTotal(AccountType.equity);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.primary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Chart of Accounts',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary),
        ),
        actions: [
          IconButton(
            onPressed: () => _showEditAccountDialog(),
            icon: const Icon(Icons.add_circle_outline,
                color: AppColors.primary, size: 24),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo is ScrollUpdateNotification) {
                      _scrollListener();
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // KPI Cards - Matching Customer Screen UI
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Total Accounts Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primary.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Accounts',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          totalAccounts.toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Chart of Accounts',
                                          style: GoogleFonts.lato(
                                            fontSize: 10,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.account_balance,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Two Cards Row
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total Assets',
                                                style: GoogleFonts.lato(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.success
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.trending_up,
                                                  size: 14,
                                                  color: AppColors.success,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '₹${NumberFormat('#,##0').format(totalAssets)}',
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Total asset value',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total Liabilities',
                                                style: GoogleFonts.lato(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.error
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.trending_down,
                                                  size: 14,
                                                  color: AppColors.error,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '₹${NumberFormat('#,##0').format(totalLiabilities)}',
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Total liability value',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Equity Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Equity',
                                          style: GoogleFonts.lato(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${NumberFormat('#,##0').format(totalEquity)}',
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'Owner\'s equity',
                                          style: GoogleFonts.lato(
                                            fontSize: 10,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.info.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.trending_up,
                                        size: 20,
                                        color: AppColors.info,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Search Bar
                        Container(
                          color: AppColors.background,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: GoogleFonts.lato(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText:
                                      'Search by account name, code or description...',
                                  hintStyle: GoogleFonts.lato(
                                      fontSize: 12, color: AppColors.textHint),
                                  prefixIcon: const Icon(Icons.search,
                                      size: 16, color: AppColors.textSecondary),
                                  suffixIcon: _isSearchActive
                                      ? IconButton(
                                          icon: const Icon(Icons.close,
                                              size: 16,
                                              color: AppColors.textSecondary),
                                          onPressed: () =>
                                              _searchController.clear(),
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Account List
                        if (_filteredAccounts.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.account_balance_outlined,
                                      size: 60, color: Colors.grey.shade300),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No accounts found',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Try adjusting your search',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredAccounts.length,
                            itemBuilder: (context, index) {
                              return _buildAccordionItem(
                                  _filteredAccounts[index]);
                            },
                          ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Sticky Search Bar
          if (_isSearchSticky)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.background,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.lato(fontSize: 13),
                    decoration: InputDecoration(
                      hintText:
                          'Search by account name, code or description...',
                      hintStyle: GoogleFonts.lato(
                          fontSize: 12, color: AppColors.textHint),
                      prefixIcon: const Icon(Icons.search,
                          size: 16, color: AppColors.textSecondary),
                      suffixIcon: _isSearchActive
                          ? IconButton(
                              icon: const Icon(Icons.close,
                                  size: 16, color: AppColors.textSecondary),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
            ),

          // Create Account Button - Professional Floating Button
          Positioned(
            bottom: 16,
            right: 16,
            child: SafeArea(
              child: ElevatedButton.icon(
                onPressed: () => _showEditAccountDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  'Create Account',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.primary.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionItem(AccountNode node) {
    final typeColor = _getAccountTypeColor(node.type);
    final hasChildren = node.children != null && node.children!.isNotEmpty;
    final isExpanded = _expandedSections.contains(node.id);
    final totalBalance = _calculateNodeTotal(node);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (hasChildren) {
                  _toggleExpansion(node.id);
                } else {
                  _showEditAccountDialog(existingAccount: node);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Type Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_getAccountTypeIcon(node.type),
                          size: 18, color: typeColor),
                    ),
                    const SizedBox(width: 12),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  node.name,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (hasChildren)
                                Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: AppColors.textSecondary,
                                  size: 18,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.borderLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  node.code,
                                  style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  node.description,
                                  style: GoogleFonts.lato(
                                      fontSize: 11, color: AppColors.textHint),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Balance & Actions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          hasChildren
                              ? '₹${NumberFormat('#,##0').format(totalBalance)}'
                              : '₹${NumberFormat('#,##0').format(node.openingBalance)}',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: totalBalance >= 0
                                ? AppColors.textPrimary
                                : AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasChildren) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.borderLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.folder_outlined,
                                        size: 10,
                                        color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_countChildren(node)}',
                                      style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            // Professional Add Button for Parent
                            if (hasChildren)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: typeColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _showEditAccountDialog(parentNode: node);
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.add,
                                          size: 12, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Add',
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              // Edit Icon for Leaf Nodes
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.edit_outlined,
                                    size: 14, color: AppColors.primary),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Children (Accordion Content)
          if (hasChildren && isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: node.children!
                    .map((child) => _buildChildAccountTile(child))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChildAccountTile(AccountNode node) {
    final typeColor = _getAccountTypeColor(node.type);
    final hasGrandChildren = node.children != null && node.children!.isNotEmpty;

    if (hasGrandChildren) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.borderLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _toggleExpansion(node.id),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(_getAccountTypeIcon(node.type),
                            size: 14, color: typeColor),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              node.name,
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    node.code,
                                    style: GoogleFonts.lato(
                                        fontSize: 9,
                                        color: AppColors.textSecondary),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    node.description,
                                    style: GoogleFonts.lato(
                                        fontSize: 10,
                                        color: AppColors.textHint),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${NumberFormat('#,##0').format(_calculateNodeTotal(node))}',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: typeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _getAccountTypeLabel(node.type),
                                  style: GoogleFonts.lato(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      color: typeColor),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.chevron_right,
                                  size: 14,
                                  color: _expandedSections.contains(node.id)
                                      ? typeColor
                                      : AppColors.textHint),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_expandedSections.contains(node.id))
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: node.children!
                      .map((child) => _buildLeafAccountTile(child))
                      .toList(),
                ),
              ),
          ],
        ),
      );
    }

    return _buildLeafAccountTile(node);
  }

  Widget _buildLeafAccountTile(AccountNode node) {
    final typeColor = _getAccountTypeColor(node.type);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => _showEditAccountDialog(existingAccount: node),
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_getAccountTypeIcon(node.type),
                  size: 14, color: typeColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    node.name,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          node.code,
                          style: GoogleFonts.lato(
                              fontSize: 9, color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          node.description,
                          style: GoogleFonts.lato(
                              fontSize: 9, color: AppColors.textHint),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${NumberFormat('#,##0').format(node.openingBalance)}',
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getAccountTypeLabel(node.type),
                    style: GoogleFonts.lato(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: typeColor),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.edit_outlined,
                  size: 12, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateNodeTotal(AccountNode node) {
    if (node.children == null || node.children!.isEmpty) {
      return node.openingBalance;
    }
    double total = 0;
    for (var child in node.children!) {
      total += _calculateNodeTotal(child);
    }
    return total;
  }

  int _countAllAccounts(List<AccountNode> nodes) {
    int count = 0;
    for (var node in nodes) {
      if (node.children == null || node.children!.isEmpty) {
        count++;
      } else {
        count += _countAllAccounts(node.children!);
      }
    }
    return count;
  }

  int _countChildren(AccountNode node) {
    if (node.children == null) return 0;
    int count = 0;
    for (var child in node.children!) {
      if (child.children == null || child.children!.isEmpty) {
        count++;
      } else {
        count += _countChildren(child);
      }
    }
    return count;
  }

  double _calculateTypeTotal(AccountType type) {
    return _calculateTypeTotalRecursive(_allAccounts, type);
  }

  double _calculateTypeTotalRecursive(
      List<AccountNode> nodes, AccountType type) {
    double total = 0;
    for (var node in nodes) {
      if (node.type == type &&
          (node.children == null || node.children!.isEmpty)) {
        total += node.openingBalance;
      }
      if (node.children != null) {
        total += _calculateTypeTotalRecursive(node.children!, type);
      }
    }
    return total;
  }

  Color _getAccountTypeColor(AccountType type) {
    switch (type) {
      case AccountType.assets:
        return AppColors.primaryLight;
      case AccountType.liabilities:
        return AppColors.error;
      case AccountType.equity:
        return AppColors.info;
      case AccountType.income:
        return AppColors.success;
      case AccountType.expenses:
        return AppColors.warning;
    }
  }

  IconData _getAccountTypeIcon(AccountType type) {
    switch (type) {
      case AccountType.assets:
        return Icons.account_balance_wallet;
      case AccountType.liabilities:
        return Icons.credit_card;
      case AccountType.equity:
        return Icons.trending_up;
      case AccountType.income:
        return Icons.arrow_circle_up;
      case AccountType.expenses:
        return Icons.arrow_circle_down;
    }
  }

  String _getAccountTypeLabel(AccountType type) {
    switch (type) {
      case AccountType.assets:
        return 'Asset';
      case AccountType.liabilities:
        return 'Liability';
      case AccountType.equity:
        return 'Equity';
      case AccountType.income:
        return 'Income';
      case AccountType.expenses:
        return 'Expense';
    }
  }
}

// ==================== ACCOUNT NODE MODEL ====================
enum AccountType { assets, liabilities, equity, income, expenses }

class AccountNode {
  final String id;
  String name;
  String code;
  AccountType type;
  double openingBalance;
  String description;
  bool isExpanded;
  List<AccountNode>? children;

  AccountNode({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.openingBalance,
    required this.description,
    this.isExpanded = false,
    this.children,
  });
}

// ==================== EDIT ACCOUNT FORM ====================
class EditAccountForm extends StatefulWidget {
  final AccountNode? parentNode;
  final AccountNode? existingAccount;
  final Function(AccountNode) onSave;

  const EditAccountForm(
      {super.key, this.parentNode, this.existingAccount, required this.onSave});

  @override
  State<EditAccountForm> createState() => _EditAccountFormState();
}

class _EditAccountFormState extends State<EditAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountCodeController = TextEditingController();
  final TextEditingController _openingBalanceController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  AccountType _selectedType = AccountType.assets;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingAccount != null;
    if (_isEditing) {
      _accountNameController.text = widget.existingAccount!.name;
      _accountCodeController.text = widget.existingAccount!.code;
      _openingBalanceController.text =
          widget.existingAccount!.openingBalance.toString();
      _descriptionController.text = widget.existingAccount!.description;
      _selectedType = widget.existingAccount!.type;
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountCodeController.dispose();
    _openingBalanceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      final account = AccountNode(
        id: widget.existingAccount?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _accountNameController.text.trim(),
        code: _accountCodeController.text.trim(),
        type: _selectedType,
        openingBalance:
            double.tryParse(_openingBalanceController.text.trim()) ?? 0,
        description: _descriptionController.text.trim(),
      );
      widget.onSave(account);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2)),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.account_balance,
                          color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isEditing ? 'Update Account' : 'Create New Account',
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.close,
                            size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: AppColors.border),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Parent Account
                        if (widget.parentNode != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.subdirectory_arrow_right,
                                    color: AppColors.primary, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Parent Account',
                                          style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: AppColors.textSecondary)),
                                      const SizedBox(height: 2),
                                      Text(widget.parentNode!.name,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(widget.parentNode!.code,
                                      style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary)),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Account Name
                        _buildSectionLabel('Account Name'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _accountNameController,
                          hint: 'e.g., Cash in Hand',
                          icon: Icons.account_balance_outlined,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Please enter account name'
                              : null,
                        ),

                        const SizedBox(height: 20),

                        // Account Code
                        _buildSectionLabel('Account Code'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _accountCodeController,
                          hint: 'e.g., 1101',
                          icon: Icons.qr_code,
                          keyboardType: TextInputType.number,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Please enter account code'
                              : null,
                        ),

                        const SizedBox(height: 20),

                        // Account Type
                        _buildSectionLabel('Account Type'),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<AccountType>(
                              value: _selectedType,
                              isExpanded: true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 14),
                              ),
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.textSecondary, size: 20),
                              items: AccountType.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: _getTypeColor(type)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(_getTypeIcon(type),
                                            size: 16,
                                            color: _getTypeColor(type)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(_getTypeLabel(type),
                                          style:
                                              GoogleFonts.lato(fontSize: 14)),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null)
                                  setState(() => _selectedType = value);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Opening Balance
                        _buildSectionLabel('Opening Balance'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _openingBalanceController,
                          hint: '0.00',
                          icon: Icons.account_balance_wallet_outlined,
                          keyboardType: TextInputType.number,
                          prefixText: '₹ ',
                        ),

                        const SizedBox(height: 20),

                        // Description
                        _buildSectionLabel('Description (Optional)'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _descriptionController,
                          hint: 'Add a description for this account',
                          icon: Icons.description_outlined,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  side: BorderSide(color: AppColors.border),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Cancel',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: _saveAccount,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: Text(
                                  _isEditing
                                      ? 'Update Account'
                                      : 'Create Account',
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.surface),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.3),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? prefixText,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.lato(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.lato(fontSize: 14, color: AppColors.textHint),
        prefixIcon: prefixText != null
            ? null
            : Icon(icon, size: 18, color: AppColors.textHint),
        prefixText: prefixText,
        prefixStyle: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: true,
        fillColor: AppColors.surface,
      ),
      validator: validator,
    );
  }

  Color _getTypeColor(AccountType type) {
    switch (type) {
      case AccountType.assets:
        return AppColors.primaryLight;
      case AccountType.liabilities:
        return AppColors.error;
      case AccountType.equity:
        return AppColors.info;
      case AccountType.income:
        return AppColors.success;
      case AccountType.expenses:
        return AppColors.warning;
    }
  }

  IconData _getTypeIcon(AccountType type) {
    switch (type) {
      case AccountType.assets:
        return Icons.account_balance_wallet;
      case AccountType.liabilities:
        return Icons.credit_card;
      case AccountType.equity:
        return Icons.trending_up;
      case AccountType.income:
        return Icons.arrow_circle_up;
      case AccountType.expenses:
        return Icons.arrow_circle_down;
    }
  }

  String _getTypeLabel(AccountType type) {
    switch (type) {
      case AccountType.assets:
        return 'Assets';
      case AccountType.liabilities:
        return 'Liabilities';
      case AccountType.equity:
        return 'Equity';
      case AccountType.income:
        return 'Income';
      case AccountType.expenses:
        return 'Expenses';
    }
  }
}
