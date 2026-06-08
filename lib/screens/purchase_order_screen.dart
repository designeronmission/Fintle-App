// purchase_order_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class PurchaseOrderScreen extends StatefulWidget {
  const PurchaseOrderScreen({super.key});

  @override
  State<PurchaseOrderScreen> createState() => _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState extends State<PurchaseOrderScreen> {
  // ==================== LIST VIEW STATE ====================
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isSearchSticky = false;
  bool _showCreateForm = false;

  final List<String> _filterOptions = [
    'All',
    'Draft',
    'Pending',
    'Approved',
    'Ordered',
    'Received',
    'Cancelled'
  ];

  List<Map<String, dynamic>> _purchaseOrders = [];
  List<Map<String, dynamic>> _filteredOrders = [];

  // ==================== CREATE FORM STATE ====================
  final TextEditingController _poNumberController = TextEditingController();
  final TextEditingController _poDateController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _productSearchController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _subtotalController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  String _selectedSupplier = '';
  String _selectedPOStatus = 'Draft';
  String _selectedPaymentTerms = 'Net 30';

  List<Map<String, dynamic>> _selectedItems = [];
  List<Map<String, dynamic>> _suppliers = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];

  bool _showProductSearch = false;

  final List<String> _statusOptions = [
    'Draft',
    'Pending',
    'Approved',
    'Ordered',
    'Received',
    'Cancelled'
  ];

  final List<String> _paymentTermsOptions = [
    'Net 15',
    'Net 30',
    'Net 45',
    'Net 60',
    'Cash on Delivery',
    'Advance Payment'
  ];

  @override
  void initState() {
    super.initState();
    _loadPurchaseOrders();
    _searchController.addListener(_filterOrders);
    _scrollController.addListener(_scrollListener);
    _loadSuppliers();
    _loadProducts();
    _productSearchController.addListener(_filterProducts);
    _generatePONumber();
    _poDateController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
    _deliveryDateController.text = DateFormat('dd MMM yyyy')
        .format(DateTime.now().add(const Duration(days: 15)));
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterOrders);
    _scrollController.removeListener(_scrollListener);
    _searchController.dispose();
    _scrollController.dispose();
    _productSearchController.removeListener(_filterProducts);
    _productSearchController.dispose();
    _poNumberController.dispose();
    _poDateController.dispose();
    _deliveryDateController.dispose();
    _notesController.dispose();
    _subtotalController.dispose();
    _taxController.dispose();
    _discountController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    const kpiHeight = 160.0;
    setState(() {
      _isSearchSticky = _scrollController.offset >= kpiHeight;
    });
  }

  //==================== LIST VIEW METHODS ====================//
  void _loadPurchaseOrders() {
    _purchaseOrders = [
      {
        'poNumber': 'PO-2404-001',
        'poDate': DateTime(2024, 4, 5),
        'supplier': 'Reliance Industries Ltd',
        'supplierCode': 'SUP-001',
        'totalAmount': 125000.00,
        'status': 'Approved',
        'itemsCount': 3,
        'deliveryDate': DateTime(2024, 4, 20),
      },
      {
        'poNumber': 'PO-2404-002',
        'poDate': DateTime(2024, 4, 10),
        'supplier': 'Tata Motors Ltd',
        'supplierCode': 'SUP-002',
        'totalAmount': 87500.00,
        'status': 'Pending',
        'itemsCount': 2,
        'deliveryDate': DateTime(2024, 4, 25),
      },
      {
        'poNumber': 'PO-2404-003',
        'poDate': DateTime(2024, 4, 15),
        'supplier': 'Infosys Technologies',
        'supplierCode': 'SUP-003',
        'totalAmount': 234000.00,
        'status': 'Ordered',
        'itemsCount': 5,
        'deliveryDate': DateTime(2024, 5, 5),
      },
      {
        'poNumber': 'PO-2404-004',
        'poDate': DateTime(2024, 4, 18),
        'supplier': 'Wipro Enterprises',
        'supplierCode': 'SUP-005',
        'totalAmount': 189000.00,
        'status': 'Draft',
        'itemsCount': 4,
        'deliveryDate': DateTime(2024, 5, 10),
      },
      {
        'poNumber': 'PO-2404-005',
        'poDate': DateTime(2024, 4, 22),
        'supplier': 'HDFC Bank Ltd',
        'supplierCode': 'SUP-004',
        'totalAmount': 56000.00,
        'status': 'Received',
        'itemsCount': 2,
        'deliveryDate': DateTime(2024, 5, 2),
      },
    ];
    _filteredOrders = List.from(_purchaseOrders);
  }

  void _filterOrders() {
    setState(() {
      _filteredOrders = _purchaseOrders.where((order) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            order['poNumber'].toLowerCase().contains(searchQuery) ||
            order['supplier'].toLowerCase().contains(searchQuery);

        final matchesStatus =
            _selectedStatus == 'All' || order['status'] == _selectedStatus;

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
                        'Filter Purchase Orders',
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
                          _filterOrders();
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
                            _filterOrders();
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Draft':
        return Colors.grey;
      case 'Pending':
        return Colors.orange;
      case 'Approved':
        return Colors.blue;
      case 'Ordered':
        return Colors.purple;
      case 'Received':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return AppTheme.subtitleGray;
    }
  }

  // ==================== CREATE FORM METHODS ====================
  void _toggleCreateForm() {
    setState(() {
      _showCreateForm = !_showCreateForm;
      if (!_showCreateForm) {
        _resetForm();
      }
    });
  }

  void _resetForm() {
    _generatePONumber();
    _selectedSupplier = '';
    _selectedPOStatus = 'Draft';
    _selectedPaymentTerms = 'Net 30';
    _selectedItems.clear();
    _notesController.clear();
    _discountController.clear();
    _productSearchController.clear();
    _showProductSearch = false;
    _poDateController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
    _deliveryDateController.text = DateFormat('dd MMM yyyy')
        .format(DateTime.now().add(const Duration(days: 15)));
    _subtotalController.clear();
    _taxController.clear();
    _totalController.clear();
  }

  void _generatePONumber() {
    String year = DateFormat('yy').format(DateTime.now());
    String month = DateFormat('MM').format(DateTime.now());
    String random =
        DateTime.now().millisecondsSinceEpoch.toString().substring(10, 13);
    _poNumberController.text = 'PO-$year$month-$random';
  }

  void _loadSuppliers() {
    _suppliers = [
      {
        'id': 'SUP-001',
        'name': 'Reliance Industries Ltd',
        'gst': '27AAACR1234E1Z5'
      },
      {'id': 'SUP-002', 'name': 'Tata Motors Ltd', 'gst': '27AAACT5678E2Z8'},
      {
        'id': 'SUP-003',
        'name': 'Infosys Technologies',
        'gst': '29AAACI9012E3Z1'
      },
      {'id': 'SUP-004', 'name': 'HDFC Bank Ltd', 'gst': '27AAACH1234E4Z2'},
      {'id': 'SUP-005', 'name': 'Wipro Enterprises', 'gst': '29AAACW5678E5Z3'},
    ];
  }

  void _loadProducts() {
    _products = [
      {
        'id': 'PROD-001',
        'name': 'Raw Materials - Steel',
        'unit': 'Ton',
        'price': 45000.0,
        'gst': 18
      },
      {
        'id': 'PROD-002',
        'name': 'Office Supplies - Paper',
        'unit': 'Box',
        'price': 2500.0,
        'gst': 12
      },
      {
        'id': 'PROD-003',
        'name': 'Equipment - Laptop',
        'unit': 'Piece',
        'price': 65000.0,
        'gst': 18
      },
      {
        'id': 'PROD-004',
        'name': 'Inventory - Packaging',
        'unit': 'Roll',
        'price': 3500.0,
        'gst': 12
      },
      {
        'id': 'PROD-005',
        'name': 'Raw Materials - Plastic',
        'unit': 'KG',
        'price': 1200.0,
        'gst': 18
      },
    ];
    _filteredProducts = _products;
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product['name']
                  .toLowerCase()
                  .contains(_productSearchController.text.toLowerCase()) ||
              product['id']
                  .toLowerCase()
                  .contains(_productSearchController.text.toLowerCase()))
          .toList();
    });
  }

  void _selectDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppTheme.primaryDarkBlue),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      setState(() {
        controller.text = DateFormat('dd MMM yyyy').format(date);
      });
    }
  }

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      _selectedItems.add({
        'id': product['id'],
        'name': product['name'],
        'unit': product['unit'],
        'quantity': 1,
        'price': product['price'],
        'gst': product['gst'],
        'amount': product['price'],
        'gstAmount': (product['price'] * product['gst'] / 100),
        'total': product['price'] + (product['price'] * product['gst'] / 100),
      });
      _showProductSearch = false;
      _productSearchController.clear();
      _calculateTotals();
    });
  }

  void _updateQuantity(int index, int quantity) {
    if (quantity < 1) return;
    setState(() {
      _selectedItems[index]['quantity'] = quantity;
      double amount = _selectedItems[index]['price'] * quantity;
      double gstAmount = amount * _selectedItems[index]['gst'] / 100;
      _selectedItems[index]['amount'] = amount;
      _selectedItems[index]['gstAmount'] = gstAmount;
      _selectedItems[index]['total'] = amount + gstAmount;
      _calculateTotals();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _selectedItems.removeAt(index);
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    double subtotal = _selectedItems.fold(
        0.0, (sum, item) => sum + (item['amount'] as double));
    double totalGst = _selectedItems.fold(
        0.0, (sum, item) => sum + (item['gstAmount'] as double));
    double discount = double.tryParse(_discountController.text) ?? 0;
    double total = subtotal + totalGst - discount;

    _subtotalController.text =
        NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(subtotal);
    _taxController.text =
        NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(totalGst);
    _totalController.text =
        NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(total);
  }

  void _savePurchaseOrder() {
    if (_selectedSupplier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a supplier'),
            backgroundColor: Colors.red),
      );
      return;
    }
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add at least one item'),
            backgroundColor: Colors.red),
      );
      return;
    }

    // Add new PO to list
    Map<String, dynamic> newPO = {
      'poNumber': _poNumberController.text,
      'poDate': DateTime.now(),
      'supplier': _selectedSupplier,
      'supplierCode':
          _suppliers.firstWhere((s) => s['name'] == _selectedSupplier)['id'],
      'totalAmount': double.tryParse(_totalController.text
              .replaceAll('₹', '')
              .replaceAll(',', '')
              .trim()) ??
          0,
      'status': _selectedPOStatus,
      'itemsCount': _selectedItems.length,
      'deliveryDate':
          DateFormat('dd MMM yyyy').parse(_deliveryDateController.text),
    };

    setState(() {
      _purchaseOrders.insert(0, newPO);
      _filterOrders();
      _showCreateForm = false;
      _resetForm();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Purchase Order ${_poNumberController.text} created successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==================== BUILD METHODS ====================
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
          _showCreateForm ? 'Create Purchase Order' : 'Purchase Orders',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue),
        ),
        actions: [
          if (!_showCreateForm)
            IconButton(
              onPressed: _toggleCreateForm,
              icon: const Icon(Icons.add,
                  color: AppTheme.primaryDarkBlue, size: 24),
              tooltip: 'Create Purchase Order',
            ),
          if (_showCreateForm)
            TextButton(
              onPressed: _savePurchaseOrder,
              child: Text(
                'Save',
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDarkBlue),
              ),
            ),
        ],
      ),
      body: _showCreateForm ? _buildCreateForm() : _buildListView(),
    );
  }

  // ==================== LIST VIEW ====================
  Widget _buildListView() {
    final totalPOs = _filteredOrders.length;
    final totalAmount = _filteredOrders.fold(
        0.0, (sum, order) => sum + (order['totalAmount'] as double));
    final pendingPOs = _filteredOrders
        .where((order) =>
            order['status'] == 'Pending' || order['status'] == 'Draft')
        .length;

    return Stack(
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
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildKPICard(
                                title: 'Total POs',
                                value: totalPOs.toString(),
                                icon: Icons.receipt_long,
                                color: AppTheme.primaryDarkBlue,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildKPICard(
                                title: 'Total Amount',
                                value:
                                    '₹${NumberFormat('#,##0').format(totalAmount)}',
                                icon: Icons.currency_rupee,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildKPICard(
                                title: 'Pending',
                                value: pendingPOs.toString(),
                                icon: Icons.pending_actions,
                                color: Colors.orange.shade700,
                              ),
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
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                      ),
                                      child: TextField(
                                        controller: _searchController,
                                        style: GoogleFonts.lato(fontSize: 13),
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search by PO number or supplier',
                                          hintStyle: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.grey.shade400),
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
                            if (_selectedStatus != 'All')
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
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
                                          _filterOrders();
                                        },
                                        backgroundColor: AppTheme.lightBlueBg,
                                        deleteIcon:
                                            const Icon(Icons.close, size: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Purchase Order List
                      if (_filteredOrders.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.receipt_long_outlined,
                                    size: 60, color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                Text('No purchase orders found',
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
                          itemCount: _filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = _filteredOrders[index];
                            final statusColor =
                                _getStatusColor(order['status']);
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
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
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
                                                    order['poNumber'],
                                                    style: GoogleFonts.lato(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppTheme
                                                            .primaryDarkBlue),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    order['supplier'],
                                                    style: GoogleFonts.lato(
                                                        fontSize: 11,
                                                        color: AppTheme
                                                            .subtitleGray),
                                                  ),
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
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                order['status'],
                                                style: GoogleFonts.lato(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: statusColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today,
                                                size: 12,
                                                color: AppTheme.subtitleGray),
                                            const SizedBox(width: 4),
                                            Text(
                                                'PO Date: ${DateFormat('dd MMM yyyy').format(order['poDate'])}',
                                                style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    color:
                                                        AppTheme.subtitleGray)),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.local_shipping,
                                                size: 12,
                                                color: AppTheme.subtitleGray),
                                            const SizedBox(width: 4),
                                            Text(
                                                'Delivery: ${DateFormat('dd MMM yyyy').format(order['deliveryDate'])}',
                                                style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    color:
                                                        AppTheme.subtitleGray)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(height: 1),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${order['itemsCount']} items',
                                                style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    color:
                                                        AppTheme.subtitleGray)),
                                            Text(
                                              '₹${NumberFormat('#,##0').format(order['totalAmount'])}',
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
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

            // Create PO Button
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2)),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _toggleCreateForm,
                    icon: const Icon(Icons.add, size: 20),
                    label: Text('Create Purchase Order',
                        style: GoogleFonts.lato(
                            fontSize: 14, fontWeight: FontWeight.w600)),
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
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.lato(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search by PO number or supplier',
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
                              offset: const Offset(0, 2))
                        ],
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
                                  color: _selectedStatus != 'All'
                                      ? Colors.white
                                      : Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ==================== CREATE FORM ====================
  Widget _buildCreateForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Basic Information Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.info_outline,
                            size: 18, color: AppTheme.primaryDarkBlue),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Basic Information',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildReadOnlyField(
                          'PO Number', _poNumberController.text),
                      const SizedBox(height: 14),
                      _buildDateField(
                          controller: _poDateController,
                          label: 'PO Date',
                          onTap: () => _selectDate(_poDateController)),
                      const SizedBox(height: 14),
                      _buildDateField(
                          controller: _deliveryDateController,
                          label: 'Delivery Date',
                          onTap: () => _selectDate(_deliveryDateController)),
                      const SizedBox(height: 14),
                      _buildSupplierDropdown(),
                      const SizedBox(height: 14),
                      _buildDropdownField(
                        value: _selectedPOStatus,
                        label: 'Status',
                        icon: Icons.flag,
                        items: _statusOptions,
                        onChanged: (value) =>
                            setState(() => _selectedPOStatus = value!),
                      ),
                      const SizedBox(height: 14),
                      _buildDropdownField(
                        value: _selectedPaymentTerms,
                        label: 'Payment Terms',
                        icon: Icons.payment,
                        items: _paymentTermsOptions,
                        onChanged: (value) =>
                            setState(() => _selectedPaymentTerms = value!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Items Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shopping_cart,
                            size: 18, color: AppTheme.primaryDarkBlue),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Order Items',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Add Product Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () => setState(
                        () => _showProductSearch = !_showProductSearch),
                    icon: const Icon(Icons.add, size: 18),
                    label:
                        Text('Add Item', style: GoogleFonts.lato(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDarkBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),

                // Product Search
                if (_showProductSearch)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _productSearchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      AppTheme.primaryDarkBlue.withOpacity(0.1),
                                  child: Icon(Icons.inventory_2,
                                      size: 18,
                                      color: AppTheme.primaryDarkBlue),
                                ),
                                title: Text(product['name'],
                                    style: GoogleFonts.lato(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                  '₹${NumberFormat('#,##0').format(product['price'])} / ${product['unit']}',
                                  style: GoogleFonts.lato(fontSize: 11),
                                ),
                                trailing: Text('GST: ${product['gst']}%',
                                    style: GoogleFonts.lato(fontSize: 11)),
                                onTap: () => _addProduct(product),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                // Items List
                if (_selectedItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ..._selectedItems.asMap().entries.map((entry) {
                          int index = entry.key;
                          var item = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['name'],
                                        style: GoogleFonts.lato(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          size: 18),
                                      onPressed: () => _removeItem(index),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      color: Colors.red,
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
                                          Text('Quantity',
                                              style: GoogleFonts.lato(
                                                  fontSize: 10,
                                                  color:
                                                      AppTheme.subtitleGray)),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove,
                                                    size: 16),
                                                onPressed: () =>
                                                    _updateQuantity(
                                                        index,
                                                        (item['quantity']
                                                                as int) -
                                                            1),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                              Text(item['quantity'].toString(),
                                                  style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              IconButton(
                                                icon: const Icon(Icons.add,
                                                    size: 16),
                                                onPressed: () =>
                                                    _updateQuantity(
                                                        index,
                                                        (item['quantity']
                                                                as int) +
                                                            1),
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text('Amount',
                                              style: GoogleFonts.lato(
                                                  fontSize: 10,
                                                  color:
                                                      AppTheme.subtitleGray)),
                                          Text(
                                            NumberFormat.currency(
                                                    symbol: '₹',
                                                    decimalDigits: 2)
                                                .format(item['amount']),
                                            style: GoogleFonts.lato(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Summary Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.calculate,
                            size: 18, color: AppTheme.primaryDarkBlue),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Order Summary',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal', _subtotalController.text),
                      const SizedBox(height: 10),
                      _buildSummaryRow('Tax (GST)', _taxController.text),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _discountController,
                        label: 'Discount (₹)',
                        hint: 'Enter discount amount',
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculateTotals(),
                      ),
                      const Divider(height: 20),
                      _buildSummaryRow('Total', _totalController.text,
                          isBold: true),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Notes Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDarkBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.note,
                            size: 18, color: AppTheme.primaryDarkBlue),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Notes',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Add any additional notes or instructions...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppTheme.primaryDarkBlue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ==================== HELPER WIDGETS ====================
  Widget _buildKPICard(
      {required String title,
      required String value,
      required IconData icon,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.lato(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(title,
              style:
                  GoogleFonts.lato(fontSize: 10, color: AppTheme.subtitleGray)),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Text(value,
                  style: GoogleFonts.lato(
                      fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: AppTheme.subtitleGray),
                const SizedBox(width: 10),
                Text(controller.text,
                    style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupplierDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Supplier',
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSupplier.isEmpty ? null : _selectedSupplier,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Choose supplier',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ),
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              style: GoogleFonts.lato(fontSize: 13, color: Colors.black87),
              items: _suppliers.map((supplier) {
                return DropdownMenuItem<String>(
                  value: supplier['name'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(supplier['name'],
                          style: GoogleFonts.lato(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                      Text(supplier['id'],
                          style: GoogleFonts.lato(
                              fontSize: 10, color: AppTheme.subtitleGray)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedSupplier = value!),
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

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              style: GoogleFonts.lato(fontSize: 13, color: Colors.black87),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, size: 16, color: AppTheme.subtitleGray),
                      const SizedBox(width: 8),
                      Text(item, style: GoogleFonts.lato(fontSize: 13)),
                    ],
                  ),
                );
              }).toList(),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.subtitleGray)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.primaryDarkBlue),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        Text(value,
            style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? AppTheme.primaryDarkBlue : Colors.black87)),
      ],
    );
  }
}
