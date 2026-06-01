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
}

// ==================== BANK PAYMENT MODEL ====================
class BankPayment {
  final String id;
  final String paymentNo;
  final DateTime paymentDate;
  final String bankAccount;
  final String recipient;
  final String accountHead;
  final String ledgerAccount;
  final String description;
  final double amount;
  final String status;
  final String transactionId;

  BankPayment({
    required this.id,
    required this.paymentNo,
    required this.paymentDate,
    required this.bankAccount,
    required this.recipient,
    required this.accountHead,
    required this.ledgerAccount,
    required this.description,
    required this.amount,
    required this.status,
    required this.transactionId,
  });
}

// ==================== MAIN BANK PAYMENT LIST SCREEN ====================
class BankPaymentScreen extends StatefulWidget {
  const BankPaymentScreen({super.key});

  @override
  State<BankPaymentScreen> createState() => _BankPaymentScreenState();
}

class _BankPaymentScreenState extends State<BankPaymentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isSearchSticky = false;

  final List<String> _statusOptions = ['All', 'Completed', 'Pending', 'Failed'];

  final List<BankPayment> _allPayments = [
    BankPayment(
      id: '1',
      paymentNo: 'PAY-2025-001',
      paymentDate: DateTime.now().subtract(const Duration(days: 1)),
      bankAccount: 'HDFC Bank - 1234',
      recipient: 'ABC Suppliers Ltd',
      accountHead: 'Expenses',
      ledgerAccount: 'Office Supplies',
      description: 'Payment for office supplies purchased in March',
      amount: 25000.00,
      status: 'Completed',
      transactionId: 'TXN123456789',
    ),
    BankPayment(
      id: '2',
      paymentNo: 'PAY-2025-002',
      paymentDate: DateTime.now(),
      bankAccount: 'ICICI Bank - 5678',
      recipient: 'XYZ Corporation',
      accountHead: 'Expenses',
      ledgerAccount: 'Rent',
      description: 'Monthly office rent payment for April 2025',
      amount: 45000.00,
      status: 'Completed',
      transactionId: 'TXN987654321',
    ),
    BankPayment(
      id: '3',
      paymentNo: 'PAY-2025-003',
      paymentDate: DateTime.now().subtract(const Duration(days: 2)),
      bankAccount: 'SBI Bank - 9012',
      recipient: 'Tech Solutions Inc',
      accountHead: 'Expenses',
      ledgerAccount: 'Software Subscription',
      description: 'Annual software license renewal',
      amount: 120000.00,
      status: 'Pending',
      transactionId: 'TXN456789123',
    ),
    BankPayment(
      id: '4',
      paymentNo: 'PAY-2025-004',
      paymentDate: DateTime.now().subtract(const Duration(days: 3)),
      bankAccount: 'HDFC Bank - 1234',
      recipient: 'Utility Services Ltd',
      accountHead: 'Expenses',
      ledgerAccount: 'Electricity',
      description: 'Electricity bill payment for March',
      amount: 8500.00,
      status: 'Completed',
      transactionId: 'TXN789123456',
    ),
    BankPayment(
      id: '5',
      paymentNo: 'PAY-2025-005',
      paymentDate: DateTime.now().subtract(const Duration(days: 5)),
      bankAccount: 'Axis Bank - 3456',
      recipient: 'Global Marketing Agency',
      accountHead: 'Expenses',
      ledgerAccount: 'Marketing',
      description: 'Digital marketing campaign payment',
      amount: 75000.00,
      status: 'Failed',
      transactionId: 'TXN321654987',
    ),
    BankPayment(
      id: '6',
      paymentNo: 'PAY-2025-006',
      paymentDate: DateTime.now().subtract(const Duration(days: 7)),
      bankAccount: 'ICICI Bank - 5678',
      recipient: 'Employee Salaries',
      accountHead: 'Expenses',
      ledgerAccount: 'Salary',
      description: 'Monthly salary for March 2025',
      amount: 350000.00,
      status: 'Completed',
      transactionId: 'TXN654987321',
    ),
    BankPayment(
      id: '7',
      paymentNo: 'PAY-2025-007',
      paymentDate: DateTime.now().subtract(const Duration(days: 4)),
      bankAccount: 'SBI Bank - 9012',
      recipient: 'Insurance Co Ltd',
      accountHead: 'Expenses',
      ledgerAccount: 'Insurance',
      description: 'Annual insurance premium payment',
      amount: 55000.00,
      status: 'Pending',
      transactionId: 'TXN147258369',
    ),
  ];

  List<BankPayment> _filteredPayments = [];

  @override
  void initState() {
    super.initState();
    _filteredPayments = List.from(_allPayments);
    _searchController.addListener(_filterPayments);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPayments);
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

  void _filterPayments() {
    setState(() {
      _filteredPayments = _allPayments.where((payment) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            payment.paymentNo.toLowerCase().contains(searchQuery) ||
            payment.recipient.toLowerCase().contains(searchQuery) ||
            payment.description.toLowerCase().contains(searchQuery) ||
            payment.transactionId.toLowerCase().contains(searchQuery);

        final matchesStatus =
            _selectedStatus == 'All' || payment.status == _selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filter Payments',
                          style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppTheme.lightBlueBg,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.close,
                                size: 18, color: AppTheme.primaryDarkBlue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Payment Status',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _statusOptions.map((status) {
                      bool isSelected = _selectedStatus == status;
                      return FilterChip(
                        selected: isSelected,
                        label: Text(status,
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87)),
                        onSelected: (selected) {
                          setState(() => _selectedStatus = status);
                          _filterPayments();
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: AppTheme.primaryDarkBlue,
                        shape: StadiumBorder(
                            side: BorderSide(
                                color: isSelected
                                    ? AppTheme.primaryDarkBlue
                                    : Colors.grey.shade300)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatus = 'All';
                              _searchController.clear();
                            });
                            _filterPayments();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: Text('Clear All',
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
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryDarkBlue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0),
                          child: Text('Apply Filters',
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
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
    );
  }

  void _showPaymentDetail(BankPayment payment) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BankPaymentDetailScreen(payment: payment)));
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF10B981);
      case 'Pending':
        return const Color(0xFFF59E0B);
      case 'Failed':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.subtitleGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPayments = _filteredPayments.length;
    final totalAmount = _filteredPayments.fold(0.0, (sum, p) => sum + p.amount);
    final completedCount =
        _filteredPayments.where((p) => p.status == 'Completed').length;
    final completedAmount = _filteredPayments
        .where((p) => p.status == 'Completed')
        .fold(0.0, (sum, p) => sum + p.amount);
    final pendingCount =
        _filteredPayments.where((p) => p.status == 'Pending').length;
    final pendingAmount = _filteredPayments
        .where((p) => p.status == 'Pending')
        .fold(0.0, (sum, p) => sum + p.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppTheme.primaryDarkBlue, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Text('Bank Payments',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo is ScrollUpdateNotification)
                      _scrollListener();
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // KPI Cards
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Total Payments Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppTheme.primaryDarkBlue,
                                        AppTheme.primaryDarkBlue
                                            .withOpacity(0.8)
                                      ]),
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
                                          Text('Total Payments',
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white70)),
                                          const SizedBox(height: 4),
                                          Text(totalPayments.toString(),
                                              style: GoogleFonts.lato(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          Text(
                                              'Total: ₹${NumberFormat('#,##0').format(totalAmount)}',
                                              style: GoogleFonts.lato(
                                                  fontSize: 10,
                                                  color: Colors.white70)),
                                        ]),
                                    Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: const Icon(Icons.payments,
                                            size: 24, color: Colors.white)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Two Cards Row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildKPICard(
                                        'Completed',
                                        completedCount.toString(),
                                        '₹${NumberFormat('#,##0').format(completedAmount)}',
                                        Icons.check_circle,
                                        const Color(0xFF10B981),
                                        'Successful payments'),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildKPICard(
                                        'Pending',
                                        pendingCount.toString(),
                                        '₹${NumberFormat('#,##0').format(pendingAmount)}',
                                        Icons.pending_actions,
                                        const Color(0xFFF59E0B),
                                        'Awaiting clearance'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Search and Filter
                        Container(
                          color: const Color(0xFFF5F7FA),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 44,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.grey.shade200)),
                                        child: TextField(
                                          controller: _searchController,
                                          style: GoogleFonts.lato(fontSize: 13),
                                          decoration: InputDecoration(
                                            hintText:
                                                'Search by Payment No, Recipient or Transaction ID',
                                            hintStyle: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Colors.grey.shade400),
                                            prefixIcon: const Icon(Icons.search,
                                                size: 16,
                                                color: AppTheme.subtitleGray),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: _showFilterDialog,
                                      child: Container(
                                        height: 44,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: _selectedStatus != 'All'
                                              ? AppTheme.primaryDarkBlue
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: _selectedStatus != 'All'
                                                  ? AppTheme.primaryDarkBlue
                                                  : Colors.grey.shade200),
                                        ),
                                        child: Row(children: [
                                          Icon(Icons.filter_list,
                                              size: 16,
                                              color: _selectedStatus != 'All'
                                                  ? Colors.white
                                                  : AppTheme.subtitleGray),
                                          const SizedBox(width: 6),
                                          Text('Filter',
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      _selectedStatus != 'All'
                                                          ? Colors.white
                                                          : Colors.black87)),
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectedStatus != 'All')
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(children: [
                                        Chip(
                                          label: Text(
                                              'Status: $_selectedStatus',
                                              style: GoogleFonts.lato(
                                                  fontSize: 11)),
                                          onDeleted: () {
                                            setState(
                                                () => _selectedStatus = 'All');
                                            _filterPayments();
                                          },
                                          backgroundColor: AppTheme.lightBlueBg,
                                          deleteIcon:
                                              const Icon(Icons.close, size: 12),
                                        ),
                                      ])),
                                ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),

                        // Payment List
                        if (_filteredPayments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(children: [
                                Icon(Icons.payments_outlined,
                                    size: 60, color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                Text('No payments found',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.subtitleGray)),
                                const SizedBox(height: 6),
                                Text('Try adjusting your filters',
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: AppTheme.subtitleGray)),
                              ]),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredPayments.length,
                            itemBuilder: (context, index) {
                              final payment = _filteredPayments[index];
                              final statusColor =
                                  _getStatusColor(payment.status);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.grey.shade200)),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _showPaymentDetail(payment),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(payment.recipient,
                                                          style: GoogleFonts.lato(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppTheme
                                                                  .primaryDarkBlue)),
                                                      const SizedBox(height: 3),
                                                      Row(children: [
                                                        Container(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6,
                                                                vertical: 2),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade100,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Text(
                                                                payment
                                                                    .paymentNo,
                                                                style: GoogleFonts.lato(
                                                                    fontSize: 9,
                                                                    color: AppTheme
                                                                        .subtitleGray))),
                                                        const SizedBox(
                                                            width: 8),
                                                        Container(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6,
                                                                vertical: 2),
                                                            decoration: BoxDecoration(
                                                                color: AppTheme
                                                                    .lightBlueBg,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Text(
                                                                payment
                                                                    .bankAccount,
                                                                style: GoogleFonts.lato(
                                                                    fontSize: 9,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: AppTheme
                                                                        .primaryDarkBlue))),
                                                      ]),
                                                    ]),
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 3),
                                                        decoration: BoxDecoration(
                                                            color: statusColor
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text(
                                                            payment.status,
                                                            style: GoogleFonts.lato(
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    statusColor))),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                        '₹${NumberFormat('#,##0').format(payment.amount)}',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .black87)),
                                                  ]),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(payment.description,
                                              style: GoogleFonts.lato(
                                                  fontSize: 11,
                                                  color: AppTheme.subtitleGray),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 8),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(children: [
                                                  const Icon(Icons.receipt,
                                                      size: 12,
                                                      color: AppTheme
                                                          .subtitleGray),
                                                  const SizedBox(width: 4),
                                                  Text(payment.ledgerAccount,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 10,
                                                          color: AppTheme
                                                              .subtitleGray)),
                                                ]),
                                                Row(children: [
                                                  const Icon(
                                                      Icons.calendar_today,
                                                      size: 12,
                                                      color: AppTheme
                                                          .subtitleGray),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                      DateFormat('dd MMM yyyy')
                                                          .format(payment
                                                              .paymentDate),
                                                      style: GoogleFonts.lato(
                                                          fontSize: 10,
                                                          color: AppTheme
                                                              .subtitleGray)),
                                                ]),
                                              ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Create Payment Button
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2))
                ]),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CreateBankPaymentScreen()));
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text('Create Payment',
                          style: GoogleFonts.lato(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryDarkBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0),
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
                color: const Color(0xFFF5F7FA),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2))
                          ]),
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.lato(fontSize: 13),
                        decoration: InputDecoration(
                            hintText:
                                'Search by Payment No, Recipient or Transaction ID',
                            hintStyle: GoogleFonts.lato(
                                fontSize: 12, color: Colors.grey.shade400),
                            prefixIcon: const Icon(Icons.search,
                                size: 16, color: AppTheme.subtitleGray),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _showFilterDialog,
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: _selectedStatus != 'All'
                              ? AppTheme.primaryDarkBlue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: _selectedStatus != 'All'
                                  ? AppTheme.primaryDarkBlue
                                  : Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2))
                          ]),
                      child: Row(children: [
                        Icon(Icons.filter_list,
                            size: 16,
                            color: _selectedStatus != 'All'
                                ? Colors.white
                                : AppTheme.subtitleGray),
                        const SizedBox(width: 6),
                        Text('Filter',
                            style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _selectedStatus != 'All'
                                    ? Colors.white
                                    : Colors.black87))
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String count, String amount, IconData icon,
      Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: GoogleFonts.lato(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.subtitleGray)),
          Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 14, color: color)),
        ]),
        const SizedBox(height: 6),
        Text(count,
            style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        Text(amount,
            style: GoogleFonts.lato(
                fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        Text(subtitle,
            style: GoogleFonts.lato(fontSize: 9, color: AppTheme.subtitleGray)),
      ]),
    );
  }
}

