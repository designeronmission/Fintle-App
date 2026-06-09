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
import 'bills.dart';
import 'invoice.dart';
import 'category_management.dart';

// ==================== HSN/SAC CODE MODEL ====================
class HsnSacCode {
  final String id;
  final String code;
  final String description;
  final String type;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? gstRate;
  final String? section;

  HsnSacCode({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.gstRate,
    this.section,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'description': description,
        'type': type,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'gstRate': gstRate,
        'section': section,
      };

  factory HsnSacCode.fromJson(Map<String, dynamic> json) => HsnSacCode(
        id: json['id'],
        code: json['code'],
        description: json['description'],
        type: json['type'],
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        gstRate: json['gstRate'],
        section: json['section'],
      );
}

// ==================== HSN/SAC MANAGEMENT SCREEN ====================
class HsnSacManagementScreen extends StatefulWidget {
  const HsnSacManagementScreen({super.key});

  @override
  State<HsnSacManagementScreen> createState() => _HsnSacManagementScreenState();
}

class _HsnSacManagementScreenState extends State<HsnSacManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All';
  String _selectedStatus = 'All';
  int _selectedBottomNavIndex = 2; // Changed to 2 for Items menu

  List<HsnSacCode> _allCodes = [];
  List<HsnSacCode> _filteredCodes = [];

  bool _isLoading = true;
  bool _isItemExpanded = true; // Changed to true for Master menu
  bool _isPurchaseExpanded = false;
  bool _isSalesExpanded = false;
  bool _isAccountExpanded = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  String userName = "John";
  String userEmail = "john@business.com";
  String userBusiness = "Business";
  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _loadUserData();
    _loadProfileImage();
    _searchController.addListener(_filterCodes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCodes);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('current_user_name') ??
          prefs.getString('user_name') ??
          'John';
      userEmail = prefs.getString('current_user_email') ?? 'john@business.com';
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

  void _loadSampleData() {
    final sampleCodes = [
      HsnSacCode(
        id: '1',
        code: '84713010',
        description:
            'Portable automatic data processing machines, weighing not more than 10 kg',
        type: 'HSN',
        status: 'Active',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        gstRate: 18.0,
        section: '84',
      ),
      HsnSacCode(
        id: '2',
        code: '85171210',
        description:
            'Telephones for cellular networks or for other wireless networks',
        type: 'HSN',
        status: 'Active',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
        gstRate: 12.0,
        section: '85',
      ),
      HsnSacCode(
        id: '3',
        code: '998311',
        description: 'Software development services',
        type: 'SAC',
        status: 'Active',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
        gstRate: 18.0,
      ),
      HsnSacCode(
        id: '4',
        code: '997211',
        description: 'Accounting and auditing services',
        type: 'SAC',
        status: 'Active',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        gstRate: 18.0,
      ),
      HsnSacCode(
        id: '5',
        code: '87032391',
        description: 'Motor cars with engine capacity 1500cc to 2000cc',
        type: 'HSN',
        status: 'Inactive',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
        gstRate: 28.0,
        section: '87',
      ),
    ];

    setState(() {
      _allCodes = sampleCodes;
      _filteredCodes = List.from(_allCodes);
      _isLoading = false;
    });
  }

  void _filterCodes() {
    setState(() {
      _filteredCodes = _allCodes.where((code) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            code.code.toLowerCase().contains(searchQuery) ||
            code.description.toLowerCase().contains(searchQuery);
        final matchesType =
            _selectedType == 'All' || code.type == _selectedType;
        final matchesStatus =
            _selectedStatus == 'All' || code.status == _selectedStatus;
        return matchesSearch && matchesType && matchesStatus;
      }).toList();
    });
  }

  void _navigateToScreen(String screenName) {
    Navigator.pop(context);
    switch (screenName) {
      case 'Dashboard':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        break;
      case 'Customers':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerScreen()),
        );
        break;
      case 'Items':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ItemScreen()),
        );
        break;
      case 'Invoices':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InvoiceListScreen()),
        );
        break;
      case 'Bills':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BillListScreen()),
        );
        break;
      case 'Category':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CategoryManagementScreen()),
        );
        break;
      case 'HSN & SAC Code':
        // Already on this screen
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Coming soon'), duration: Duration(seconds: 1)),
        );
    }
  }

  void _createNewCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateHsnSacCodeScreen()),
    ).then((result) {
      if (result != null && result is HsnSacCode) {
        setState(() {
          _allCodes.add(result);
          _filterCodes();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${result.type} Code created successfully'),
              backgroundColor: const Color(0xFF10B981)),
        );
      }
    });
  }

