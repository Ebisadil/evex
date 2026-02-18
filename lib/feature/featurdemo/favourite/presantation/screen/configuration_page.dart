import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ← add this dependency for nice date/time formatting

class EventConfigurationScreen extends StatefulWidget {
  const EventConfigurationScreen({super.key});

  @override
  State<EventConfigurationScreen> createState() =>
      _EventConfigurationScreenState();
}

class _EventConfigurationScreenState extends State<EventConfigurationScreen> {
  // ── Controllers ──────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  // ── State variables ──────────────────────────────────────────────────────
  bool _mapIntegrationEnabled = true;
  bool _isPrivateEvent = false;
  bool _hasCapacityLimit = true; // false = unlimited
  double _maxCapacity = 500;
  String _visibility = 'Public'; // Public / Private / Unlisted

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  // ── Pickers ──────────────────────────────────────────────────────────────

  Future<void> _pickDateTime(bool isStart) async {
    final initial = isStart
        ? _startDateTime ?? DateTime.now()
        : _endDateTime ?? DateTime.now().add(const Duration(hours: 2));

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    if (time == null || !mounted) return;

    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isStart) {
        _startDateTime = picked;
        _startDateController.text =
            DateFormat('dd MMM yyyy • hh:mm a').format(picked);
      } else {
        _endDateTime = picked;
        _endDateController.text =
            DateFormat('dd MMM yyyy • hh:mm a').format(picked);
      }
    });
  }

  // ── Save logic ───────────────────────────────────────────────────────────

  void _saveConfiguration() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields correctly")),
      );
      return;
    }

    if (_startDateTime != null &&
        _endDateTime != null &&
        _endDateTime!.isBefore(_startDateTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End date/time must be after start")),
      );
      return;
    }

    // Here you would normally save to Firestore / Supabase / local storage / etc.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Event configuration saved successfully"),
        backgroundColor: Color(0xFFE1BC4E),
      ),
    );
  }

  // ── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text("Event Configuration",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── GENERAL INFO ───────────────────────────────────────────────
              _buildSectionHeader('GENERAL INFO'),
              const SizedBox(height: 16),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('EVENT NAME *'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _eventNameController,
                      hintText: 'Summer Music Festival 2025',
                      validator: (v) =>
                          v?.trim().isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('DESCRIPTION'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _descriptionController,
                      hintText: 'Tell attendees what to expect...',
                      maxLines: 4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── VENUE ──────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('VENUE DETAILS'),
                  Row(
                    children: [
                      Text(
                        'MAP INTEGRATION',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: _mapIntegrationEnabled,
                        onChanged: (v) =>
                            setState(() => _mapIntegrationEnabled = v),
                        activeColor: const Color(0xFFE1BC4E),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('VENUE NAME'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _venueNameController,
                      hintText: 'Jawaharlal Nehru Stadium',
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('FULL ADDRESS'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _addressController,
                      hintText: 'Stadium Link Rd, Kochi, Kerala',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Private Event',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('Only visible via invitation link',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 13)),
                          ],
                        ),
                        Switch(
                          value: _isPrivateEvent,
                          onChanged: (v) => setState(() => _isPrivateEvent = v),
                          activeColor: const Color(0xFFE1BC4E),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── SCHEDULE & CAPACITY ────────────────────────────────────────
              _buildSectionHeader('SCHEDULING & CAPACITY'),
              const SizedBox(height: 16),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('START DATE & TIME *'),
                              const SizedBox(height: 8),
                              _buildDateTimeField(
                                controller: _startDateController,
                                onTap: () => _pickDateTime(true),
                                validator: (v) =>
                                    v?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('END DATE & TIME *'),
                              const SizedBox(height: 8),
                              _buildDateTimeField(
                                controller: _endDateController,
                                onTap: () => _pickDateTime(false),
                                validator: (v) =>
                                    v?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Capacity Limit',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        Switch(
                          value: _hasCapacityLimit,
                          onChanged: (v) =>
                              setState(() => _hasCapacityLimit = v),
                          activeColor: const Color(0xFFE1BC4E),
                        ),
                      ],
                    ),
                    if (_hasCapacityLimit) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabel('MAX ATTENDEES'),
                          Text('${_maxCapacity.toInt()}',
                              style: const TextStyle(
                                  color: Color(0xFFE1BC4E),
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      Slider(
                        value: _maxCapacity,
                        min: 10,
                        max: 5000,
                        divisions: 499,
                        label: _maxCapacity.toInt().toString(),
                        activeColor: const Color(0xFFE1BC4E),
                        onChanged: (v) => setState(() => _maxCapacity = v),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ── SAVE BUTTON ────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveConfiguration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1BC4E),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Save & Continue',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: Text(
                  'END-TO-END ENCRYPTED • PRO TIER',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 1, 1, 1),
                      fontSize: 11,
                      letterSpacing: 1.2),
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper widgets ───────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w600));
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.white54) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDateTimeField({
    required TextEditingController controller,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: _buildTextField(
          controller: controller,
          hintText: 'Select date & time',
          validator: validator,
          prefixIcon: Icons.calendar_today_outlined,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _venueNameController.dispose();
    _addressController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}
