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
      // In the ItemScreen class, replace the appBar with this:

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.primaryDarkBlue, size: 20),
          onPressed: () {
            // Check if there's a previous screen before popping
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {}
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
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Selling Price',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 9,
                                                        color: AppTheme
                                                            .subtitleGray,
                                                      ),
                                                    ),
                                                    Text(
                                                      '₹${NumberFormat('#,##0.00').format(item['sellingPrice'])}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Stock',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 9,
                                                        color: AppTheme
                                                            .subtitleGray,
                                                      ),
                                                    ),
                                                    Text(
                                                      '$stock ${item['unit']}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: stock <= minStock
                                                            ? const Color(
                                                                0xFFF59E0B)
                                                            : const Color(
                                                                0xFF10B981),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            child: LinearProgressIndicator(
                                              value: stock >
                                                      (item['maxStock'] as int)
                                                  ? 1.0
                                                  : stock /
                                                      (item['maxStock'] as int),
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              color: stock <= minStock
                                                  ? const Color(0xFFF59E0B)
                                                  : const Color(0xFF10B981),
                                              minHeight: 3,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Min: ${item['minStock']} ${item['unit']}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 9,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                              Text(
                                                'Max: ${item['maxStock']} ${item['unit']}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 9,
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
          mainAxisSize: MainAxisSize.min,
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
    final maxStock = item['maxStock'] as int;
    final stockPercentage = maxStock > 0 ? (stock / maxStock) : 0.0;

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
                    SizedBox(width: 12),
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
                            Text(
                              '$stock ${item['unit']}',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: stock <= minStock
                                    ? const Color(0xFFFBBF24)
                                    : Colors.white,
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
                      value: stockPercentage,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      color: stock <= minStock
                          ? const Color(0xFFFBBF24)
                          : Colors.white,
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(stockPercentage * 100).toStringAsFixed(1)}% of max stock',
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      color: Colors.white70,
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

            // Stock Information
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

// Replace the entire CreateItemScreen class with this fixed version:

// ==================== CREATE ITEM SCREEN (Fixed Back Navigation) ====================
class CreateItemScreen extends StatefulWidget {
  const CreateItemScreen({super.key});

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  final _formKey = GlobalKey<FormState>();

  // Scroll controller for better scrolling
  final ScrollController _scrollController = ScrollController();

  // Controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _maxStockController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _hsnController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();

  // Focus nodes to detect when user moves to next field
  final FocusNode _itemNameFocus = FocusNode();
  final FocusNode _skuFocus = FocusNode();
  final FocusNode _sellingPriceFocus = FocusNode();
  final FocusNode _stockFocus = FocusNode();

  // Keys for each section to scroll to
  final GlobalKey _basicSectionKey = GlobalKey();
  final GlobalKey _pricingSectionKey = GlobalKey();
  final GlobalKey _stockSectionKey = GlobalKey();
  final GlobalKey _supplierSectionKey = GlobalKey();

  // Dropdown values
  String _selectedCategory = 'Electronics';
  String _selectedUnit = 'Pcs';
  String _selectedStatus = 'Active';
  String _selectedTaxType = 'GST';

  final List<String> _categories = [
    'Electronics',
    'Furniture',
    'Clothing',
    'Books',
    'Office Supplies',
    'Raw Materials',
    'Finished Goods',
    'Other'
  ];

  final List<String> _units = [
    'Pcs',
    'Kg',
    'Liters',
    'Meters',
    'Box',
    'Pack',
    'Ream',
    'Dozen',
    'Set'
  ];

  final List<String> _statusOptions = ['Active', 'Inactive', 'Low Stock'];
  final List<String> _taxTypes = ['GST', 'VAT', 'CST', 'None'];

  // Section visibility states
  bool _showPricingSection = false;
  bool _showStockSection = false;
  bool _showSupplierSection = false;

  // Section completion states
  bool _isBasicInfoCompleted = false;
  bool _isPricingCompleted = false;
  bool _isStockCompleted = false;

  // Track if sections have been auto-opened (to prevent multiple openings)
  bool _pricingSectionOpened = false;
  bool _stockSectionOpened = false;
  bool _supplierSectionOpened = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to detect when focus is lost
    _itemNameFocus.addListener(_onItemNameFocusChange);
    _skuFocus.addListener(_onSkuFocusChange);
    _sellingPriceFocus.addListener(_onSellingPriceFocusChange);
    _stockFocus.addListener(_onStockFocusChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _itemNameFocus.dispose();
    _skuFocus.dispose();
    _sellingPriceFocus.dispose();
    _stockFocus.dispose();
    _itemNameController.dispose();
    _skuController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    _gstController.dispose();
    _hsnController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  void _onItemNameFocusChange() {
    // When user leaves the Item Name field
    if (!_itemNameFocus.hasFocus) {
      _checkAndOpenPricingSection();
    }
  }

  void _onSkuFocusChange() {
    // When user leaves the SKU field
    if (!_skuFocus.hasFocus) {
      _checkAndOpenPricingSection();
    }
  }

  void _onSellingPriceFocusChange() {
    // When user leaves the Selling Price field
    if (!_sellingPriceFocus.hasFocus) {
      _checkAndOpenStockSection();
    }
  }

  void _onStockFocusChange() {
    // When user leaves the Stock field
    if (!_stockFocus.hasFocus) {
      _checkAndOpenSupplierSection();
    }
  }

  void _checkAndOpenPricingSection() {
    if (!mounted) return;
    setState(() {
      _isBasicInfoCompleted = _itemNameController.text.trim().isNotEmpty &&
          _skuController.text.trim().isNotEmpty;

      // Auto-show pricing section only when basic info is completed AND not already opened
      if (_isBasicInfoCompleted && !_pricingSectionOpened) {
        _pricingSectionOpened = true;
        _showPricingSection = true;
        _scrollToSection(_pricingSectionKey);
      }
    });
  }

  void _checkAndOpenStockSection() {
    if (!mounted) return;
    setState(() {
      _isPricingCompleted = _sellingPriceController.text.trim().isNotEmpty;

      // Auto-show stock section only when pricing is completed AND not already opened
      if (_isPricingCompleted && !_stockSectionOpened) {
        _stockSectionOpened = true;
        _showStockSection = true;
        _scrollToSection(_stockSectionKey);
      }
    });
  }

  void _checkAndOpenSupplierSection() {
    if (!mounted) return;
    setState(() {
      _isStockCompleted = _stockController.text.trim().isNotEmpty;

      // Auto-show supplier section only when stock is completed AND not already opened
      if (_isStockCompleted && !_supplierSectionOpened) {
        _supplierSectionOpened = true;
        _showSupplierSection = true;
        _scrollToSection(_supplierSectionKey);
      }
    });
  }

  void _scrollToSection(GlobalKey sectionKey) {
    // Add a small delay to allow UI to build
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

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Item "${_itemNameController.text}" created successfully!',
            style: GoogleFonts.lato(),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.of(context).pop(); // Use Navigator.of(context) for safety
        }
      });
    }
  }

  void _navigateBack() {
    // Safe navigation back
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBack();
        return false; // Return false since we're handling the navigation
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppTheme.primaryDarkBlue, size: 20),
            onPressed: _navigateBack, // Use the safe navigation method
          ),
          title: Text(
            'Create Item',
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _saveItem,
              child: Text(
                'Save',
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
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Basic Information Section (Always visible)
                Container(
                  key: _basicSectionKey,
                  child: _buildInfoCard(
                    title: 'Basic Information',
                    icon: Icons.info_outline,
                    isRequired: true,
                    isCompleted: _isBasicInfoCompleted,
                    isVisible: true,
                    content: Column(
                      children: [
                        _buildTextField(
                          controller: _itemNameController,
                          focusNode: _itemNameFocus,
                          label: 'Item Name',
                          hint: 'Enter item name',
                          icon: Icons.inventory_2_outlined,
                          required: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Item name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _skuController,
                          focusNode: _skuFocus,
                          label: 'SKU',
                          hint: 'Enter unique SKU code',
                          icon: Icons.qr_code,
                          required: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'SKU is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildDropdownField(
                          value: _selectedCategory,
                          label: 'Category',
                          icon: Icons.category_outlined,
                          items: _categories,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildDropdownField(
                          value: _selectedUnit,
                          label: 'Unit of Measure',
                          icon: Icons.production_quantity_limits,
                          items: _units,
                          onChanged: (value) {
                            setState(() {
                              _selectedUnit = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Enter item description (optional)',
                          icon: Icons.description_outlined,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),

                // Pricing Information Section (Shows after basic info)
                if (_showPricingSection)
                  Container(
                    key: _pricingSectionKey,
                    child: _buildInfoCard(
                      title: 'Pricing Information',
                      icon: Icons.currency_rupee,
                      isRequired: true,
                      isCompleted: _isPricingCompleted,
                      isVisible: _showPricingSection,
                      content: Column(
                        children: [
                          _buildTextField(
                            controller: _purchasePriceController,
                            label: 'Purchase Price',
                            hint: 'Enter purchase price',
                            icon: Icons.shopping_cart_outlined,
                            keyboardType: TextInputType.number,
                            prefix: '₹ ',
                          ),
                          const SizedBox(height: 14),
                          _buildTextField(
                            controller: _sellingPriceController,
                            focusNode: _sellingPriceFocus,
                            label: 'Selling Price',
                            hint: 'Enter selling price',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            prefix: '₹ ',
                            required: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Selling price is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildDropdownField(
                                  value: _selectedTaxType,
                                  label: 'Tax Type',
                                  icon: Icons.percent,
                                  items: _taxTypes,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTaxType = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: _buildTextField(
                                  controller: _gstController,
                                  label: 'Rate %',
                                  hint: '0',
                                  icon: Icons.calculate_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildTextField(
                            controller: _hsnController,
                            label: 'HSN/SAC Code',
                            hint: 'Enter HSN/SAC code',
                            icon: Icons.code,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Stock Information Section (Shows after pricing)
                if (_showStockSection)
                  Container(
                    key: _stockSectionKey,
                    child: _buildInfoCard(
                      title: 'Stock Information',
                      icon: Icons.inventory,
                      isRequired: true,
                      isCompleted: _isStockCompleted,
                      isVisible: _showStockSection,
                      content: Column(
                        children: [
                          _buildTextField(
                            controller: _stockController,
                            focusNode: _stockFocus,
                            label: 'Initial Stock',
                            hint: 'Enter stock quantity',
                            icon: Icons.warehouse,
                            keyboardType: TextInputType.number,
                            required: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Initial stock is required';
                              }
                              return null;
                            },
                            suffix: _selectedUnit,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _minStockController,
                                  label: 'Min Stock',
                                  hint: 'Minimum stock level',
                                  icon: Icons.trending_down,
                                  keyboardType: TextInputType.number,
                                  suffix: _selectedUnit,
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
                                  suffix: _selectedUnit,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildTextField(
                            controller: _locationController,
                            label: 'Storage Location',
                            hint: 'e.g., Warehouse A, Shelf 1',
                            icon: Icons.location_on_outlined,
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
                  ),

                // Supplier Information Section (Shows after stock)
                if (_showSupplierSection)
                  Container(
                    key: _supplierSectionKey,
                    child: _buildInfoCard(
                      title: 'Supplier Information',
                      icon: Icons.business_outlined,
                      isRequired: false,
                      isCompleted: _supplierController.text.isNotEmpty,
                      isVisible: _showSupplierSection,
                      content: Column(
                        children: [
                          _buildTextField(
                            controller: _supplierController,
                            label: 'Supplier Name',
                            hint: 'Enter supplier name (optional)',
                            icon: Icons.people_outline,
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _navigateBack, // Use safe navigation
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
                        onPressed: _saveItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryDarkBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Create Item',
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
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required bool isRequired,
    required bool isCompleted,
    required bool isVisible,
    required Widget content,
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
                  child: Icon(
                    icon,
                    size: 18,
                    color: isCompleted
                        ? const Color(0xFF10B981)
                        : AppTheme.primaryDarkBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                      if (isRequired)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '(Required)',
                            style: GoogleFonts.lato(
                              fontSize: 10,
                              color: isCompleted
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      if (isCompleted)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.check_circle,
                            size: 14,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
    FocusNode? focusNode,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
    String? suffix,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: GoogleFonts.lato(fontSize: 14, color: Colors.black87),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppTheme.subtitleGray),
        prefixText: prefix,
        suffixText: suffix,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        labelStyle: GoogleFonts.lato(
          fontSize: 13,
          color: AppTheme.subtitleGray,
        ),
        hintStyle: GoogleFonts.lato(
          fontSize: 12,
          color: Colors.grey.shade400,
        ),
        errorStyle: GoogleFonts.lato(
          fontSize: 11,
          color: const Color(0xFFEF4444),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        isDense: true,
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
          labelStyle: GoogleFonts.lato(
            fontSize: 13,
            color: AppTheme.subtitleGray,
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.lato(fontSize: 14, color: Colors.black87),
            ),
          );
        }).toList(),
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
