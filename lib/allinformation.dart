import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDirectoryPage extends StatefulWidget {
  const UserDirectoryPage({super.key});

  @override
  State<UserDirectoryPage> createState() => _UserDirectoryPageState();
}

class _UserDirectoryPageState extends State<UserDirectoryPage> {
  // Fetch users from the provided API link
  Future<List<dynamic>> fetchAllUsers() async {
    final response = await http.get(
      Uri.parse('https://king-makers-mongo-api.vercel.app/allusers'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Accessing the 'users' key from your JSON response
      return data['users'] as List<dynamic>;
    } else {
      throw Exception('Failed to load users from database');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo.shade900, Colors.purple.shade900],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(25),
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.05),
                        child: const Text(
                          "Investor Database",
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Table Section
                      Expanded(
                        child: FutureBuilder<List<dynamic>>(
                          future: fetchAllUsers(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.cyanAccent,
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Error: ${snapshot.error}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              );
                            }

                            final users = snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingTextStyle: const TextStyle(
                                    color: Colors.cyanAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  dataTextStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('NAME')),
                                    DataColumn(label: Text('PHONE')),
                                    DataColumn(label: Text('GENDER')),
                                    DataColumn(label: Text('OCCUPATION')),
                                    DataColumn(label: Text('INVESTED')),
                                    DataColumn(label: Text('UPI ID')),
                                    DataColumn(label: Text('GENERATED CODE')),
                                    DataColumn(
                                      label: Text('CODE USED TO LOGIN'),
                                    ),
                                  ],
                                  rows:
                                      users.map((user) {
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(user['name'] ?? 'N/A'),
                                            ),
                                            DataCell(
                                              Text(user['phnumber'] ?? 'N/A'),
                                            ),
                                            DataCell(
                                              Text(user['gender'] ?? 'N/A'),
                                            ),
                                            DataCell(
                                              Text(user['occupation'] ?? 'N/A'),
                                            ),
                                            DataCell(
                                              Text(
                                                "₹${user['investedamount']}",
                                                style: const TextStyle(
                                                  color: Colors.greenAccent,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(user['upi_id'] ?? 'N/A'),
                                            ),
                                            DataCell(
                                              _buildCodeBadge(
                                                user['referral_code_generated'],
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                user['given_referral_code'] ??
                                                    'None',
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper to build a spectacular badge for referral codes
  Widget _buildCodeBadge(String? code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.cyanAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Text(
        code ?? '-',
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
