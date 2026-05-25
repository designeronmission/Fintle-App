import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'customer_screen.dart';
import 'create_customer_screen.dart';

// ==================== MAIN CUSTOMER LIST SCREEN ====================
class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isSearchSticky = false;

  final List<String> _filterOptions = ['All', 'Active', 'Inactive'];

  // Sample customer data
  final List<Map<String, dynamic>> _allCustomers = [
    {
      'id': 'CUST-001',
      'name': 'ABC Corporation',
      'email': 'abc@corporation.com',
      'phone': '+91 98765 43210',
      'address': '123 Business Park, Mumbai',
      'gst': '29AAACB1234E1Z5',
      'status': 'Active',
      'totalReceivable': 12500.00,
      'totalCollected': 8500.00,
      'outstanding': 4000.00,
      'totalInvoices': 5,
      'paidInvoices': 3,
      'overdueInvoices': 1,
      'lastInvoiceDate': DateTime.now().subtract(const Duration(days: 2)),
      'customerSince': DateTime.now().subtract(const Duration(days: 180)),
      'creditLimit': 50000,
      'paymentTerms': 'Net 30',
    },
    {
      'id': 'CUST-002',
      'name': 'XYZ Enterprises',
      'email': 'contact@xyz.com',
      'phone': '+91 99887 66554',
      'address': '45 Tech Hub, Bangalore',
      'gst': '27BBBCD5678E2Z8',
      'status': 'Active',
      'totalReceivable': 8700.00,
      'totalCollected': 8700.00,
      'outstanding': 0.00,
      'totalInvoices': 3,
      'paidInvoices': 3,
      'overdueInvoices': 0,
      'lastInvoiceDate': DateTime.now().subtract(const Duration(days: 5)),
      'customerSince': DateTime.now().subtract(const Duration(days: 90)),
      'creditLimit': 25000,
      'paymentTerms': 'Net 15',
    },
    {
      'id': 'CUST-003',
      'name': 'Tech Solutions Ltd',
      'email': 'info@techsolutions.com',
      'phone': '+91 87654 32109',
      'address': '12 IT Park, Chennai',
      'gst': '24CCCDE9012E3Z1',
      'status': 'Active',
      'totalReceivable': 23400.00,
      'totalCollected': 15000.00,
      'outstanding': 8400.00,
      'totalInvoices': 8,
      'paidInvoices': 5,
      'overdueInvoices': 2,
      'lastInvoiceDate': DateTime.now().subtract(const Duration(days: 3)),
      'customerSince': DateTime.now().subtract(const Duration(days: 365)),
      'creditLimit': 75000,
      'paymentTerms': 'Net 45',
    },
    {
      'id': 'CUST-004',
      'name': 'Global Services Inc',
      'email': 'accounts@globalservices.com',
      'phone': '+91 76543 21098',
      'address': '78 Corporate Tower, Delhi',
      'gst': '27DDDEF1234E4Z2',
      'status': 'Inactive',
      'totalReceivable': 5600.00,
      'totalCollected': 5600.00,
      'outstanding': 0.00,
      'totalInvoices': 2,
      'paidInvoices': 2,
      'overdueInvoices': 0,
      'lastInvoiceDate': DateTime.now().subtract(const Duration(days: 60)),
      'customerSince': DateTime.now().subtract(const Duration(days: 200)),
      'creditLimit': 15000,
      'paymentTerms': 'Net 30',
    },
    {
      'id': 'CUST-005',
      'name': 'Digital Marketing Pro',
      'email': 'hello@digitalpro.com',
      'phone': '+91 65432 10987',
      'address': '34 Marketing Plaza, Pune',
      'gst': '29EEEFG5678E5Z3',
      'status': 'Active',
      'totalReceivable': 18900.00,
      'totalCollected': 10000.00,
      'outstanding': 8900.00,
      'totalInvoices': 6,
      'paidInvoices': 4,
      'overdueInvoices': 1,
      'lastInvoiceDate': DateTime.now().subtract(const Duration(days: 1)),
      'customerSince': DateTime.now().subtract(const Duration(days: 120)),
      'creditLimit': 40000,
      'paymentTerms': 'Net 30',
    },
    {
      'id': 'CUST-006',
      'name': 'Sunrise Industries',
      'email': 'info@sunrise.com',
      'phone': '+91 54321 09876',
      'address': '56 Industrial Area, Ahmedabad',
      'gst': '24FFGHI7890E6Z4',
      'status': 'Active',
      'totalReceivable': 3200.00,
      'totalCollected': 3200.00,
      'outstanding': 0.00,
      'totalInvoices': 2,
      'paidInvoices': 2,
      'overdueInvoices': 0,
      'lastInvoiceDate': DateTime.now().subtract(const Duration(days: 15)),
      'customerSince': DateTime.now().subtract(const Duration(days: 60)),
      'creditLimit': 10000,
      'paymentTerms': 'Net 30',
    },
    {
      'id': 'CUST-007',
      'name': 'Blue Ocean Ventures',
      'email': 'contact@blueocean.com',
      'phone': '+91 43210 98765',
      'address': '89 Business Bay, Hyderabad',
      'gst': '36GGHIJ9012E7Z5',
      'status': 'Active',
      'totalReceivable': 9500.00,
      'totalCollected': 5000.00,
      'outstanding': 4500.00,
      'totalInvoices': 4,
      'paidInvoices': 2,
      'overdueInvoices': 1,
      'lastInvoiceDate': DateTime.now().subtract(const Duration(days: 7)),
      'customerSince': DateTime.now().subtract(const Duration(days: 150)),
      'creditLimit': 30000,
      'paymentTerms': 'Net 30',
    },
    {
      'id': 'CUST-008',
      'name': 'Redwood Solutions',
      'email': 'info@redwood.com',
      'phone': '+91 32109 87654',
      'address': '12 Tech Park, Kochi',
      'gst': '32JKKLM1234E8Z6',
      'status': 'Active',
      'totalReceivable': 4700.00,
      'totalCollected': 4700.00,
      'outstanding': 0.00,
      'totalInvoices': 3,
      'paidInvoices': 3,
      'overdueInvoices': 0,
      'lastInvoiceDate': DateTime.now().subtract(const Duration(days: 10)),
      'customerSince': DateTime.now().subtract(const Duration(days: 80)),
      'creditLimit': 15000,
      'paymentTerms': 'Net 15',
    },
    {
      'id': 'CUST-009',
      'name': 'Silver Star Traders',
      'email': 'sales@silverstar.com',
      'phone': '+91 21098 76543',
      'address': '67 Market Street, Kolkata',
      'gst': '19LLMNO5678E9Z7',
      'status': 'Active',
      'totalReceivable': 15200.00,
      'totalCollected': 10000.00,
      'outstanding': 5200.00,
      'totalInvoices': 5,
      'paidInvoices': 3,
      'overdueInvoices': 1,
      'lastInvoiceDate': DateTime.now().subtract(const Duration(days: 4)),
      'customerSince': DateTime.now().subtract(const Duration(days: 250)),
      'creditLimit': 35000,
      'paymentTerms': 'Net 30',
    },
  ];

  List<Map<String, dynamic>> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _filteredCustomers = List.from(_allCustomers);
    _searchController.addListener(_filterCustomers);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCustomers);
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

  void _filterCustomers() {
    setState(() {
      _filteredCustomers = _allCustomers.where((customer) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            customer['id'].toLowerCase().contains(searchQuery) ||
            customer['name'].toLowerCase().contains(searchQuery) ||
            customer['email'].toLowerCase().contains(searchQuery) ||
            customer['phone'].contains(searchQuery);

        final matchesStatus =
            _selectedType == 'All' || customer['status'] == _selectedType;

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
                        'Filter Customers',
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
                      bool isSelected = _selectedType == status;
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
                            _selectedType = status;
                          });
                          _filterCustomers();
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
                              _selectedType = 'All';
                              _searchController.clear();
                            });
                            _filterCustomers();
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

  void _showCustomerDetail(Map<String, dynamic> customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailScreen(customer: customer),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF10B981);
      case 'Inactive':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.subtitleGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCustomers = _filteredCustomers.length;
    final totalReceivable = _filteredCustomers.fold(
        0.0, (sum, customer) => sum + (customer['totalReceivable'] as double));
    final customersToCollect = _filteredCustomers
        .where((customer) => (customer['outstanding'] as double) > 0)
        .toList();
    final totalToCollect = customersToCollect.fold(
        0.0, (sum, customer) => sum + (customer['outstanding'] as double));
    final toCollectCount = customersToCollect.length;
    final toPayCount = _filteredCustomers
        .where((customer) => (customer['totalReceivable'] as double) > 0)
        .length;

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
          'Customers',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
        // Removed actions (notification icon)
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
                        // Reduced size KPI Cards
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Total Customers Card - Reduced size
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
                                          'Total Customers',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          totalCustomers.toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Registered accounts',
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
                                        Icons.people_alt,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Two Cards Row - Reduced size
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
                                                'To Pay',
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
                                                  color: const Color(0xFF3B82F6)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.payments,
                                                  size: 14,
                                                  color: Color(0xFF3B82F6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '₹${NumberFormat('#,##0').format(totalReceivable)}',
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '$toPayCount customers',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: AppTheme.subtitleGray,
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
                                                'To Collect',
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
                                                  Icons.attach_money,
                                                  size: 14,
                                                  color: Color(0xFFF59E0B),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '₹${NumberFormat('#,##0').format(totalToCollect)}',
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '$toCollectCount customers',
                                            style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: AppTheme.subtitleGray,
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
                                                'Search by name, email or phone',
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
                                          color: _selectedType != 'All'
                                              ? AppTheme.primaryDarkBlue
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _selectedType != 'All'
                                                ? AppTheme.primaryDarkBlue
                                                : Colors.grey.shade200,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.filter_list,
                                              size: 16,
                                              color: _selectedType != 'All'
                                                  ? Colors.white
                                                  : AppTheme.subtitleGray,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Filter',
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: _selectedType != 'All'
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
                              if (_selectedType != 'All')
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Chip(
                                          label: Text(
                                            'Status: $_selectedType',
                                            style:
                                                GoogleFonts.lato(fontSize: 11),
                                          ),
                                          onDeleted: () {
                                            setState(() {
                                              _selectedType = 'All';
                                            });
                                            _filterCustomers();
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

                        // Customer List
                        if (_filteredCustomers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 60,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No customers found',
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
                            itemCount: _filteredCustomers.length,
                            itemBuilder: (context, index) {
                              final customer = _filteredCustomers[index];
                              final statusColor =
                                  _getStatusColor(customer['status']);
                              final outstanding =
                                  customer['outstanding'] as double;

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
                                    onTap: () => _showCustomerDetail(customer),
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
                                                      customer['name'],
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
                                                      customer['id'],
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
                                                  customer['status'],
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
                                                  customer['email'],
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
                                                customer['phone'],
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
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Receivable',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 9,
                                                      color:
                                                          AppTheme.subtitleGray,
                                                    ),
                                                  ),
                                                  Text(
                                                    '₹${NumberFormat('#,##0').format(customer['totalReceivable'])}',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'To Collect',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 9,
                                                      color:
                                                          AppTheme.subtitleGray,
                                                    ),
                                                  ),
                                                  Text(
                                                    '₹${NumberFormat('#,##0').format(outstanding)}',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: outstanding > 0
                                                          ? const Color(
                                                              0xFFF59E0B)
                                                          : const Color(
                                                              0xFF10B981),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            child: LinearProgressIndicator(
                                              value: customer[
                                                          'totalReceivable'] >
                                                      0
                                                  ? (customer['totalReceivable'] -
                                                          outstanding) /
                                                      customer[
                                                          'totalReceivable']
                                                  : 0.0,
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              color: const Color(0xFF10B981),
                                              minHeight: 3,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${customer['totalInvoices']} invoices',
                                                style: GoogleFonts.lato(
                                                  fontSize: 9,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                              if (customer['overdueInvoices'] >
                                                  0)
                                                Text(
                                                  '${customer['overdueInvoices']} overdue',
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

              // Create Customer Button
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
                            builder: (context) =>
                                const CreateCustomerScreen(), // Change this line
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(
                        'Create Customer',
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
                            hintText: 'Search by name, email or phone',
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
                          color: _selectedType != 'All'
                              ? AppTheme.primaryDarkBlue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedType != 'All'
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
                              color: _selectedType != 'All'
                                  ? Colors.white
                                  : AppTheme.subtitleGray,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filter',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _selectedType != 'All'
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

// ==================== CUSTOMER DETAIL SCREEN ====================
class CustomerDetailScreen extends StatelessWidget {
  final Map<String, dynamic> customer;

  const CustomerDetailScreen({super.key, required this.customer});

  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
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
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.primaryDarkBlue),
              title: const Text('Edit Customer'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit customer screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Customer',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: const Text(
            'Are you sure you want to delete this customer? This action cannot be undone.'),
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
                  content: Text('Customer deleted successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context); // Go back to customer list
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outstanding = customer['outstanding'] as double;
    final totalReceivable = customer['totalReceivable'] as double;
    final paymentPercentage = totalReceivable > 0
        ? ((totalReceivable - outstanding) / totalReceivable) * 100
        : 0.0;

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
          'Customer Details',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
        actions: [
          // 3-dot menu icon instead of edit icon
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryDarkBlue),
            onSelected: (value) {
              if (value == 'edit') {
                // Navigate to edit customer screen
              } else if (value == 'delete') {
                _showDeleteConfirmation(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20, color: AppTheme.primaryDarkBlue),
                    SizedBox(width: 12),
                    Text('Edit Customer'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete Customer',
                        style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Header Card
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer['name'],
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              customer['id'],
                              style: GoogleFonts.lato(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          customer['status'],
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
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
                              'Total Receivable',
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '₹${NumberFormat('#,##0').format(totalReceivable)}',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                              'Outstanding',
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '₹${NumberFormat('#,##0').format(outstanding)}',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: outstanding > 0
                                    ? const Color(0xFFFBBF24)
                                    : const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: paymentPercentage / 100,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      color: Colors.white,
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${paymentPercentage.toStringAsFixed(1)}% paid',
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Contact Information
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Contact Information',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildInfoRow(
                            Icons.email_outlined, 'Email', customer['email']),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.phone_outlined, 'Phone', customer['phone']),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.location_on_outlined, 'Address',
                            customer['address']),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Business Information
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Business Information',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.business_outlined, 'GST Number',
                            customer['gst'] ?? 'Not provided'),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.credit_card_outlined,
                            'Credit Limit',
                            '₹${NumberFormat('#,##0').format(customer['creditLimit'])}'),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.payment_outlined, 'Payment Terms',
                            customer['paymentTerms']),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Invoice Summary
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Invoice Summary',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            'Total',
                            '${customer['totalInvoices']}',
                            Icons.receipt_long,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            'Paid',
                            '${customer['paidInvoices']}',
                            Icons.check_circle,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            'Overdue',
                            '${customer['overdueInvoices']}',
                            Icons.warning_amber,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Recent Activity
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Recent Activity',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildActivityRow(
                          'Last Invoice',
                          DateFormat('dd MMM yyyy')
                              .format(customer['lastInvoiceDate']),
                          Icons.receipt,
                        ),
                        const SizedBox(height: 10),
                        _buildActivityRow(
                          'Customer Since',
                          DateFormat('dd MMM yyyy')
                              .format(customer['customerSince']),
                          Icons.person_add,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),
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
                  onPressed: () {
                    // Navigate to create invoice for this customer
                  },
                  icon: const Icon(Icons.receipt, size: 16),
                  label: Text(
                    'Create Invoice',
                    style: GoogleFonts.lato(
                      fontSize: 13,
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
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to record payment
                  },
                  icon: const Icon(
                    Icons.payment,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Record Payment',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.subtitleGray),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  color: AppTheme.subtitleGray,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon,
      {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color ?? AppTheme.subtitleGray),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 9,
            color: AppTheme.subtitleGray,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.lightBlueBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: AppTheme.primaryDarkBlue),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  color: AppTheme.subtitleGray,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
