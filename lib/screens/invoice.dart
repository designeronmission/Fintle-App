import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'create_invoice_screen.dart';
import 'customer_screen.dart';

// ==================== MAIN INVOICE LIST SCREEN ==================== //
class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});
  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isSearchSticky = false;

  final List<String> _filterOptions = [
    'All',
    'Draft',
    'Sent',
    'Paid',
    'Overdue'
  ];

  // Sample invoice data
  final List<Map<String, dynamic>> _allInvoices = [
    {
      'id': 'INV-001',
      'customer': 'ABC Corporation',
      'email': 'abc@corporation.com',
      'phone': '+91 98765 43210',
      'address': '123 Business Park, Mumbai',
      'gst': '29AAACB1234E1Z5',
      'amount': 12500.00,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'dueDate': DateTime.now().add(const Duration(days: 5)),
      'status': 'Paid',
      'items': 2,
      'notes': 'Thanks for your business!',
    },
    {
      'id': 'INV-002',
      'customer': 'XYZ Enterprises',
      'email': 'contact@xyz.com',
      'phone': '+91 99887 66554',
      'address': '45 Tech Hub, Bangalore',
      'gst': '27BBBCD5678E2Z8',
      'amount': 8700.00,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'status': 'Sent',
      'items': 2,
      'notes': 'Payment expected within 7 days',
    },
    {
      'id': 'INV-003',
      'customer': 'Tech Solutions Ltd',
      'email': 'info@techsolutions.com',
      'phone': '+91 87654 32109',
      'address': '12 IT Park, Chennai',
      'gst': '24CCCDE9012E3Z1',
      'amount': 23400.00,
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'dueDate': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'Overdue',
      'items': 2,
      'notes': 'Please process payment immediately',
    },
    {
      'id': 'INV-004',
      'customer': 'Global Services Inc',
      'email': 'accounts@globalservices.com',
      'phone': '+91 76543 21098',
      'address': '78 Corporate Tower, Delhi',
      'gst': '27DDDEF1234E4Z2',
      'amount': 5600.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'dueDate': DateTime.now().add(const Duration(days: 10)),
      'status': 'Draft',
      'items': 1,
      'notes': 'Draft invoice - pending approval',
    },
    {
      'id': 'INV-005',
      'customer': 'Digital Marketing Pro',
      'email': 'hello@digitalpro.com',
      'phone': '+91 65432 10987',
      'address': '34 Marketing Plaza, Pune',
      'gst': '29EEEFG5678E5Z3',
      'amount': 18900.00,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'dueDate': DateTime.now().add(const Duration(days: 4)),
      'status': 'Sent',
      'items': 2,
      'notes': 'Monthly retainer invoice',
    },
  ];

  List<Map<String, dynamic>> _filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    _filteredInvoices = List.from(_allInvoices);
    _searchController.addListener(_filterInvoices);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterInvoices);
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

  void _filterInvoices() {
    setState(() {
      _filteredInvoices = _allInvoices.where((invoice) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            invoice['id'].toLowerCase().contains(searchQuery) ||
            invoice['customer'].toLowerCase().contains(searchQuery) ||
            invoice['email'].toLowerCase().contains(searchQuery);
        final matchesStatus =
            _selectedStatus == 'All' || invoice['status'] == _selectedStatus;
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Invoices',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
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
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppTheme.primaryDarkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Status',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _filterOptions.map((status) {
                      bool isSelected = _selectedStatus == status;
                      return FilterChip(
                        selected: isSelected,
                        label: Text(
                          status,
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedStatus = status;
                          });
                          _filterInvoices();
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: AppTheme.primaryDarkBlue,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.primaryDarkBlue
                                : Colors.grey.shade300,
                          ),
                        ),
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
                            _filterInvoices();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Clear All',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.subtitleGray,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryDarkBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Apply Filters',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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

  void _showInvoiceDetail(Map<String, dynamic> invoice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceDetailScreen(invoice: invoice),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFF10B981);
      case 'Sent':
        return const Color(0xFF3B82F6);
      case 'Draft':
        return const Color(0xFFF59E0B);
      case 'Overdue':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.subtitleGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalInvoices = _filteredInvoices.length;
    final totalAmount = _filteredInvoices.fold(
        0.0, (sum, inv) => sum + (inv['amount'] as double));
    final overdueCount =
        _filteredInvoices.where((inv) => inv['status'] == 'Overdue').length;
    final overdueAmount = _filteredInvoices
        .where((inv) => inv['status'] == 'Overdue')
        .fold(0.0, (sum, inv) => sum + (inv['amount'] as double));
    final paidCount =
        _filteredInvoices.where((inv) => inv['status'] == 'Paid').length;
    final paidAmount = _filteredInvoices
        .where((inv) => inv['status'] == 'Paid')
        .fold(0.0, (sum, inv) => sum + (inv['amount'] as double));
    final draftCount =
        _filteredInvoices.where((inv) => inv['status'] == 'Draft').length;
    final draftAmount = _filteredInvoices
        .where((inv) => inv['status'] == 'Draft')
        .fold(0.0, (sum, inv) => sum + (inv['amount'] as double));

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
          'Invoices',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
        // No actions - matching customer_screen
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
                        // KPI Cards
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Total Invoices Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Invoices',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          totalInvoices.toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Total amount',
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
                                        Icons.receipt_long,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Three Cards Row
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
                                                'Overdue',
                                                style: GoogleFonts.lato(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEF4444)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.warning_amber,
                                                  size: 14,
                                                  color: Color(0xFFEF4444),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            overdueCount.toString(),
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '₹${NumberFormat('#,##0').format(overdueAmount)}',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: const Color(0xFFEF4444),
                                              fontWeight: FontWeight.w600,
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
                                                'Paid',
                                                style: GoogleFonts.lato(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF10B981)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.check_circle,
                                                  size: 14,
                                                  color: Color(0xFF10B981),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            paidCount.toString(),
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '₹${NumberFormat('#,##0').format(paidAmount)}',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: const Color(0xFF10B981),
                                              fontWeight: FontWeight.w600,
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
                                                'Draft',
                                                style: GoogleFonts.lato(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF59E0B)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.edit_note,
                                                  size: 14,
                                                  color: Color(0xFFF59E0B),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            draftCount.toString(),
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '₹${NumberFormat('#,##0').format(draftAmount)}',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: const Color(0xFFF59E0B),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                              color: Colors.grey.shade200),
                                        ),
                                        child: TextField(
                                          controller: _searchController,
                                          style: GoogleFonts.lato(fontSize: 13),
                                          decoration: InputDecoration(
                                            hintText:
                                                'Search by Invoice # or Customer',
                                            hintStyle: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.grey.shade400,
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.search,
                                              size: 16,
                                              color: AppTheme.subtitleGray,
                                            ),
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
                                                : Colors.grey.shade200,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.filter_list,
                                              size: 16,
                                              color: _selectedStatus != 'All'
                                                  ? Colors.white
                                                  : AppTheme.subtitleGray,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Filter',
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: _selectedStatus != 'All'
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (_selectedStatus != 'All')
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Chip(
                                          label: Text(
                                            'Status: $_selectedStatus',
                                            style:
                                                GoogleFonts.lato(fontSize: 11),
                                          ),
                                          onDeleted: () {
                                            setState(() {
                                              _selectedStatus = 'All';
                                            });
                                            _filterInvoices();
                                          },
                                          backgroundColor: AppTheme.lightBlueBg,
                                          deleteIcon:
                                              const Icon(Icons.close, size: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),

                        // Invoice List
                        if (_filteredInvoices.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 60,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No invoices found',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Try adjusting your filters',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: AppTheme.subtitleGray,
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
                            itemCount: _filteredInvoices.length,
                            itemBuilder: (context, index) {
                              final invoice = _filteredInvoices[index];
                              final statusColor =
                                  _getStatusColor(invoice['status']);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _showInvoiceDetail(invoice),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      invoice['customer'],
                                                      style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppTheme
                                                            .primaryDarkBlue,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      invoice['id'],
                                                      style: GoogleFonts.lato(
                                                        fontSize: 10,
                                                        color: AppTheme
                                                            .subtitleGray,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: statusColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  invoice['status'],
                                                  style: GoogleFonts.lato(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: statusColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.email_outlined,
                                                size: 12,
                                                color: AppTheme.subtitleGray,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  invoice['email'],
                                                  style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    color:
                                                        AppTheme.subtitleGray,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.phone_outlined,
                                                size: 12,
                                                color: AppTheme.subtitleGray,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                invoice['phone'],
                                                style: GoogleFonts.lato(
                                                  fontSize: 11,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          const Divider(
                                              color: Color(0xFFE2E8F0),
                                              height: 1),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Amount',
                                                style: GoogleFonts.lato(
                                                  fontSize: 9,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                              Text(
                                                'Due Date',
                                                style: GoogleFonts.lato(
                                                  fontSize: 9,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₹${NumberFormat('#,##0').format(invoice['amount'])}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('dd MMM yyyy')
                                                    .format(invoice['dueDate']),
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: invoice['dueDate']
                                                              .isBefore(DateTime
                                                                  .now()) &&
                                                          invoice['status'] !=
                                                              'Paid'
                                                      ? Colors.red
                                                      : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${invoice['items']} items',
                                                style: GoogleFonts.lato(
                                                  fontSize: 9,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                              if (invoice['status'] ==
                                                  'Overdue')
                                                Text(
                                                  'Payment Overdue',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 9,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                            ],
                                          ),
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

              // Create Invoice Button
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateInvoiceScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(
                        'Create Invoice',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDarkBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
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
                child: Row(
                  children: [
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
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.lato(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Search by Invoice # or Customer',
                            hintStyle: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 16,
                              color: AppTheme.subtitleGray,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
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
                                : Colors.grey.shade200,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 16,
                              color: _selectedStatus != 'All'
                                  ? Colors.white
                                  : AppTheme.subtitleGray,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filter',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _selectedStatus != 'All'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== INVOICE DETAIL SCREEN WITH PROFESSIONAL PREVIEW ====================
class InvoiceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  // Sample invoice items for preview
  final List<Map<String, dynamic>> _invoiceItems = [
    {
      'description': 'Web Development Services',
      'hsn': '998314',
      'quantity': 1,
      'unit': 'Project',
      'price': 10000.00,
      'discount': 5.0,
      'tax': 18.0,
      'amount': 10000.00,
    },
    {
      'description': 'UI/UX Design Services',
      'hsn': '998313',
      'quantity': 1,
      'unit': 'Project',
      'price': 5000.00,
      'discount': 0.0,
      'tax': 18.0,
      'amount': 5000.00,
    },
    {
      'description': 'Server Maintenance - Monthly',
      'hsn': '998412',
      'quantity': 1,
      'unit': 'Month',
      'price': 2000.00,
      'discount': 0.0,
      'tax': 18.0,
      'amount': 2000.00,
    },
  ];

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invoice'),
        content: const Text(
            'Are you sure you want to delete this invoice? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invoice deleted successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Invoice',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.picture_as_pdf, 'PDF', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating PDF...')),
                  );
                }),
                _buildShareOption(Icons.email, 'Email', () {
                  Navigator.pop(context);
                }),
                _buildShareOption(Icons.share, 'Share', () {
                  Navigator.pop(context);
                }),
                _buildShareOption(Icons.print, 'Print', () {
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.lightBlueBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: AppTheme.primaryDarkBlue),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.lato(fontSize: 12)),
        ],
      ),
    );
  }

  double _getDoubleValue(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    }
    return 0.0;
  }

  double _calculateSubtotal() {
    double total = 0.0;
    for (var item in _invoiceItems) {
      total += _getDoubleValue(item['amount']);
    }
    return total;
  }

  double _calculateDiscount() {
    double totalDiscount = 0.0;
    for (var item in _invoiceItems) {
      double amount = _getDoubleValue(item['amount']);
      double discountPercent = _getDoubleValue(item['discount']);
      double discount = amount * discountPercent / 100;
      totalDiscount += discount;
    }
    return totalDiscount;
  }

  double _calculateTax() {
    double totalTax = 0.0;
    for (var item in _invoiceItems) {
      double amount = _getDoubleValue(item['amount']);
      double discountPercent = _getDoubleValue(item['discount']);
      double taxPercent = _getDoubleValue(item['tax']);

      double amountAfterDiscount = amount - (amount * discountPercent / 100);
      double tax = amountAfterDiscount * taxPercent / 100;
      totalTax += tax;
    }
    return totalTax;
  }

  double _calculateTotal() {
    return _calculateSubtotal() - _calculateDiscount() + _calculateTax();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFF10B981);
      case 'Sent':
        return const Color(0xFF3B82F6);
      case 'Draft':
        return const Color(0xFFF59E0B);
      case 'Overdue':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.subtitleGray;
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Invoice Preview',
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share,
                color: AppTheme.primaryDarkBlue, size: 20),
            onPressed: () => _showShareOptions(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,
                color: AppTheme.primaryDarkBlue, size: 20),
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation(context);
              } else if (value == 'download') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading PDF...')),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: AppTheme.primaryDarkBlue),
                    SizedBox(width: 12),
                    Text('Edit Invoice'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download,
                        size: 18, color: AppTheme.primaryDarkBlue),
                    SizedBox(width: 12),
                    Text('Download PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete Invoice', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Professional Invoice Card - Full width
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header Section with Gradient
                  Container(
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
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'INVOICE',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.invoice['id'],
                                  style: GoogleFonts.lato(
                                    fontSize: 11,
                                    color: Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _getStatusColor(widget.invoice['status']),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                widget.invoice['status'].toUpperCase(),
                                style: GoogleFonts.lato(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'INVOICE DATE',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat('dd MMM yyyy')
                                        .format(widget.invoice['date']),
                                    style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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
                                    'DUE DATE',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat('dd MMM yyyy')
                                        .format(widget.invoice['dueDate']),
                                    style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'AMOUNT DUE',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '₹${NumberFormat('#,##0.00').format(_calculateTotal())}',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Company & Customer Info
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FROM',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.subtitleGray,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Your Company Name',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '123 Business Street',
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  Text(
                                    'Mumbai, Maharashtra 400001',
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'GST: 27AAACA1234E1Z5',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  Text(
                                    'PAN: AAACA1234E',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TO',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.subtitleGray,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.invoice['customer'],
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.invoice['address'],
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'GST: ${widget.invoice['gst']}',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  Text(
                                    'Email: ${widget.invoice['email']}',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  Text(
                                    'Phone: ${widget.invoice['phone']}',
                                    style: GoogleFonts.lato(
                                      fontSize: 9,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Invoice Items Table - Scrollable horizontally for mobile
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Table Header
                          Container(
                            color: AppTheme.lightBlueBg,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'DESCRIPTION',
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    'HSN/SAC',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    'QTY',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    'RATE',
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    'DISCOUNT',
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    'TAX',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    'AMOUNT',
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Table Rows
                          ..._invoiceItems.asMap().entries.map((entry) {
                            int index = entry.key;
                            var item = entry.value;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                                color: index % 2 == 0
                                    ? Colors.white
                                    : Colors.grey.shade50,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      item['description'],
                                      style: GoogleFonts.lato(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      item['hsn'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        fontSize: 9,
                                        color: AppTheme.subtitleGray,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      '${item['quantity']} ${item['unit']}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      '₹${NumberFormat('#,##0').format(_getDoubleValue(item['price']))}',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.lato(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      '${_getDoubleValue(item['discount']).toInt()}%',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.lato(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      '${_getDoubleValue(item['tax']).toInt()}%',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      '₹${NumberFormat('#,##0').format(_getDoubleValue(item['amount']))}',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Totals Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlueBg.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTotalRow('Subtotal', _calculateSubtotal()),
                        if (_calculateDiscount() > 0)
                          _buildTotalRow('Discount', -_calculateDiscount(),
                              isNegative: true),
                        _buildTotalRow('Tax (GST)', _calculateTax()),
                        const Divider(height: 12, thickness: 1),
                        _buildTotalRow('Total', _calculateTotal(),
                            isBold: true, fontSize: 16),
                      ],
                    ),
                  ),

                  // Bank Details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BANK DETAILS',
                          style: GoogleFonts.lato(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.subtitleGray,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBankDetail(
                                      'Bank Name', 'HDFC Bank Ltd'),
                                  const SizedBox(height: 6),
                                  _buildBankDetail(
                                      'Account Name', 'Your Company Name'),
                                  const SizedBox(height: 6),
                                  _buildBankDetail(
                                      'Account Number', '12345678901234'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBankDetail('IFSC Code', 'HDFC0001234'),
                                  const SizedBox(height: 6),
                                  _buildBankDetail(
                                      'Branch', 'Andheri East, Mumbai'),
                                  const SizedBox(height: 6),
                                  _buildBankDetail(
                                      'UPI ID', 'company@hdfcbank'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Notes
                  if (widget.invoice['notes'] != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TERMS & NOTES',
                            style: GoogleFonts.lato(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.subtitleGray,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.lightBlueBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.invoice['notes'],
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                color: Colors.black87,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Footer
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlueBg,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified,
                                size: 12, color: AppTheme.primaryDarkBlue),
                            const SizedBox(width: 4),
                            Text(
                              'This is a computer generated invoice',
                              style: GoogleFonts.lato(
                                fontSize: 8,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Thank you for your business!',
                          style: GoogleFonts.lato(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.primaryDarkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showShareOptions(context),
                  icon: const Icon(Icons.share, size: 16),
                  label: Text(
                    'Share',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: AppTheme.primaryDarkBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading PDF...')),
                    );
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: Text(
                    'Download',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: AppTheme.primaryDarkBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Record payment feature coming soon')),
                    );
                  },
                  icon:
                      const Icon(Icons.payment, size: 16, color: Colors.white),
                  label: Text(
                    'Record Payment',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDarkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount,
      {bool isBold = false, bool isNegative = false, double fontSize = 12}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.lato(
              fontSize: fontSize - 2,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? Colors.black87 : AppTheme.subtitleGray,
            ),
          ),
          Text(
            isNegative
                ? '-₹${NumberFormat('#,##0.00').format(amount.abs())}'
                : '₹${NumberFormat('#,##0.00').format(amount)}',
            style: GoogleFonts.lato(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold
                  ? AppTheme.primaryDarkBlue
                  : (isNegative ? Colors.red : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetail(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 85,
          child: Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 9,
              color: AppTheme.subtitleGray,
            ),
          ),
        ),
        Text(':',
            style: GoogleFonts.lato(fontSize: 9, color: AppTheme.subtitleGray)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
