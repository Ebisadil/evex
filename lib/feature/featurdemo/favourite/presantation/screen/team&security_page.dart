import 'package:flutter/material.dart';

class TeamSecurityScreen extends StatefulWidget {
  const TeamSecurityScreen({super.key});

  @override
  State<TeamSecurityScreen> createState() => _TeamSecurityScreenState();
}

class _TeamSecurityScreenState extends State<TeamSecurityScreen> {
  // ── State ────────────────────────────────────────────────────────────────

  bool twoFactorEnabled = true;

  final List<Map<String, dynamic>> team = [
    {
      "name": "Sarah Mitchell",
      "email": "sarah.m@eventure.io",
      "role": "MANAGER",
    },
    {
      "name": "David Chen",
      "email": "d.chen@eventure.io",
      "role": "EDITOR",
    },
    {
      "name": "Elena Rodriguez",
      "email": "elena.r@eventure.io",
      "role": "VIEWER",
    },
  ];

  final List<Map<String, String>> activity = [
    {
      "user": "Sarah Mitchell",
      "text": "updated Ticket Pricing for 'Grand Gala 2024'",
      "time": "2 hours ago • 192.168.1.1",
    },
    {
      "user": "David Chen",
      "text": "published a new event announcement",
      "time": "5 hours ago • 192.168.1.4",
    },
  ];

  // For editing / adding
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedRole;
  int? _editingIndex;

  final List<String> availableRoles = ["MANAGER", "EDITOR", "VIEWER"];

  // ── Dialogs ──────────────────────────────────────────────────────────────

  void _showMemberDialog({int? index}) {
    final isEdit = index != null;

    if (isEdit) {
      final member = team[index!];
      _nameController.text = member["name"];
      _emailController.text = member["email"];
      _selectedRole = member["role"];
      _editingIndex = index;
    } else {
      _nameController.clear();
      _emailController.clear();
      _selectedRole = null;
      _editingIndex = null;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Member" : "Add Team Member"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Required";
                  if (!v.contains("@") || !v.contains(".")) {
                    return "Invalid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                hint: const Text("Select Role"),
                isExpanded: true,
                items: availableRoles
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRole = value),
                validator: (v) => v == null ? "Required" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newMember = {
                  "name": _nameController.text.trim(),
                  "email": _emailController.text.trim(),
                  "role": _selectedRole!,
                };

                setState(() {
                  if (isEdit) {
                    team[_editingIndex!] = newMember;
                  } else {
                    team.add(newMember);
                  }
                });

                Navigator.pop(context);
              }
            },
            child: Text(isEdit ? "Save" : "Add"),
          ),
        ],
      ),
    );
  }

  void _deleteMember(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Member?"),
        content: Text("Remove ${team[index]["name"]} from the team?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              setState(() => team.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  // ── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 252),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Team & Security",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2FA
            _twoFactorCard(),
            const SizedBox(height: 28),

            // Team
            _sectionHeader("TEAM ROLES", "${team.length} Active"),
            const SizedBox(height: 12),
            _teamCard(),

            const SizedBox(height: 28),

            // Recent Activity
            _sectionHeader("RECENT ACTIVITY", ""),
            const SizedBox(height: 12),
            ...activity.map(_activityTile).toList(),

            const SizedBox(height: 120),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _manageButton(),
    );
  }

  Widget _twoFactorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF1A1A1A)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE1BC4E).withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shield, color: Color(0xFFE1BC4E)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Two-Factor Authentication",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Enhanced account protection",
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(
            value: twoFactorEnabled,
            onChanged: (v) => setState(() => twoFactorEnabled = v),
            activeColor: const Color(0xFFE1BC4E),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String tag) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 12,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (tag.isNotEmpty)
          Text(
            tag,
            style: const TextStyle(
              color: Color(0xFFE1BC4E),
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _teamCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          ...team.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            return _teamTile(user, index);
          }).toList(),
          const Divider(height: 1, color: Colors.white12),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: const CircleAvatar(
              backgroundColor: Colors.white12,
              child: Icon(Icons.add, color: Color(0xFFE1BC4E)),
            ),
            title: const Text(
              "Add team member",
              style: TextStyle(
                  color: Color(0xFFE1BC4E), fontWeight: FontWeight.w600),
            ),
            onTap: () => _showMemberDialog(),
          ),
        ],
      ),
    );
  }

  Widget _teamTile(Map<String, dynamic> user, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: Colors.white12,
        child: const Icon(Icons.person, color: Colors.white54),
      ),
      title: Text(user["name"], style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(user["email"], style: const TextStyle(color: Colors.white54)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _roleBadge(user["role"]),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white54),
            onSelected: (value) {
              if (value == "edit") {
                _showMemberDialog(index: index);
              } else if (value == "delete") {
                _deleteMember(index);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "edit", child: Text("Edit")),
              const PopupMenuItem(
                value: "delete",
                child: Text("Remove", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleBadge(String role) {
    Color color;

    switch (role.toUpperCase()) {
      case "MANAGER":
        color = const Color(0xFFE1BC4E);
        break;
      case "EDITOR":
        color = Colors.blueAccent;
        break;
      case "VIEWER":
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        role,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _activityTile(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFE1BC4E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: item["user"],
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: " ${item["text"]}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item["time"]!,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _manageButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFF5E08E), Color(0xFFE1BC4E)],
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          // TODO: open real manage access screen / invite flow
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Manage Access – coming soon")),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group, color: Colors.black87),
            SizedBox(width: 10),
            Text(
              "Manage Access",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
