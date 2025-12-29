import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:king_maker_cpanel/allinformation.dart';
import 'package:king_maker_cpanel/allusers.dart';
import 'package:king_maker_cpanel/createuser.dart';
import 'package:king_maker_cpanel/homepage.dart';

class WelcomeHub extends StatelessWidget {
  const WelcomeHub({super.key});

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
            colors: [
              Colors.indigo.shade900,
              Colors.indigo.shade700,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spectacular Header
                Image.asset("images/logo.png", width: 120, height: 120),
                const SizedBox(height: 10),
                const Text(
                  "KING MAKERS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                Text(
                  "INVESTMENT CONTROL PANEL",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 60),

                // Navigation Grid
                Wrap(
                  spacing: 25,
                  runSpacing: 25,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildNavCard(
                      context,
                      title: "Add Investor",
                      subtitle: "Register new users",
                      icon: Icons.person_add_alt_1_rounded,
                      color: Colors.cyanAccent,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateNewUser(),
                            ),
                          ),
                    ),
                    _buildNavCard(
                      context,
                      title: "Directory",
                      subtitle: "View all investors",
                      icon: Icons.analytics_outlined,
                      color: Colors.blueAccent,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDirectoryPage(),
                            ),
                          ),
                    ),
                    _buildNavCard(
                      context,
                      title: "Update Amount",
                      subtitle: "Update investment amount for a user",
                      icon: Icons.monetization_on_outlined,
                      color: Colors.amberAccent,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Homepage()),
                          ),
                    ),
                    _buildNavCard(
                      context,
                      title: " Referral Leaderboard",
                      subtitle: "Top investors by referrals",
                      icon: Icons.leaderboard_outlined,
                      color: Colors.cyanAccent,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllUserView(),
                            ),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: 200,
            height: 220,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
