import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'customer_screen.dart';
import 'item_screen.dart';
import 'signin_screen.dart';

// ==================== MAIN BILL LIST SCREEN ====================
class BillListScreen extends StatefulWidget {
  const BillListScreen({super.key});

  @override
  State<BillListScreen> createState() => _BillListScreenState();
}

class _BillListScreenState extends State<BillListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isSearchSticky = false;
  int _selectedBottomNavIndex = 4;

  // User data
  String userName = "Demo User";
  String userEmail = "demo@business.com";
  String userBusiness = "Business";
  String? profileImagePath;

  // Dropdown states for drawer
  bool _isItemExpanded = false;
  bool _isPurchaseExpanded = false;
  bool _isSalesExpanded = false;
  bool _isAccountExpanded = false;

  final List<String> _filterOptions = [
    'All',
    'Draft',
    'Pending',
    'Paid',
    'Overdue'
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  // Sample bill data
  final List<Map<String, dynamic>> _allBills = [
    {
      'id': 'BILL-001',
      'supplier': 'Tech Distributors Inc',
      'email': 'sales@techdist.com',
      'phone': '+91 98765 43210',
      'address': '123 Electronics Market, Mumbai',
      'gst': '29AAACB1234E1Z5',
      'amount': 12500.00,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'dueDate': DateTime.now().add(const Duration(days: 5)),
      'status': 'Pending',
      'items': 3,
      'currency': 'INR',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 2)),
      'deliveryDate': DateTime.now().add(const Duration(days: 3)),
      'referenceNo': 'PO-2024-001',
      'supplierBillNo': 'SINV-12345',
      'notes': 'Need to follow up for delivery',
    },
    {
      'id': 'BILL-002',
      'supplier': 'Office Solutions Ltd',
      'email': 'contact@officesolutions.com',
      'phone': '+91 99887 66554',
      'address': '45 Tech Hub, Bangalore',
      'gst': '27BBBCD5678E2Z8',
      'amount': 8700.00,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'status': 'Paid',
      'items': 2,
      'currency': 'INR',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 5)),
      'deliveryDate': DateTime.now().subtract(const Duration(days: 1)),
      'referenceNo': 'PO-2024-002',
      'supplierBillNo': 'SI-67890',
      'notes': 'Payment completed',
    },
    {
      'id': 'BILL-003',
      'supplier': 'Steel Mills Ltd',
      'email': 'orders@steelmills.com',
      'phone': '+91 87654 32109',
      'address': '12 Industrial Area, Chennai',
      'gst': '24CCCDE9012E3Z1',
      'amount': 23400.00,
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'dueDate': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'Overdue',
      'items': 4,
      'currency': 'INR',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 10)),
      'deliveryDate': DateTime.now().subtract(const Duration(days: 5)),
      'referenceNo': 'PO-2024-003',
      'supplierBillNo': 'SML-78901',
      'notes': 'Urgent payment required',
    },
    {
      'id': 'BILL-004',
      'supplier': 'Global Logistics',
      'email': 'accounts@globallogistics.com',
      'phone': '+91 76543 21098',
      'address': '78 Corporate Tower, Delhi',
      'gst': '27DDDEF1234E4Z2',
      'amount': 5600.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'dueDate': DateTime.now().add(const Duration(days: 10)),
      'status': 'Draft',
      'items': 1,
      'currency': 'INR',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 1)),
      'deliveryDate': DateTime.now().add(const Duration(days: 7)),
      'referenceNo': 'PO-2024-004',
      'supplierBillNo': 'GL-45678',
      'notes': 'Draft - awaiting approval',
    },
    {
      'id': 'BILL-005',
      'supplier': 'Fashion Hub',
      'email': 'orders@fashionhub.com',
      'phone': '+91 65432 10987',
      'address': '34 Fashion Street, Pune',
      'gst': '29EEEFG5678E5Z3',
      'amount': 18900.00,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'dueDate': DateTime.now().add(const Duration(days: 4)),
      'status': 'Pending',
      'items': 5,
      'currency': 'USD',
      'purchaseDate': DateTime.now().subtract(const Duration(days: 3)),
      'deliveryDate': DateTime.now().add(const Duration(days: 2)),
      'referenceNo': 'PO-2024-005',
      'supplierBillNo': 'FH-112233',
      'notes': 'International order',
    },
  ];

  List<Map<String, dynamic>> _filteredBills = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfileImage();
    _filteredBills = List.from(_allBills);
    _searchController.addListener(_filterBills);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterBills);
    _scrollController.removeListener(_scrollListener);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('current_user_name') ??
          prefs.getString('user_name') ??
          'Demo User';
      userEmail = prefs.getString('current_user_email') ?? 'demo@business.com';
      userBusiness = prefs.getString('business_name') ?? 'Business';
    });
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImagePath = prefs.getString('profile_image_path');
    });
  }

  Future<void> _saveProfileImage(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString('profile_image_path', path);
    } else {
      await prefs.remove('profile_image_path');
    }
    setState(() {
      profileImagePath = path;
    });
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading:
                  const Icon(Icons.camera_alt, color: AppTheme.primaryDarkBlue),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? photo = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null) {
                  await _saveProfileImage(photo.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: AppTheme.primaryDarkBlue),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  await _saveProfileImage(image.path);
                }
              },
            ),
            if (profileImagePath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);
                  await _saveProfileImage(null);
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
        (route) => false,
      );
    }
  }

  void _scrollListener() {
    const kpiHeight = 180.0;
    setState(() {
      _isSearchSticky = _scrollController.offset >= kpiHeight;
    });
  }

  void _filterBills() {
    setState(() {
      _filteredBills = _allBills.where((bill) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            bill['id'].toLowerCase().contains(searchQuery) ||
            bill['supplier'].toLowerCase().contains(searchQuery) ||
            bill['supplierBillNo'].toLowerCase().contains(searchQuery);

        final matchesStatus =
            _selectedStatus == 'All' || bill['status'] == _selectedStatus;

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
                        'Filter Bills',
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
                          child: const Icon(Icons.close,
                              size: 18, color: AppTheme.primaryDarkBlue),
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
                          _filterBills();
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
                            _filterBills();
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

  void _showBillDetail(Map<String, dynamic> bill) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BillDetailScreen(bill: bill),
      ),
    );
  }

  void _navigateToScreen(int index) {
    if (index == _selectedBottomNavIndex) return;

    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ItemScreen()),
        );
        break;
      case 3:
        // Invoices
        break;
      case 4:
        // Already on bills screen
        break;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFF10B981);
      case 'Pending':
        return const Color(0xFFF59E0B);
      case 'Draft':
        return const Color(0xFF3B82F6);
      case 'Overdue':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.subtitleGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalBills = _filteredBills.length;
    final totalAmount = _filteredBills.fold(
        0.0, (sum, bill) => sum + (bill['amount'] as double));
    final overdueCount =
        _filteredBills.where((bill) => bill['status'] == 'Overdue').length;
    final overdueAmount = _filteredBills
        .where((bill) => bill['status'] == 'Overdue')
        .fold(0.0, (sum, bill) => sum + (bill['amount'] as double));
    final pendingCount =
        _filteredBills.where((bill) => bill['status'] == 'Pending').length;
    final pendingAmount = _filteredBills
        .where((bill) => bill['status'] == 'Pending')
        .fold(0.0, (sum, bill) => sum + (bill['amount'] as double));
    final paidCount =
        _filteredBills.where((bill) => bill['status'] == 'Paid').length;
    final paidAmount = _filteredBills
        .where((bill) => bill['status'] == 'Paid')
        .fold(0.0, (sum, bill) => sum + (bill['amount'] as double));

    return WillPopScope(
      onWillPop: () async {
        if (_selectedBottomNavIndex != 0) {
          _navigateToScreen(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: AppTheme.primaryDarkBlue),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlueBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person,
                        size: 14, color: AppTheme.primaryDarkBlue),
                    const SizedBox(width: 4),
                    Text(
                      userName,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none,
                      color: AppTheme.primaryDarkBlue),
                  onPressed: () {},
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        drawer: _buildStyledDrawer(),
        body: Column(
          children: [
            // Main content area (scrollable)
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
                                      Text('Total Bills',
                                          style: GoogleFonts.lato(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white70)),
                                      const SizedBox(height: 4),
                                      Text(totalBills.toString(),
                                          style: GoogleFonts.lato(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      Text('Total amount',
                                          style: GoogleFonts.lato(
                                              fontSize: 10,
                                              color: Colors.white70)),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Icon(Icons.receipt,
                                        size: 24, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _buildKpiCard(
                                    'Overdue',
                                    overdueCount,
                                    overdueAmount,
                                    Icons.warning_amber,
                                    const Color(0xFFEF4444)),
                                const SizedBox(width: 10),
                                _buildKpiCard(
                                    'Pending',
                                    pendingCount,
                                    pendingAmount,
                                    Icons.pending_actions,
                                    const Color(0xFFF59E0B)),
                                const SizedBox(width: 10),
                                _buildKpiCard(
                                    'Paid',
                                    paidCount,
                                    paidAmount,
                                    Icons.check_circle,
                                    const Color(0xFF10B981)),
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
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                      ),
                                      child: TextField(
                                        controller: _searchController,
                                        style: GoogleFonts.lato(fontSize: 13),
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search by Bill #, Supplier or PO #',
                                          hintStyle: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Colors.grey.shade400,
                                          ),
                                          prefixIcon: const Icon(Icons.search,
                                              size: 16,
                                              color: AppTheme.subtitleGray),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: _selectedStatus != 'All'
                                            ? AppTheme.primaryDarkBlue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: _selectedStatus != 'All'
                                                ? AppTheme.primaryDarkBlue
                                                : Colors.grey.shade200),
                                      ),
                                      child: Row(
                                        children: [
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Chip(
                                        label: Text('Status: $_selectedStatus',
                                            style:
                                                GoogleFonts.lato(fontSize: 11)),
                                        onDeleted: () {
                                          setState(() {
                                            _selectedStatus = 'All';
                                          });
                                          _filterBills();
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
                      // Bill List
                      if (_filteredBills.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.receipt_outlined,
                                    size: 60, color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                Text('No bills found',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.subtitleGray)),
                                const SizedBox(height: 6),
                                Text('Try adjusting your filters',
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: AppTheme.subtitleGray)),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredBills.length,
                          itemBuilder: (context, index) {
                            final bill = _filteredBills[index];
                            final statusColor = _getStatusColor(bill['status']);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _showBillDetail(bill),
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
                                                  Text(bill['supplier'],
                                                      style: GoogleFonts.lato(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppTheme
                                                              .primaryDarkBlue)),
                                                  const SizedBox(height: 2),
                                                  Text(bill['id'],
                                                      style: GoogleFonts.lato(
                                                          fontSize: 10,
                                                          color: AppTheme
                                                              .subtitleGray)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  color: statusColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Text(bill['status'],
                                                  style: GoogleFonts.lato(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: statusColor)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.receipt_outlined,
                                                size: 12,
                                                color: AppTheme.subtitleGray),
                                            const SizedBox(width: 4),
                                            Text(
                                                'Bill No: ${bill['supplierBillNo']}',
                                                style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    color:
                                                        AppTheme.subtitleGray)),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.qr_code,
                                                size: 12,
                                                color: AppTheme.subtitleGray),
                                            const SizedBox(width: 4),
                                            Text(
                                                'PO Ref: ${bill['referenceNo']}',
                                                style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    color:
                                                        AppTheme.subtitleGray)),
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
                                                Text('Amount',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 9,
                                                        color: AppTheme
                                                            .subtitleGray)),
                                                Text(
                                                    '${bill['currency']} ${NumberFormat('#,##0').format(bill['amount'])}',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87)),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text('Due Date',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 9,
                                                        color: AppTheme
                                                            .subtitleGray)),
                                                Text(
                                                    DateFormat('dd MMM yyyy')
                                                        .format(
                                                            bill['dueDate']),
                                                    style: GoogleFonts.lato(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: bill['dueDate']
                                                                    .isBefore(
                                                                        DateTime
                                                                            .now()) &&
                                                                bill['status'] !=
                                                                    'Paid'
                                                            ? Colors.red
                                                            : Colors.black87)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${bill['items']} items',
                                                style: GoogleFonts.lato(
                                                    fontSize: 9,
                                                    color:
                                                        AppTheme.subtitleGray)),
                                            if (bill['status'] == 'Overdue')
                                              Text('Payment Overdue',
                                                  style: GoogleFonts.lato(
                                                      fontSize: 9,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w600)),
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
            // Create Bill Button - FIXED AT BOTTOM
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2))
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateBillScreen()));
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: Text('Create Bill',
                        style: GoogleFonts.lato(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDarkBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildKpiCard(
      String title, int count, double amount, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
              ],
            ),
            const SizedBox(height: 6),
            Text(count.toString(),
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            Text('₹${NumberFormat('#,##0').format(amount)}',
                style: GoogleFonts.lato(
                    fontSize: 10, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5))
      ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        child: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          onTap: _navigateToScreen,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryDarkBlue,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle:
              GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w500),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined, size: 22),
                activeIcon: Icon(Icons.dashboard, size: 22),
                label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_outline, size: 22),
                activeIcon: Icon(Icons.people, size: 22),
                label: 'Customers'),
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined, size: 22),
                activeIcon: Icon(Icons.inventory_2, size: 22),
                label: 'Items'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined, size: 22),
                activeIcon: Icon(Icons.receipt_long, size: 22),
                label: 'Invoices'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_outlined, size: 22),
                activeIcon: Icon(Icons.receipt, size: 22),
                label: 'Bills'),
          ],
          elevation: 0,
        ),
      ),
    );
  }

  // ==================== DRAWER MENU ====================
  Widget _buildStyledDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      width: 280,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryDarkBlue,
                  AppTheme.primaryDarkBlue.withOpacity(0.7)
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2))
                            ]),
                        child: ClipOval(
                          child: profileImagePath != null
                              ? Image.file(File(profileImagePath!),
                                  width: 50, height: 50, fit: BoxFit.cover)
                              : const Icon(Icons.person,
                                  size: 28, color: AppTheme.primaryDarkBlue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName,
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(userEmail,
                              style: GoogleFonts.lato(
                                  fontSize: 11, color: Colors.white70),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.business,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                              userBusiness.length > 10
                                  ? '${userBusiness.substring(0, 8)}...'
                                  : userBusiness,
                              style: GoogleFonts.lato(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8EAED)),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 4),
                _buildMenuItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToScreen(0);
                    }),
                _buildDropdownMenuItem(
                  icon: Icons.inventory_2_outlined,
                  title: 'Items',
                  isExpanded: _isItemExpanded,
                  onTap: () {
                    setState(() {
                      _isItemExpanded = !_isItemExpanded;
                    });
                  },
                  children: [
                    _buildSubMenuItem('Item', () {
                      Navigator.pop(context);
                      _navigateToScreen(2);
                    }),
                    _buildSubMenuItem('HSN & SAC Code', () {}),
                    _buildSubMenuItem('Categories', () {})
                  ],
                ),
                _buildDropdownMenuItem(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Purchase',
                  isExpanded: _isPurchaseExpanded,
                  onTap: () {
                    setState(() {
                      _isPurchaseExpanded = !_isPurchaseExpanded;
                    });
                  },
                  children: [
                    _buildSubMenuItem('Supplier', () {}),
                    _buildSubMenuItem('Supplier Statement', () {}),
                    _buildSubMenuItem('Purchase Order', () {}),
                    _buildSubMenuItem('Purchase Bill', () {})
                  ],
                ),
                _buildDropdownMenuItem(
                  icon: Icons.trending_up_outlined,
                  title: 'Sales',
                  isExpanded: _isSalesExpanded,
                  onTap: () {
                    setState(() {
                      _isSalesExpanded = !_isSalesExpanded;
                    });
                  },
                  children: [
                    _buildSubMenuItem('Customer', () {
                      Navigator.pop(context);
                      _navigateToScreen(1);
                    }),
                    _buildSubMenuItem('Enquiry', () {}),
                    _buildSubMenuItem('Estimate', () {}),
                    _buildSubMenuItem('Create Invoice', () {})
                  ],
                ),
                _buildDropdownMenuItem(
                  icon: Icons.account_balance_outlined,
                  title: 'Account',
                  isExpanded: _isAccountExpanded,
                  onTap: () {
                    setState(() {
                      _isAccountExpanded = !_isAccountExpanded;
                    });
                  },
                  children: [
                    _buildSubMenuItem('Account Master', () {}),
                    _buildSubMenuItem('Journals', () {}),
                    _buildSubMenuItem('Vouchers', () {}),
                    _buildSubMenuItem('Bank Payments', () {}),
                    _buildSubMenuItem('General Ledger', () {}),
                    _buildSubMenuItem('Trial Balance', () {}),
                    _buildSubMenuItem('Balance Sheets', () {}),
                  ],
                ),
                _buildMenuItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Invoices',
                    onTap: () {
                      Navigator.pop(context);
                    }),
                _buildMenuItem(
                    icon: Icons.receipt_outlined,
                    title: 'Bills',
                    onTap: () {
                      Navigator.pop(context);
                    }),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200))),
            child: Column(
              children: [
                _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {}),
                _buildMenuItem(
                    icon: Icons.logout_outlined,
                    title: 'Logout',
                    iconColor: const Color(0xFFD93025),
                    titleColor: const Color(0xFFD93025),
                    onTap: _logout),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      VoidCallback? onTap,
      bool isActive = false,
      Color? iconColor,
      Color? titleColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
          color: isActive ? AppTheme.lightBlueBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon,
            color: iconColor ??
                (isActive ? AppTheme.primaryDarkBlue : AppTheme.subtitleGray),
            size: 20),
        title: Text(title,
            style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: titleColor ??
                    (isActive ? AppTheme.primaryDarkBlue : Colors.black87))),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        dense: true,
      ),
    );
  }

  Widget _buildDropdownMenuItem(
      {required IconData icon,
      required String title,
      required bool isExpanded,
      required VoidCallback onTap,
      required List<Widget> children}) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: Icon(icon, color: AppTheme.subtitleGray, size: 20),
            title: Text(title,
                style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
            trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 18,
                color: AppTheme.subtitleGray),
            onTap: onTap,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            dense: true,
          ),
        ),
        if (isExpanded)
          Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Column(children: children)),
      ],
    );
  }

  Widget _buildSubMenuItem(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        title: Text(title,
            style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.subtitleGray)),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        dense: true,
      ),
    );
  }
}

