import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

// ==================== MAIN JOURNAL LIST SCREEN ====================
class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isSearchSticky = false;

  final List<String> _filterOptions = ['All', 'Draft', 'Posted', 'Cancelled'];

  final List<Map<String, dynamic>> _allJournals = [
    {
      'id': 'JV-001',
      'voucherNo': 'VCH-2025-001',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'description': 'Monthly rent payment for office premises',
      'status': 'Posted',
      'totalDebit': 25000.00,
      'totalCredit': 25000.00,
      'entries': 2,
      'invoiceNo': 'INV-001',
      'createdBy': 'John Doe',
    },
    {
      'id': 'JV-002',
      'voucherNo': 'VCH-2025-002',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'description': 'Salary payment for March 2025',
      'status': 'Posted',
      'totalDebit': 150000.00,
      'totalCredit': 150000.00,
      'entries': 5,
      'invoiceNo': '',
      'createdBy': 'John Doe',
    },
    {
      'id': 'JV-003',
      'voucherNo': 'VCH-2025-003',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'description': 'Purchase of office supplies',
      'status': 'Draft',
      'totalDebit': 8500.00,
      'totalCredit': 8500.00,
      'entries': 2,
      'invoiceNo': 'INV-003',
      'createdBy': 'Jane Smith',
    },
    {
      'id': 'JV-004',
      'voucherNo': 'VCH-2025-004',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'description': 'Depreciation entry for fixed assets',
      'status': 'Posted',
      'totalDebit': 12000.00,
      'totalCredit': 12000.00,
      'entries': 3,
      'invoiceNo': '',
      'createdBy': 'John Doe',
    },
    {
      'id': 'JV-005',
      'voucherNo': 'VCH-2025-005',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'description': 'Bank charges for March',
      'status': 'Cancelled',
      'totalDebit': 1200.00,
      'totalCredit': 1200.00,
      'entries': 2,
      'invoiceNo': '',
      'createdBy': 'Admin',
    },
    {
      'id': 'JV-006',
      'voucherNo': 'VCH-2025-006',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'description': 'Sales revenue recognition',
      'status': 'Posted',
      'totalDebit': 45000.00,
      'totalCredit': 45000.00,
      'entries': 2,
      'invoiceNo': 'INV-006',
      'createdBy': 'Jane Smith',
    },
  ];

  List<Map<String, dynamic>> _filteredJournals = [];

  @override
  void initState() {
    super.initState();
    _filteredJournals = List.from(_allJournals);
    _searchController.addListener(_filterJournals);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterJournals);
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

  void _filterJournals() {
    setState(() {
      _filteredJournals = _allJournals.where((journal) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            journal['id'].toLowerCase().contains(searchQuery) ||
            journal['voucherNo'].toLowerCase().contains(searchQuery) ||
            journal['description'].toLowerCase().contains(searchQuery) ||
            journal['invoiceNo'].toLowerCase().contains(searchQuery);
        final matchesStatus =
            _selectedStatus == 'All' || journal['status'] == _selectedStatus;
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
                      Text('Filter Journals',
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
                  Text('Status',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _filterOptions.map((status) {
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
                          _filterJournals();
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
                            _filterJournals();
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

  void _showJournalDetail(Map<String, dynamic> journal) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JournalDetailScreen(journal: journal)));
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Posted':
        return const Color(0xFF10B981);
      case 'Draft':
        return const Color(0xFFF59E0B);
      case 'Cancelled':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.subtitleGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalJournals = _filteredJournals.length;
    final totalDebit = _filteredJournals.fold(
        0.0, (sum, j) => sum + (j['totalDebit'] as double));
    final postedCount =
        _filteredJournals.where((j) => j['status'] == 'Posted').length;
    final postedAmount = _filteredJournals
        .where((j) => j['status'] == 'Posted')
        .fold(0.0, (sum, j) => sum + (j['totalDebit'] as double));
    final draftCount =
        _filteredJournals.where((j) => j['status'] == 'Draft').length;
    final draftAmount = _filteredJournals
        .where((j) => j['status'] == 'Draft')
        .fold(0.0, (sum, j) => sum + (j['totalDebit'] as double));
    final cancelledCount =
        _filteredJournals.where((j) => j['status'] == 'Cancelled').length;
    final cancelledAmount = _filteredJournals
        .where((j) => j['status'] == 'Cancelled')
        .fold(0.0, (sum, j) => sum + (j['totalDebit'] as double));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppTheme.primaryDarkBlue, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Text('Journals',
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
                                          Text('Total Journals',
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white70)),
                                          const SizedBox(height: 4),
                                          Text(totalJournals.toString(),
                                              style: GoogleFonts.lato(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          Text(
                                              'Total: ₹${NumberFormat('#,##0').format(totalDebit)}',
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
                                        child: const Icon(Icons.book,
                                            size: 24, color: Colors.white)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(children: [
                                Expanded(
                                    child: _buildKPICard(
                                        'Posted',
                                        postedCount.toString(),
                                        '₹${NumberFormat('#,##0').format(postedAmount)}',
                                        Icons.check_circle,
                                        const Color(0xFF10B981))),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: _buildKPICard(
                                        'Draft',
                                        draftCount.toString(),
                                        '₹${NumberFormat('#,##0').format(draftAmount)}',
                                        Icons.edit_note,
                                        const Color(0xFFF59E0B))),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: _buildKPICard(
                                        'Cancelled',
                                        cancelledCount.toString(),
                                        '₹${NumberFormat('#,##0').format(cancelledAmount)}',
                                        Icons.cancel,
                                        const Color(0xFFEF4444))),
                              ]),
                            ],
                          ),
                        ),
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
                                                'Search by JV#, Voucher or Description',
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
                                        label: Text('Status: $_selectedStatus',
                                            style:
                                                GoogleFonts.lato(fontSize: 11)),
                                        onDeleted: () {
                                          setState(
                                              () => _selectedStatus = 'All');
                                          _filterJournals();
                                        },
                                        backgroundColor: AppTheme.lightBlueBg,
                                        deleteIcon:
                                            const Icon(Icons.close, size: 12),
                                      ),
                                    ]),
                                  ),
                                ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        if (_filteredJournals.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(children: [
                                Icon(Icons.book_outlined,
                                    size: 60, color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                Text('No journals found',
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
                            itemCount: _filteredJournals.length,
                            itemBuilder: (context, index) {
                              final journal = _filteredJournals[index];
                              final statusColor =
                                  _getStatusColor(journal['status']);
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
                                    onTap: () => _showJournalDetail(journal),
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
                                                      Text(
                                                          journal[
                                                              'description'],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppTheme
                                                                  .primaryDarkBlue),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      const SizedBox(height: 4),
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
                                                                journal['id'],
                                                                style: GoogleFonts.lato(
                                                                    fontSize:
                                                                        10,
                                                                    color: AppTheme
                                                                        .subtitleGray))),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                            journal[
                                                                'voucherNo'],
                                                            style: GoogleFonts.lato(
                                                                fontSize: 10,
                                                                color: AppTheme
                                                                    .subtitleGray)),
                                                      ]),
                                                    ]),
                                              ),
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                      color: statusColor
                                                          .withOpacity(0.1),
                                                      borderRadius: BorderRadius
                                                          .circular(12)),
                                                  child: Text(
                                                      journal['status'],
                                                      style: GoogleFonts.lato(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: statusColor))),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(children: [
                                            Expanded(
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                                0xFFFEE2E2)
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Debit',
                                                              style: GoogleFonts.lato(
                                                                  fontSize: 10,
                                                                  color: const Color(
                                                                      0xFFEF4444))),
                                                          const SizedBox(
                                                              height: 2),
                                                          Text(
                                                              '₹${NumberFormat('#,##0').format(journal['totalDebit'])}',
                                                              style: GoogleFonts.lato(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color(
                                                                      0xFFEF4444)))
                                                        ]))),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                                0xFFD1FAE5)
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Credit',
                                                              style: GoogleFonts.lato(
                                                                  fontSize: 10,
                                                                  color: const Color(
                                                                      0xFF10B981))),
                                                          const SizedBox(
                                                              height: 2),
                                                          Text(
                                                              '₹${NumberFormat('#,##0').format(journal['totalCredit'])}',
                                                              style: GoogleFonts.lato(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color(
                                                                      0xFF10B981)))
                                                        ]))),
                                          ]),
                                          const SizedBox(height: 8),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(children: [
                                                  const Icon(Icons.receipt_long,
                                                      size: 12,
                                                      color: AppTheme
                                                          .subtitleGray),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                      '${journal['entries']} entries',
                                                      style: GoogleFonts.lato(
                                                          fontSize: 10,
                                                          color: AppTheme
                                                              .subtitleGray))
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
                                                          .format(
                                                              journal['date']),
                                                      style: GoogleFonts.lato(
                                                          fontSize: 10,
                                                          color: AppTheme
                                                              .subtitleGray))
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
                                    const CreateJournalScreen()));
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text('Create Journal',
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
                            hintText: 'Search by JV#, Voucher or Description',
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

  Widget _buildKPICard(
      String title, String count, String amount, IconData icon, Color color) {
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
                fontSize: 10, color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ==================== JOURNAL DETAIL SCREEN ====================
class JournalDetailScreen extends StatelessWidget {
  final Map<String, dynamic> journal;
  const JournalDetailScreen({super.key, required this.journal});

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
        title: Text('Journal Details',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      Text(journal['description'],
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('${journal['id']} | ${journal['voucherNo']}',
                          style: GoogleFonts.lato(
                              fontSize: 11, color: Colors.white70)),
                    ])),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(journal['status'],
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
                      Text('Total Debit',
                          style: GoogleFonts.lato(
                              fontSize: 10, color: Colors.white70)),
                      Text(
                          '₹${NumberFormat('#,##0').format(journal['totalDebit'])}',
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFCA5A5)))
                    ])),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      Text('Total Credit',
                          style: GoogleFonts.lato(
                              fontSize: 10, color: Colors.white70)),
                      Text(
                          '₹${NumberFormat('#,##0').format(journal['totalCredit'])}',
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF86EFAC)))
                    ])),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Journal Information',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue))),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  _buildInfoRow(Icons.book, 'Journal ID', journal['id']),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      Icons.receipt, 'Voucher No', journal['voucherNo']),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.calendar_today, 'Date',
                      DateFormat('dd MMM yyyy').format(journal['date'])),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      Icons.description, 'Description', journal['description']),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      Icons.receipt_long,
                      'Invoice No',
                      journal['invoiceNo'].toString().isEmpty
                          ? 'N/A'
                          : journal['invoiceNo']),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      Icons.person, 'Created By', journal['createdBy']),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.list_alt, 'Entries',
                      '${journal['entries']} entries'),
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
}

