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

// ==================== HSN/SAC CODE MODEL ====================
class HsnSacCode {
  final String id;
  final String code;
  final String description;
  final String type; // 'HSN' or 'SAC'
  final String status; // 'Active' or 'Inactive'
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? gstRate; // GST rate percentage
  final String? section; // Section/chapter number

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
  String _selectedType = 'All'; // 'All', 'HSN', 'SAC'
  String _selectedStatus = 'All'; // 'All', 'Active', 'Inactive'

  List<HsnSacCode> _allCodes = [];
  List<HsnSacCode> _filteredCodes = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _searchController.addListener(_filterCodes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCodes);
    _searchController.dispose();
    super.dispose();
  }

  void _loadSampleData() {
    // Sample HSN Codes
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
        code: '94036000',
        description: 'Wooden furniture of a kind used in dining room',
        type: 'HSN',
        status: 'Active',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
        gstRate: 18.0,
        section: '94',
      ),
      HsnSacCode(
        id: '4',
        code: '998311',
        description: 'Software development services',
        type: 'SAC',
        status: 'Active',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
        gstRate: 18.0,
      ),
      HsnSacCode(
        id: '5',
        code: '998312',
        description: 'Software consulting services',
        type: 'SAC',
        status: 'Active',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        gstRate: 18.0,
      ),
      HsnSacCode(
        id: '6',
        code: '997211',
        description: 'Accounting and auditing services',
        type: 'SAC',
        status: 'Active',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        gstRate: 18.0,
      ),
      HsnSacCode(
        id: '7',
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
                        'Filter Codes',
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
                    'Code Type',
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
                    children: ['All', 'HSN', 'SAC'].map((type) {
                      bool isSelected = _selectedType == type;
                      return FilterChip(
                        selected: isSelected,
                        label: Text(
                          type,
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedType = type;
                          });
                          _filterCodes();
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: AppTheme.primaryDarkBlue,
                      );
                    }).toList(),
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
                    children: ['All', 'Active', 'Inactive'].map((status) {
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
                          _filterCodes();
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: AppTheme.primaryDarkBlue,
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
                              _selectedStatus = 'All';
                              _searchController.clear();
                            });
                            _filterCodes();
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

  void _createNewCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateHsnSacCodeScreen(),
      ),
    ).then((result) {
      if (result != null && result is HsnSacCode) {
        setState(() {
          _allCodes.add(result);
          _filterCodes();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${result.type} Code ${result.code} created successfully'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    });
  }

  void _editCode(HsnSacCode code) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateHsnSacCodeScreen(editCode: code),
      ),
    ).then((result) {
      if (result != null && result is HsnSacCode) {
        setState(() {
          final index = _allCodes.indexWhere((c) => c.id == result.id);
          if (index != -1) {
            _allCodes[index] = result;
            _filterCodes();
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${result.type} Code ${result.code} updated successfully'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    });
  }

  void _toggleCodeStatus(HsnSacCode code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(code.status == 'Active' ? 'Deactivate Code' : 'Activate Code'),
        content: Text(
          'Are you sure you want to ${code.status == 'Active' ? 'deactivate' : 'activate'} this code?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final index = _allCodes.indexWhere((c) => c.id == code.id);
                if (index != -1) {
                  _allCodes[index] = HsnSacCode(
                    id: code.id,
                    code: code.code,
                    description: code.description,
                    type: code.type,
                    status: code.status == 'Active' ? 'Inactive' : 'Active',
                    createdAt: code.createdAt,
                    updatedAt: DateTime.now(),
                    gstRate: code.gstRate,
                    section: code.section,
                  );
                  _filterCodes();
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Code ${code.status == 'Active' ? 'deactivated' : 'activated'} successfully'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
            child: Text(
              code.status == 'Active' ? 'Deactivate' : 'Activate',
              style: TextStyle(
                color: code.status == 'Active'
                    ? Colors.red
                    : const Color(0xFF10B981),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCode(HsnSacCode code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Code'),
        content: const Text(
          'Are you sure you want to delete this code? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allCodes.removeWhere((c) => c.id == code.id);
                _filterCodes();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Code deleted successfully'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCodeDetails(HsnSacCode code) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            code.type == 'HSN'
                                ? 'HSN Code Details'
                                : 'SAC Code Details',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: code.status == 'Active'
                                ? const Color(0xFF10B981).withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            code.status,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: code.status == 'Active'
                                  ? const Color(0xFF10B981)
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailCard(
                      icon: Icons.code,
                      label: '${code.type} Code',
                      value: code.code,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      icon: Icons.description,
                      label: 'Description',
                      value: code.description,
                    ),
                    if (code.gstRate != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailCard(
                        icon: Icons.percent,
                        label: 'GST Rate',
                        value: '${code.gstRate}%',
                      ),
                    ],
                    if (code.section != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailCard(
                        icon: Icons.folder,
                        label: 'Section/Chapter',
                        value: code.section!,
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      icon: Icons.calendar_today,
                      label: 'Created At',
                      value: DateFormat('dd MMM yyyy, hh:mm a')
                          .format(code.createdAt),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailCard(
                      icon: Icons.update,
                      label: 'Last Updated',
                      value: DateFormat('dd MMM yyyy, hh:mm a')
                          .format(code.updatedAt),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _editCode(code);
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(
                                  color: AppTheme.primaryDarkBlue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _toggleCodeStatus(code);
                            },
                            icon: Icon(
                              code.status == 'Active'
                                  ? Icons.block
                                  : Icons.check_circle,
                              size: 18,
                            ),
                            label: Text(code.status == 'Active'
                                ? 'Deactivate'
                                : 'Activate'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: code.status == 'Active'
                                  ? Colors.red
                                  : const Color(0xFF10B981),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteCode(code);
                      },
                      icon:
                          const Icon(Icons.delete, size: 18, color: Colors.red),
                      label: const Text('Delete',
                          style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  Widget _buildDetailCard(
      {required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightBlueBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppTheme.primaryDarkBlue),
          ),
          const SizedBox(width: 12),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    final activeCount =
        _filteredCodes.where((c) => c.status == 'Active').length;
    final hsnCount = _filteredCodes.where((c) => c.type == 'HSN').length;
    final sacCount = _filteredCodes.where((c) => c.type == 'SAC').length;

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
          'HSN / SAC Management',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
      ),
      body: Column(
        children: [
          // Stats Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatCard('Total Codes', _filteredCodes.length, Icons.code,
                    AppTheme.primaryDarkBlue),
                const SizedBox(width: 10),
                _buildStatCard('Active', activeCount, Icons.check_circle,
                    const Color(0xFF10B981)),
                const SizedBox(width: 10),
                _buildStatCard('HSN', hsnCount, Icons.inventory_2,
                    const Color(0xFF3B82F6)),
                const SizedBox(width: 10),
                _buildStatCard('SAC', sacCount, Icons.room_service,
                    const Color(0xFF8B5CF6)),
              ],
            ),
          ),

          // Search and Filter
          Container(
            color: const Color(0xFFF5F7FA),
            child: Column(
              children: [
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
                              hintText: 'Search by code or description',
                              hintStyle: GoogleFonts.lato(
                                fontSize: 12,
                                color: Colors.grey.shade400,
                              ),
                              prefixIcon: const Icon(Icons.search,
                                  size: 16, color: AppTheme.subtitleGray),
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
                            color: (_selectedType != 'All' ||
                                    _selectedStatus != 'All')
                                ? AppTheme.primaryDarkBlue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (_selectedType != 'All' ||
                                      _selectedStatus != 'All')
                                  ? AppTheme.primaryDarkBlue
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_list,
                                size: 16,
                                color: (_selectedType != 'All' ||
                                        _selectedStatus != 'All')
                                    ? Colors.white
                                    : AppTheme.subtitleGray,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Filter',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: (_selectedType != 'All' ||
                                          _selectedStatus != 'All')
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
              ],
            ),
          ),

          // Codes List
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
                            Text(
                              'No codes found',
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
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredCodes.length,
                        itemBuilder: (context, index) {
                          final code = _filteredCodes[index];
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
                                onTap: () => _showCodeDetails(code),
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
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: code.type ==
                                                                'HSN'
                                                            ? const Color(
                                                                    0xFF3B82F6)
                                                                .withOpacity(
                                                                    0.1)
                                                            : const Color(
                                                                    0xFF8B5CF6)
                                                                .withOpacity(
                                                                    0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Text(
                                                        code.type,
                                                        style: GoogleFonts.lato(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: code.type ==
                                                                  'HSN'
                                                              ? const Color(
                                                                  0xFF3B82F6)
                                                              : const Color(
                                                                  0xFF8B5CF6),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      code.code,
                                                      style: GoogleFonts.lato(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppTheme
                                                            .primaryDarkBlue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  code.description,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    color:
                                                        AppTheme.subtitleGray,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: code.status == 'Active'
                                                  ? const Color(0xFF10B981)
                                                      .withOpacity(0.1)
                                                  : Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              code.status,
                                              style: GoogleFonts.lato(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: code.status == 'Active'
                                                    ? const Color(0xFF10B981)
                                                    : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      if (code.gstRate != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.percent,
                                                size: 12,
                                                color: AppTheme.subtitleGray),
                                            const SizedBox(width: 4),
                                            Text(
                                              'GST Rate: ${code.gstRate}%',
                                              style: GoogleFonts.lato(
                                                fontSize: 11,
                                                color: AppTheme.subtitleGray,
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
          ),

          // Create Button
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
                  label: Text(
                    'Create HSN / SAC Code',
                    style: GoogleFonts.lato(
                        fontSize: 15, fontWeight: FontWeight.w600),
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
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Expanded(
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
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.subtitleGray,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 14, color: color),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              count.toString(),
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
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

  String _selectedType = 'HSN'; // 'HSN' or 'SAC'
  String _selectedStatus = 'Active'; // 'Active' or 'Inactive'

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
      if (widget.editCode!.gstRate != null) {
        _gstRateController.text = widget.editCode!.gstRate!.toString();
      }
      if (widget.editCode!.section != null) {
        _sectionController.text = widget.editCode!.section!;
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _gstRateController.dispose();
    _sectionController.dispose();
    super.dispose();
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
              color: AppTheme.primaryDarkBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing
              ? 'Edit ${_selectedType} Code'
              : 'Create ${_selectedType} Code',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveCode,
            child: Text(
              _isEditing ? 'Update' : 'Save',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDarkBlue,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Code Type Selection
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Code Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTypeCard(
                              title: 'HSN Code',
                              subtitle: 'Goods / Products',
                              icon: Icons.inventory_2,
                              isSelected: _selectedType == 'HSN',
                              onTap: () {
                                setState(() {
                                  _selectedType = 'HSN';
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTypeCard(
                              title: 'SAC Code',
                              subtitle: 'Services',
                              icon: Icons.room_service,
                              isSelected: _selectedType == 'SAC',
                              onTap: () {
                                setState(() {
                                  _selectedType = 'SAC';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Code Details
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Code Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _codeController,
                            label: '${_selectedType} Code',
                            hint:
                                'Enter ${_selectedType} code (e.g., 84713010)',
                            icon: Icons.code,
                            required: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ${_selectedType} code';
                              }
                              if (_selectedType == 'HSN' &&
                                  !RegExp(r'^\d{6,8}$').hasMatch(value)) {
                                return 'HSN code should be 6-8 digits';
                              }
                              if (_selectedType == 'SAC' &&
                                  !RegExp(r'^\d{4,6}$').hasMatch(value)) {
                                return 'SAC code should be 4-6 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            hint: 'Enter description of the product/service',
                            icon: Icons.description,
                            required: true,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _gstRateController,
                            label: 'GST Rate (%)',
                            hint: 'Enter GST rate (e.g., 5, 12, 18, 28)',
                            icon: Icons.percent,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final rate = double.tryParse(value);
                                if (rate == null || rate < 0 || rate > 100) {
                                  return 'Please enter valid GST rate (0-100)';
                                }
                              }
                              return null;
                            },
                          ),
                          if (_selectedType == 'HSN') ...[
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _sectionController,
                              label: 'Section/Chapter',
                              hint: 'Enter section or chapter number',
                              icon: Icons.folder,
                            ),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
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
                      onPressed: _saveCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDarkBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isEditing ? 'Update Code' : 'Create Code',
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryDarkBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryDarkBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : AppTheme.subtitleGray,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 10,
                color: isSelected ? Colors.white70 : AppTheme.subtitleGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.lato(fontSize: 14, color: Colors.black87),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppTheme.subtitleGray),
        fillColor: Colors.white,
        filled: true,
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
              const BorderSide(color: AppTheme.primaryDarkBlue, width: 1.5),
        ),
        labelStyle:
            GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
        hintStyle: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        isDense: true,
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        decoration: InputDecoration(
          labelText: 'Status',
          prefixIcon: const Icon(Icons.toggle_on_outlined,
              size: 18, color: AppTheme.subtitleGray),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle:
              GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
        ),
        items: ['Active', 'Inactive']
            .map((status) => DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: status == 'Active'
                              ? const Color(0xFF10B981)
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: GoogleFonts.lato(
                            fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedStatus = value!;
          });
        },
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
