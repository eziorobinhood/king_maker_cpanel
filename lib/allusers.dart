import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllUserView extends StatefulWidget {
  const AllUserView({super.key});

  @override
  State<AllUserView> createState() => AllUserViewState();
}

class AllUserViewState extends State<AllUserView> {
  // Updated to specifically handle your new API structure
  Future<Map<String, dynamic>> fetchLeaderboardData() async {
    final response = await http.get(
      Uri.parse(
        'https://king-makers-mongo-api.vercel.app/referral-leaderboard',
      ),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load leaderboard');
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
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      // Header Section with Glass Title
                      Container(
                        padding: const EdgeInsets.all(25),
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Referral Leaderboard",
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.emoji_events,
                              color: Colors.yellowAccent.shade400,
                              size: 30,
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: fetchLeaderboardData(),
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

                            // Extract the list and the winner from your API response
                            final List<dynamic> users =
                                snapshot.data!['fullList'];
                            final Map<String, dynamic> winner =
                                snapshot.data!['winner'];

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
                                    DataColumn(label: Text('RANK')),
                                    DataColumn(label: Text('NAME')),
                                    DataColumn(label: Text('PHONE')),
                                    DataColumn(label: Text('REFERRAL CODE')),
                                    DataColumn(label: Text('TOTAL REFERRALS')),
                                  ],
                                  rows:
                                      users.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        var user = entry.value;

                                        // Logic to check if this user is the winner
                                        bool isWinner =
                                            user['phone'] == winner['phone'];

                                        return DataRow(
                                          // Spectacular highlighting for the winner row
                                          selected: isWinner,
                                          color:
                                              isWinner
                                                  ? MaterialStateProperty.all(
                                                    Colors.cyanAccent
                                                        .withOpacity(0.1),
                                                  )
                                                  : null,
                                          cells: [
                                            DataCell(
                                              Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                  color:
                                                      isWinner
                                                          ? Colors.yellowAccent
                                                          : Colors.white70,
                                                  fontWeight:
                                                      isWinner
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Row(
                                                children: [
                                                  Text(user['name'] ?? 'N/A'),
                                                  if (isWinner)
                                                    const SizedBox(width: 8),
                                                  if (isWinner)
                                                    const Icon(
                                                      Icons.star,
                                                      color:
                                                          Colors.yellowAccent,
                                                      size: 16,
                                                    ),
                                                ],
                                              ),
                                            ),
                                            DataCell(
                                              Text(user['phone'] ?? 'N/A'),
                                            ),
                                            DataCell(
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  user['myReferralCode'] ?? '-',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        isWinner
                                                            ? Colors.cyanAccent
                                                            : Colors.white10,
                                                  ),
                                                  child: Text(
                                                    user['totalReferrals']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color:
                                                          isWinner
                                                              ? Colors.black
                                                              : Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
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
}