// ==================== CREATE JOURNAL SCREEN (TWO-STEP FLOW) ====================
class CreateJournalScreen extends StatefulWidget {
  const CreateJournalScreen({super.key});

  @override
  State<CreateJournalScreen> createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends State<CreateJournalScreen> {
  final _formKey = GlobalKey<FormState>();

  // Step tracking
  int _currentStep = 0;

  // Journal Details Controllers
  final TextEditingController _invoiceNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _voucherNoController = TextEditingController();
  DateTime _journalDate = DateTime.now();

  // Journal Entries
  final List<JournalEntry> _entries = [];
  final ScrollController _entriesScrollController = ScrollController();

  final List<String> _accountGroups = [
    'Assets',
    'Liabilities',
    'Equity',
    'Income',
    'Expenses'
  ];
  final List<String> _entryTypes = ['Debit', 'Credit'];

  final Map<String, List<String>> _accountsByGroup = {
    'Assets': [
      'Cash in Hand',
      'Bank Account - HDFC',
      'Accounts Receivable',
      'Inventory',
      'Office Equipment'
    ],
    'Liabilities': [
      'Accounts Payable',
      'Short-term Loans',
      'Tax Payable',
      'Bank Loan'
    ],
    'Equity': ['Share Capital', 'Retained Earnings'],
    'Income': ['Sales Revenue', 'Service Income', 'Interest Income'],
    'Expenses': [
      'Rent Expense',
      'Salary Expense',
      'Utility Expense',
      'Office Supplies',
      'Legal Fees'
    ],
  };

  @override
  void initState() {
    super.initState();
    _voucherNoController.text =
        'VCH-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    _entries.add(JournalEntry());
    _entries.add(JournalEntry());
  }

  @override
  void dispose() {
    _invoiceNoController.dispose();
    _descriptionController.dispose();
    _voucherNoController.dispose();
    _entriesScrollController.dispose();
    for (var entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _goToEntriesStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep = 1;
      });
    }
  }

  void _goBackToDetails() {
    setState(() {
      _currentStep = 0;
    });
  }

  void _addEntry() {
    setState(() {
      _entries.add(JournalEntry());
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_entriesScrollController.hasClients) {
        _entriesScrollController.animateTo(
          _entriesScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _removeEntry(int index) {
    if (_entries.length > 2) {
      setState(() {
        _entries[index].dispose();
        _entries.removeAt(index);
      });
    }
  }

  double get _totalDebit {
    return _entries.where((e) => e.type == 'Debit').fold(
        0.0, (sum, e) => sum + (double.tryParse(e.amountController.text) ?? 0));
  }

  double get _totalCredit {
    return _entries.where((e) => e.type == 'Credit').fold(
        0.0, (sum, e) => sum + (double.tryParse(e.amountController.text) ?? 0));
  }

  void _saveJournal() {
    bool hasEmptyEntries = _entries.any((e) =>
        e.group == null ||
        e.account == null ||
        e.amountController.text.isEmpty);
    if (hasEmptyEntries) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all journal entries'),
            backgroundColor: Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating),
      );
      return;
    }

    if (_totalDebit != _totalCredit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Total Debit (₹${NumberFormat('#,##0').format(_totalDebit)}) must equal Total Credit (₹${NumberFormat('#,##0').format(_totalCredit)})'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Journal created successfully!'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating),
    );
    Navigator.pop(context);
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
          onPressed: () {
            if (_currentStep == 1) {
              _goBackToDetails();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _currentStep == 0 ? 'Journal Details' : 'Journal Entries',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue),
        ),
        actions: [
          if (_currentStep == 1)
            IconButton(
              onPressed: _addEntry,
              icon: const Icon(Icons.add_circle_outline,
                  color: AppTheme.primaryDarkBlue, size: 24),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _currentStep == 0 ? _buildDetailsStep() : _buildEntriesStep(),
      ),
    );
  }

  // ==================== STEP 1: JOURNAL DETAILS ====================
  Widget _buildDetailsStep() {
    return Column(
      key: const ValueKey('details'),
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
                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDarkBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.primaryDarkBlue.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.info_outline,
                              size: 18, color: AppTheme.primaryDarkBlue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Fill in the journal details below. You will add journal entries in the next step.',
                            style: GoogleFonts.lato(
                                fontSize: 12, color: AppTheme.subtitleGray),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Journal Details Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryDarkBlue.withOpacity(0.03),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.primaryDarkBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.book,
                                    size: 20, color: AppTheme.primaryDarkBlue),
                              ),
                              const SizedBox(width: 12),
                              Text('JOURNAL DETAILS',
                                  style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.subtitleGray,
                                      letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Journal Date & Voucher No
                              Row(
                                children: [
                                  Expanded(child: _buildDateField()),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _voucherNoController,
                                      label: 'Voucher No',
                                      hint: 'Auto-generated',
                                      icon: Icons.receipt,
                                      readOnly: true,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Invoice Number
                              _buildTextField(
                                controller: _invoiceNoController,
                                label: 'Invoice Number (Optional)',
                                hint: 'Enter invoice number',
                                icon: Icons.receipt_long,
                              ),
                              const SizedBox(height: 16),

                              // Description
                              _buildTextField(
                                controller: _descriptionController,
                                label: 'JV Description',
                                hint: 'Enter journal description',
                                icon: Icons.description_outlined,
                                maxLines: 3,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Please enter journal description'
                                    : null,
                              ),
                            ],
                          ),
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

        // Next Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2))
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToEntriesStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryDarkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next: Add Entries',
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward,
                        size: 20, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== STEP 2: JOURNAL ENTRIES ====================
  Widget _buildEntriesStep() {
    return Column(
      key: const ValueKey('entries'),
      children: [
        // Summary Banner
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.book,
                    size: 16, color: AppTheme.primaryDarkBlue),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _descriptionController.text.isNotEmpty
                          ? _descriptionController.text
                          : 'Journal Entry',
                      style: GoogleFonts.lato(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDarkBlue),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${DateFormat('dd MMM yyyy').format(_journalDate)} | ${_voucherNoController.text}',
                      style: GoogleFonts.lato(
                          fontSize: 10, color: AppTheme.subtitleGray),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _goBackToDetails,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlueBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Edit',
                      style: GoogleFonts.lato(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDarkBlue)),
                ),
              ),
            ],
          ),
        ),

        // Entries List
        Expanded(
          child: ListView.builder(
            controller: _entriesScrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _entries.length + 1, // +1 for totals card
            itemBuilder: (context, index) {
              if (index < _entries.length) {
                return _buildEntryCard(index, _entries[index]);
              } else {
                // Totals Card at the end
                return _buildTotalsCard();
              }
            },
          ),
        ),

        // Save Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2))
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveJournal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryDarkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Save Journal',
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== ENTRY CARD ====================
  Widget _buildEntryCard(int index, JournalEntry entry) {
    final isDebit = entry.type == 'Debit';
    final isCredit = entry.type == 'Credit';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDebit
              ? const Color(0xFFEF4444).withOpacity(0.3)
              : isCredit
                  ? const Color(0xFF10B981).withOpacity(0.3)
                  : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDebit
                  ? const Color(0xFFFEF2F2)
                  : isCredit
                      ? const Color(0xFFECFDF5)
                      : Colors.grey.shade50,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDarkBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Entry ${index + 1}',
                          style: GoogleFonts.lato(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    if (isDebit)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('DEBIT',
                            style: GoogleFonts.lato(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFEF4444))),
                      ),
                    if (isCredit)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('CREDIT',
                            style: GoogleFonts.lato(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981))),
                      ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _removeEntry(index),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline,
                        size: 16, color: Color(0xFFEF4444)),
                  ),
                ),
              ],
            ),
          ),
          // Card Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _buildDropdownField(
                  value: entry.group,
                  label: 'Account Group',
                  hint: 'Select group',
                  icon: Icons.folder_outlined,
                  items: _accountGroups,
                  onChanged: (v) {
                    setState(() {
                      entry.group = v;
                      entry.account = null;
                    });
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownField(
                  value: entry.account,
                  label: 'Account',
                  hint: 'Select account',
                  icon: Icons.account_balance_outlined,
                  items:
                      entry.group != null ? _accountsByGroup[entry.group]! : [],
                  onChanged: (v) {
                    setState(() {
                      entry.account = v;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: _buildTextField(
                            controller: entry.amountController,
                            label: 'Amount (₹)',
                            hint: '0.00',
                            icon: Icons.currency_rupee,
                            keyboardType: TextInputType.number)),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: _buildDropdownField(
                        value: entry.type,
                        label: 'Type',
                        hint: 'Select',
                        icon: Icons.swap_vert,
                        items: _entryTypes,
                        onChanged: (v) {
                          setState(() {
                            entry.type = v;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                    controller: entry.narrationController,
                    label: 'Narration (Optional)',
                    hint: 'Enter narration',
                    icon: Icons.notes,
                    maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TOTALS CARD ====================
  Widget _buildTotalsCard() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFEF4444).withOpacity(0.2))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.arrow_upward,
                              size: 14, color: Color(0xFFEF4444)),
                          const SizedBox(width: 6),
                          Text('Total Debit',
                              style: GoogleFonts.lato(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFEF4444)))
                        ]),
                        const SizedBox(height: 8),
                        Text('₹${NumberFormat('#,##0.00').format(_totalDebit)}',
                            style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFEF4444))),
                      ]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.2))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.arrow_downward,
                              size: 14, color: Color(0xFF10B981)),
                          const SizedBox(width: 6),
                          Text('Total Credit',
                              style: GoogleFonts.lato(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF10B981)))
                        ]),
                        const SizedBox(height: 8),
                        Text(
                            '₹${NumberFormat('#,##0.00').format(_totalCredit)}',
                            style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF10B981))),
                      ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _totalDebit == _totalCredit &&
                      (_totalDebit > 0 || _totalCredit > 0)
                  ? const Color(0xFFECFDF5)
                  : _totalDebit != _totalCredit &&
                          (_totalDebit > 0 || _totalCredit > 0)
                      ? const Color(0xFFFEF2F2)
                      : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _totalDebit == _totalCredit &&
                        (_totalDebit > 0 || _totalCredit > 0)
                    ? const Color(0xFF10B981).withOpacity(0.3)
                    : _totalDebit != _totalCredit &&
                            (_totalDebit > 0 || _totalCredit > 0)
                        ? const Color(0xFFEF4444).withOpacity(0.3)
                        : Colors.grey.shade200,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _totalDebit == _totalCredit &&
                          (_totalDebit > 0 || _totalCredit > 0)
                      ? Icons.check_circle
                      : _totalDebit != _totalCredit &&
                              (_totalDebit > 0 || _totalCredit > 0)
                          ? Icons.warning_amber
                          : Icons.info_outline,
                  size: 18,
                  color: _totalDebit == _totalCredit &&
                          (_totalDebit > 0 || _totalCredit > 0)
                      ? const Color(0xFF10B981)
                      : _totalDebit != _totalCredit &&
                              (_totalDebit > 0 || _totalCredit > 0)
                          ? const Color(0xFFEF4444)
                          : AppTheme.subtitleGray,
                ),
                const SizedBox(width: 8),
                Text(
                  _totalDebit == _totalCredit &&
                          (_totalDebit > 0 || _totalCredit > 0)
                      ? 'Balanced - Ready to save'
                      : _totalDebit != _totalCredit &&
                              (_totalDebit > 0 || _totalCredit > 0)
                          ? 'Unbalanced - Diff: ₹${NumberFormat('#,##0.00').format((_totalDebit - _totalCredit).abs())}'
                          : 'Add entries to begin',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _totalDebit == _totalCredit &&
                            (_totalDebit > 0 || _totalCredit > 0)
                        ? const Color(0xFF10B981)
                        : _totalDebit != _totalCredit &&
                                (_totalDebit > 0 || _totalCredit > 0)
                            ? const Color(0xFFEF4444)
                            : AppTheme.subtitleGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Add Row Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addEntry,
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: Text('Add Another Entry',
                  style: GoogleFonts.lato(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(
                    color: AppTheme.primaryDarkBlue.withOpacity(0.5),
                    width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: AppTheme.primaryDarkBlue.withOpacity(0.02),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryDarkBlue : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isActive
                ? Text('${step + 1}',
                    style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
                : Icon(Icons.lock, size: 14, color: Colors.grey.shade500),
          ),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? AppTheme.primaryDarkBlue
                    : Colors.grey.shade400)),
      ],
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              hint: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(hint,
                      style: GoogleFonts.lato(
                          fontSize: 13, color: Colors.grey.shade400))),
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
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('JOURNAL DATE',
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
              initialDate: _journalDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                          primary: AppTheme.primaryDarkBlue)),
                  child: child!),
            );
            if (date != null) setState(() => _journalDate = date);
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
              Text(DateFormat('dd MMM yyyy').format(_journalDate),
                  style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500)),
            ]),
          ),
        ),
      ],
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

// ==================== JOURNAL ENTRY MODEL ====================
class JournalEntry {
  String? group;
  String? account;
  final TextEditingController amountController;
  String? type;
  final TextEditingController narrationController;

  JournalEntry({
    this.group,
    this.account,
    TextEditingController? amountController,
    this.type,
    TextEditingController? narrationController,
  })  : amountController = amountController ?? TextEditingController(),
        narrationController = narrationController ?? TextEditingController();

  void dispose() {
    amountController.dispose();
    narrationController.dispose();
  }
}
