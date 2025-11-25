import 'package:flutter/material.dart';
import '../models/club.dart';
import '../main.dart';

class ClubSelectionScreen extends StatelessWidget {
  const ClubSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for clubs
    final clubs = [
      Club(name: 'Iron Titans', primaryColor: Colors.red, id: '1'),
      Club(name: 'Cyber Athletics', primaryColor: Colors.cyan, id: '2'),
      Club(name: 'Neon Runners', primaryColor: Colors.purple, id: '3'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Club')),
      body: ListView.builder(
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          final club = clubs[index];
          return _ClubCard(club: club);
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
    return GestureDetector(
      onTap: () {
        MyApp.setClub(context, club);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
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
                          fontSize: 18, 
                        ),
                  ),
                  Text(
                    'JOIN THE REVOLUTION',
                    style: Theme.of(context).textTheme.bodyMedium,
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
      ),
    );
  }
}