// Update the build method's KPI section and _buildStatCard method

  @override
  Widget build(BuildContext context) {
    final activeCount =
        _filteredCodes.where((c) => c.status == 'Active').length;
    final hsnCount = _filteredCodes.where((c) => c.type == 'HSN').length;
    final sacCount = _filteredCodes.where((c) => c.type == 'SAC').length;
    final totalItems = _filteredCodes.length;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.primaryDarkBlue),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'HSN / SAC Codes',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue),
        ),
      ),
      drawer: _buildStyledDrawer(),
      body: Column(
        children: [
          // KPI Cards - Matching Customer Screen Design
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Total Codes Card (Gradient - like Total Customers)
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Codes',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            totalItems.toString(),
                            style: GoogleFonts.lato(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'HSN: $hsnCount | SAC: $sacCount',
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
                          Icons.code,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Two Cards Row - Active & Inactive
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
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
                                Text(
                                  'Active',
                                  style: GoogleFonts.lato(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.subtitleGray,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
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
                              activeCount.toString(),
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${((activeCount / totalItems) * 100).toStringAsFixed(0)}% of total',
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
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Inactive',
                                  style: GoogleFonts.lato(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.subtitleGray,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              (totalItems - activeCount).toString(),
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${(((totalItems - activeCount) / totalItems) * 100).toStringAsFixed(0)}% of total',
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

          // Search & Filter (same as before)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.lato(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Search by code or description...',
                        hintStyle: GoogleFonts.lato(
                            fontSize: 12, color: Colors.grey.shade400),
                        prefixIcon: const Icon(Icons.search,
                            size: 16, color: AppTheme.subtitleGray),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildFilterChip(),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips Row (same as before)
          if (_selectedType != 'All' || _selectedStatus != 'All')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_selectedType != 'All')
                      Chip(
                        label: Text('Type: $_selectedType',
                            style: GoogleFonts.lato(fontSize: 11)),
                        onDeleted: () {
                          setState(() {
                            _selectedType = 'All';
                          });
                          _filterCodes();
                        },
                        backgroundColor: AppTheme.lightBlueBg,
                        deleteIcon: const Icon(Icons.close, size: 12),
                      ),
                    if (_selectedStatus != 'All') ...[
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('Status: $_selectedStatus',
                            style: GoogleFonts.lato(fontSize: 11)),
                        onDeleted: () {
                          setState(() {
                            _selectedStatus = 'All';
                          });
                          _filterCodes();
                        },
                        backgroundColor: AppTheme.lightBlueBg,
                        deleteIcon: const Icon(Icons.close, size: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),

          // List (same as before)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCodes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.code_off,
                                size: 60, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('No codes found',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.subtitleGray)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredCodes.length,
                        itemBuilder: (context, index) {
                          final code = _filteredCodes[index];
                          return _buildCodeCard(code);
                        },
                      ),
          ),

          // Create Button (same as before)
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
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _createNewCode,
                  icon: const Icon(Icons.add, size: 20),
                  label: Text('Create New Code',
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
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildFilterChip() {
    bool isFilterActive = _selectedType != 'All' || _selectedStatus != 'All';
    return GestureDetector(
      onTap: _showFilterDialog,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isFilterActive ? AppTheme.primaryDarkBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isFilterActive
                  ? AppTheme.primaryDarkBlue
                  : Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_list,
                size: 16,
                color: isFilterActive ? Colors.white : AppTheme.subtitleGray),
            const SizedBox(width: 6),
            Text('Filter',
                style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isFilterActive ? Colors.white : Colors.black87)),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Filter Codes',
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkBlue)),
            const SizedBox(height: 20),
            Text('Code Type',
                style: GoogleFonts.lato(
                    fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['All', 'HSN', 'SAC']
                  .map((type) => FilterChip(
                        selected: _selectedType == type,
                        label: Text(type),
                        onSelected: (s) {
                          setState(() {
                            _selectedType = type;
                          });
                          _filterCodes();
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: AppTheme.primaryDarkBlue,
                        labelStyle: GoogleFonts.lato(
                            color: _selectedType == type
                                ? Colors.white
                                : Colors.black87),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('Status',
                style: GoogleFonts.lato(
                    fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['All', 'Active', 'Inactive']
                  .map((status) => FilterChip(
                        selected: _selectedStatus == status,
                        label: Text(status),
                        onSelected: (s) {
                          setState(() {
                            _selectedStatus = status;
                          });
                          _filterCodes();
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: AppTheme.primaryDarkBlue,
                        labelStyle: GoogleFonts.lato(
                            color: _selectedStatus == status
                                ? Colors.white
                                : Colors.black87),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedType = 'All';
                        _selectedStatus = 'All';
                        _searchController.clear();
                      });
                      _filterCodes();
                      Navigator.pop(context);
                    },
                    child: Text('Clear All',
                        style: GoogleFonts.lato(color: AppTheme.subtitleGray)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDarkBlue),
                    child: Text('Apply',
                        style: GoogleFonts.lato(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeCard(HsnSacCode code) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showCodeDetails(code),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: code.type == 'HSN'
                            ? const Color(0xFF3B82F6).withOpacity(0.1)
                            : const Color(0xFF8B5CF6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        code.type == 'HSN'
                            ? Icons.inventory_2
                            : Icons.room_service,
                        size: 24,
                        color: code.type == 'HSN'
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(code.code,
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryDarkBlue)),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: code.type == 'HSN'
                                  ? const Color(0xFF3B82F6).withOpacity(0.1)
                                  : const Color(0xFF8B5CF6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(code.type,
                                style: GoogleFonts.lato(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: code.type == 'HSN'
                                        ? const Color(0xFF3B82F6)
                                        : const Color(0xFF8B5CF6))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: code.status == 'Active'
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(code.status,
                          style: GoogleFonts.lato(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: code.status == 'Active'
                                  ? const Color(0xFF10B981)
                                  : Colors.red)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(code.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                        fontSize: 12, color: AppTheme.subtitleGray)),
                if (code.gstRate != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.percent,
                            size: 12, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text('GST ${code.gstRate}%',
                            style: GoogleFonts.lato(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF59E0B))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCodeDetails(HsnSacCode code) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${code.type} Code Details',
                            style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDarkBlue)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              color: code.status == 'Active'
                                  ? const Color(0xFF10B981).withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(code.status,
                              style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: code.status == 'Active'
                                      ? const Color(0xFF10B981)
                                      : Colors.red)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailTile(Icons.code, 'Code', code.code),
                    const SizedBox(height: 12),
                    _buildDetailTile(
                        Icons.description, 'Description', code.description),
                    if (code.gstRate != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailTile(
                          Icons.percent, 'GST Rate', '${code.gstRate}%'),
                    ],
                    if (code.section != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailTile(Icons.folder, 'Section', code.section!),
                    ],
                    const SizedBox(height: 12),
                    _buildDetailTile(Icons.calendar_today, 'Created',
                        DateFormat('dd MMM yyyy').format(code.createdAt)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigate to edit
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppTheme.primaryDarkBlue)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Delete functionality
                            },
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.lightBlueBg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: AppTheme.primaryDarkBlue)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.lato(
                        fontSize: 11, color: AppTheme.subtitleGray)),
                Text(value,
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, size: 14, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(count.toString(),
              style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
      ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        child: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          onTap: (index) {
            setState(() {
              _selectedBottomNavIndex = index;
            });
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()));
                break;
              case 1:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomerScreen()));
                break;
              case 2:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ItemScreen()));
                break;
              case 3:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InvoiceListScreen()));
                break;
              case 4:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BillListScreen()));
                break;
            }
          },
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
        ),
      ),
    );
  }

  Widget _buildStyledDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      width: 280,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              AppTheme.primaryDarkBlue,
              AppTheme.primaryDarkBlue.withOpacity(0.7)
            ])),
            child: Row(
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
                              blurRadius: 8)
                        ]),
                    child: ClipOval(
                        child: profileImagePath != null
                            ? Image.file(File(profileImagePath!),
                                fit: BoxFit.cover)
                            : const Icon(Icons.person,
                                size: 28, color: AppTheme.primaryDarkBlue)),
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
                              color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(userEmail,
                          style: GoogleFonts.lato(
                              fontSize: 11, color: Colors.white70),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(Icons.business, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                          userBusiness.length > 10
                              ? '${userBusiness.substring(0, 8)}...'
                              : userBusiness,
                          style: GoogleFonts.lato(
                              fontSize: 10, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8EAED)),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(Icons.dashboard_outlined, 'Dashboard',
                    () => _navigateToScreen('Dashboard')),
                _buildMenuItem(Icons.people_outline, 'Customers',
                    () => _navigateToScreen('Customers')),
                _buildMenuItem(Icons.inventory_2_outlined, 'Items',
                    () => _navigateToScreen('Items')),
                _buildDropdownMenuItem(
                    Icons.receipt_long_outlined,
                    'Sales',
                    _isSalesExpanded,
                    () => setState(() {
                          _isSalesExpanded = !_isSalesExpanded;
                        }),
                    [
                      _buildSubMenuItem('Create Invoice',
                          () => _navigateToScreen('Create Invoice')),
                      _buildSubMenuItem(
                          'Invoices', () => _navigateToScreen('Invoices')),
                      _buildSubMenuItem(
                          'Customer', () => _navigateToScreen('Customers')),
                    ]),
                _buildMenuItem(Icons.receipt_outlined, 'Bills',
                    () => _navigateToScreen('Bills')),
                _buildDropdownMenuItem(
                    Icons.category,
                    'Master',
                    _isItemExpanded,
                    () => setState(() {
                          _isItemExpanded = !_isItemExpanded;
                        }),
                    [
                      _buildSubMenuItem(
                          'Category', () => _navigateToScreen('Category')),
                      _buildSubMenuItem('HSN & SAC Code',
                          () => _navigateToScreen('HSN & SAC Code'),
                          isActive: true),
                    ]),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200))),
            child: Column(
              children: [
                _buildMenuItem(Icons.settings_outlined, 'Settings', () {}),
                _buildMenuItem(Icons.logout_outlined, 'Logout', _logout,
                    iconColor: const Color(0xFFD93025),
                    titleColor: const Color(0xFFD93025)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {bool isActive = false, Color? iconColor, Color? titleColor}) {
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
        dense: true,
      ),
    );
  }

  Widget _buildDropdownMenuItem(IconData icon, String title, bool isExpanded,
      VoidCallback onTap, List<Widget> children) {
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

  Widget _buildSubMenuItem(String title, VoidCallback onTap,
      {bool isActive = false}) {
    return ListTile(
      title: Text(title,
          style: GoogleFonts.lato(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color:
                  isActive ? AppTheme.primaryDarkBlue : AppTheme.subtitleGray)),
      onTap: onTap,
      dense: true,
    );
  }
}

