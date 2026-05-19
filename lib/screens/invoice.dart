import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'create_invoice_screen.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  DateTimeRange? _selectedDateRange;
  final ScrollController _scrollController = ScrollController();
  bool _isSearchSticky = false;
  
  final List<String> _filterOptions = ['All', 'Draft', 'Sent', 'Paid', 'Overdue'];
  
  // Sample invoice data
  List<Map<String, dynamic>> _allInvoices = [
    {
      'id': 'INV-001',
      'customer': 'ABC Corporation',
      'customerEmail': 'abc@corporation.com',
      'customerPhone': '+91 98765 43210',
      'customerAddress': '123 Business Park, Mumbai',
      'customerGst': 'GST: 29AAACB1234E1Z5',
      'amount': 12500.00,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'dueDate': DateTime.now().add(const Duration(days: 5)),
      'status': 'Paid',
      'items': [
        {'name': 'Web Design Service', 'qty': 2, 'price': 2500, 'tax': 12},
        {'name': 'SEO Package', 'qty': 1, 'price': 7500, 'tax': 18},
      ],
      'notes': 'Thanks for your business!',
      'itemsCount': 2,
    },
    {
      'id': 'INV-002',
      'customer': 'XYZ Enterprises',
      'customerEmail': 'contact@xyz.com',
      'customerPhone': '+91 99887 66554',
      'customerAddress': '45 Tech Hub, Bangalore',
      'customerGst': 'GST: 27BBBCD5678E2Z8',
      'amount': 8700.00,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'status': 'Sent',
      'items': [
        {'name': 'Cloud Hosting', 'qty': 1, 'price': 4800, 'tax': 5},
        {'name': 'Domain Registration', 'qty': 2, 'price': 1950, 'tax': 0},
      ],
      'notes': 'Payment expected within 7 days',
      'itemsCount': 2,
    },
    {
      'id': 'INV-003',
      'customer': 'Tech Solutions Ltd',
      'customerEmail': 'info@techsolutions.com',
      'customerPhone': '+91 87654 32109',
      'customerAddress': '12 IT Park, Chennai',
      'customerGst': 'GST: 24CCCDE9012E3Z1',
      'amount': 23400.00,
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'dueDate': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'Overdue',
      'items': [
        {'name': 'Mobile App Development', 'qty': 1, 'price': 15000, 'tax': 18},
        {'name': 'UI/UX Design', 'qty': 1, 'price': 8400, 'tax': 12},
      ],
      'notes': 'Please process payment immediately',
      'itemsCount': 2,
    },
    {
      'id': 'INV-004',
      'customer': 'Global Services Inc',
      'customerEmail': 'accounts@globalservices.com',
      'customerPhone': '+91 76543 21098',
      'customerAddress': '78 Corporate Tower, Delhi',
      'customerGst': 'GST: 27DDDEF1234E4Z2',
      'amount': 5600.00,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'dueDate': DateTime.now().add(const Duration(days: 10)),
      'status': 'Draft',
      'items': [
        {'name': 'Consulting Service', 'qty': 2, 'price': 2800, 'tax': 18},
      ],
      'notes': 'Draft invoice - pending approval',
      'itemsCount': 1,
    },
    {
      'id': 'INV-005',
      'customer': 'Digital Marketing Pro',
      'customerEmail': 'hello@digitalpro.com',
      'customerPhone': '+91 65432 10987',
      'customerAddress': '34 Marketing Plaza, Pune',
      'customerGst': 'GST: 29EEEFG5678E5Z3',
      'amount': 18900.00,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'dueDate': DateTime.now().add(const Duration(days: 4)),
      'status': 'Sent',
      'items': [
        {'name': 'Social Media Management', 'qty': 3, 'price': 3500, 'tax': 12},
        {'name': 'Content Creation', 'qty': 2, 'price': 4200, 'tax': 18},
      ],
      'notes': 'Monthly retainer invoice',
      'itemsCount': 2,
    },
  ];
  
  List<Map<String, dynamic>> _filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    _filteredInvoices = List.from(_allInvoices);
    _searchController.addListener(_filterInvoices);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterInvoices);
    _scrollController.removeListener(_scrollListener);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // KPI cards height is approximately 200
    const kpiHeight = 200.0;
    
    setState(() {
      _isSearchSticky = _scrollController.offset >= kpiHeight;
    });
  }

  void _filterInvoices() {
    setState(() {
      _filteredInvoices = _allInvoices.where((invoice) {
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            invoice['id'].toLowerCase().contains(searchQuery) ||
            invoice['customer'].toLowerCase().contains(searchQuery);
        
        final matchesStatus = _selectedStatus == 'All' || invoice['status'] == _selectedStatus;
        
        bool matchesDateRange = true;
        if (_selectedDateRange != null) {
          matchesDateRange = (invoice['date'] as DateTime).isAfter(_selectedDateRange!.start) &&
              (invoice['date'] as DateTime).isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
        }
        
        return matchesSearch && matchesStatus && matchesDateRange;
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
                        'Filter Invoices',
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
                          child: Icon(
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
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedStatus = status;
                          });
                          _filterInvoices();
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: AppTheme.primaryDarkBlue,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryDarkBlue : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'Date Range',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: _selectedDateRange,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppTheme.primaryDarkBlue,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (range != null) {
                        setState(() {
                          _selectedDateRange = range;
                        });
                        _filterInvoices();
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: AppTheme.primaryDarkBlue,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedDateRange != null
                                  ? '${DateFormat('dd MMM yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM yyyy').format(_selectedDateRange!.end)}'
                                  : 'Select date range',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                color: _selectedDateRange != null ? Colors.black87 : AppTheme.subtitleGray,
                              ),
                            ),
                          ),
                          if (_selectedDateRange != null)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDateRange = null;
                                });
                                _filterInvoices();
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: AppTheme.subtitleGray,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatus = 'All';
                              _selectedDateRange = null;
                              _searchController.clear();
                            });
                            _filterInvoices();
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

  void _showInvoiceDetail(Map<String, dynamic> invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          final items = invoice['items'] as List;
          final subtotal = items.fold(0.0, (sum, item) => sum + (item['price'] * item['qty']));
          final tax = items.fold(0.0, (sum, item) => sum + (item['price'] * item['qty'] * item['tax'] / 100));
          final total = subtotal + tax;
          
          return Container(
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
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'INVOICE DETAILS',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryDarkBlue,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: AppTheme.subtitleGray),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'INVOICE',
                                  style: GoogleFonts.lato(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryDarkBlue,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 50,
                                  height: 2,
                                  color: AppTheme.primaryDarkBlue,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  invoice['id'],
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Invoice #',
                                  style: GoogleFonts.lato(
                                    fontSize: 11,
                                    color: AppTheme.subtitleGray,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(invoice['status']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    invoice['status'],
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _getStatusColor(invoice['status']),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Customer and Invoice Details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BILL TO',
                                    style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.subtitleGray,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    invoice['customer'],
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (invoice['customerAddress'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      invoice['customerAddress'],
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: AppTheme.subtitleGray,
                                      ),
                                    ),
                                  ],
                                  if (invoice['customerGst'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      invoice['customerGst'],
                                      style: GoogleFonts.lato(
                                        fontSize: 11,
                                        color: AppTheme.primaryDarkBlue,
                                      ),
                                    ),
                                  ],
                                  if (invoice['customerEmail'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      invoice['customerEmail'],
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: AppTheme.subtitleGray,
                                      ),
                                    ),
                                  ],
                                  if (invoice['customerPhone'] != null) ...[
                                    Text(
                                      invoice['customerPhone'],
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: AppTheme.subtitleGray,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'INVOICE DETAILS',
                                    style: GoogleFonts.lato(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.subtitleGray,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildDetailRow('DATE', DateFormat('dd MMM yyyy').format(invoice['date'])),
                                  const SizedBox(height: 6),
                                  _buildDetailRow('DUE DATE', DateFormat('dd MMM yyyy').format(invoice['dueDate'])),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Items Table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightBlueBg,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'DESCRIPTION',
                                        style: GoogleFonts.lato(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryDarkBlue,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'QTY',
                                        style: GoogleFonts.lato(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryDarkBlue,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'PRICE',
                                        style: GoogleFonts.lato(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryDarkBlue,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'AMOUNT',
                                        style: GoogleFonts.lato(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryDarkBlue,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...items.map((item) {
                                final amount = item['price'] * item['qty'];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'],
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (item['tax'] > 0)
                                              Text(
                                                'Tax: ${item['tax']}%',
                                                style: GoogleFonts.lato(
                                                  fontSize: 10,
                                                  color: const Color(0xFF94A3B8),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${item['qty']}',
                                          style: GoogleFonts.lato(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '₹${NumberFormat('#,##0').format(item['price'])}',
                                          style: GoogleFonts.lato(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '₹${NumberFormat('#,##0').format(amount)}',
                                          style: GoogleFonts.lato(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Totals Section
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 280,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _buildSummaryRow('Subtotal', subtotal),
                                const SizedBox(height: 8),
                                _buildSummaryRow('Tax', tax),
                                const Divider(height: 24),
                                _buildSummaryRow('Total', total, isTotal: true),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Notes Section
                        if (invoice['notes'] != null && invoice['notes'].toString().isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TERMS & NOTES',
                                  style: GoogleFonts.lato(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.subtitleGray,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  invoice['notes'],
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: AppTheme.subtitleGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 24),
                        
                        Center(
                          child: Text(
                            'Thank you for your business!',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: const Color(0xFF94A3B8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
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
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: isTotal ? 14 : 12,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? Colors.black87 : AppTheme.subtitleGray,
          ),
        ),
        Text(
          '₹${NumberFormat('#,##0').format(amount)}',
          style: GoogleFonts.lato(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppTheme.primaryDarkBlue : Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(0xFF10B981);
      case 'Sent':
        return const Color(0xFF3B82F6);
      case 'Draft':
        return const Color(0xFFF59E0B);
      case 'Overdue':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.subtitleGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalInvoices = _filteredInvoices.length;
    final totalAmount = _filteredInvoices.fold(0.0, (sum, inv) => sum + (inv['amount'] as double));
    final overdueCount = _filteredInvoices.where((inv) => inv['status'] == 'Overdue').length;
    final overdueAmount = _filteredInvoices.where((inv) => inv['status'] == 'Overdue').fold(0.0, (sum, inv) => sum + (inv['amount'] as double));
    final paidCount = _filteredInvoices.where((inv) => inv['status'] == 'Paid').length;
    final paidAmount = _filteredInvoices.where((inv) => inv['status'] == 'Paid').fold(0.0, (sum, inv) => sum + (inv['amount'] as double));
    final draftCount = _filteredInvoices.where((inv) => inv['status'] == 'Draft').length;
    final draftAmount = _filteredInvoices.where((inv) => inv['status'] == 'Draft').fold(0.0, (sum, inv) => sum + (inv['amount'] as double));
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryDarkBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Invoices',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDarkBlue,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main Scrollable Content
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
                        // KPI Cards Section
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.4,
                            children: [
                              _buildKPICard(
                                title: 'No. of. Invoice',
                                count: '#${totalInvoices.toString()}',
                                amount: '₹${NumberFormat('#,##0').format(totalAmount)}',
                                icon: Icons.receipt_long,
                                color: AppTheme.primaryDarkBlue,
                              ),
                              _buildKPICard(
                                title: 'Over Due',
                                count: '#${overdueCount.toString()}',
                                amount: '₹${NumberFormat('#,##0').format(overdueAmount)}',
                                icon: Icons.warning_amber,
                                color: const Color(0xFFEF4444),
                              ),
                              _buildKPICard(
                                title: 'No. of. Paid',
                                count: '#${paidCount.toString()}',
                                amount: '₹${NumberFormat('#,##0').format(paidAmount)}',
                                icon: Icons.check_circle,
                                color: const Color(0xFF10B981),
                              ),
                              _buildKPICard(
                                title: 'No. of. Draft',
                                count: '#${draftCount.toString()}',
                                amount: '₹${NumberFormat('#,##0').format(draftAmount)}',
                                icon: Icons.edit_note,
                                color: const Color(0xFFF59E0B),
                              ),
                            ],
                          ),
                        ),
                        
                        // Original Search and Filter Section (will be hidden when sticky)
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
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        child: TextField(
                                          controller: _searchController,
                                          style: GoogleFonts.lato(fontSize: 14),
                                          decoration: InputDecoration(
                                            hintText: 'Search by Invoice # or',
                                            hintStyle: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: Colors.grey.shade400,
                                            ),
                                            prefixIcon: Icon(
                                              Icons.search,
                                              size: 18,
                                              color: AppTheme.subtitleGray,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: _showFilterDialog,
                                      child: Container(
                                        height: 48,
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: _selectedStatus != 'All' || _selectedDateRange != null
                                              ? AppTheme.primaryDarkBlue
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: _selectedStatus != 'All' || _selectedDateRange != null
                                                ? AppTheme.primaryDarkBlue
                                                : Colors.grey.shade200,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.filter_list,
                                              size: 18,
                                              color: _selectedStatus != 'All' || _selectedDateRange != null
                                                  ? Colors.white
                                                  : AppTheme.subtitleGray,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Filter',
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: _selectedStatus != 'All' || _selectedDateRange != null
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
                              
                              const SizedBox(height: 12),
                              
                              // Active Filters Display
                              if (_selectedStatus != 'All' || _selectedDateRange != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        if (_selectedStatus != 'All')
                                          Chip(
                                            label: Text(
                                              'Status: $_selectedStatus',
                                              style: GoogleFonts.lato(fontSize: 12),
                                            ),
                                            onDeleted: () {
                                              setState(() {
                                                _selectedStatus = 'All';
                                              });
                                              _filterInvoices();
                                            },
                                            backgroundColor: AppTheme.lightBlueBg,
                                            deleteIcon: const Icon(Icons.close, size: 14),
                                          ),
                                        if (_selectedDateRange != null) ...[
                                          if (_selectedStatus != 'All') const SizedBox(width: 8),
                                          Chip(
                                            label: Text(
                                              '${DateFormat('dd MMM').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM').format(_selectedDateRange!.end)}',
                                              style: GoogleFonts.lato(fontSize: 12),
                                            ),
                                            onDeleted: () {
                                              setState(() {
                                                _selectedDateRange = null;
                                              });
                                              _filterInvoices();
                                            },
                                            backgroundColor: AppTheme.lightBlueBg,
                                            deleteIcon: const Icon(Icons.close, size: 14),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        
                        // Invoice List
                        if (_filteredInvoices.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 80,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No invoices found',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.subtitleGray,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try adjusting your filters',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
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
                            itemCount: _filteredInvoices.length,
                            itemBuilder: (context, index) {
                              final invoice = _filteredInvoices[index];
                              final statusColor = _getStatusColor(invoice['status']);
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _showInvoiceDetail(invoice),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  invoice['id'],
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.primaryDarkBlue,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  invoice['status'],
                                                  style: GoogleFonts.lato(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: statusColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            invoice['customer'],
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: AppTheme.subtitleGray,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Issued: ${DateFormat('dd MMM yyyy').format(invoice['date'])}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: AppTheme.subtitleGray,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Icon(
                                                Icons.event,
                                                size: 14,
                                                color: AppTheme.subtitleGray,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Due: ${DateFormat('dd MMM yyyy').format(invoice['dueDate'])}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: (invoice['dueDate'] as DateTime).isBefore(DateTime.now()) && invoice['status'] != 'Paid'
                                                      ? Colors.red
                                                      : AppTheme.subtitleGray,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          const Divider(color: Color(0xFFE2E8F0), height: 1),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.shopping_bag_outlined,
                                                    size: 14,
                                                    color: AppTheme.subtitleGray,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    '${invoice['itemsCount'] ?? (invoice['items'] as List).length} items',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      color: AppTheme.subtitleGray,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '₹${NumberFormat('#,##0').format(invoice['amount'])}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.primaryDarkBlue,
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
              
              // Create Invoice Button at Bottom
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
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateInvoiceScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(
                        'Create Invoice',
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDarkBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Sticky Search Bar at Top (appears when scrolled)
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
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
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
                          style: GoogleFonts.lato(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search by Invoice # or',
                            hintStyle: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 18,
                              color: AppTheme.subtitleGray,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _showFilterDialog,
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: _selectedStatus != 'All' || _selectedDateRange != null
                              ? AppTheme.primaryDarkBlue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _selectedStatus != 'All' || _selectedDateRange != null
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
                              size: 18,
                              color: _selectedStatus != 'All' || _selectedDateRange != null
                                  ? Colors.white
                                  : AppTheme.subtitleGray,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Filter',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _selectedStatus != 'All' || _selectedDateRange != null
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

  Widget _buildKPICard({
    required String title,
    required String count,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.subtitleGray,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}