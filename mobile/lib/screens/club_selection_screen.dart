import 'package:flutter/material.dart';
import '../models/club.dart';
import '../repositories/club_repository.dart';
import '../main.dart'; // For MyApp.setClub

class ClubSelectionScreen extends StatelessWidget {
  const ClubSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clubs = ClubRepository.clubs;

    return Scaffold(
      appBar: AppBar(title: const Text('SELECT YOUR CLUB')),
      body: ListView.builder(
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              final club = clubs[index];
              await ClubRepository.saveSelectedClub(club.id);
              if (context.mounted) {
                MyApp.setClub(context, club);
                Navigator.pop(context);
              }
            },
            child: _ClubCard(club: clubs[index]),
          );
        },
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  final Club club;

  const _ClubCard({required this.club});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: club.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mock Logo Area
          Container(
            width: 80,
            height: double.infinity,
            decoration: BoxDecoration(
              color: club.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Icon(Icons.shield, color: club.primaryColor, size: 40),
          ),
          const SizedBox(width: 24),
          // Text Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club.name,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: club.primaryColor,
                    fontSize: 20, // Adjusted for displaySmall
                  ),
                ),
                Text(
                  'JOIN THE REVOLUTION',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          // Arrow
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Icon(Icons.arrow_forward_ios, color: club.primaryColor),
          ),
        ],
      ),
    );
  }
}