// ==================== CREATE/EDIT HSN/SAC CODE SCREEN ====================
class CreateHsnSacCodeScreen extends StatefulWidget {
  final HsnSacCode? editCode;
  const CreateHsnSacCodeScreen({super.key, this.editCode});

  @override
  State<CreateHsnSacCodeScreen> createState() => _CreateHsnSacCodeScreenState();
}

class _CreateHsnSacCodeScreenState extends State<CreateHsnSacCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _gstRateController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  String _selectedType = 'HSN';
  String _selectedStatus = 'Active';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.editCode != null) {
      _isEditing = true;
      _codeController.text = widget.editCode!.code;
      _descriptionController.text = widget.editCode!.description;
      _selectedType = widget.editCode!.type;
      _selectedStatus = widget.editCode!.status;
      if (widget.editCode!.gstRate != null)
        _gstRateController.text = widget.editCode!.gstRate!.toString();
      if (widget.editCode!.section != null)
        _sectionController.text = widget.editCode!.section!;
    }
  }

  void _saveCode() {
    if (_formKey.currentState!.validate()) {
      final newCode = HsnSacCode(
        id: _isEditing
            ? widget.editCode!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        code: _codeController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        status: _selectedStatus,
        createdAt: _isEditing ? widget.editCode!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        gstRate: _gstRateController.text.trim().isNotEmpty
            ? double.parse(_gstRateController.text.trim())
            : null,
        section: _sectionController.text.trim().isNotEmpty
            ? _sectionController.text.trim()
            : null,
      );
      Navigator.pop(context, newCode);
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
                color: AppTheme.primaryDarkBlue),
            onPressed: () => Navigator.pop(context)),
        title: Text(
            _isEditing
                ? 'Edit $_selectedType Code'
                : 'Create $_selectedType Code',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
        actions: [
          TextButton(
              onPressed: _saveCode,
              child: Text(_isEditing ? 'Update' : 'Save',
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDarkBlue)))
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Select Code Type',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDarkBlue))),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                              child: _buildTypeCard(
                                  'HSN Code',
                                  'Goods / Products',
                                  Icons.inventory_2,
                                  _selectedType == 'HSN',
                                  () => setState(() => _selectedType = 'HSN'))),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildTypeCard(
                                  'SAC Code',
                                  'Services',
                                  Icons.room_service,
                                  _selectedType == 'SAC',
                                  () => setState(() => _selectedType = 'SAC'))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Code Details',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDarkBlue))),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildTextField(
                              _codeController,
                              '${_selectedType} Code',
                              'Enter code',
                              Icons.code,
                              true,
                              validator: (v) =>
                                  v!.isEmpty ? 'Enter code' : null),
                          const SizedBox(height: 16),
                          _buildTextField(_descriptionController, 'Description',
                              'Enter description', Icons.description, true,
                              maxLines: 3),
                          const SizedBox(height: 16),
                          _buildTextField(_gstRateController, 'GST Rate (%)',
                              'Enter GST rate', Icons.percent, false,
                              keyboardType: TextInputType.number),
                          if (_selectedType == 'HSN') ...[
                            const SizedBox(height: 16),
                            _buildTextField(
                                _sectionController,
                                'Section/Chapter',
                                'Enter section number',
                                Icons.folder,
                                false),
                          ],
                          const SizedBox(height: 16),
                          _buildStatusDropdown(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel',
                              style: GoogleFonts.lato(
                                  color: AppTheme.subtitleGray)))),
                  const SizedBox(width: 12),
                  Expanded(
                      flex: 2,
                      child: ElevatedButton(
                          onPressed: _saveCode,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryDarkBlue),
                          child: Text(_isEditing ? 'Update' : 'Create',
                              style: GoogleFonts.lato(color: Colors.white)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard(String title, String subtitle, IconData icon,
      bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryDarkBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color:
                  isSelected ? AppTheme.primaryDarkBlue : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 28,
                color: isSelected ? Colors.white : AppTheme.subtitleGray),
            const SizedBox(height: 8),
            Text(title,
                style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87)),
            Text(subtitle,
                style: GoogleFonts.lato(
                    fontSize: 10,
                    color:
                        isSelected ? Colors.white70 : AppTheme.subtitleGray)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String hint, IconData icon, bool required,
      {TextInputType keyboardType = TextInputType.text,
      int maxLines = 1,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator ??
          (required ? (v) => v!.isEmpty ? 'Enter $label' : null : null),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppTheme.subtitleGray),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryDarkBlue)),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: InputDecoration(
        labelText: 'Status',
        prefixIcon: const Icon(Icons.toggle_on_outlined,
            size: 18, color: AppTheme.subtitleGray),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
      items: ['Active', 'Inactive']
          .map((s) => DropdownMenuItem(
              value: s,
              child: Row(children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: s == 'Active'
                            ? const Color(0xFF10B981)
                            : Colors.red)),
                const SizedBox(width: 8),
                Text(s)
              ])))
          .toList(),
      onChanged: (v) => setState(() => _selectedStatus = v!),
    );
  }
}
