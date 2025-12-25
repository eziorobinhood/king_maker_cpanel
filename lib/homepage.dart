import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController upiController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false; // Added loading state for the button

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
                          "Investment Portal",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          "Update your payment securely",
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
                          controller: upiController,
                          label: "UPI ID",
                          icon: Icons.alternate_email,
                          hint: "mobile@upi",
                        ),
                        const SizedBox(height: 25),
                        _buildGlassInput(
                          controller: amountController,
                          label: "Invested Amount",
                          icon: Icons.currency_rupee,
                          hint: "Enter amount",
                          isNumber: true,
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
                                  isLoading ? null : () => _handlePayment(),
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
                                        'CONFIRM PAYMENT',
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

  // Helper widget for spectacular glass input fields
  Widget _buildGlassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isNumber = false,
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
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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

  void _handlePayment() async {
    setState(() => isLoading = true);
    // Add your API call function here
    await sendPaymentData(context, upiController.text, amountController.text);
    setState(() => isLoading = false);
  }
}

Future<void> sendPaymentData(
  BuildContext context,
  String upi,
  String amount,
) async {
  final url = Uri.parse(
    'https://king-makers-mongo-api.vercel.app/user/updatepayment',
  );

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Tell Vercel you are sending JSON
      },
      body: jsonEncode({'upi_id': upi, 'investedamount': amount}),
    );

    if (!context.mounted) return;

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
    }
  } catch (e) {
    // Handle no internet or server down
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Network error: $e")));
  }
}
