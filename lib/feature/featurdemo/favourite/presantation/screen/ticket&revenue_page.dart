import 'package:flutter/material.dart';

class TicketingRevenueScreen extends StatefulWidget {
  const TicketingRevenueScreen({super.key});

  @override
  State<TicketingRevenueScreen> createState() => _TicketingRevenueScreenState();
}

class _TicketingRevenueScreenState extends State<TicketingRevenueScreen> {
  // Tax & fees
  bool absorbFees = false;
  bool passThroughTax = true;

  // Pricing tiers
  List<Map<String, dynamic>> pricingTiers = [
    {
      "title": "Early Bird",
      "price": 49.00,
      "currency": "₹",
      "sold": 200,
      "total": 200,
      "active": true,
    },
    {
      "title": "General Admission",
      "price": 89.00,
      "currency": "₹",
      "sold": 0,
      "total": 450,
      "active": false,
    },
    {
      "title": "VIP Experience 💎",
      "price": 249.00,
      "currency": "₹",
      "sold": 0,
      "total": 50,
      "active": false,
    },
  ];

  // Controllers for edit/add dialog
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  // ── Dialog: Add or Edit Tier ─────────────────────────────────────────────

  void _showTierDialog({int? editIndex}) {
    final isEdit = editIndex != null;
    final tier = isEdit ? pricingTiers[editIndex!] : null;

    _titleController.text = tier?["title"] ?? "";
    _priceController.text =
        tier != null ? tier["price"].toStringAsFixed(2) : "";
    _quantityController.text = tier != null ? tier["total"].toString() : "";

    bool active = tier?["active"] ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),
            title: Text(
              isEdit ? "Edit Pricing Tier" : "Create New Tier",
              style: const TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration:
                      _inputDecoration("Tier Name (e.g. VIP Early Access)"),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _priceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Price (without currency)"),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _quantityController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Total available tickets"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text("Active",
                      style: TextStyle(color: Colors.white70)),
                  value: active,
                  activeColor: const Color(0xFFE1BC4E),
                  onChanged: (v) => setDialogState(() => active = v),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE1BC4E),
                  foregroundColor: Colors.black87,
                ),
                onPressed: () {
                  final title = _titleController.text.trim();
                  final priceStr = _priceController.text.trim();
                  final qtyStr = _quantityController.text.trim();

                  if (title.isEmpty || priceStr.isEmpty || qtyStr.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  final price = double.tryParse(priceStr);
                  final total = int.tryParse(qtyStr);

                  if (price == null ||
                      price <= 0 ||
                      total == null ||
                      total <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Invalid price or quantity")),
                    );
                    return;
                  }

                  final newTier = {
                    "title": title,
                    "price": price,
                    "currency": "₹",
                    "sold": tier?["sold"] ?? 0,
                    "total": total,
                    "active": active,
                  };

                  setState(() {
                    if (isEdit) {
                      pricingTiers[editIndex!] = newTier;
                    } else {
                      pricingTiers.add(newTier);
                    }
                  });

                  Navigator.pop(context);
                },
                child: Text(isEdit ? "Save" : "Create"),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      _titleController.clear();
      _priceController.clear();
      _quantityController.clear();
    });
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE1BC4E), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
    );
  }

  void _deleteTier(int index) {
    final title = pricingTiers[index]["title"];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title:
            const Text("Remove Tier?", style: TextStyle(color: Colors.white)),
        content: Text(
          "Delete \"$title\"?\nThis cannot be undone.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () {
              setState(() => pricingTiers.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // ── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ticketing & Revenue",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _revenueCard(),
            const SizedBox(height: 32),
            _sectionHeader(
              title: "PRICING TIERS",
              trailing: GestureDetector(
                onTap: () => _showTierDialog(),
                child: const Text(
                  "ADD NEW",
                  style: TextStyle(
                    color: Color(0xFFE1BC4E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              pricingTiers.length,
              (i) => _priceCard(
                pricingTiers[i],
                onEdit: () => _showTierDialog(editIndex: i),
                onDelete: () => _deleteTier(i),
              ),
            ),
            const SizedBox(height: 40),
            _sectionHeader(title: "PAYOUT SETTINGS"),
            const SizedBox(height: 12),
            _payoutCard(),
            const SizedBox(height: 40),
            _sectionHeader(title: "TAX & FEES"),
            const SizedBox(height: 12),
            _toggleTile(
              "Absorb Service Fees",
              "You pay the platform fees — guests see clean price",
              absorbFees,
              (v) => setState(() => absorbFees = v),
            ),
            _toggleTile(
              "Pass-through Taxes",
              "Automatically calculate & collect sales tax / GST",
              passThroughTax,
              (v) => setState(() => passThroughTax = v),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _revenueCard() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F0F0F), Color(0xFF1A1A2E)],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TOTAL REVENUE",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          SizedBox(height: 8),
          Text(
            "₹142,850.00",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            "+12.4% vs last month",
            style: TextStyle(color: Colors.greenAccent, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _priceCard(
    Map<String, dynamic> tier, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    final bool active = tier["active"];
    final String status = tier["sold"] >= tier["total"]
        ? "Sold Out"
        : "${tier["total"] - tier["sold"]} remaining";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active ? const Color(0xFFE1BC4E) : Colors.white12,
          width: active ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tier["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${tier["currency"]}${tier["price"].toStringAsFixed(2)}  •  ${tier["sold"]}/${tier["total"]} sold  •  $status",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white54),
            color: const Color(0xFF25253A),
            onSelected: (value) {
              if (value == "edit") onEdit();
              if (value == "delete") onDelete();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "edit", child: Text("Edit")),
              const PopupMenuItem(
                value: "delete",
                child:
                    Text("Delete", style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _payoutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance, color: Color(0xFFE1BC4E)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Bank Account (****8842)",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE1BC4E),
              side: const BorderSide(color: Color(0xFFE1BC4E)),
            ),
            onPressed: () {
              // TODO: open bank / payout settings
            },
            child: const Text("Manage"),
          ),
        ],
      ),
    );
  }

  Widget _toggleTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
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
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55), fontSize: 13)),
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
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
