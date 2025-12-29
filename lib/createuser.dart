import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CreateNewUser extends StatefulWidget {
  const CreateNewUser({super.key});

  @override
  State<CreateNewUser> createState() => _CreateNewUserState();
}

class _CreateNewUserState extends State<CreateNewUser> {
  final TextEditingController upiController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateofbirthController = TextEditingController();
  final TextEditingController referralIdController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  // 1. Variable to hold the selection
  String? selectedGender;

  // 2. Options list
  final List<String> genderOptions = [
    "Male",
    "Female",
    "Other",
    "Prefer not to say",
  ];
  bool isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // Default year for DOB
      firstDate: DateTime(1950), // Earliest date allowed
      lastDate: DateTime.now(), // Cannot be in the future
      builder: (context, child) {
        // This theme makes the calendar match your Indigo/Cyan design
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.cyanAccent, // Header & selected day color
              onPrimary: Colors.black, // Text on selected day
              surface: Colors.indigo.shade900, // Background of dialog
              onSurface: Colors.white, // Text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.cyanAccent),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format the date as DD-MM-YYYY to match your backend
        dateofbirthController.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modern gradient background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade900,
              Colors.indigo.shade700,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 450,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1), // Glass effect
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Banner Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 50,
                          color: Colors.cyanAccent,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Create New User",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          "Fill in the details below to create a new user",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        _buildGlassInput(
                          controller: phoneController,
                          label: "Phone Number",
                          icon: Icons.phone,
                          hint: "Enter 10-digit number",
                          keyboardType:
                              TextInputType.number, // Opens the numeric keypad
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Blocks all non-numeric characters
                            LengthLimitingTextInputFormatter(
                              10,
                            ), // Limits input to 10 digits
                          ],
                        ),
                        const SizedBox(height: 25),
                        _buildGlassInput(
                          controller: nameController,
                          label: "Name",
                          icon: Icons.person,
                          hint: "Enter name",
                        ),
                        const SizedBox(height: 25),
                        _buildGlassInput(
                          controller: dateofbirthController,
                          label: "Date of Birth",
                          icon: Icons.calendar_today,
                          hint: "Select your DOB",
                          onTap:
                              () =>
                                  _selectDate(context), // Trigger the calendar
                        ),
                        const SizedBox(height: 25),
                        _buildGlassInput(
                          controller: occupationController,
                          label: "Occupation",
                          icon: Icons.how_to_reg,
                          hint: "Enter Your Occupation",
                        ),
                        const SizedBox(height: 25),
                        _buildGlassDropdown(),
                        const SizedBox(height: 25),
                        _buildGlassInput(
                          controller: upiController,
                          label: "UPI ID",
                          icon: Icons.alternate_email,
                          hint: "Enter UPI ID",
                        ),
                        const SizedBox(height: 25),
                        _buildGlassInput(
                          controller: referralIdController,
                          label: "Referral ID",
                          icon: Icons.how_to_reg,
                          hint: "Enter Your Referral ID",
                        ),

                        const SizedBox(height: 40),

                        // Spectacular Gradient Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.cyanAccent, Colors.blueAccent],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyanAccent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed:
                                  isLoading
                                      ? null
                                      : () => createUser(
                                        context,
                                        phoneController.text,
                                        nameController.text,
                                        dateofbirthController.text,
                                        selectedGender!,
                                        occupationController.text,
                                        upiController.text,
                                        referralIdController.text,
                                      ),
                              child:
                                  isLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text(
                                        'CREATE ACCOUNT',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Theme(
          // This theme ensures the popup menu is also dark/glassy
          data: Theme.of(
            context,
          ).copyWith(canvasColor: Colors.indigo.shade900.withOpacity(0.9)),
          child: DropdownButtonFormField<String>(
            value: selectedGender,
            dropdownColor: Colors.indigo.shade900,
            style: const TextStyle(color: Colors.white),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person_outline,
                color: Colors.white70,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.cyanAccent,
                  width: 2,
                ),
              ),
            ),
            hint: Text(
              "Select Gender",
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 14,
              ),
            ),
            items:
                genderOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedGender = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGlassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    VoidCallback? onTap,
    bool readOnly = false,
    TextInputType? keyboardType, // New optional parameter
    List<TextInputFormatter>? inputFormatters, // New optional parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType, // Applied here
          inputFormatters: inputFormatters, // Applied here
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: Icon(icon, color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> createUser(
    BuildContext context,
    String phone,
    String name,
    String dob,
    String occupation,
    String? gender,
    String upi,
    String referralId,
  ) async {
    final url = Uri.parse(
      "https://king-makers-mongo-api.vercel.app/user/signup",
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phnumber': phone,
          'name': name,
          'dateofbirth': dob,
          'occupation': occupation,
          'gender': gender,
          'upi_id': upi,
          "given_referral_id": referralId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Payment data sent successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed: Server returned ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
        print(response.body);
      }
    } catch (e) {
      // Handle no internet or server down
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Network error: $e")));
    }
  }
}