// ==================== BANK PAYMENT DETAIL SCREEN ====================
class BankPaymentDetailScreen extends StatelessWidget {
  final BankPayment payment;
  const BankPaymentDetailScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(payment.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppTheme.primaryDarkBlue, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Text('Payment Details',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      AppTheme.primaryDarkBlue.withOpacity(0.8)
                    ]),
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(payment.recipient,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(payment.paymentNo,
                          style: GoogleFonts.lato(
                              fontSize: 11, color: Colors.white70)),
                    ])),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(payment.status,
                        style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white))),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Amount',
                          style: GoogleFonts.lato(
                              fontSize: 10, color: Colors.white70)),
                      Text('₹${NumberFormat('#,##0').format(payment.amount)}',
                          style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ])),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      Icon(_getStatusIcon(payment.status),
                          size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(payment.status,
                          style: GoogleFonts.lato(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ])),
              ]),
            ]),
          ),
          const SizedBox(height: 12),

          // Payment Information
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Payment Information',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue))),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  _buildInfoRow(Icons.receipt, 'Payment No', payment.paymentNo),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.calendar_today, 'Payment Date',
                      DateFormat('dd MMM yyyy').format(payment.paymentDate)),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.account_balance, 'Bank Account',
                      payment.bankAccount),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      Icons.business, 'Recipient / Payee', payment.recipient),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      Icons.category, 'Account Head', payment.accountHead),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      Icons.book, 'Ledger Account', payment.ledgerAccount),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.description, 'Payment Description',
                      payment.description),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      Icons.payments, 'Transaction ID', payment.transactionId),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 60),
        ]),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 14, color: AppTheme.subtitleGray),
      const SizedBox(width: 10),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style:
                GoogleFonts.lato(fontSize: 10, color: AppTheme.subtitleGray)),
        Text(value,
            style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
      ])),
    ]);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF10B981);
      case 'Pending':
        return const Color(0xFFF59E0B);
      case 'Failed':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.subtitleGray;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Completed':
        return Icons.check_circle;
      case 'Pending':
        return Icons.pending;
      case 'Failed':
        return Icons.error;
      default:
        return Icons.info;
    }
  }
}

