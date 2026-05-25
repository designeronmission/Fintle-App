import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CreateItemScreen extends StatefulWidget {
  const CreateItemScreen({super.key});

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _hsnController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dropdown values
  String _selectedCategory = 'Services';
  String _selectedUnit = 'Piece';
  String _selectedStatus = 'Active';

  final List<String> _categories = ['Services', 'Products', 'Hardware'];
  final List<String> _units = [
    'Piece',
    'Kg',
    'Liter',
    'Meter',
    'Hour',
    'Day',
    'Month',
    'Year',
    'Project'
  ];
  final List<String> _statusOptions = ['Active', 'Inactive'];

  // Accordion expansion states
  bool _basicInfoExpanded = true;
  bool _pricingExpanded = true;
  bool _stockExpanded = true;

  @override
  void dispose() {
    _itemNameController.dispose();
    _skuController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _stockController.dispose();
    _gstController.dispose();
    _hsnController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Item "${_itemNameController.text}" created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
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
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDarkBlue,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAccordionSection(
                title: 'Basic Information',
                icon: Icons.info_outline,
                expanded: _basicInfoExpanded,
                onTap: () {
                  setState(() {
                    _basicInfoExpanded = !_basicInfoExpanded;
                  });
                },
                content: Column(
                  children: [
                    _buildTextField(
                      controller: _itemNameController,
                      label: 'Item Name',
                      hint: 'Enter item name',
                      required: true,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _skuController,
                      label: 'SKU',
                      hint: 'Enter SKU code',
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: _inputDecoration('Category'),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: _inputDecoration('Unit'),
                      items: _units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUnit = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildAccordionSection(
                title: 'Pricing Information',
                icon: Icons.currency_rupee,
                expanded: _pricingExpanded,
                onTap: () {
                  setState(() {
                    _pricingExpanded = !_pricingExpanded;
                  });
                },
                content: Column(
                  children: [
                    _buildTextField(
                      controller: _purchasePriceController,
                      label: 'Purchase Price',
                      hint: 'Enter purchase price',
                      keyboardType: TextInputType.number,
                      prefix: '₹',
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _sellingPriceController,
                      label: 'Selling Price',
                      hint: 'Enter selling price',
                      keyboardType: TextInputType.number,
                      prefix: '₹',
                      required: true,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _gstController,
                            label: 'GST %',
                            hint: 'Enter GST percentage',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _hsnController,
                            label: 'HSN/SAC Code',
                            hint: 'Enter HSN/SAC code',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildAccordionSection(
                title: 'Stock Information',
                icon: Icons.inventory,
                expanded: _stockExpanded,
                onTap: () {
                  setState(() {
                    _stockExpanded = !_stockExpanded;
                  });
                },
                content: Column(
                  children: [
                    _buildTextField(
                      controller: _stockController,
                      label: 'Initial Stock',
                      hint: 'Enter stock quantity',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: _inputDecoration('Status'),
                      items: _statusOptions.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
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
              _buildAccordionSection(
                title: 'Description',
                icon: Icons.description_outlined,
                expanded: false,
                onTap: () {
                  setState(() {
                    // Toggle description expansion - handled by parent
                  });
                },
                content: Column(
                  children: [
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: GoogleFonts.lato(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Enter item description',
                        hintStyle: GoogleFonts.lato(
                            fontSize: 12, color: Colors.grey.shade400),
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
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
                          fontSize: 15,
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

  Widget _buildAccordionSection({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlueBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Icon(icon, size: 18, color: AppTheme.primaryDarkBlue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.subtitleGray,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
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
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.lato(fontSize: 14),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        labelStyle:
            GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
        hintText: hint,
        hintStyle: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400),
        prefixText: prefix != null ? '$prefix ' : null,
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
        isDense: true,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    );
  }
}
