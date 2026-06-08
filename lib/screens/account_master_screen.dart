// account_master_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class AccountMasterScreen extends StatefulWidget {
  const AccountMasterScreen({super.key});

  @override
  State<AccountMasterScreen> createState() => _AccountMasterScreenState();
}

class _AccountMasterScreenState extends State<AccountMasterScreen> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _openingBalanceController =
      TextEditingController();

  String _selectedGroup = 'Assets';
  String _selectedParent = 'None';
  String _selectedAccountType = 'Assets';

  List<AccountNode> _chartOfAccounts = [];
  List<AccountNode> _filteredAccounts = [];
  String _searchQuery = '';

  final List<String> _mainGroups = [
    'Assets',
    'Liabilities',
    'Equity',
    'Income',
    'Expense'
  ];

  @override
  void initState() {
    super.initState();
    _initializeChartOfAccounts();
  }

  String _formatAmount(double amount) {
    return NumberFormat.currency(symbol: '₹', decimalDigits: 0).format(amount);
  }

  void _initializeChartOfAccounts() {
    _chartOfAccounts = [
      AccountNode(
        code: '1',
        name: 'Assets',
        type: 'Assets',
        level: 0,
        isExpanded: true,
        children: [
          AccountNode(
            code: '1.1',
            name: 'Current Assets',
            type: 'Assets',
            level: 1,
            isExpanded: true,
            children: [
              AccountNode(
                code: '1.1.1',
                name: 'Cash & Bank',
                type: 'Assets',
                level: 2,
                isExpanded: true,
                children: [
                  AccountNode(
                    code: '1.1.1.1',
                    name: 'HDFC Bank',
                    type: 'Assets',
                    level: 3,
                    openingBalance: 845000,
                    children: [],
                  ),
                  AccountNode(
                    code: '1.1.1.2',
                    name: 'SBI Bank',
                    type: 'Assets',
                    level: 3,
                    openingBalance: 425000,
                    children: [],
                  ),
                ],
              ),
              AccountNode(
                code: '1.1.2',
                name: 'Sundry Debtors',
                type: 'Assets',
                level: 2,
                isExpanded: true,
                children: [
                  AccountNode(
                    code: '1.1.2.1',
                    name: 'ABC Enterprises',
                    type: 'Assets',
                    level: 3,
                    openingBalance: 95000,
                    children: [],
                  ),
                ],
              ),
            ],
          ),
          AccountNode(
            code: '1.2',
            name: 'Fixed Assets',
            type: 'Assets',
            level: 1,
            isExpanded: true,
            children: [],
          ),
        ],
      ),
      AccountNode(
        code: '2',
        name: 'Liabilities',
        type: 'Liabilities',
        level: 0,
        isExpanded: true,
        children: [
          AccountNode(
            code: '2.1',
            name: 'Current Liabilities',
            type: 'Liabilities',
            level: 1,
            isExpanded: true,
            children: [
              AccountNode(
                code: '2.1.1',
                name: 'XYZ Suppliers',
                type: 'Liabilities',
                level: 2,
                openingBalance: 185000,
                children: [],
              ),
            ],
          ),
        ],
      ),
      AccountNode(
        code: '3',
        name: 'Equity',
        type: 'Equity',
        level: 0,
        isExpanded: true,
        children: [],
      ),
      AccountNode(
        code: '4',
        name: 'Income',
        type: 'Income',
        level: 0,
        isExpanded: true,
        children: [
          AccountNode(
            code: '4.1',
            name: 'Operating Revenue',
            type: 'Income',
            level: 1,
            isExpanded: true,
            children: [],
          ),
        ],
      ),
      AccountNode(
        code: '5',
        name: 'Expense',
        type: 'Expense',
        level: 0,
        isExpanded: true,
        children: [
          AccountNode(
            code: '5.1',
            name: 'Direct Expenses',
            type: 'Expense',
            level: 1,
            isExpanded: true,
            children: [],
          ),
        ],
      ),
    ];
    _filteredAccounts = _chartOfAccounts;
  }

  void _filterAccounts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredAccounts = _chartOfAccounts;
      } else {
        _filteredAccounts = [];
        for (var node in _chartOfAccounts) {
          var filtered = _filterNode(node, query.toLowerCase());
          if (filtered != null) {
            _filteredAccounts.add(filtered);
          }
        }
      }
    });
  }

  AccountNode? _filterNode(AccountNode node, String query) {
    List<AccountNode> filteredChildren = [];
    for (var child in node.children) {
      var filteredChild = _filterNode(child, query);
      if (filteredChild != null) {
        filteredChildren.add(filteredChild);
      }
    }

    if (node.name.toLowerCase().contains(query) ||
        filteredChildren.isNotEmpty) {
      return AccountNode(
        code: node.code,
        name: node.name,
        type: node.type,
        level: node.level,
        isExpanded: true,
        openingBalance: node.openingBalance,
        children: filteredChildren,
      );
    }
    return null;
  }

  void _showCreateAccountDialog() {
    _accountNameController.clear();
    _openingBalanceController.clear();
    _selectedParent = 'None';
    _selectedAccountType = 'Assets';

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
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.account_tree,
                            color: AppTheme.primaryDarkBlue, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Create Account Head',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDarkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _accountNameController,
                    decoration: InputDecoration(
                      labelText: 'Account Name',
                      hintText: 'Enter account name',
                      prefixIcon:
                          const Icon(Icons.account_balance_wallet, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppTheme.primaryDarkBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedAccountType,
                    decoration: InputDecoration(
                      labelText: 'Account Type',
                      prefixIcon: const Icon(Icons.category, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    items: _mainGroups.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      setStateBottomSheet(() {
                        _selectedAccountType = value!;
                        _selectedGroup = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedParent,
                    decoration: InputDecoration(
                      labelText: 'Parent Group',
                      prefixIcon: const Icon(Icons.account_tree, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    items: _getAvailableParents().map((parent) {
                      return DropdownMenuItem(
                          value: parent, child: Text(parent));
                    }).toList(),
                    onChanged: (value) {
                      setStateBottomSheet(() {
                        _selectedParent = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _openingBalanceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Opening Balance (Optional)',
                      hintText: 'Enter opening balance',
                      prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Cancel',
                              style: GoogleFonts.lato(fontSize: 14)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _createAccountHead();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryDarkBlue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Create Account',
                              style: GoogleFonts.lato(
                                  fontSize: 14, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<String> _getAvailableParents() {
    List<String> parents = ['None'];
    void collectParents(AccountNode node) {
      parents.add(node.name);
      for (var child in node.children) {
        collectParents(child);
      }
    }

    for (var node in _chartOfAccounts) {
      collectParents(node);
    }
    return parents;
  }

  void _createAccountHead() {
    if (_accountNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter account name'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      String newCode = _generateNextCode();
      AccountNode newAccount = AccountNode(
        code: newCode,
        name: _accountNameController.text.trim(),
        type: _selectedAccountType,
        level: 2,
        openingBalance: double.tryParse(_openingBalanceController.text) ?? 0,
        children: [],
      );

      if (_selectedParent == 'None') {
        _chartOfAccounts.add(newAccount);
      } else {
        _addToParent(_chartOfAccounts, _selectedParent, newAccount);
      }

      _filterAccounts(_searchQuery);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Account created successfully'),
          backgroundColor: Colors.green),
    );
  }

  bool _addToParent(
      List<AccountNode> nodes, String parentName, AccountNode newAccount) {
    for (var node in nodes) {
      if (node.name == parentName) {
        node.children.add(newAccount);
        return true;
      }
      if (_addToParent(node.children, parentName, newAccount)) {
        return true;
      }
    }
    return false;
  }

  String _generateNextCode() {
    int maxCode = 0;
    void collectCodes(AccountNode node) {
      int codeNum = int.tryParse(node.code.replaceAll('.', '')) ?? 0;
      if (codeNum > maxCode) maxCode = codeNum;
      for (var child in node.children) {
        collectCodes(child);
      }
    }

    for (var node in _chartOfAccounts) {
      collectCodes(node);
    }
    return (maxCode + 1).toString();
  }

  int _getTotalAccounts() {
    int count = 0;
    void countAccounts(AccountNode node) {
      count++;
      for (var child in node.children) {
        countAccounts(child);
      }
    }

    for (var node in _chartOfAccounts) {
      countAccounts(node);
    }
    return count;
  }

  int _getTotalSubGroups() {
    int count = 0;
    void countSubGroups(AccountNode node) {
      if (node.level > 0) count++;
      for (var child in node.children) {
        countSubGroups(child);
      }
    }

    for (var node in _chartOfAccounts) {
      countSubGroups(node);
    }
    return count;
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
          'Chart of Accounts',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _showCreateAccountDialog,
              icon: const Icon(Icons.add,
                  color: AppTheme.primaryDarkBlue, size: 24),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _filterAccounts,
              decoration: InputDecoration(
                hintText: 'Search accounts...',
                hintStyle:
                    GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade400),
                prefixIcon:
                    const Icon(Icons.search, color: AppTheme.subtitleGray),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppTheme.subtitleGray),
                        onPressed: () => _filterAccounts(''),
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
                  borderSide: const BorderSide(color: AppTheme.primaryDarkBlue),
                ),
              ),
            ),
          ),

          // KPI Cards - Perfect Alignment with Single Line Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                    title: 'Total Accounts',
                    value: _getTotalAccounts().toString(),
                    icon: Icons.account_tree,
                    color: AppTheme.primaryDarkBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKPICard(
                    title: 'Main Groups',
                    value: _mainGroups.length.toString(),
                    icon: Icons.category,
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKPICard(
                    title: 'Sub Groups',
                    value: _getTotalSubGroups().toString(),
                    icon: Icons.account_balance,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section Title - Without left side bar color
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'ACCOUNT HIERARCHY',
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppTheme.subtitleGray,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Chart of Accounts List
          Expanded(
            child: _filteredAccounts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No accounts found',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: AppTheme.subtitleGray,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredAccounts.length,
                    itemBuilder: (context, index) {
                      return _buildAccountTree(_filteredAccounts[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateAccountDialog,
        backgroundColor: AppTheme.primaryDarkBlue,
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.subtitleGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTree(AccountNode node) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (node.children.isNotEmpty) {
              setState(() {
                node.isExpanded = !node.isExpanded;
              });
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getTypeColor(node.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_getTypeIcon(node.type),
                            size: 18, color: _getTypeColor(node.type)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              node.name,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            if (node.openingBalance > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  'Opening Balance: ${_formatAmount(node.openingBalance)}',
                                  style: GoogleFonts.lato(
                                      fontSize: 10,
                                      color: AppTheme.subtitleGray),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getTypeColor(node.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          node.code,
                          style: GoogleFonts.lato(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getTypeColor(node.type)),
                        ),
                      ),
                      if (node.children.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Icon(
                          node.isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: AppTheme.subtitleGray,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
                if (node.children.isNotEmpty && node.isExpanded)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 0, bottom: 8, right: 0),
                    child: Column(
                      children: node.children
                          .map((child) => _buildAccountTree(child))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Assets':
        return const Color(0xFF2196F3);
      case 'Liabilities':
        return const Color(0xFFEF4444);
      case 'Equity':
        return const Color(0xFF8B5CF6);
      case 'Income':
        return const Color(0xFF10B981);
      case 'Expense':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Assets':
        return Icons.account_balance_wallet;
      case 'Liabilities':
        return Icons.credit_card;
      case 'Equity':
        return Icons.people;
      case 'Income':
        return Icons.trending_up;
      case 'Expense':
        return Icons.trending_down;
      default:
        return Icons.account_tree;
    }
  }
}

class AccountNode {
  final String code;
  final String name;
  final String type;
  final int level;
  bool isExpanded;
  final double openingBalance;
  List<AccountNode> children;

  AccountNode({
    required this.code,
    required this.name,
    required this.type,
    required this.level,
    this.isExpanded = false,
    this.openingBalance = 0,
    this.children = const [],
  });
}
