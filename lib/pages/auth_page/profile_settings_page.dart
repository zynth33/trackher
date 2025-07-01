import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../sessions/user_session.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  DateTime? _selectedDate;
  String? _profileImagePath;

  final session = UserSession();

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  void _loadSessionData() {
    _nameController.text = session.name ?? '';
    _emailController.text = session.email ?? '';
    _phoneController.text = session.userDetails['phone'] ?? '';
    final dob = session.dateOfBirth;
    if (dob != null) {
      _selectedDate = dob;
      _dobController.text = DateFormat('dd/MM/yyyy').format(dob);
    }
    _profileImagePath = session.profileImageUrl;
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      await session.setMultipleUserDetails({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dateOfBirth': _selectedDate?.toIso8601String(),
        'profileImageUrl': _profileImagePath,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarWidget = _profileImagePath != null
        ? CircleAvatar(
      radius: 40,
      backgroundImage: NetworkImage(_profileImagePath!),
    )
        : const CircleAvatar(
      radius: 40,
      backgroundColor: Colors.purpleAccent,
      child: Icon(Icons.person, size: 40, color: Colors.white),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.pink.shade100,
            ],
          ),
        ),
        child: ListView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 InkWell(
                     onTap: () => Navigator.pop(context),
                     borderRadius: BorderRadius.circular(100),
                     child: const Icon(Icons.arrow_back, size: 30)
                 ),
                 const SizedBox(width: 20),
                 const Text(
                   "Update Your Profile",
                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                 ),
               ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(20, 0, 0, 0),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  avatarWidget,
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _pickImage,
                    child: Container (
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurpleAccent,
                            Colors.purple
                          ]
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(40, 0, 0, 0),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text('Change Photo', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ), textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(20, 0, 0, 0),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      icon: Icons.person,
                      label: 'Full Name',
                    ),
                    _buildTextField(
                      controller: _emailController,
                      icon: Icons.email,
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      controller: _phoneController,
                      icon: Icons.phone,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextField(
                      controller: _dobController,
                      icon: Icons.calendar_today,
                      label: 'Birth Date',
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap:_saveChanges,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.pink
                            ]
                          )
                        ),
                        child: Text('Save Changes', style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ), textAlign: TextAlign.center,)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
        (value == null || value.trim().isEmpty) ? 'Required field' : null,
      ),
    );
  }
}
