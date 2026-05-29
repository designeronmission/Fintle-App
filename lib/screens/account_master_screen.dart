import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

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

  List<AccountNode> _allAccounts = [];
  List<AccountNode> _filteredAccounts = [];

  @override
  void initState() {
    super.initState();
    _initializeAccounts();
    _filteredAccounts = List.from(_allAccounts);
    _searchController.addListener(_filterAccounts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            isExpanded: true,
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
            id: '1.2',
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
            isExpanded: true,
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

  void _toggleNodeExpansion(AccountNode node) {
    setState(() {
      node.isExpanded = !node.isExpanded;
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Account updated successfully!'),
                  backgroundColor: Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating),
            );
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Account created successfully!'),
                  backgroundColor: Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating),
            );
          }
        },
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Chart of Accounts',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue),
        ),
        actions: [
          IconButton(
            onPressed: () => _showEditAccountDialog(),
            icon: const Icon(Icons.add_circle_outline,
                color: AppTheme.primaryDarkBlue, size: 24),
          ),
        ],
      ),
      body: Column(
        children: [
          // KPI Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                      'Total Accounts',
                      _countAllAccounts(_allAccounts).toString(),
                      Icons.account_balance,
                      AppTheme.primaryDarkBlue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                      'Asset Total',
                      '₹${NumberFormat('#,##0').format(_calculateTypeTotal(AccountType.assets))}',
                      Icons.trending_up,
                      const Color(0xFF10B981)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                      'Liability Total',
                      '₹${NumberFormat('#,##0').format(_calculateTypeTotal(AccountType.liabilities))}',
                      Icons.trending_down,
                      const Color(0xFFEF4444)),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.lato(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by account name, code or description...',
                  hintStyle: GoogleFonts.lato(
                      fontSize: 13, color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.search,
                      size: 20, color: AppTheme.subtitleGray),
                  suffixIcon: _isSearchActive
                      ? IconButton(
                          icon: const Icon(Icons.close,
                              size: 18, color: AppTheme.subtitleGray),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Account List
          Expanded(
            child: _filteredAccounts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('No accounts found',
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.subtitleGray)),
                        const SizedBox(height: 8),
                        Text('Try adjusting your search',
                            style: GoogleFonts.lato(
                                fontSize: 13, color: AppTheme.subtitleGray)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredAccounts.length,
                    itemBuilder: (context, index) {
                      return _buildAccountTreeTile(_filteredAccounts[index], 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.lato(fontSize: 10, color: AppTheme.subtitleGray),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTreeTile(AccountNode node, int depth) {
    final typeColor = _getAccountTypeColor(node.type);
    final hasChildren = node.children != null && node.children!.isNotEmpty;
    final isParent = hasChildren;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color:
                isParent ? AppTheme.lightBlueBg.withOpacity(0.5) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isParent
                    ? typeColor.withOpacity(0.3)
                    : Colors.grey.shade200),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (hasChildren) {
                  _toggleNodeExpansion(node);
                } else {
                  _showEditAccountDialog(existingAccount: node);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 8 + (depth * 20.0), right: 12, top: 10, bottom: 10),
                child: Row(
                  children: [
                    // Expand/Collapse Icon
                    SizedBox(
                      width: 24,
                      child: hasChildren
                          ? AnimatedRotation(
                              turns: node.isExpanded ? 0.25 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(Icons.chevron_right,
                                  size: 20, color: AppTheme.primaryDarkBlue),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 4),

                    // Account Type Icon
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(_getAccountTypeIcon(node.type),
                          size: 16, color: typeColor),
                    ),
                    const SizedBox(width: 10),

                    // Account Name and Code
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            node.name,
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              fontWeight:
                                  isParent ? FontWeight.bold : FontWeight.w600,
                              color: isParent
                                  ? AppTheme.primaryDarkBlue
                                  : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  node.code,
                                  style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.subtitleGray),
                                ),
                              ),
                              if (!isParent) ...[
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    node.description,
                                    style: GoogleFonts.lato(
                                        fontSize: 10,
                                        color: AppTheme.subtitleGray),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Balance and Actions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isParent)
                          Text(
                            '₹${NumberFormat('#,##0').format(node.openingBalance)}',
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: node.openingBalance >= 0
                                  ? Colors.black87
                                  : const Color(0xFFEF4444),
                            ),
                          ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isParent)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: typeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _getAccountTypeLabel(node.type),
                                  style: GoogleFonts.lato(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: typeColor),
                                ),
                              ),
                            if (isParent) ...[
                              Text(
                                '${_countChildren(node)}',
                                style: GoogleFonts.lato(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.subtitleGray),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.folder_outlined,
                                  size: 14, color: typeColor),
                            ],
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                if (isParent) {
                                  _showEditAccountDialog(parentNode: node);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isParent
                                      ? typeColor.withOpacity(0.1)
                                      : AppTheme.lightBlueBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isParent ? Icons.add : Icons.edit_outlined,
                                  size: 14,
                                  color: isParent
                                      ? typeColor
                                      : AppTheme.primaryDarkBlue,
                                ),
                              ),
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
        ),

        // Children
        if (hasChildren && node.isExpanded)
          ...node.children!
              .map((child) => _buildAccountTreeTile(child, depth + 1)),
      ],
    );
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
        return const Color(0xFF3B82F6);
      case AccountType.liabilities:
        return const Color(0xFFEF4444);
      case AccountType.equity:
        return const Color(0xFF8B5CF6);
      case AccountType.income:
        return const Color(0xFF10B981);
      case AccountType.expenses:
        return const Color(0xFFF59E0B);
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
            color: Colors.white,
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
                    color: Colors.grey.shade300,
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
                        color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.account_balance,
                          color: AppTheme.primaryDarkBlue, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isEditing ? 'Update Account' : 'New Account',
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDarkBlue),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlueBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.close,
                            size: 18, color: AppTheme.primaryDarkBlue),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFE2E8F0)),

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
                              color: AppTheme.lightBlueBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppTheme.primaryDarkBlue
                                      .withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.subdirectory_arrow_right,
                                    color: AppTheme.primaryDarkBlue, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Parent Account',
                                          style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: AppTheme.subtitleGray)),
                                      const SizedBox(height: 2),
                                      Text(widget.parentNode!.name,
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.primaryDarkBlue)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryDarkBlue
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(widget.parentNode!.code,
                                      style: GoogleFonts.lato(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primaryDarkBlue)),
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
                          hint: 'Enter account name',
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
                          hint: 'Enter account code',
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
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
                                  color: Colors.grey.shade600, size: 20),
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
                                              BorderRadius.circular(6),
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
                          hint: 'Enter opening balance',
                          icon: Icons.account_balance_wallet_outlined,
                          keyboardType: TextInputType.number,
                          prefixText: '₹ ',
                        ),

                        const SizedBox(height: 20),

                        // Description
                        _buildSectionLabel('Description'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _descriptionController,
                          hint: 'Enter description (optional)',
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
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text('Cancel',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.subtitleGray)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: _saveAccount,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryDarkBlue,
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
                                      color: Colors.white),
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
      label.toUpperCase(),
      style: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.subtitleGray,
          letterSpacing: 0.5),
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
        hintStyle: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade400),
        prefixIcon: prefixText != null
            ? null
            : Icon(icon, size: 18, color: Colors.grey.shade400),
        prefixText: prefixText,
        prefixStyle: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryDarkBlue),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppTheme.primaryDarkBlue, width: 2)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Color _getTypeColor(AccountType type) {
    switch (type) {
      case AccountType.assets:
        return const Color(0xFF3B82F6);
      case AccountType.liabilities:
        return const Color(0xFFEF4444);
      case AccountType.equity:
        return const Color(0xFF8B5CF6);
      case AccountType.income:
        return const Color(0xFF10B981);
      case AccountType.expenses:
        return const Color(0xFFF59E0B);
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
