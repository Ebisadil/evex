import 'package:flutter/material.dart';
import 'package:mainproject/feature/featurdemo/home/presentation/screen/widget/payment_page.dart';

class AttendeeDetailsScreen extends StatefulWidget {
  final String image;
  final String title;
  final String date;
  final String location;
  final double price;
  final int quantity;

  const AttendeeDetailsScreen({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.location,
    required this.price,
    required this.quantity,
  });

  @override
  State<AttendeeDetailsScreen> createState() => _AttendeeDetailsScreenState();
}

class _AttendeeDetailsScreenState extends State<AttendeeDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _saveForFuture = true;
  bool _isGuestCheckout = false;

  // Mock saved profile (in real app → load from local storage / backend)
  final Map<String, String> _savedProfile = {
    'name': 'Ebi John',
    'email': 'ebi@example.com',
    'phone': '+919876543210',
  };

  bool get _hasSavedProfile =>
      _savedProfile['name']?.isNotEmpty == true &&
      _savedProfile['email']?.isNotEmpty == true;

  @override
  void initState() {
    super.initState();
    // Optional: auto-fill if user is logged in and has saved data
    // Here we wait for user to tap "Autofill"
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  double get subtotal => widget.price * widget.quantity;
  double get serviceFee => 24.50;
  double get total => subtotal + serviceFee;

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 2) return 'Name is too short';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone is required';
    final phoneRegex = RegExp(r'^\+?[1-9]\d{7,14}$');
    if (!phoneRegex.hasMatch(value.trim())) return 'Enter a valid phone number';
    return null;
  }

  void _autofillFromProfile() {
    setState(() {
      _nameController.text = _savedProfile['name'] ?? '';
      _emailController.text = _savedProfile['email'] ?? '';
      _phoneController.text = _savedProfile['phone'] ?? '';
      _saveForFuture = true;
    });

    // Re-validate form after autofill
    _formKey.currentState?.validate();
  }

  void _proceedToPayment() {
    if (_formKey.currentState!.validate()) {
      // In real app → save if !_isGuestCheckout && _saveForFuture
      if (!_isGuestCheckout && _saveForFuture) {
        // TODO: save to profile / backend / local storage
        debugPrint("Saving attendee details for future use...");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SecureCheckoutScreen(
            title: widget.title,
            date: widget.date,
            location: widget.location,
            price: widget.price,
            quantity: widget.quantity,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Attendee Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress bar (unchanged)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProgressStep('Cart', true),
                  _buildProgressLine(true),
                  _buildProgressStep('Details', true),
                  _buildProgressLine(false),
                  _buildProgressStep('Pay', false),
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
                    // Event summary card (mostly unchanged)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE1BC4E)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'VIP EXPERIENCE',
                                      style: TextStyle(
                                        color: Color(0xFFE1BC4E),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(widget.date,
                                      style:
                                          TextStyle(color: Colors.grey[700])),
                                  const SizedBox(height: 6),
                                  Text(widget.location,
                                      style:
                                          TextStyle(color: Colors.grey[700])),
                                  const SizedBox(height: 16),
                                  Text(
                                    "₹${widget.price.toStringAsFixed(2)} × ${widget.quantity}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE1BC4E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                widget.image,
                                width: 120,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Contact Information + Autofill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Contact Information",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (_hasSavedProfile)
                          TextButton(
                            onPressed: _autofillFromProfile,
                            child: const Text(
                              "Autofill from profile",
                              style: TextStyle(
                                color: Color(0xFFE1BC4E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      decoration: InputDecoration(
                        labelText: 'Email Address *',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      validator: _validateName,
                      decoration: InputDecoration(
                        labelText: 'Full Name *',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number *',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Save / Guest options
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text("Save for future bookings"),
                              subtitle:
                                  const Text("Securely stored in your profile"),
                              value: _saveForFuture && !_isGuestCheckout,
                              onChanged: _isGuestCheckout
                                  ? null
                                  : (v) => setState(() => _saveForFuture = v),
                              activeColor: const Color(0xFFE1BC4E),
                            ),
                            const Divider(height: 32),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isGuestCheckout,
                                  activeColor: const Color(0xFFE1BC4E),
                                  onChanged: (v) {
                                    setState(() {
                                      _isGuestCheckout = v == true;
                                      if (_isGuestCheckout)
                                        _saveForFuture = false;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    "Continue as guest (no profile needed)",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
              blurRadius: 12,
              offset: const Offset(0, -4),
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
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _formKey.currentState?.validate() == true
                      ? _proceedToPayment
                      : null,
                  icon: const Icon(Icons.payment),
                  label: Text(_isGuestCheckout
                      ? "Guest Checkout"
                      : "Continue to Payment"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1BC4E),
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
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
          width: 44,
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
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFFE1BC4E) : Colors.grey,
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
}
