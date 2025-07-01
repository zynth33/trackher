import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../pages/avatar_page/avatar_page.dart';
import '../../services/supabase/supabase_user_service.dart';
import '../../sessions/user_session.dart';

import '_components/image_source_picker_bottom_sheet.dart';
import '_components/auth_text_field.dart';


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

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (mounted && context.mounted) {
      Navigator.pop(context);
    }
    if (image != null) {
      try {
        final uid = UserSession().id;
        if(uid != null) {
          final url = await SupabaseUserService().uploadProfilePicture(uid, File(image.path));

          setState(() {
            _profileImagePath = url;

            session.setUserDetail('profileImageUrl', url);
          });
          if (kDebugMode) {
            print(url);
          }
        }
      } catch (e) {
        if(kDebugMode) {
          print("Error Occurred $e");
        }
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (mounted && context.mounted) {
      Navigator.pop(context);
    }
    if (image != null) {
      try {
        final uid = UserSession().id;
        if(uid != null) {
          final url = await SupabaseUserService().uploadProfilePicture(uid, File(image.path));

          setState(() {
            _profileImagePath = url;

            session.setUserDetail('profileImageUrl', url);
          });
          if (kDebugMode) {
            print(url);
          }
        }
      } catch (e) {
        if(kDebugMode) {
          print("Error Occurred $e");
        }
      }
    }
  }

  void _pickAvatar() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarPage()));
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

     if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Profile updated')),
       );
     }
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
    final avatarWidget = _profileImagePath != null ? CircleAvatar(
      radius: 40,
      backgroundImage: NetworkImage(_profileImagePath!),
    ) : const CircleAvatar(
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
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => ImageSourcePickerBottomSheet(
                            pickImageFromGallery: _pickImageFromGallery,
                            pickImageFromCamera: _pickImageFromCamera,
                            pickAvatar: _pickAvatar
                        ),
                      );
                    },
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
                    AuthTextField(
                      controller: _nameController,
                      icon: Icons.person,
                      label: 'Full Name',
                    ),
                    AuthTextField(
                      controller: _emailController,
                      icon: Icons.email,
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AuthTextField(
                      controller: _phoneController,
                      icon: Icons.phone,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                    ),
                    AuthTextField(
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
}
