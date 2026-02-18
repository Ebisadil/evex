import 'package:flutter/material.dart';

class AttendeeExperienceScreen extends StatefulWidget {
  const AttendeeExperienceScreen({super.key});

  @override
  State<AttendeeExperienceScreen> createState() =>
      _AttendeeExperienceScreenState();
}

class _AttendeeExperienceScreenState extends State<AttendeeExperienceScreen> {
  // Core toggles
  bool dataCollection = true;
  bool reminders = true;
  bool qrSecurity = false;
  bool walletIntegration = true;

  // Editable values
  double completion = 0.84;
  List<String> customFields = [
    "Dietary requirements",
    "T-shirt size",
    "Job title"
  ];
  List<String> reminderTimes = ["24 hours before", "1 hour before"];
  bool collectPhone = true;
  bool requireProfilePhoto = false;
  String customCssHint = "Not configured";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 246),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text(
              "Attendee Experience",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              "ORGANIZER PRO",
              style: TextStyle(
                color: Color(0xFFE1BC4E),
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _funnelCard(),
            const SizedBox(height: 28),
            _section("REGISTRATION FORM", Icons.dashboard_customize),
            const SizedBox(height: 12),
            _navCard(
              "Custom Fields",
              customFields.join(", "),
              onTap: _editCustomFields,
            ),
            _toggleCard(
              "Data Collection",
              "Marketing consent & GDPR",
              dataCollection,
              (v) => setState(() => dataCollection = v),
              onTap: _editDataCollection,
            ),
            const SizedBox(height: 28),
            _section("EMAIL & COMMUNICATIONS", Icons.email),
            const SizedBox(height: 12),
            _toggleCard(
              "Automated Reminders",
              reminderTimes.join(" • "),
              reminders,
              (v) => setState(() => reminders = v),
              onTap: _editReminders,
            ),
            _navCard(
              "Custom Templates",
              "Branded CSS & dynamic tags • $customCssHint",
              icon: Icons.edit,
              onTap: _editEmailTemplates,
            ),
            const SizedBox(height: 28),
            _section("DIGITAL TICKETS", Icons.qr_code),
            const SizedBox(height: 12),
            _toggleCard(
              "QR Code Security",
              "Dynamic rotating codes",
              qrSecurity,
              (v) => setState(() => qrSecurity = v),
              onTap: _editQrSettings,
            ),
            _toggleCard(
              "Wallet Integration",
              "Apple Wallet & Google Pay",
              walletIntegration,
              (v) => setState(() => walletIntegration = v),
              onTap: _editWalletSettings,
            ),
            const SizedBox(height: 40),
            _previewButton(),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "SECURE CLOUD SYNC ACTIVE",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                  letterSpacing: 2,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  Widgets (most are similar — only changed interactivity)
  // ──────────────────────────────────────────────────────────────

  Widget _funnelCard() {
    return GestureDetector(
      onTap: _editFunnelHealth,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF1A1A1A)]),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 20),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "FORM COMPLETION LOGIC",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Registration Funnel Health",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "${(completion * 100).toInt()}%",
                  style: const TextStyle(
                      color: Color(0xFFE1BC4E), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: completion,
                minHeight: 6,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation(Color(0xFFE1BC4E)),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Tap to adjust logic →",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4), fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFE1BC4E)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _navCard(
    String title,
    String subtitle, {
    IconData icon = Icons.arrow_forward_ios,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(icon, color: Colors.white38, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _toggleCard(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () => onChanged(!value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 13),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFFE1BC4E),
            ),
          ],
        ),
      ),
    );
  }

  Widget _previewButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
            colors: [Color(0xFFF5E08E), Color(0xFFE1BC4E)]),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFE1BC4E).withOpacity(0.4), blurRadius: 20)
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // TODO: navigate to preview screen / webview / deep link
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Opening preview… (not implemented yet)")),
          );
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_red_eye, color: Colors.black),
            SizedBox(width: 8),
            Text(
              "Preview Experience",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  //  Edit dialogs
  // ──────────────────────────────────────────────────────────────

  void _editFunnelHealth() {
    double temp = completion;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Adjust Funnel Health (Demo)"),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${(temp * 100).toInt()}%",
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
              Slider(
                value: temp,
                min: 0.0,
                max: 1.0,
                divisions: 20,
                label: "${(temp * 100).toInt()}%",
                activeColor: const Color(0xFFE1BC4E),
                onChanged: (v) => setDialogState(() => temp = v),
              ),
              const Text(
                  "In real app: controlled by conditional logic, required fields, page order",
                  style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() => completion = temp);
              Navigator.pop(context);
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }

  void _editCustomFields() {
    // Very simplified — real version would use reorderable list + add/remove
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Custom Registration Fields"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...customFields.map((f) => ListTile(
                    title: Text(f),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() => customFields.remove(f));
                        Navigator.pop(context);
                        _editCustomFields(); // refresh dialog
                      },
                    ),
                  )),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add_circle_outline,
                    color: Color(0xFFE1BC4E)),
                title: const Text("Add new field…",
                    style: TextStyle(color: Color(0xFFE1BC4E))),
                onTap: () {
                  // In real app → open field type chooser + name input
                  setState(() =>
                      customFields.add("New field ${customFields.length + 1}"));
                  Navigator.pop(context);
                  _editCustomFields();
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"))
        ],
      ),
    );
  }

  void _editDataCollection() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Data Collection Settings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text("Collect marketing consent"),
              value: dataCollection,
              onChanged: (v) => setState(() => dataCollection = v),
              activeColor: const Color(0xFFE1BC4E),
            ),
            SwitchListTile(
              title: const Text("Collect phone number"),
              value: collectPhone,
              onChanged: (v) => setState(() => collectPhone = v),
              activeColor: const Color(0xFFE1BC4E),
            ),
            SwitchListTile(
              title: const Text("Require profile photo"),
              value: requireProfilePhoto,
              onChanged: (v) => setState(() => requireProfilePhoto = v),
              activeColor: const Color(0xFFE1BC4E),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  void _editReminders() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Automated Reminders"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text("Send reminders"),
              value: reminders,
              onChanged: (v) => setState(() => reminders = v),
              activeColor: const Color(0xFFE1BC4E),
            ),
            const Divider(),
            const Text("Reminder times:",
                style: TextStyle(fontWeight: FontWeight.w600)),
            ...[
              "24 hours before",
              "6 hours before",
              "1 hour before",
              "15 minutes before"
            ].map(
              (t) => CheckboxListTile(
                title: Text(t),
                value: reminderTimes.contains(t),
                onChanged: (bool? v) {
                  setState(() {
                    if (v == true) {
                      reminderTimes.add(t);
                    } else {
                      reminderTimes.remove(t);
                    }
                  });
                },
                activeColor: const Color(0xFFE1BC4E),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Save"))
        ],
      ),
    );
  }

  void _editEmailTemplates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            "Custom email template editor – opens in new screen (not implemented yet)"),
        duration: Duration(seconds: 3),
      ),
    );
    // → real version would navigate to rich text / HTML editor with variables support
  }

  void _editQrSettings() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("QR Code Security"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text("Use dynamic / rotating codes"),
              value: qrSecurity,
              onChanged: (v) => setState(() => qrSecurity = v),
              activeColor: const Color(0xFFE1BC4E),
            ),
            const SizedBox(height: 12),
            const Text(
                "More options coming: expiration time, one-time use, geo-fencing…"),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  void _editWalletSettings() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Wallet Integration"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text("Apple Wallet"),
              value: walletIntegration,
              onChanged: (v) => setState(() => walletIntegration = v),
              activeColor: const Color(0xFFE1BC4E),
            ),
            SwitchListTile(
              title: const Text("Google Wallet / Pay"),
              value: walletIntegration,
              onChanged: (v) => setState(() => walletIntegration = v),
              activeColor: const Color(0xFFE1BC4E),
            ),
            const SizedBox(height: 12),
            const Text("Branding & fields can be customized in next step."),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }
}
