// create_purchase_order_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class CreatePurchaseOrderScreen extends StatefulWidget {
  const CreatePurchaseOrderScreen({super.key});

  @override
  State<CreatePurchaseOrderScreen> createState() =>
      _CreatePurchaseOrderScreenState();
}

class _CreatePurchaseOrderScreenState extends State<CreatePurchaseOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _poNumberController = TextEditingController();
  final TextEditingController _poDateController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _subtotalController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  String _selectedSupplier = '';
  String _selectedStatus = 'Draft';
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
    _generatePONumber();
    _poDateController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
    _deliveryDateController.text = DateFormat('dd MMM yyyy')
        .format(DateTime.now().add(const Duration(days: 15)));
    _loadSuppliers();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _poNumberController.dispose();
    _poDateController.dispose();
    _deliveryDateController.dispose();
    _searchController.dispose();
    _notesController.dispose();
    _subtotalController.dispose();
    _taxController.dispose();
    _discountController.dispose();
    _totalController.dispose();
    _searchController.removeListener(_filterProducts);
    super.dispose();
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
                  .contains(_searchController.text.toLowerCase()) ||
              product['id']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
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
      _searchController.clear();
      _calculateTotals();
    });
  }

  void _updateQuantity(int index, int quantity) {
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
    double subtotal =
        _selectedItems.fold(0, (sum, item) => sum + (item['amount'] as double));
    double totalGst = _selectedItems.fold(
        0, (sum, item) => sum + (item['gstAmount'] as double));
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Purchase Order ${_poNumberController.text} created successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Purchase Order',
          style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDarkBlue),
        ),
        actions: [
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
      body: SingleChildScrollView(
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
                          value: _selectedStatus,
                          label: 'Status',
                          icon: Icons.flag,
                          items: _statusOptions,
                          onChanged: (value) =>
                              setState(() => _selectedStatus = value!),
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
                      label: Text('Add Item',
                          style: GoogleFonts.lato(fontSize: 13)),
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
                            controller: _searchController,
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
                                    backgroundColor: AppTheme.primaryDarkBlue
                                        .withOpacity(0.1),
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
                                                Text(
                                                    item['quantity'].toString(),
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
