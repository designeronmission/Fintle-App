import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import 'create_invoice_screen.dart';
import 'customer_screen.dart';
import 'bills.dart';
import 'invoice.dart';
import 'signin_screen.dart';
import 'item_screen.dart';
import 'hsn_sac_management_screen.dart';
import 'account_master_screen.dart';
import 'journal_screen.dart';
import 'voucher_screen.dart';
import 'bank-payment.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = "John";
  String userEmail = "john@business.com";
  String userBusiness = "Business";
  String selectedFinancialYear = "FY 2025-26";
  String? profileImagePath;
  final TextEditingController _searchController = TextEditingController();
  int _selectedBottomNavIndex = 0;
  String _selectedChartPeriod = 'Monthly'; // Monthly, Quarterly, Yearly

  // Dropdown states
  bool _isItemExpanded = false;
  bool _isPurchaseExpanded = false;
  bool _isSalesExpanded = false;
  bool _isAccountExpanded = false;

  // Sample financial data for charts
  final Map<String, List<double>> _salesData = {
    'Monthly': [
      12500,
      18900,
      15200,
      23400,
      18700,
      21500,
      25600,
      28900,
      31200,
      29800,
      34500,
      37800
    ],
    'Quarterly': [46600, 63600, 85700, 102100],
    'Yearly': [125000, 189000, 234000, 298000]
  };

  final Map<String, List<double>> _purchaseData = {
    'Monthly': [
      8500,
      9200,
      7800,
      14500,
      12300,
      15600,
      18900,
      19800,
      21200,
      18700,
      23400,
      25600
    ],
    'Quarterly': [25500, 42400, 56300, 67700],
    'Yearly': [85000, 120000, 185000, 225000]
  };

  final Map<String, List<double>> _expenseData = {
    'Monthly': [
      4200,
      3800,
      5100,
      6200,
      5800,
      7100,
      6800,
      7900,
      7200,
      6500,
      8400,
      9100
    ],
    'Quarterly': [13100, 19100, 20900, 24000],
    'Yearly': [45000, 68000, 89000, 112000]
  };

  final Map<String, List<String>> _periodLabels = {
    'Monthly': [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ],
    'Quarterly': ['Q1', 'Q2', 'Q3', 'Q4'],
    'Yearly': ['2022', '2023', '2024', '2025']
  };

  final List<Map<String, dynamic>> alerts = [
    {
      'title': 'Pay Bills',
      'amount': '₹2,000',
      'message': 'Due in 2 days',
      'icon': Icons.payment,
      'color': const Color(0xFFF59E0B)
    },
    {
      'title': 'Outstanding Dues',
      'amount': '₹12,000',
      'message': 'Due in 10 days',
      'icon': Icons.warning_amber,
      'color': const Color(0xFFEF4444)
    },
    {
      'title': 'Bill Generated',
      'amount': '₹4,000',
      'message': 'Pay by 30 June',
      'icon': Icons.receipt,
      'color': const Color(0xFF3B82F6)
    },
    {
      'title': 'Upcoming Due',
      'amount': '₹3,000',
      'message': 'Due in 5 days',
      'icon': Icons.event,
      'color': const Color(0xFF8B5CF6)
    },
    {
      'title': 'Tax Payment',
      'amount': '₹5,000',
      'message': 'Due in 15 days',
      'icon': Icons.request_quote,
      'color': const Color(0xFF14B8A6)
    },
    {
      'title': 'Invoice Pending',
      'amount': '₹8,000',
      'message': 'Overdue 3 days',
      'icon': Icons.receipt_long,
      'color': const Color(0xFFEC4899)
    },
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfileImage();
  }

  @override
  void dispose() {
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

  void _handleQuickAction(String action) {
    switch (action) {
      case 'New Invoice':
      case 'Invoice':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateInvoiceScreen()),
        ).then((_) {
          _loadUserData();
        });
        break;
      case 'New Bill':
      case 'Bill':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateBillScreen()),
        ).then((_) {
          _loadUserData();
        });
        break;
      case 'Add Customer':
      case 'Customer':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustomerScreen()),
        ).then((_) {
          _loadUserData();
        });
        break;
      case 'Record Payment':
      case 'Payment':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment recording coming soon'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$action coming soon'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  void _navigateToScreen(String screenName) {
    Navigator.pop(context); // Close drawer

    switch (screenName) {
      case 'Create Invoice':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateInvoiceScreen()),
        ).then((_) {
          _loadUserData();
        });
        break;
      case 'Invoices':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InvoiceListScreen()),
        );
        break;
      case 'Dashboard':
        setState(() {
          _selectedBottomNavIndex = 0;
        });
        break;
      case 'Customers':
      case 'Customer':
        setState(() {
          _selectedBottomNavIndex = 1;
        });
        break;
      case 'Items':
        setState(() {
          _selectedBottomNavIndex = 2;
        });
        break;
      case 'Bills':
      case 'Bill':
      case 'Purchase Bill':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BillListScreen()),
        );
        break;
      case 'HSN & SAC Code':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HsnSacManagementScreen(),
          ),
        );
        break;
      case 'Item':
        // Navigate to Item screen (already on Item screen via bottom nav)
        setState(() {
          _selectedBottomNavIndex = 2;
        });
        break;
      case 'Categories':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categories screen coming soon'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'Supplier':
      case 'Supplier Statement':
      case 'Purchase Order':
      case 'Purchase Bill':
      case 'Enquiry':
      case 'Estimate':
      case 'Account Master':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountMasterScreen(),
          ),
        );
        break;
      case 'Journals':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JournalListScreen()),
        );
        break;
      case 'Vouchers':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const VoucherListScreen()));
        break;
      case 'Bank Payments':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BankPaymentScreen()));
        break;
      case 'General Ledger':
      case 'Trial Balance':
      case 'Balance Sheets':
      case 'Settings':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$screenName screen coming soon'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$screenName screen coming soon'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  // Calculate totals for current period
  double getTotalSales() {
    List<double> data = _salesData[_selectedChartPeriod]!;
    return data.fold(0, (sum, val) => sum + val);
  }

  double getTotalPurchases() {
    List<double> data = _purchaseData[_selectedChartPeriod]!;
    return data.fold(0, (sum, val) => sum + val);
  }

  double getTotalExpenses() {
    List<double> data = _expenseData[_selectedChartPeriod]!;
    return data.fold(0, (sum, val) => sum + val);
  }

  double getProfit() {
    return getTotalSales() - getTotalPurchases() - getTotalExpenses();
  }

  double getProfitMargin() {
    double totalSales = getTotalSales();
    if (totalSales == 0) return 0;
    return (getProfit() / totalSales) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedBottomNavIndex != 0) {
          setState(() {
            _selectedBottomNavIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8F9FC),
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
        body: _buildCurrentScreen(),
        bottomNavigationBar: _buildModernBottomNavBar(),
        floatingActionButton: _selectedBottomNavIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  _showQuickActionSheet();
                },
                backgroundColor: AppTheme.primaryDarkBlue,
                elevation: 2,
                child: const Icon(Icons.add, color: Colors.white, size: 22),
              )
            : null,
      ),
    );
  }

  Widget _buildModernBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          onTap: (index) {
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InvoiceListScreen()),
              );
            } else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BillListScreen()),
              );
            } else {
              setState(() {
                _selectedBottomNavIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryDarkBlue,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: GoogleFonts.lato(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.lato(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined, size: 22),
              activeIcon: Icon(Icons.dashboard, size: 22),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline, size: 22),
              activeIcon: Icon(Icons.people, size: 22),
              label: 'Customers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined, size: 22),
              activeIcon: Icon(Icons.inventory_2, size: 22),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined, size: 22),
              activeIcon: Icon(Icons.receipt_long, size: 22),
              label: 'Invoices',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_outlined, size: 22),
              activeIcon: Icon(Icons.receipt, size: 22),
              label: 'Bills',
            ),
          ],
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedBottomNavIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return const CustomerScreen();
      case 2:
        return const ItemScreen();
      case 3:
        return const InvoiceListScreen();
      case 4:
        return const BillListScreen();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    List<double> currentSales = _salesData[_selectedChartPeriod]!;
    List<double> currentPurchases = _purchaseData[_selectedChartPeriod]!;
    List<String> currentLabels = _periodLabels[_selectedChartPeriod]!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search invoices, customers...',
                        hintStyle: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.grey, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => _buildFinancialYearSheet(),
                    );
                  },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: AppTheme.subtitleGray),
                        const SizedBox(width: 8),
                        Text(
                          selectedFinancialYear,
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Alerts Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Alerts',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${alerts.length}',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return GestureDetector(
                        onTap: () {
                          if (alert['title'] == 'Pay Bills' ||
                              alert['title'] == 'Bill Generated') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BillListScreen()),
                            );
                          } else if (alert['title'] == 'Invoice Pending') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const InvoiceListScreen()),
                            );
                          }
                        },
                        child: Container(
                          width: 180,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (alert['color'] as Color)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(alert['icon'],
                                    size: 18, color: alert['color']),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      alert['title'],
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      alert['amount'],
                                      style: GoogleFonts.lato(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: alert['color'],
                                      ),
                                    ),
                                    Text(
                                      alert['message'],
                                      style: GoogleFonts.lato(
                                        fontSize: 10,
                                        color: AppTheme.subtitleGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Action Cards
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        'New Invoice',
                        Icons.receipt_long,
                        const Color(0xFF4F46E5),
                        'Create invoice',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionCard(
                        'New Bill',
                        Icons.receipt,
                        const Color(0xFFEC4899),
                        'Record bill',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        'Add Customer',
                        Icons.person_add,
                        const Color(0xFF10B981),
                        'New customer',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionCard(
                        'Record Payment',
                        Icons.payment,
                        const Color(0xFFF59E0B),
                        'Receive payment',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Financial Summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Summary',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Bank Balance',
                        '₹20,000',
                        Icons.account_balance_wallet,
                        const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        'Cash Balance',
                        '₹10,000',
                        Icons.currency_rupee,
                        const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // KPI Cards
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                    'Total Sales',
                    '₹${getTotalSales().toStringAsFixed(0)}',
                    Icons.trending_up,
                    const Color(0xFF10B981),
                    '+12.5%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKPICard(
                    'Total Purchases',
                    '₹${getTotalPurchases().toStringAsFixed(0)}',
                    Icons.shopping_cart,
                    const Color(0xFFF59E0B),
                    '+8.3%',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                    'Net Profit',
                    '₹${getProfit().toStringAsFixed(0)}',
                    Icons.account_balance,
                    const Color(0xFF3B82F6),
                    '+${getProfitMargin().toStringAsFixed(1)}%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKPICard(
                    'Expenses',
                    '₹${getTotalExpenses().toStringAsFixed(0)}',
                    Icons.money_off,
                    const Color(0xFFEF4444),
                    '+5.2%',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Expense Chart
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expense Breakdown',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 35,
                          title: 'Rent\n35%',
                          color: const Color(0xFFEF4444),
                          radius: 60,
                          titleStyle: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 25,
                          title: 'Salary\n25%',
                          color: const Color(0xFF3B82F6),
                          radius: 60,
                          titleStyle: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 20,
                          title: 'Utilities\n20%',
                          color: const Color(0xFF10B981),
                          radius: 60,
                          titleStyle: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 20,
                          title: 'Others\n20%',
                          color: const Color(0xFFF59E0B),
                          radius: 60,
                          titleStyle: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Analysis Cards
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Insights',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInsightCard(
                  'Revenue Growth',
                  '+23.5% vs last period',
                  Icons.arrow_upward,
                  const Color(0xFF10B981),
                  'Your revenue has increased significantly compared to previous period.',
                ),
                const SizedBox(height: 8),
                _buildInsightCard(
                  'Profit Margin',
                  '${getProfitMargin().toStringAsFixed(1)}%',
                  Icons.trending_up,
                  const Color(0xFF3B82F6),
                  'Maintain healthy profit margins by optimizing costs.',
                ),
                const SizedBox(height: 8),
                _buildInsightCard(
                  'Top Performing Month',
                  'Decr (₹37,800)',
                  Icons.emoji_events,
                  const Color(0xFFF59E0B),
                  'Highest sales recorded in December. Plan promotions accordingly.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recent Activity
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activity',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View All',
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildActivityCard(
                  'Invoice #INV-001 created',
                  '2 hours ago',
                  Icons.receipt_long,
                  const Color(0xFF4F46E5),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InvoiceListScreen()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildActivityCard(
                  'Bill #BILL-001 created',
                  '5 hours ago',
                  Icons.receipt,
                  const Color(0xFFEC4899),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BillListScreen()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildActivityCard(
                  'New customer added',
                  'Yesterday',
                  Icons.person_add,
                  const Color(0xFF8B5CF6),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomerScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    bool isSelected = _selectedChartPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChartPeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryDarkBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          period,
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.subtitleGray,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(
      String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up,
                        size: 10, color: const Color(0xFF10B981)),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: GoogleFonts.lato(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 11,
              color: AppTheme.subtitleGray,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon,
      Color color, String description) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        value,
                        style: GoogleFonts.lato(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: AppTheme.subtitleGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, String subtitle) {
    return GestureDetector(
      onTap: () {
        _handleQuickAction(title);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 10,
                color: AppTheme.subtitleGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.subtitleGray,
                ),
              ),
              Icon(icon, size: 18, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      String title, String time, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: GoogleFonts.lato(
                      fontSize: 11,
                      color: AppTheme.subtitleGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showQuickActionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Actions',
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
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final List<Map<String, dynamic>> actions = [
                    {
                      'icon': Icons.receipt_long,
                      'label': 'Invoice',
                      'color': const Color(0xFF4F46E5)
                    },
                    {
                      'icon': Icons.receipt,
                      'label': 'Bill',
                      'color': const Color(0xFFEC4899)
                    },
                    {
                      'icon': Icons.person_add,
                      'label': 'Customer',
                      'color': const Color(0xFF10B981)
                    },
                    {
                      'icon': Icons.payment,
                      'label': 'Payment',
                      'color': const Color(0xFFF59E0B)
                    },
                  ];
                  final action = actions[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _handleQuickAction(action['label'] as String);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (action['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            color: action['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          action['label'] as String,
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialYearSheet() {
    List<String> financialYears = [
      'FY 2025-26',
      'FY 2024-25',
      'FY 2023-24',
      'FY 2022-23',
      'FY 2021-22',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
          Text(
            'Select Financial Year',
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDarkBlue,
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: financialYears
                  .map((year) => ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: selectedFinancialYear == year
                              ? AppTheme.primaryDarkBlue
                              : AppTheme.subtitleGray,
                        ),
                        title: Text(
                          year,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: selectedFinancialYear == year
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: selectedFinancialYear == year
                                ? AppTheme.primaryDarkBlue
                                : AppTheme.subtitleGray,
                          ),
                        ),
                        trailing: selectedFinancialYear == year
                            ? const Icon(Icons.check_circle,
                                color: AppTheme.primaryDarkBlue, size: 20)
                            : null,
                        onTap: () {
                          setState(() {
                            selectedFinancialYear = year;
                          });
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==================== DRAWER METHODS ====================

  Widget _buildStyledDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      width: 280,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header with Profile
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryDarkBlue,
                  AppTheme.primaryDarkBlue.withOpacity(0.7),
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
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: profileImagePath != null
                              ? Image.file(
                                  File(profileImagePath!),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 28,
                                  color: AppTheme.primaryDarkBlue,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userEmail,
                            style: GoogleFonts.lato(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
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
                              fontWeight: FontWeight.w500,
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
                    setState(() {
                      _selectedBottomNavIndex = 0;
                    });
                  },
                ),
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
                    _buildSubMenuItem('Item', () => _navigateToScreen('Item')),
                    _buildSubMenuItem('HSN & SAC Code',
                        () => _navigateToScreen('HSN & SAC Code')),
                    _buildSubMenuItem(
                        'Categories', () => _navigateToScreen('Categories')),
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
                    _buildSubMenuItem(
                        'Supplier', () => _navigateToScreen('Supplier')),
                    _buildSubMenuItem('Supplier Statement',
                        () => _navigateToScreen('Supplier Statement')),
                    _buildSubMenuItem('Purchase Order',
                        () => _navigateToScreen('Purchase Order')),
                    _buildSubMenuItem('Purchase Bill',
                        () => _navigateToScreen('Purchase Bill')),
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
                    _buildSubMenuItem(
                        'Customer', () => _navigateToScreen('Customer')),
                    _buildSubMenuItem(
                        'Enquiry', () => _navigateToScreen('Enquiry')),
                    _buildSubMenuItem(
                        'Estimate', () => _navigateToScreen('Estimate')),
                    _buildSubMenuItem('Create Invoice',
                        () => _navigateToScreen('Create Invoice')),
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
                    _buildSubMenuItem('Account Master',
                        () => _navigateToScreen('Account Master')),
                    _buildSubMenuItem(
                        'Journals', () => _navigateToScreen('Journals')),
                    _buildSubMenuItem(
                        'Vouchers', () => _navigateToScreen('Vouchers')),
                    _buildSubMenuItem('Bank Payments',
                        () => _navigateToScreen('Bank Payments')),
                    _buildSubMenuItem('General Ledger',
                        () => _navigateToScreen('General Ledger')),
                    _buildSubMenuItem('Trial Balance',
                        () => _navigateToScreen('Trial Balance')),
                    _buildSubMenuItem('Balance Sheets',
                        () => _navigateToScreen('Balance Sheets')),
                  ],
                ),
                _buildMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Invoices',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InvoiceListScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.receipt_outlined,
                  title: 'Bills',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BillListScreen()),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => _navigateToScreen('Settings'),
                ),
                _buildMenuItem(
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  iconColor: const Color(0xFFD93025),
                  titleColor: const Color(0xFFD93025),
                  onTap: _logout,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isActive = false,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.lightBlueBg : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ??
              (isActive ? AppTheme.primaryDarkBlue : AppTheme.subtitleGray),
          size: 20,
        ),
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: titleColor ??
                (isActive ? AppTheme.primaryDarkBlue : Colors.black87),
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        dense: true,
      ),
    );
  }

  Widget _buildDropdownMenuItem({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: Icon(
              icon,
              color: AppTheme.subtitleGray,
              size: 20,
            ),
            title: Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 18,
              color: AppTheme.subtitleGray,
            ),
            onTap: onTap,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            dense: true,
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Column(
              children: children,
            ),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppTheme.subtitleGray,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        dense: true,
      ),
    );
  }
}