// ==================== CREATE BILL SCREEN (Progressive Reveal) ====================
class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Controllers
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _supplierEmailController =
      TextEditingController();
  final TextEditingController _supplierPhoneController =
      TextEditingController();
  final TextEditingController _supplierAddressController =
      TextEditingController();
  final TextEditingController _supplierGstController = TextEditingController();
  final TextEditingController _referenceNoController = TextEditingController();
  final TextEditingController _supplierBillNoController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Focus nodes
  final FocusNode _supplierFocus = FocusNode();
  final FocusNode _supplierBillNoFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();

  // Date controllers
  DateTime? _selectedBillDate;
  DateTime? _selectedPurchaseDate;
  DateTime? _selectedDeliveryDate;
  DateTime? _selectedDueDate;

  // Dropdown values
  String _selectedCurrency = 'INR';
  String _selectedStatus = 'Pending';

  final List<String> _currencies = ['INR', 'USD', 'EUR', 'GBP'];
  final List<String> _statusOptions = ['Draft', 'Pending', 'Paid'];

  // Section visibility states
  bool _showSupplierSection = true;
  bool _showBillDetailsSection = false;
  bool _showAmountSection = false;
  bool _showNotesSection = false;

  // Section completion states
  bool _isSupplierCompleted = false;
  bool _isBillDetailsCompleted = false;
  bool _isAmountCompleted = false;

  // Keys for scrolling
  final GlobalKey _supplierSectionKey = GlobalKey();
  final GlobalKey _billDetailsSectionKey = GlobalKey();
  final GlobalKey _amountSectionKey = GlobalKey();
  final GlobalKey _notesSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _supplierFocus.addListener(_onSupplierFocusChange);
    _supplierBillNoFocus.addListener(_onSupplierBillNoFocusChange);
    _amountFocus.addListener(_onAmountFocusChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _supplierFocus.dispose();
    _supplierBillNoFocus.dispose();
    _amountFocus.dispose();
    _supplierController.dispose();
    _supplierEmailController.dispose();
    _supplierPhoneController.dispose();
    _supplierAddressController.dispose();
    _supplierGstController.dispose();
    _referenceNoController.dispose();
    _supplierBillNoController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSupplierFocusChange() {
    if (!_supplierFocus.hasFocus) {
      _checkAndOpenBillDetailsSection();
    }
  }

  void _onSupplierBillNoFocusChange() {
    if (!_supplierBillNoFocus.hasFocus) {
      _checkAndOpenAmountSection();
    }
  }

  void _onAmountFocusChange() {
    if (!_amountFocus.hasFocus) {
      _checkAndOpenNotesSection();
    }
  }

  void _checkAndOpenBillDetailsSection() {
    setState(() {
      _isSupplierCompleted = _supplierController.text.trim().isNotEmpty;
      if (_isSupplierCompleted && !_showBillDetailsSection) {
        _showBillDetailsSection = true;
        _scrollToSection(_billDetailsSectionKey);
      }
    });
  }

  void _checkAndOpenAmountSection() {
    setState(() {
      _isBillDetailsCompleted =
          _supplierBillNoController.text.trim().isNotEmpty &&
              _selectedDueDate != null;
      if (_isBillDetailsCompleted && !_showAmountSection) {
        _showAmountSection = true;
        _scrollToSection(_amountSectionKey);
      }
    });
  }

  void _checkAndOpenNotesSection() {
    setState(() {
      _isAmountCompleted = _amountController.text.trim().isNotEmpty;
      if (_isAmountCompleted && !_showNotesSection) {
        _showNotesSection = true;
        _scrollToSection(_notesSectionKey);
      }
    });
  }

  void _scrollToSection(GlobalKey sectionKey) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final context = sectionKey.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.2,
          );
        }
      }
    });
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    DateTime? initialDate;
    switch (type) {
      case 'Bill Date':
        initialDate = _selectedBillDate ?? DateTime.now();
        break;
      case 'Purchase Date':
        initialDate = _selectedPurchaseDate ?? DateTime.now();
        break;
      case 'Delivery Date':
        initialDate = _selectedDeliveryDate ?? DateTime.now();
        break;
      case 'Due Date':
        initialDate = _selectedDueDate ?? DateTime.now();
        break;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                const ColorScheme.light(primary: AppTheme.primaryDarkBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        switch (type) {
          case 'Bill Date':
            _selectedBillDate = picked;
            break;
          case 'Purchase Date':
            _selectedPurchaseDate = picked;
            break;
          case 'Delivery Date':
            _selectedDeliveryDate = picked;
            break;
          case 'Due Date':
            _selectedDueDate = picked;
            _checkAndOpenAmountSection();
            break;
        }
      });
    }
  }

  void _saveBill() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bill created successfully!'),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
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
        title: Text('Create Bill',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
        actions: [
          TextButton(
            onPressed: _saveBill,
            child: Text('Save',
                style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDarkBlue)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Supplier Information Section
              Container(
                key: _supplierSectionKey,
                child: _buildInfoCard(
                  title: 'Supplier Information',
                  icon: Icons.business_outlined,
                  isRequired: true,
                  isCompleted: _isSupplierCompleted,
                  children: [
                    _buildTextField(
                      controller: _supplierController,
                      focusNode: _supplierFocus,
                      label: 'Supplier Name',
                      hint: 'Enter supplier name',
                      icon: Icons.business,
                      required: true,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Supplier name is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _supplierEmailController,
                      label: 'Email',
                      hint: 'supplier@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _supplierPhoneController,
                      label: 'Phone',
                      hint: 'Enter phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _supplierAddressController,
                      label: 'Address',
                      hint: 'Enter supplier address',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _supplierGstController,
                      label: 'GST Number',
                      hint: 'Enter GST number',
                      icon: Icons.request_quote_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Bill Details Section
              if (_showBillDetailsSection)
                Container(
                  key: _billDetailsSectionKey,
                  child: _buildInfoCard(
                    title: 'Bill Details',
                    icon: Icons.receipt_outlined,
                    isRequired: true,
                    isCompleted: _isBillDetailsCompleted,
                    children: [
                      _buildDateField(
                        label: 'Bill Date',
                        selectedDate: _selectedBillDate,
                        onTap: () => _selectDate(context, 'Bill Date'),
                        icon: Icons.calendar_today,
                      ),
                      const SizedBox(height: 14),
                      _buildDateField(
                        label: 'Purchase Date',
                        selectedDate: _selectedPurchaseDate,
                        onTap: () => _selectDate(context, 'Purchase Date'),
                        icon: Icons.shopping_cart,
                      ),
                      const SizedBox(height: 14),
                      _buildDateField(
                        label: 'Delivery Date',
                        selectedDate: _selectedDeliveryDate,
                        onTap: () => _selectDate(context, 'Delivery Date'),
                        icon: Icons.local_shipping,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _referenceNoController,
                        label: 'Reference # (PO)',
                        hint: 'Enter PO number',
                        icon: Icons.qr_code,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _supplierBillNoController,
                        focusNode: _supplierBillNoFocus,
                        label: 'Supplier Bill No.',
                        hint: 'Enter supplier bill number',
                        icon: Icons.receipt,
                        required: true,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Supplier Bill No. is required'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      _buildDateField(
                        label: 'Due Date',
                        selectedDate: _selectedDueDate,
                        onTap: () => _selectDate(context, 'Due Date'),
                        icon: Icons.event,
                        required: true,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Amount & Currency Section
              if (_showAmountSection)
                Container(
                  key: _amountSectionKey,
                  child: _buildInfoCard(
                    title: 'Amount Details',
                    icon: Icons.attach_money,
                    isRequired: true,
                    isCompleted: _isAmountCompleted,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildDropdownField(
                              value: _selectedCurrency,
                              label: 'Currency',
                              icon: Icons.currency_exchange,
                              items: _currencies,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCurrency = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 3,
                            child: _buildTextField(
                              controller: _amountController,
                              focusNode: _amountFocus,
                              label: 'Amount',
                              hint: '0.00',
                              icon: Icons.currency_rupee,
                              keyboardType: TextInputType.number,
                              required: true,
                              prefix: _selectedCurrency == 'INR'
                                  ? '₹ '
                                  : _selectedCurrency == 'USD'
                                      ? '\$ '
                                      : _selectedCurrency == 'EUR'
                                          ? '€ '
                                          : '£ ',
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Amount is required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildDropdownField(
                        value: _selectedStatus,
                        label: 'Status',
                        icon: Icons.toggle_on_outlined,
                        items: _statusOptions,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Notes Section
              if (_showNotesSection)
                Container(
                  key: _notesSectionKey,
                  child: _buildInfoCard(
                    title: 'Additional Notes',
                    icon: Icons.note_outlined,
                    isRequired: false,
                    isCompleted: false,
                    children: [
                      _buildTextField(
                        controller: _notesController,
                        label: 'Notes',
                        hint: 'Enter any additional notes',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                      onPressed: _saveBill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDarkBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text('Create Bill',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required bool isRequired,
    required bool isCompleted,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF10B981).withOpacity(0.5)
              : Colors.grey.shade200,
          width: isCompleted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : AppTheme.lightBlueBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      size: 18,
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : AppTheme.primaryDarkBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Text(title,
                          style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue)),
                      if (isRequired)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text('(Required)',
                              style: GoogleFonts.lato(
                                  fontSize: 10,
                                  color: isCompleted
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444))),
                        ),
                      if (isCompleted)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(Icons.check_circle,
                              size: 14, color: const Color(0xFF10B981)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(children: children)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: GoogleFonts.lato(fontSize: 14, color: Colors.black87),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppTheme.subtitleGray),
        prefixText: prefix,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppTheme.primaryDarkBlue, width: 1.5)),
        labelStyle:
            GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
        hintStyle: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        isDense: true,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    required IconData icon,
    bool required = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.subtitleGray),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate != null
                    ? DateFormat('dd MMM yyyy').format(selectedDate)
                    : 'Select $label',
                style: GoogleFonts.lato(
                    fontSize: 14,
                    color: selectedDate != null
                        ? Colors.black87
                        : Colors.grey.shade400),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppTheme.subtitleGray),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 18, color: AppTheme.subtitleGray),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle:
              GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item,
                    style:
                        GoogleFonts.lato(fontSize: 14, color: Colors.black87))))
            .toList(),
        onChanged: onChanged,
        style: GoogleFonts.lato(fontSize: 14, color: Colors.black87),
        icon: Icon(Icons.keyboard_arrow_down, color: AppTheme.subtitleGray),
        dropdownColor: Colors.white,
        isExpanded: true,
        menuMaxHeight: 300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

// ==================== BILL DETAIL SCREEN ====================
class BillDetailScreen extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillDetailScreen({super.key, required this.bill});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bill'),
        content: const Text(
            'Are you sure you want to delete this bill? This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Bill deleted successfully'),
                  duration: Duration(seconds: 2)));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFF10B981);
      case 'Pending':
        return const Color(0xFFF59E0B);
      case 'Draft':
        return const Color(0xFF3B82F6);
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
        title: Text('Bill Details',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryDarkBlue),
            onSelected: (value) {
              if (value == 'delete') _showDeleteConfirmation(context);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit, size: 20, color: AppTheme.primaryDarkBlue),
                    SizedBox(width: 12),
                    Text('Edit Bill')
                  ])),
              const PopupMenuItem(
                  value: 'preview',
                  child: Row(children: [
                    Icon(Icons.preview,
                        size: 20, color: AppTheme.primaryDarkBlue),
                    SizedBox(width: 12),
                    Text('Preview Bill')
                  ])),
              const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete Bill', style: TextStyle(color: Colors.red))
                  ])),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Header Card
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
                            Text(bill['supplier'],
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(bill['id'],
                                style: GoogleFonts.lato(
                                    fontSize: 11, color: Colors.white70)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(bill['status'],
                            style: GoogleFonts.lato(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
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
                            Text('Amount',
                                style: GoogleFonts.lato(
                                    fontSize: 10, color: Colors.white70)),
                            Text(
                                '${bill['currency']} ${NumberFormat('#,##0').format(bill['amount'])}',
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Due Date',
                                style: GoogleFonts.lato(
                                    fontSize: 10, color: Colors.white70)),
                            Text(
                                DateFormat('dd MMM yyyy')
                                    .format(bill['dueDate']),
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Supplier Information
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Supplier Information',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue))),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.business_outlined, 'Supplier Name',
                            bill['supplier']),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.email_outlined, 'Email', bill['email']),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.phone_outlined, 'Phone', bill['phone']),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.location_on_outlined, 'Address',
                            bill['address']),
                        if (bill['gst'] != null) ...[
                          const SizedBox(height: 10),
                          _buildInfoRow(Icons.request_quote_outlined,
                              'GST Number', bill['gst'])
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Bill Details
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Bill Details',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue))),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.calendar_today, 'Bill Date',
                            DateFormat('dd MMM yyyy').format(bill['date'])),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.shopping_cart,
                            'Purchase Date',
                            DateFormat('dd MMM yyyy')
                                .format(bill['purchaseDate'])),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.local_shipping,
                            'Delivery Date',
                            DateFormat('dd MMM yyyy')
                                .format(bill['deliveryDate'])),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.qr_code, 'Reference # (PO)',
                            bill['referenceNo']),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.receipt, 'Supplier Bill No.',
                            bill['supplierBillNo']),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.event, 'Due Date',
                            DateFormat('dd MMM yyyy').format(bill['dueDate'])),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.currency_exchange, 'Currency',
                            bill['currency']),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.receipt, 'Total Items',
                            '${bill['items']} items'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (bill['notes'] != null && bill['notes'].toString().isNotEmpty)
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('Notes',
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDarkBlue))),
                    const Divider(height: 1),
                    Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(bill['notes'],
                            style: GoogleFonts.lato(
                                fontSize: 12, color: AppTheme.subtitleGray))),
                  ],
                ),
              ),
            const SizedBox(height: 60),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ]),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BillPreviewScreen(bill: bill)));
                  },
                  icon: const Icon(Icons.preview, size: 16),
                  label: Text('Preview',
                      style: GoogleFonts.lato(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(color: AppTheme.primaryDarkBlue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Payment recording coming soon')));
                  },
                  icon:
                      const Icon(Icons.payment, size: 16, color: Colors.white),
                  label: Text('Record Payment',
                      style: GoogleFonts.lato(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDarkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0),
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
              Text(label,
                  style: GoogleFonts.lato(
                      fontSize: 10, color: AppTheme.subtitleGray)),
              Text(value,
                  style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== BILL PREVIEW SCREEN (Professional Design) ====================
class BillPreviewScreen extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillPreviewScreen({super.key, required this.bill});

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
          'Bill Preview',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppTheme.primaryDarkBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppTheme.primaryDarkBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.print, color: AppTheme.primaryDarkBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Print feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main Bill Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with Gradient
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryDarkBlue,
                          AppTheme.primaryDarkBlue.withOpacity(0.85),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PURCHASE BILL',
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 50,
                                  height: 3,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    bill['status'].toUpperCase(),
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Bill #: ${bill['id']}',
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  'Date: ${DateFormat('dd MMM yyyy').format(bill['date'])}',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bill Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Bill From Section (Full Width)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.lightBlueBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryDarkBlue.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryDarkBlue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.business_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'BILL FROM',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                bill['supplier'],
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (bill['address'] != null)
                                Text(
                                  bill['address'],
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: AppTheme.subtitleGray,
                                    height: 1.4,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    size: 14,
                                    color: AppTheme.subtitleGray,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    bill['email'],
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone_outlined,
                                    size: 14,
                                    color: AppTheme.subtitleGray,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    bill['phone'],
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                ],
                              ),
                              if (bill['gst'] != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'GST: ${bill['gst']}',
                                    style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Bill Details Section (Below)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightBlueBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.receipt_outlined,
                                      size: 18,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'BILL DETAILS',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Two Column Grid for Bill Details
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildDetailItem(
                                          icon: Icons.receipt_long,
                                          label: 'Supplier Bill No.',
                                          value: bill['supplierBillNo'],
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailItem(
                                          icon: Icons.qr_code,
                                          label: 'PO Reference',
                                          value: bill['referenceNo'],
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailItem(
                                          icon: Icons.calendar_today,
                                          label: 'Bill Date',
                                          value: DateFormat('dd MMM yyyy')
                                              .format(bill['date']),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildDetailItem(
                                          icon: Icons.event,
                                          label: 'Due Date',
                                          value: DateFormat('dd MMM yyyy')
                                              .format(bill['dueDate']),
                                          valueColor: bill['dueDate'].isBefore(
                                                      DateTime.now()) &&
                                                  bill['status'] != 'Paid'
                                              ? Colors.red
                                              : null,
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailItem(
                                          icon: Icons.shopping_cart,
                                          label: 'Purchase Date',
                                          value: DateFormat('dd MMM yyyy')
                                              .format(bill['purchaseDate']),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailItem(
                                          icon: Icons.local_shipping,
                                          label: 'Delivery Date',
                                          value: DateFormat('dd MMM yyyy')
                                              .format(bill['deliveryDate']),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Items Summary Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightBlueBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2_outlined,
                                      size: 18,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'ITEMS SUMMARY',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSummaryItem(
                                      title: 'Total Items',
                                      value: '${bill['items']}',
                                      icon: Icons.production_quantity_limits,
                                      color: const Color(0xFF3B82F6),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSummaryItem(
                                      title: 'Currency',
                                      value: bill['currency'],
                                      icon: Icons.currency_exchange,
                                      color: const Color(0xFF8B5CF6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Amount Section (Highlighted)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryDarkBlue.withOpacity(0.05),
                                AppTheme.primaryDarkBlue.withOpacity(0.02),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryDarkBlue.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  Text(
                                    '${bill['currency']} ${NumberFormat('#,##0.00').format(bill['amount'] * 0.97)}',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tax (GST)',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  Text(
                                    '${bill['currency']} ${NumberFormat('#,##0.00').format(bill['amount'] * 0.03)}',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'TOTAL AMOUNT',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                  Text(
                                    '${bill['currency']} ${NumberFormat('#,##0.00').format(bill['amount'])}',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDarkBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Notes Section
                        if (bill['notes'] != null &&
                            bill['notes'].toString().isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.lightBlueBg,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.note_outlined,
                                        size: 18,
                                        color: AppTheme.primaryDarkBlue,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'NOTES',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryDarkBlue,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  bill['notes'],
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: AppTheme.subtitleGray,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Terms & Conditions
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TERMS & CONDITIONS',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.subtitleGray,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '1. Payment is due within 30 days of invoice date.\n'
                                '2. Please include the bill number with your payment.\n'
                                '3. Late payments may incur additional charges.',
                                style: GoogleFonts.lato(
                                  fontSize: 11,
                                  color: AppTheme.subtitleGray,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Footer
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.lightBlueBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.qr_code_2,
                                    size: 40,
                                    color: AppTheme.primaryDarkBlue
                                        .withOpacity(0.5),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    children: [
                                      Text(
                                        'Thank you for your business!',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primaryDarkBlue,
                                        ),
                                      ),
                                      Text(
                                        'This is a computer generated bill',
                                        style: GoogleFonts.lato(
                                          fontSize: 10,
                                          color: AppTheme.primaryDarkBlue
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Powered by text
                        Center(
                          child: Text(
                            'Powered by Your Business Name',
                            style: GoogleFonts.lato(
                              fontSize: 10,
                              color: AppTheme.subtitleGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.subtitleGray),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 11,
                  color: AppTheme.subtitleGray,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    color: AppTheme.subtitleGray,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
