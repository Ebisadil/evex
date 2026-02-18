import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/sucess_page.dart';

class SecureCheckoutScreen extends StatefulWidget {
  final String title;
  final String date;
  final String location;
  final double price;
  final int quantity;

  const SecureCheckoutScreen({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.price,
    required this.quantity,
  });

  @override
  State<SecureCheckoutScreen> createState() => _SecureCheckoutScreenState();
}

class _SecureCheckoutScreenState extends State<SecureCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // Optional: pre-fill test data during development
    // _cardNumberController.text = '4111111111111111';
    // _expiryController.text = '12/28';
    // _cvvController.text = '123';
    // _nameController.text = 'Ebi John';
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  double get total => widget.price * widget.quantity;

  // ── Formatting & Validation Helpers ─────────────────────────────────────

  String? _validateCardNumber(String? value) {
    if (value == null || value.replaceAll(' ', '').length != 16) {
      return 'Enter a valid 16-digit card number';
    }
    return null;
  }

  String? _validateExpiry(String? value) {
    if (value == null || value.length != 5 || !value.contains('/')) {
      return 'Enter valid expiry (MM/YY)';
    }
    final parts = value.split('/');
    if (parts.length != 2) return 'Invalid format';
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || month < 1 || month > 12) return 'Invalid month';
    if (year == null || year < 24) return 'Card expired';
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || (value.length != 3 && value.length != 4)) {
      return 'Enter valid CVV (3-4 digits)';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Cardholder name is required';
    if (value.trim().length < 3) return 'Name is too short';
    return null;
  }

  void _updateFormValidity() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  // Auto-format card number with spaces
  void _formatCardNumber(String value) {
    final clean = value.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(clean[i]);
    }
    _cardNumberController.value = TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }

  // Auto-format expiry MM/YY
  void _formatExpiry(String value) {
    final clean = value.replaceAll('/', '');
    final buffer = StringBuffer();
    if (clean.length >= 2) {
      buffer.write('${clean.substring(0, 2)}/');
      if (clean.length > 2)
        buffer.write(clean.substring(2, clean.length.clamp(2, 4)));
    } else {
      buffer.write(clean);
    }
    _expiryController.value = TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Secure Checkout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        onChanged: _updateFormValidity,
        child: Column(
          children: [
            // Progress bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProgressStep('Cart', true),
                  _buildProgressLine(true),
                  _buildProgressStep('Details', true),
                  _buildProgressLine(true),
                  _buildProgressStep('Pay', true),
                  _buildProgressLine(false),
                  _buildProgressStep('Done', false),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event summary (quick recap)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(widget.date,
                                style: TextStyle(color: Colors.grey[700])),
                            Text(widget.location,
                                style: TextStyle(color: Colors.grey[700])),
                            const SizedBox(height: 12),
                            Text(
                              "₹${(widget.price * widget.quantity).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE1BC4E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Apple Pay / Google Pay (mock)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.apple, color: Colors.white, size: 28),
                          SizedBox(width: 12),
                          Text(
                            'Pay with Apple Pay',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // OR divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[400])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR PAY WITH CARD',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[400])),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Payment Form
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                      onChanged: (v) => _formatCardNumber(v),
                      validator: _validateCardNumber,
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.credit_card),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onChanged: (v) => _formatExpiry(v),
                            validator: _validateExpiry,
                            decoration: InputDecoration(
                              labelText: 'Expiry (MM/YY)',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: _validateCVV,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              suffixIcon: const Icon(Icons.info_outline,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      validator: _validateName,
                      decoration: InputDecoration(
                        labelText: 'Cardholder Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Security badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _securityBadge(Icons.lock, 'SSL Secure'),
                        const SizedBox(width: 24),
                        _securityBadge(Icons.verified_user, 'PCI DSS Level 1'),
                      ],
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TOTAL TO PAY",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      "₹${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _isFormValid
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderConfirmationScreen(
                                title: widget.title,
                                date: widget.date,
                                location: widget.location,
                                price: widget.price,
                                quantity: widget.quantity,
                              ),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.lock),
                  label: const Text('Pay Securely'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1BC4E),
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Your payment is encrypted and secure',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE1BC4E) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFFE1BC4E) : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isActive ? const Color(0xFFE1BC4E) : Colors.grey.shade300,
      ),
    );
  }

  Widget _securityBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.green, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
