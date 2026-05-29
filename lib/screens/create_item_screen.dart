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

  // Basic Information Controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _hsnCodeController = TextEditingController();
  String _productType = 'Product'; // Product or Service

  // Pricing Section Controllers
  final TextEditingController _salesPriceController = TextEditingController();
  String _salesTaxType = 'Tax Exclusive'; // Tax Inclusive or Tax Exclusive

  final TextEditingController _purchasePriceController =
      TextEditingController();
  String _purchaseTaxType = 'Tax Exclusive';

  final TextEditingController _discountController = TextEditingController();
  String _discountType = 'Percentage'; // Percentage or Flat Amount

  // Tax & Classification
  final TextEditingController _taxRateController = TextEditingController();
  final TextEditingController _hsnSacController = TextEditingController();

  // Tax Rate options
  final List<String> _taxRates = ['0%', '5%', '12%', '18%', '28%'];

  // Accordion expansion states
  bool _basicInfoExpanded = true;
  bool _pricingExpanded = true;
  bool _taxClassificationExpanded = true;

  @override
  void dispose() {
    _itemNameController.dispose();
    _skuController.dispose();
    _hsnCodeController.dispose();
    _salesPriceController.dispose();
    _purchasePriceController.dispose();
    _discountController.dispose();
    _taxRateController.dispose();
    _hsnSacController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Item "${_itemNameController.text}" created successfully!'),
          backgroundColor: const Color(0xFF10B981),
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
              color: AppTheme.primaryDarkBlue),
        ),
        actions: [
          TextButton(
            onPressed: _saveItem,
            child: Text('Save',
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDarkBlue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Basic Information
              _buildAccordionSection(
                title: 'Basic',
                icon: Icons.info_outline,
                expanded: _basicInfoExpanded,
                onTap: () =>
                    setState(() => _basicInfoExpanded = !_basicInfoExpanded),
                content: Column(
                  children: [
                    _buildTextField(
                      controller: _itemNameController,
                      label: 'Item Name',
                      hint: 'Enter item name',
                      required: true,
                      validator: (v) => v!.isEmpty ? 'Enter item name' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _skuController,
                      label: 'SKU',
                      hint: 'Enter SKU code',
                      required: true,
                      validator: (v) => v!.isEmpty ? 'Enter SKU code' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildRadioGroup(
                      label: 'Product Type',
                      value: _productType,
                      options: ['Product', 'Service'],
                      onChanged: (v) => setState(() => _productType = v),
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _hsnCodeController,
                      label: 'HSN Code',
                      hint: 'Enter HSN code',
                      required: true,
                      validator: (v) => v!.isEmpty ? 'Enter HSN code' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Pricing Section
              _buildAccordionSection(
                title: 'Pricing Section',
                icon: Icons.currency_rupee,
                expanded: _pricingExpanded,
                onTap: () =>
                    setState(() => _pricingExpanded = !_pricingExpanded),
                content: Column(
                  children: [
                    _buildPriceField(
                      controller: _salesPriceController,
                      label: 'Sales Price',
                      hint: 'Enter sales price',
                      taxType: _salesTaxType,
                      onTaxTypeChanged: (v) =>
                          setState(() => _salesTaxType = v),
                    ),
                    const SizedBox(height: 14),
                    _buildPriceField(
                      controller: _purchasePriceController,
                      label: 'Purchase Price',
                      hint: 'Enter purchase price',
                      taxType: _purchaseTaxType,
                      onTaxTypeChanged: (v) =>
                          setState(() => _purchaseTaxType = v),
                    ),
                    const SizedBox(height: 14),
                    _buildDiscountField(),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tax & Classification
              _buildAccordionSection(
                title: 'Tax & Classification',
                icon: Icons.request_quote,
                expanded: _taxClassificationExpanded,
                onTap: () => setState(() =>
                    _taxClassificationExpanded = !_taxClassificationExpanded),
                content: Column(
                  children: [
                    _buildDropdownField(
                      controller: _taxRateController,
                      label: 'Tax Rate',
                      hint: 'Select tax rate',
                      options: _taxRates,
                      required: true,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _hsnSacController,
                      label: 'HSN / SAC Field',
                      hint: 'Enter HSN/SAC code',
                      required: true,
                      validator: (v) =>
                          v!.isEmpty ? 'Enter HSN/SAC code' : null,
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
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Cancel',
                          style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.subtitleGray)),
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
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text('Create Item',
                          style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
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
        borderRadius: BorderRadius.circular(14),
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
                    child: Text(title,
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDarkBlue)),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppTheme.subtitleGray, size: 20),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: content),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.lato(fontSize: 14),
      keyboardType: keyboardType,
      validator: validator ??
          (required ? (v) => v!.isEmpty ? 'Enter $label' : null : null),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        labelStyle:
            GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
        hintText: hint,
        hintStyle: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.primaryDarkBlue)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required List<String> options,
    bool required = false,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        labelStyle:
            GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.primaryDarkBlue)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
      hint: Text(hint,
          style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400)),
      items: options
          .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option, style: GoogleFonts.lato(fontSize: 13))))
          .toList(),
      onChanged: (value) => controller.text = value!,
      validator: required ? (v) => v == null ? 'Select $label' : null : null,
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
      children: [
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
        const SizedBox(height: 8),
        Row(
          children: options
              .map((option) => Expanded(
                    child: RadioListTile<String>(
                      title:
                          Text(option, style: GoogleFonts.lato(fontSize: 13)),
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

  Widget _buildPriceField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String taxType,
    required Function(String) onTaxTypeChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controller,
                style: GoogleFonts.lato(fontSize: 14),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: GoogleFonts.lato(
                      fontSize: 13, color: AppTheme.subtitleGray),
                  hintText: hint,
                  hintStyle: GoogleFonts.lato(
                      fontSize: 12, color: Colors.grey.shade400),
                  prefixText: '₹ ',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppTheme.primaryDarkBlue)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  isDense: true,
                ),
                validator: (v) => v!.isEmpty ? 'Enter $label' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: taxType,
                    isExpanded: true,
                    items: ['Tax Inclusive', 'Tax Exclusive']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(type,
                                    style: GoogleFonts.lato(fontSize: 12)),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => onTaxTypeChanged(v!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscountField() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: _discountController,
            style: GoogleFonts.lato(fontSize: 14),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Discount',
              labelStyle:
                  GoogleFonts.lato(fontSize: 13, color: AppTheme.subtitleGray),
              hintText: 'Enter discount',
              hintStyle:
                  GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade400),
              prefixText: _discountType == 'Percentage' ? '% ' : '₹ ',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppTheme.primaryDarkBlue)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _discountType,
                isExpanded: true,
                items: ['Percentage', 'Flat Amount']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(type,
                                style: GoogleFonts.lato(fontSize: 12)),
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _discountType = v!),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
