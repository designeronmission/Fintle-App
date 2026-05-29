import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

// ==================== MAIN ITEM LIST SCREEN ====================
class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isSearchSticky = false;

  final List<String> _categoryOptions = [
    'All',
    'Electronics',
    'Furniture',
    'Clothing',
    'Books',
    'Office Supplies',
    'Raw Materials',
    'Finished Goods'
  ];

  // Sample item data
  final List<Map<String, dynamic>> _allItems = [
    {
      'id': 'ITEM-001',
      'name': 'Wireless Mouse',
      'sku': 'WM-1001',
      'category': 'Electronics',
      'description': 'Ergonomic wireless mouse with 2.4GHz connection',
      'unit': 'Pcs',
      'sellingPrice': 25.99,
      'purchasePrice': 15.50,
      'stock': 145,
      'minStock': 20,
      'maxStock': 200,
      'status': 'Active',
      'taxRate': 18.0,
      'hsnCode': '847160',
      'location': 'Warehouse A',
      'supplier': 'Tech Distributors Inc',
      'totalSold': 450,
      'totalPurchased': 595,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 2)),
      'createdAt': DateTime.now().subtract(const Duration(days: 180)),
    },
    {
      'id': 'ITEM-002',
      'name': 'Office Chair',
      'sku': 'CH-2002',
      'category': 'Furniture',
      'description': 'Ergonomic mesh office chair with lumbar support',
      'unit': 'Pcs',
      'sellingPrice': 189.99,
      'purchasePrice': 120.00,
      'stock': 35,
      'minStock': 10,
      'maxStock': 100,
      'status': 'Active',
      'taxRate': 18.0,
      'hsnCode': '940139',
      'location': 'Warehouse B',
      'supplier': 'Office Solutions Ltd',
      'totalSold': 165,
      'totalPurchased': 200,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 5)),
      'createdAt': DateTime.now().subtract(const Duration(days: 200)),
    },
    {
      'id': 'ITEM-003',
      'name': 'Cotton T-Shirt',
      'sku': 'TS-3003',
      'category': 'Clothing',
      'description': '100% cotton premium quality t-shirt',
      'unit': 'Pcs',
      'sellingPrice': 14.99,
      'purchasePrice': 8.50,
      'stock': 230,
      'minStock': 50,
      'maxStock': 500,
      'status': 'Active',
      'taxRate': 12.0,
      'hsnCode': '610910',
      'location': 'Warehouse C',
      'supplier': 'Fashion Hub',
      'totalSold': 870,
      'totalPurchased': 1100,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 1)),
      'createdAt': DateTime.now().subtract(const Duration(days: 150)),
    },
    {
      'id': 'ITEM-004',
      'name': 'Programming Book: Flutter',
      'sku': 'BK-4004',
      'category': 'Books',
      'description': 'Complete guide to Flutter development',
      'unit': 'Pcs',
      'sellingPrice': 45.00,
      'purchasePrice': 28.00,
      'stock': 12,
      'minStock': 15,
      'maxStock': 100,
      'status': 'Low Stock',
      'taxRate': 5.0,
      'hsnCode': '490110',
      'location': 'Warehouse A',
      'supplier': 'Book Distributors',
      'totalSold': 188,
      'totalPurchased': 200,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 7)),
      'createdAt': DateTime.now().subtract(const Duration(days: 365)),
    },
    {
      'id': 'ITEM-005',
      'name': 'A4 Paper (500 sheets)',
      'sku': 'PP-5005',
      'category': 'Office Supplies',
      'description': 'Premium quality A4 printing paper',
      'unit': 'Ream',
      'sellingPrice': 6.99,
      'purchasePrice': 4.20,
      'stock': 320,
      'minStock': 50,
      'maxStock': 500,
      'status': 'Active',
      'taxRate': 12.0,
      'hsnCode': '480256',
      'location': 'Warehouse B',
      'supplier': 'Office Depot',
      'totalSold': 1280,
      'totalPurchased': 1600,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 3)),
      'createdAt': DateTime.now().subtract(const Duration(days: 250)),
    },
    {
      'id': 'ITEM-006',
      'name': 'LED Monitor 24"',
      'sku': 'MN-6006',
      'category': 'Electronics',
      'description': '24 inch Full HD LED monitor',
      'unit': 'Pcs',
      'sellingPrice': 159.99,
      'purchasePrice': 110.00,
      'stock': 8,
      'minStock': 10,
      'maxStock': 50,
      'status': 'Low Stock',
      'taxRate': 18.0,
      'hsnCode': '852852',
      'location': 'Warehouse A',
      'supplier': 'Tech Distributors Inc',
      'totalSold': 92,
      'totalPurchased': 100,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 4)),
      'createdAt': DateTime.now().subtract(const Duration(days: 120)),
    },
    {
      'id': 'ITEM-007',
      'name': 'Steel Table',
      'sku': 'TB-7007',
      'category': 'Furniture',
      'description': 'Heavy duty steel table for office',
      'unit': 'Pcs',
      'sellingPrice': 249.99,
      'purchasePrice': 180.00,
      'stock': 18,
      'minStock': 5,
      'maxStock': 50,
      'status': 'Active',
      'taxRate': 18.0,
      'hsnCode': '940320',
      'location': 'Warehouse B',
      'supplier': 'Office Solutions Ltd',
      'totalSold': 32,
      'totalPurchased': 50,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 10)),
      'createdAt': DateTime.now().subtract(const Duration(days: 90)),
    },
    {
      'id': 'ITEM-008',
      'name': 'Sticky Notes Pack',
      'sku': 'SN-8008',
      'category': 'Office Supplies',
      'description': 'Pack of 10 sticky note pads',
      'unit': 'Pack',
      'sellingPrice': 3.99,
      'purchasePrice': 2.00,
      'stock': 450,
      'minStock': 100,
      'maxStock': 1000,
      'status': 'Active',
      'taxRate': 12.0,
      'hsnCode': '482010',
      'location': 'Warehouse C',
      'supplier': 'Office Depot',
      'totalSold': 2150,
      'totalPurchased': 2600,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 1)),
      'createdAt': DateTime.now().subtract(const Duration(days: 300)),
    },
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
    _searchController.addListener(_filterItems);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
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

  void _filterItems() {
    setState(() {
      _filteredItems = _allItems.where((item) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            item['id'].toLowerCase().contains(searchQuery) ||
            item['name'].toLowerCase().contains(searchQuery) ||
            item['sku'].toLowerCase().contains(searchQuery) ||
            item['category'].toLowerCase().contains(searchQuery);

        final matchesCategory =
            _selectedCategory == 'All' || item['category'] == _selectedCategory;

        return matchesSearch && matchesCategory;
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
                        'Filter Items',
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
                    'Category',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categoryOptions.map((category) {
                      bool isSelected = _selectedCategory == category;
                      return FilterChip(
                        selected: isSelected,
                        label: Text(
                          category,
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _filterItems();
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
                              _selectedCategory = 'All';
                              _searchController.clear();
                            });
                            _filterItems();
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

  void _showItemDetail(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(item: item),
      ),
    );
  }

  void _showStockAdjustmentDialog(
      BuildContext context, Map<String, dynamic> item) {
    final TextEditingController quantityController = TextEditingController();
    String adjustmentType = 'add';
    final String unit = item['unit'].toString();
    final int currentStock = item['stock'] as int;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.95,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
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
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryDarkBlue,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Stock Adjustment',
                                          style: GoogleFonts.lato(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['name'],
                                          style: GoogleFonts.lato(
                                            fontSize: 13,
                                            color: Colors.white70,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Current Stock Card
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppTheme.lightBlueBg,
                                          AppTheme.primaryDarkBlue
                                              .withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppTheme.primaryDarkBlue
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryDarkBlue
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.warehouse,
                                            color: AppTheme.primaryDarkBlue,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Current Stock',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '$currentStock $unit',
                                                style: GoogleFonts.lato(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppTheme.primaryDarkBlue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                currentStock <= item['minStock']
                                                    ? const Color(0xFFF59E0B)
                                                        .withOpacity(0.1)
                                                    : const Color(0xFF10B981)
                                                        .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                currentStock <= item['minStock']
                                                    ? Icons.warning_amber
                                                    : Icons.check_circle,
                                                size: 14,
                                                color: currentStock <=
                                                        item['minStock']
                                                    ? const Color(0xFFF59E0B)
                                                    : const Color(0xFF10B981),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                currentStock <= item['minStock']
                                                    ? 'Low Stock'
                                                    : 'Healthy',
                                                style: GoogleFonts.lato(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: currentStock <=
                                                          item['minStock']
                                                      ? const Color(0xFFF59E0B)
                                                      : const Color(0xFF10B981),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Adjustment Type Selection
                                  Text(
                                    'Adjustment Type',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                adjustmentType = 'add';
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: adjustmentType == 'add'
                                                    ? AppTheme.primaryDarkBlue
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add_circle_outline,
                                                    size: 18,
                                                    color: adjustmentType ==
                                                            'add'
                                                        ? Colors.white
                                                        : AppTheme.subtitleGray,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Add Stock',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: adjustmentType ==
                                                              'add'
                                                          ? Colors.white
                                                          : Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                adjustmentType = 'remove';
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: adjustmentType ==
                                                        'remove'
                                                    ? AppTheme.primaryDarkBlue
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.remove_circle_outline,
                                                    size: 18,
                                                    color: adjustmentType ==
                                                            'remove'
                                                        ? Colors.white
                                                        : AppTheme.subtitleGray,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Remove Stock',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: adjustmentType ==
                                                              'remove'
                                                          ? Colors.white
                                                          : Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Quantity Input
                                  Text(
                                    'Quantity',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: quantityController,
                                            keyboardType: TextInputType.number,
                                            style:
                                                GoogleFonts.lato(fontSize: 16),
                                            decoration: InputDecoration(
                                              hintText: 'Enter quantity',
                                              hintStyle: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.grey.shade400,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(11),
                                              bottomRight: Radius.circular(11),
                                            ),
                                          ),
                                          child: Text(
                                            unit,
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.subtitleGray,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Preview after adjustment
                                  const SizedBox(height: 24),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightBlueBg,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Preview After Adjustment',
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.subtitleGray,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Current Stock:',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: AppTheme.subtitleGray,
                                              ),
                                            ),
                                            Text(
                                              '$currentStock $unit',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
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
                                              adjustmentType == 'add'
                                                  ? 'Add:'
                                                  : 'Remove:',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: AppTheme.subtitleGray,
                                              ),
                                            ),
                                            Text(
                                              '${quantityController.text.isEmpty ? '0' : quantityController.text} $unit',
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: adjustmentType == 'add'
                                                    ? const Color(0xFF10B981)
                                                    : const Color(0xFFEF4444),
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
                                              'New Stock:',
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryDarkBlue,
                                              ),
                                            ),
                                            Text(
                                              _getNewStockPreview(
                                                currentStock,
                                                quantityController.text,
                                                adjustmentType,
                                                unit,
                                              ),
                                              style: GoogleFonts.lato(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: _getNewStockColor(
                                                  currentStock,
                                                  quantityController.text,
                                                  adjustmentType,
                                                  item['minStock'] as int,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Spacer for bottom buttons
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Fixed Bottom Buttons
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
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
                                if (quantityController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter quantity'),
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                int quantity =
                                    int.tryParse(quantityController.text) ?? 0;
                                if (quantity <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please enter a valid quantity'),
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                if (adjustmentType == 'remove' &&
                                    quantity > currentStock) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Cannot remove more than current stock ($currentStock $unit)',
                                      ),
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xFFEF4444),
                                    ),
                                  );
                                  return;
                                }

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Stock ${adjustmentType == 'add' ? 'added' : 'removed'} successfully!\nNew stock: ${adjustmentType == 'add' ? currentStock + quantity : currentStock - quantity} $unit',
                                    ),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: const Color(0xFF10B981),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryDarkBlue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Update Stock',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

// Helper method to calculate new stock preview
  String _getNewStockPreview(int currentStock, String quantityText,
      String adjustmentType, String unit) {
    if (quantityText.isEmpty) {
      return '$currentStock $unit';
    }
    int quantity = int.tryParse(quantityText) ?? 0;
    int newStock = adjustmentType == 'add'
        ? currentStock + quantity
        : currentStock - quantity;
    return '$newStock $unit';
  }

// Helper method to get color for new stock based on min stock
  Color _getNewStockColor(int currentStock, String quantityText,
      String adjustmentType, int minStock) {
    if (quantityText.isEmpty) {
      return Colors.black87;
    }
    int quantity = int.tryParse(quantityText) ?? 0;
    int newStock = adjustmentType == 'add'
        ? currentStock + quantity
        : currentStock - quantity;

    if (newStock <= 0) {
      return const Color(0xFFEF4444); // Red for out of stock
    } else if (newStock <= minStock) {
      return const Color(0xFFF59E0B); // Orange for low stock
    }
    return const Color(0xFF10B981); // Green for healthy stock
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF10B981);
      case 'Low Stock':
        return const Color(0xFFF59E0B);
      case 'Out of Stock':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.subtitleGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _filteredItems.length;
    final totalStockValue = _filteredItems.fold(
        0.0,
        (sum, item) =>
            sum + ((item['sellingPrice'] as double) * (item['stock'] as int)));
    final lowStockItems =
        _filteredItems.where((item) => item['status'] == 'Low Stock').toList();
    final outOfStockItems = _filteredItems
        .where((item) => item['status'] == 'Out of Stock')
        .toList();
    final totalCategories =
        _filteredItems.map((e) => e['category'] as String).toSet().length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.primaryDarkBlue, size: 20),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          'Items',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
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
                              // Total Items Card
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
                                          'Total Items',
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
                                          '$totalCategories categories',
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
                                        Icons.inventory_2,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Two Cards Row
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
                                                'Stock Value',
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
                                                  Icons.attach_money,
                                                  size: 14,
                                                  color: Color(0xFF3B82F6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '₹${NumberFormat('#,##0').format(totalStockValue)}',
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            'Total inventory value',
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
                                                'Low Stock',
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
                                                  Icons.warning_amber,
                                                  size: 14,
                                                  color: Color(0xFFF59E0B),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${lowStockItems.length + outOfStockItems.length}',
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '${lowStockItems.length} low, ${outOfStockItems.length} out',
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
                                                'Search by name, SKU or category',
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
                                          color: _selectedCategory != 'All'
                                              ? AppTheme.primaryDarkBlue
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _selectedCategory != 'All'
                                                ? AppTheme.primaryDarkBlue
                                                : Colors.grey.shade200,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.filter_list,
                                              size: 16,
                                              color: _selectedCategory != 'All'
                                                  ? Colors.white
                                                  : AppTheme.subtitleGray,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Filter',
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    _selectedCategory != 'All'
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
                              if (_selectedCategory != 'All')
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Chip(
                                          label: Text(
                                            'Category: $_selectedCategory',
                                            style:
                                                GoogleFonts.lato(fontSize: 11),
                                          ),
                                          onDeleted: () {
                                            setState(() {
                                              _selectedCategory = 'All';
                                            });
                                            _filterItems();
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

                        // Item List
                        if (_filteredItems.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inventory_outlined,
                                    size: 60,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No items found',
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
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              final statusColor =
                                  _getStatusColor(item['status']);
                              final stock = item['stock'] as int;
                              final minStock = item['minStock'] as int;
                              final isLowStock = stock <= minStock;

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
                                    onTap: () => _showItemDetail(item),
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
                                                      item['name'],
                                                      style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppTheme
                                                            .primaryDarkBlue,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 6,
                                                            vertical: 2,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Text(
                                                            item['sku'],
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 9,
                                                              color: AppTheme
                                                                  .subtitleGray,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        Text(
                                                          item['category'],
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 10,
                                                            color: AppTheme
                                                                .subtitleGray,
                                                          ),
                                                        ),
                                                      ],
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
                                                  item['status'],
                                                  style: GoogleFonts.lato(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: statusColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          // Stock and Price Row
                                          Row(
                                            children: [
                                              // Stock Section
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: isLowStock
                                                        ? const Color(
                                                            0xFFFEF3C7)
                                                        : AppTheme.lightBlueBg,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.inventory,
                                                            size: 14,
                                                            color: isLowStock
                                                                ? const Color(
                                                                    0xFFF59E0B)
                                                                : AppTheme
                                                                    .primaryDarkBlue,
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          Text(
                                                            'Stock',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color: AppTheme
                                                                  .subtitleGray,
                                                            ),
                                                          ),
                                                          if (isLowStock) ...[
                                                            const SizedBox(
                                                                width: 8),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                        0xFFF59E0B)
                                                                    .withOpacity(
                                                                        0.2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Text(
                                                                'Low Stock',
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: const Color(
                                                                      0xFFF59E0B),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        '$stock ${item['unit']}',
                                                        style: GoogleFonts.lato(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isLowStock
                                                              ? const Color(
                                                                  0xFFF59E0B)
                                                              : Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Min: ${item['minStock']} ${item['unit']} • Max: ${item['maxStock']} ${item['unit']}',
                                                        style: GoogleFonts.lato(
                                                          fontSize: 9,
                                                          color: AppTheme
                                                              .subtitleGray,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              // Price Section
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.lightBlueBg,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .currency_rupee,
                                                            size: 14,
                                                            color: AppTheme
                                                                .primaryDarkBlue,
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          Text(
                                                            'Selling Price',
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 10,
                                                              color: AppTheme
                                                                  .subtitleGray,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        '₹${NumberFormat('#,##0.00').format(item['sellingPrice'])}',
                                                        style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Purchase: ₹${NumberFormat('#,##0.00').format(item['purchasePrice'])}',
                                                        style: GoogleFonts.lato(
                                                          fontSize: 9,
                                                          color: AppTheme
                                                              .subtitleGray,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          // Action Buttons
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton.icon(
                                                  onPressed: () =>
                                                      _showStockAdjustmentDialog(
                                                          context, item),
                                                  icon: const Icon(
                                                      Icons.inventory,
                                                      size: 16),
                                                  label: Text(
                                                    'Adjust Stock',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    side: BorderSide(
                                                        color: AppTheme
                                                            .primaryDarkBlue),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () =>
                                                      _showItemDetail(item),
                                                  icon: const Icon(
                                                    Icons.visibility,
                                                    size: 16,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ),
                                                  label: Text(
                                                    'View Details',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: AppTheme
                                                        .primaryDarkBlue,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    elevation: 0,
                                                  ),
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

              // Create Item Button
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
                            builder: (context) => const CreateItemScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(
                        'Create Item',
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
                            hintText: 'Search by name, SKU or category',
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
                          color: _selectedCategory != 'All'
                              ? AppTheme.primaryDarkBlue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedCategory != 'All'
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
                              color: _selectedCategory != 'All'
                                  ? Colors.white
                                  : AppTheme.subtitleGray,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filter',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _selectedCategory != 'All'
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

// ==================== ITEM DETAIL SCREEN ====================
class ItemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemDetailScreen({super.key, required this.item});

  void _showStockAdjustmentDialog(BuildContext context) {
    final TextEditingController quantityController = TextEditingController();
    String adjustmentType = 'add';
    final String unit = item['unit'].toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stock Adjustment'),
        content: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'add', label: Text('Add Stock')),
                ButtonSegment(value: 'remove', label: Text('Remove Stock')),
              ],
              selected: {adjustmentType},
              onSelectionChanged: (Set<String> newSelection) {
                adjustmentType = newSelection.first;
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.primaryDarkBlue;
                  }
                  return Colors.grey.shade200;
                }),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: const OutlineInputBorder(),
                suffixText: unit,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Stock ${adjustmentType == 'add' ? 'added' : 'removed'} successfully'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryDarkBlue,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text(
            'Are you sure you want to delete this item? This action cannot be undone.'),
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
                  content: Text('Item deleted successfully'),
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

  @override
  Widget build(BuildContext context) {
    final stock = item['stock'] as int;
    final minStock = item['minStock'] as int;
    final isLowStock = stock <= minStock;

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
          'Item Details',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryDarkBlue),
            onSelected: (value) {
              if (value == 'edit') {
                // Navigate to edit item screen
              } else if (value == 'stock') {
                _showStockAdjustmentDialog(context);
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
                    Text('Edit Item'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'stock',
                child: Row(
                  children: [
                    Icon(Icons.inventory,
                        size: 20, color: AppTheme.primaryDarkBlue),
                    SizedBox(width: 18),
                    Text('Stock Adjustment'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete Item', style: TextStyle(color: Colors.red)),
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
            // Item Header Card
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
                              item['name'],
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SKU: ${item['sku']}',
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
                          item['status'],
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
                              'Selling Price',
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '₹${NumberFormat('#,##0.00').format(item['sellingPrice'])}',
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
                              'Current Stock',
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '$stock ${item['unit']}',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isLowStock
                                        ? const Color(0xFFFBBF24)
                                        : Colors.white,
                                  ),
                                ),
                                if (isLowStock) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF59E0B)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Low Stock',
                                      style: GoogleFonts.lato(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFF59E0B),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Stock Card
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
                      'Stock Information',
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
                        _buildInfoRow(Icons.inventory, 'Current Stock',
                            '$stock ${item['unit']}'),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.warning_amber, 'Minimum Stock',
                            '${item['minStock']} ${item['unit']}'),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.insights, 'Maximum Stock',
                            '${item['maxStock']} ${item['unit']}'),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.location_on_outlined,
                            'Storage Location', item['location']),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Basic Information
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
                      'Basic Information',
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
                        _buildInfoRow(Icons.category_outlined, 'Category',
                            item['category']),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.description_outlined, 'Description',
                            item['description']),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.production_quantity_limits,
                            'Unit of Measure', item['unit']),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Pricing Information
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
                      'Pricing Information',
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
                        _buildInfoRow(Icons.currency_rupee, 'Selling Price',
                            '₹${NumberFormat('#,##0.00').format(item['sellingPrice'])}'),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.shopping_cart, 'Purchase Price',
                            '₹${NumberFormat('#,##0.00').format(item['purchasePrice'])}'),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.percent, 'Tax Rate',
                            '${item['taxRate']}% (GST)'),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                            Icons.qr_code, 'HSN/SAC Code', item['hsnCode']),
                      ],
                    ),
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
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Supplier Information',
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
                        _buildInfoRow(Icons.business_outlined, 'Supplier',
                            item['supplier']),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.trending_up, 'Total Sold',
                            '${item['totalSold']} ${item['unit']}'),
                        const SizedBox(height: 10),
                        _buildInfoRow(Icons.trending_down, 'Total Purchased',
                            '${item['totalPurchased']} ${item['unit']}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Activity
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
                      'Activity',
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
                          'Last Updated',
                          DateFormat('dd MMM yyyy').format(item['lastUpdated']),
                          Icons.update,
                        ),
                        const SizedBox(height: 10),
                        _buildActivityRow(
                          'Created On',
                          DateFormat('dd MMM yyyy').format(item['createdAt']),
                          Icons.calendar_today,
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
                    _showStockAdjustmentDialog(context);
                  },
                  icon: const Icon(Icons.inventory, size: 16),
                  label: Text(
                    'Adjust Stock',
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
                    // Navigate to purchase order
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Purchase Order',
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

// ==================== CREATE ITEM SCREEN (Dynamic Button + Full Width Tax Type) ====================
class CreateItemScreen extends StatefulWidget {
  const CreateItemScreen({super.key});

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // ==================== BASIC DETAILS ====================
  final TextEditingController _itemNameController = TextEditingController();
  String _itemType = 'Product';

  // ==================== PRICING SECTION ====================
  final TextEditingController _salesPriceController = TextEditingController();
  String _salesTaxType = 'Tax Exclusive';

  final TextEditingController _purchasePriceController =
      TextEditingController();
  String _purchaseTaxType = 'Tax Exclusive';

  final TextEditingController _discountController = TextEditingController();
  String _discountType = 'Percentage';

  // ==================== TAX & CLASSIFICATION ====================
  String _taxRate = '18%';
  final TextEditingController _hsnSacController = TextEditingController();

  // ==================== INVENTORY SECTION ====================
  final TextEditingController _openingStockController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _maxStockController = TextEditingController();

  // ==================== BARCODE SECTION ====================
  final TextEditingController _barcodeController = TextEditingController();

  // ==================== CUSTOM FIELDS ====================
  List<Map<String, dynamic>> _customFields = [];
  final TextEditingController _customFieldKeyController =
      TextEditingController();
  final TextEditingController _customFieldValueController =
      TextEditingController();

  // Options
  final List<String> _taxRates = ['0%', '5%', '12%', '18%', '28%'];

  // Section visibility states - sections appear when previous is completed
  bool _showPricingSection = false;
  bool _showTaxSection = false;
  bool _showInventorySection = false;
  bool _showBarcodeSection = false;
  bool _showCustomFieldsSection = false;

  // Section completion states
  bool _isBasicCompleted = false;
  bool _isPricingCompleted = false;
  bool _isTaxCompleted = false;
  bool _isInventoryCompleted = false;

  @override
  void initState() {
    super.initState();
    _itemNameController.addListener(_checkBasicCompletion);
    _salesPriceController.addListener(_checkPricingCompletion);
    _purchasePriceController.addListener(_checkPricingCompletion);
    _hsnSacController.addListener(_checkTaxCompletion);
    _openingStockController.addListener(_checkInventoryCompletion);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _itemNameController.dispose();
    _salesPriceController.dispose();
    _purchasePriceController.dispose();
    _discountController.dispose();
    _hsnSacController.dispose();
    _openingStockController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    _barcodeController.dispose();
    _customFieldKeyController.dispose();
    _customFieldValueController.dispose();
    super.dispose();
  }

  void _checkBasicCompletion() {
    final bool completed = _itemNameController.text.trim().isNotEmpty;
    if (completed != _isBasicCompleted) {
      setState(() {
        _isBasicCompleted = completed;
        if (_isBasicCompleted && !_showPricingSection) {
          _showPricingSection = true;
          _scrollToBottom();
        }
      });
    }
  }

  void _checkPricingCompletion() {
    final bool completed = _salesPriceController.text.trim().isNotEmpty &&
        _purchasePriceController.text.trim().isNotEmpty;
    if (completed != _isPricingCompleted) {
      setState(() {
        _isPricingCompleted = completed;
        if (_isPricingCompleted && !_showTaxSection) {
          _showTaxSection = true;
          _scrollToBottom();
        }
      });
    }
  }

  void _checkTaxCompletion() {
    final bool completed = _hsnSacController.text.trim().isNotEmpty;
    if (completed != _isTaxCompleted) {
      setState(() {
        _isTaxCompleted = completed;
        if (_isTaxCompleted && !_showInventorySection) {
          _showInventorySection = true;
          _scrollToBottom();
        }
      });
    }
  }

  void _checkInventoryCompletion() {
    final bool completed = _openingStockController.text.trim().isNotEmpty;
    if (completed != _isInventoryCompleted) {
      setState(() {
        _isInventoryCompleted = completed;
        if (_isInventoryCompleted && !_showBarcodeSection) {
          _showBarcodeSection = true;
          _scrollToBottom();
        }
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _generateBarcode() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String barcode = 'ITM${timestamp.substring(timestamp.length - 8)}';
    setState(() => _barcodeController.text = barcode);
  }

  void _addCustomField() {
    if (_customFieldKeyController.text.isNotEmpty &&
        _customFieldValueController.text.isNotEmpty) {
      setState(() {
        _customFields.add({
          'key': _customFieldKeyController.text,
          'value': _customFieldValueController.text,
        });
        _customFieldKeyController.clear();
        _customFieldValueController.clear();
      });
    }
  }

  void _removeCustomField(int index) {
    setState(() => _customFields.removeAt(index));
  }

  void _toggleCustomFields() {
    setState(() {
      _showCustomFieldsSection = !_showCustomFieldsSection;
      if (_showCustomFieldsSection) {
        _scrollToBottom();
      }
    });
  }

  // Check if all required sections are completed
  bool get _isAllRequiredCompleted {
    return _isBasicCompleted &&
        _isPricingCompleted &&
        _isTaxCompleted &&
        _isInventoryCompleted;
  }

  void _handleButtonPress() {
    if (_isAllRequiredCompleted) {
      _saveItem();
    } else {
      _goToNextIncompleteSection();
    }
  }

  void _goToNextIncompleteSection() {
    if (!_isBasicCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter Item Name'),
            duration: Duration(seconds: 1)),
      );
      _scrollToTop();
    } else if (!_isPricingCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter Sales Price and Purchase Price'),
            duration: Duration(seconds: 1)),
      );
      _scrollToSection(1);
    } else if (!_isTaxCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter HSN/SAC code'),
            duration: Duration(seconds: 1)),
      );
      _scrollToSection(2);
    } else if (!_isInventoryCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter Opening Stock'),
            duration: Duration(seconds: 1)),
      );
      _scrollToSection(3);
    }
  }

  void _scrollToTop() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _scrollToSection(int sectionIndex) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        double offset = 0;
        switch (sectionIndex) {
          case 1:
            offset = 400;
            break;
          case 2:
            offset = 800;
            break;
          case 3:
            offset = 1200;
            break;
          default:
            offset = 0;
        }
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _saveItem() {
    final itemData = {
      'itemName': _itemNameController.text.trim(),
      'itemType': _itemType,
      'salesPrice': double.tryParse(_salesPriceController.text.trim()) ?? 0,
      'salesTaxType': _salesTaxType,
      'purchasePrice':
          double.tryParse(_purchasePriceController.text.trim()) ?? 0,
      'purchaseTaxType': _purchaseTaxType,
      'discount': double.tryParse(_discountController.text.trim()) ?? 0,
      'discountType': _discountType,
      'taxRate': _taxRate,
      'hsnSac': _hsnSacController.text.trim(),
      'openingStock': int.tryParse(_openingStockController.text.trim()) ?? 0,
      'minStock': int.tryParse(_minStockController.text.trim()) ?? 0,
      'maxStock': int.tryParse(_maxStockController.text.trim()) ?? 0,
      'barcode': _barcodeController.text.trim(),
      'customFields': _customFields,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Item "${_itemNameController.text}" created successfully!'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.of(context).pop(itemData);
    });
  }

  void _navigateBack() {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
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
          onPressed: _navigateBack,
        ),
        title: Text('Create Item',
            style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryDarkBlue)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Section 1: Basic Details (Always visible)
                  _buildBasicSection(),

                  const SizedBox(height: 16),

                  // Section 2: Pricing Section (Appears after Basic completed)
                  if (_showPricingSection) _buildPricingSection(),

                  if (_showPricingSection) const SizedBox(height: 16),

                  // Section 3: Tax & Classification (Appears after Pricing completed)
                  if (_showTaxSection) _buildTaxSection(),

                  if (_showTaxSection) const SizedBox(height: 16),

                  // Section 4: Inventory Section (Appears after Tax completed)
                  if (_showInventorySection) _buildInventorySection(),

                  if (_showInventorySection) const SizedBox(height: 16),

                  // Section 5: Barcode Section (Appears after Inventory completed)
                  if (_showBarcodeSection) _buildBarcodeSection(),

                  if (_showBarcodeSection) const SizedBox(height: 16),

                  // Section 6: Custom Fields (Optional - expandable)
                  _buildCustomFieldsSection(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Fixed Bottom Button - Dynamic (Continue or Create Item)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleButtonPress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAllRequiredCompleted
                        ? const Color(0xFF10B981)
                        : AppTheme.primaryDarkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    _isAllRequiredCompleted ? 'Create Item' : 'Continue',
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicSection() {
    return _buildSectionCard(
      title: 'Basic Details',
      icon: Icons.info_outline,
      isCompleted: _isBasicCompleted,
      content: Column(
        children: [
          _buildTextField(
            controller: _itemNameController,
            label: 'Item Name',
            hint: 'Enter item name',
            icon: Icons.inventory_2_outlined,
            required: true,
          ),
          const SizedBox(height: 16),
          _buildRadioGroup(
            label: 'Item Type',
            value: _itemType,
            options: ['Product', 'Service'],
            onChanged: (v) => setState(() => _itemType = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return _buildSectionCard(
      title: 'Pricing Section',
      icon: Icons.currency_rupee,
      isCompleted: _isPricingCompleted,
      content: Column(
        children: [
          // Sales Price - Full width with Tax Type below
          _buildPriceFieldFullWidth(
            controller: _salesPriceController,
            label: 'Sales Price',
            hint: 'Enter sales price',
            required: true,
          ),
          const SizedBox(height: 8),
          _buildTaxTypeSelector(
            value: _salesTaxType,
            onChanged: (v) => setState(() => _salesTaxType = v),
            label: 'Sales Tax Type',
          ),
          const SizedBox(height: 16),

          // Purchase Price - Full width with Tax Type below
          _buildPriceFieldFullWidth(
            controller: _purchasePriceController,
            label: 'Purchase Price',
            hint: 'Enter purchase price',
            required: true,
          ),
          const SizedBox(height: 8),
          _buildTaxTypeSelector(
            value: _purchaseTaxType,
            onChanged: (v) => setState(() => _purchaseTaxType = v),
            label: 'Purchase Tax Type',
          ),
          const SizedBox(height: 16),

          // Discount Field
          _buildDiscountField(),
        ],
      ),
    );
  }

  Widget _buildTaxSection() {
    return _buildSectionCard(
      title: 'Tax & Classification',
      icon: Icons.request_quote,
      isCompleted: _isTaxCompleted,
      content: Column(
        children: [
          _buildDropdownField(
            value: _taxRate,
            label: 'Tax Rate',
            icon: Icons.percent,
            items: _taxRates,
            onChanged: (v) => setState(() => _taxRate = v!),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _hsnSacController,
            label: 'HSN / SAC Field',
            hint: 'Enter HSN/SAC code',
            icon: Icons.qr_code,
            required: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection() {
    return _buildSectionCard(
      title: 'Inventory Section',
      icon: Icons.inventory,
      isCompleted: _isInventoryCompleted,
      content: Column(
        children: [
          _buildTextField(
            controller: _openingStockController,
            label: 'Opening Stock',
            hint: 'Enter opening stock quantity',
            icon: Icons.warehouse,
            keyboardType: TextInputType.number,
            required: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _minStockController,
                  label: 'Min Stock',
                  hint: 'Minimum stock level',
                  icon: Icons.trending_down,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _maxStockController,
                  label: 'Max Stock',
                  hint: 'Maximum stock level',
                  icon: Icons.trending_up,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeSection() {
    return _buildSectionCard(
      title: 'Barcode Section',
      icon: Icons.qr_code_scanner,
      isCompleted: _barcodeController.text.isNotEmpty,
      content: Column(
        children: [
          _buildTextField(
            controller: _barcodeController,
            label: 'Barcode',
            hint: 'Enter or scan barcode',
            icon: Icons.qr_code,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _generateBarcode,
                  icon: const Icon(Icons.qr_code, size: 18),
                  label: Text('Generate Code',
                      style: GoogleFonts.lato(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: AppTheme.primaryDarkBlue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFieldsSection() {
    return _buildSectionCard(
      title: 'Custom Fields',
      icon: Icons.settings_applications,
      isCompleted: _customFields.isNotEmpty,
      isOptional: true,
      onToggle: _toggleCustomFields,
      isExpanded: _showCustomFieldsSection,
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSimpleField(
                  controller: _customFieldKeyController,
                  label: 'Field Name',
                  hint: 'e.g., Color, Size',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSimpleField(
                  controller: _customFieldValueController,
                  label: 'Value',
                  hint: 'e.g., Red, Large',
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primaryDarkBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: _addCustomField,
                  icon: const Icon(Icons.add, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_customFields.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _customFields.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final field = _customFields[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlueBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(field['key'],
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryDarkBlue)),
                            const SizedBox(height: 4),
                            Text(field['value'],
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: AppTheme.subtitleGray)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeCustomField(index),
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                );
              },
            ),
          if (_customFields.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.lightBlueBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'No custom fields added. Click + to add fields.',
                  style: GoogleFonts.lato(
                      fontSize: 12, color: AppTheme.subtitleGray),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required bool isCompleted,
    bool isOptional = false,
    bool isExpanded = true,
    VoidCallback? onToggle,
    required Widget content,
  }) {
    return Container(
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted ? AppTheme.lightBlueBg : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: AppTheme.primaryDarkBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title.toUpperCase(),
                          style: GoogleFonts.lato(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.subtitleGray,
                              letterSpacing: 0.5)),
                      if (isCompleted && !isOptional)
                        Text('Completed',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF10B981))),
                      if (isOptional)
                        Text(isExpanded ? 'Tap to collapse' : 'Tap to expand',
                            style: GoogleFonts.lato(
                                fontSize: 11, color: AppTheme.subtitleGray)),
                    ],
                  ),
                ),
                if (isCompleted && !isOptional)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Done',
                        style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981))),
                  ),
                if (isOptional)
                  IconButton(
                    onPressed: onToggle,
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppTheme.subtitleGray,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: content,
            ),
        ],
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(),
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray,
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.lato(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.lato(fontSize: 14, color: const Color(0xFF94A3B8)),
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppTheme.primaryDarkBlue, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
          ),
          validator:
              required ? (v) => v!.isEmpty ? 'Enter $label' : null : null,
        ),
      ],
    );
  }

  Widget _buildPriceFieldFullWidth({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(),
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray,
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: GoogleFonts.lato(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.lato(fontSize: 14, color: const Color(0xFF94A3B8)),
            prefixIcon: const Icon(Icons.currency_rupee,
                size: 18, color: const Color(0xFF94A3B8)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppTheme.primaryDarkBlue, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
          ),
          validator:
              required ? (v) => v!.isEmpty ? 'Enter $label' : null : null,
        ),
      ],
    );
  }

  Widget _buildTaxTypeSelector({
    required String value,
    required Function(String) onChanged,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(),
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray,
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              items: ['Tax Inclusive', 'Tax Exclusive']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child:
                            Text(type, style: GoogleFonts.lato(fontSize: 14)),
                      ))
                  .toList(),
              onChanged: (v) => onChanged(v!),
              icon: Icon(Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(),
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray,
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: GoogleFonts.lato(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.lato(fontSize: 14, color: const Color(0xFF94A3B8)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppTheme.primaryDarkBlue, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildRadioGroup({
    required String label,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(),
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Row(
          children: options
              .map((option) => Expanded(
                    child: RadioListTile<String>(
                      title:
                          Text(option, style: GoogleFonts.lato(fontSize: 14)),
                      value: option,
                      groupValue: value,
                      onChanged: (v) => onChanged(v!),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: AppTheme.primaryDarkBlue,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDiscountField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('DISCOUNT',
                  style: GoogleFonts.lato(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.subtitleGray,
                      letterSpacing: 0.5)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.lato(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Enter discount',
                  hintStyle: GoogleFonts.lato(
                      fontSize: 14, color: const Color(0xFF94A3B8)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppTheme.primaryDarkBlue, width: 2)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('DISCOUNT TYPE',
                  style: GoogleFonts.lato(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.subtitleGray,
                      letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _discountType,
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    items: ['Percentage', 'Flat Amount']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type,
                                  style: GoogleFonts.lato(fontSize: 14)),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _discountType = v!),
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey.shade600, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(),
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray,
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child:
                            Text(item, style: GoogleFonts.lato(fontSize: 14)),
                      ))
                  .toList(),
              onChanged: onChanged,
              icon: Icon(Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