// ==================== CREATE BANK PAYMENT SCREEN ====================
class CreateBankPaymentScreen extends StatefulWidget {
  const CreateBankPaymentScreen({super.key});

  @override
  State<CreateBankPaymentScreen> createState() =>
      _CreateBankPaymentScreenState();
}

class _CreateBankPaymentScreenState extends State<CreateBankPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _paymentNoController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();

  String _selectedBankAccount = 'HDFC Bank - 1234';
  String _selectedAccountHead = 'Expenses';
  String _selectedLedgerAccount = 'Office Supplies';
  DateTime _paymentDate = DateTime.now();

  final List<String> _bankAccounts = [
    'HDFC Bank - 1234',
    'ICICI Bank - 5678',
    'SBI Bank - 9012',
    'Axis Bank - 3456',
    'Kotak Bank - 7890',
  ];

  final List<String> _accountHeads = [
    'Assets',
    'Expenses',
    'Liabilities',
    'Income',
  ];

  final Map<String, List<String>> _ledgerAccounts = {
    'Assets': [
      'Cash in Hand',
      'Bank Account',
      'Accounts Receivable',
      'Inventory'
    ],
    'Expenses': [
      'Office Supplies',
      'Rent',
      'Salary',
      'Utilities',
      'Marketing',
      'Insurance'
    ],
    'Liabilities': ['Accounts Payable', 'Short-term Loans', 'Tax Payable'],
    'Income': ['Sales Revenue', 'Service Income', 'Interest Income'],
  };

  @override
  void initState() {
    super.initState();
    _paymentNoController.text =
        'PAY-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  }

  @override
  void dispose() {
    _paymentNoController.dispose();
    _recipientController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  void _savePayment() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Payment created successfully!'),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating),
      );
      Navigator.pop(context);
    }
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
            onPressed: () => Navigator.pop(context)),
        title: Text('Create Bank Payment',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Details Card
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color:
                                    AppTheme.primaryDarkBlue.withOpacity(0.03),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16))),
                            child: Row(children: [
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: AppTheme.primaryDarkBlue
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.payments,
                                      size: 20,
                                      color: AppTheme.primaryDarkBlue)),
                              const SizedBox(width: 12),
                              Text('PAYMENT DETAILS',
                                  style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.subtitleGray,
                                      letterSpacing: 0.5)),
                            ]),
                          ),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(children: [
                              // Payment Date
                              _buildDateField(),
                              const SizedBox(height: 16),

                              // Payment / Voucher No
                              _buildTextField(
                                  controller: _paymentNoController,
                                  label: 'Payment / Voucher No.',
                                  hint: 'Auto-generated',
                                  icon: Icons.receipt,
                                  readOnly: true),
                              const SizedBox(height: 16),

                              // Bank Account Dropdown
                              _buildDropdownField(
                                  value: _selectedBankAccount,
                                  label: 'Bank Account',
                                  hint: 'Select bank account',
                                  icon: Icons.account_balance,
                                  items: _bankAccounts,
                                  onChanged: (v) => setState(
                                      () => _selectedBankAccount = v!)),
                              const SizedBox(height: 16),

                              // Recipient / Payee
                              _buildTextField(
                                controller: _recipientController,
                                label: 'Recipient / Payee',
                                hint: 'Enter recipient name',
                                icon: Icons.business,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Please enter recipient name'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // Account Head Dropdown
                              _buildDropdownField(
                                  value: _selectedAccountHead,
                                  label: 'Account Head',
                                  hint: 'Select account head',
                                  icon: Icons.category,
                                  items: _accountHeads,
                                  onChanged: (v) {
                                    setState(() {
                                      _selectedAccountHead = v!;
                                      _selectedLedgerAccount =
                                          _ledgerAccounts[_selectedAccountHead]!
                                              .first;
                                    });
                                  }),
                              const SizedBox(height: 16),

                              // Ledger Account Dropdown
                              _buildDropdownField(
                                  value: _selectedLedgerAccount,
                                  label: 'Ledger Account',
                                  hint: 'Select ledger account',
                                  icon: Icons.book,
                                  items: _ledgerAccounts[_selectedAccountHead]!,
                                  onChanged: (v) => setState(
                                      () => _selectedLedgerAccount = v!)),
                              const SizedBox(height: 16),

                              // Payment Description
                              _buildTextField(
                                controller: _descriptionController,
                                label: 'Payment Description',
                                hint: 'Enter payment description',
                                icon: Icons.description_outlined,
                                maxLines: 3,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Please enter description'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // Payment Amount
                              _buildTextField(
                                controller: _amountController,
                                label: 'Payment Amount (₹)',
                                hint: '0.00',
                                icon: Icons.currency_rupee,
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty)
                                    return 'Please enter amount';
                                  if (double.tryParse(v) == null ||
                                      double.parse(v) <= 0)
                                    return 'Please enter valid amount';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Transaction ID (Optional)
                              _buildTextField(
                                controller: _transactionIdController,
                                label: 'Transaction ID (Optional)',
                                hint: 'Enter transaction reference',
                                icon: Icons.confirmation_number,
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),

          // Save Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2))
            ]),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePayment,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDarkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send, size: 20, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('Create Payment',
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ]),
                ),
              ),
            ),
          ),
        ],
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(),
          style: GoogleFonts.lato(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.subtitleGray,
              letterSpacing: 0.5)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            style: GoogleFonts.lato(fontSize: 13, color: Colors.black87),
            items: items
                .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: GoogleFonts.lato(fontSize: 13))))
                .toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down,
                size: 20, color: AppTheme.subtitleGray),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ]);
  }

  Widget _buildDateField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('PAYMENT DATE',
          style: GoogleFonts.lato(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.subtitleGray,
              letterSpacing: 0.5)),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _paymentDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                        primary: AppTheme.primaryDarkBlue)),
                child: child!),
          );
          if (date != null) setState(() => _paymentDate = date);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300)),
          child: Row(children: [
            const Icon(Icons.calendar_today,
                size: 16, color: AppTheme.subtitleGray),
            const SizedBox(width: 10),
            Text(DateFormat('dd MMM yyyy').format(_paymentDate),
                style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(),
          style: GoogleFonts.lato(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.subtitleGray,
              letterSpacing: 0.5)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: GoogleFonts.lato(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.lato(fontSize: 13, color: Colors.grey.shade400),
          prefixIcon: Icon(icon, size: 16, color: AppTheme.subtitleGray),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: AppTheme.primaryDarkBlue, width: 1.5)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          filled: true,
          fillColor: readOnly ? Colors.grey.shade50 : Colors.white,
        ),
        validator: validator,
      ),
    ]);
  }
}
