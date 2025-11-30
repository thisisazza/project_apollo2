import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/drill.dart';
import '../repositories/drill_repository.dart';
import '../theme/app_colors.dart';
import 'drill_view_screen.dart';

class DrillSelectionScreen extends StatefulWidget {
  const DrillSelectionScreen({super.key});

  @override
  State<DrillSelectionScreen> createState() => _DrillSelectionScreenState();
}

class _DrillSelectionScreenState extends State<DrillSelectionScreen> {
  late Future<List<Drill>> _drillsFuture;

  @override
  void initState() {
    super.initState();
    _drillsFuture = DrillRepository.getDrills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SELECT DRILL', style: TextStyle(fontFamily: 'Teko')),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppColors.black,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showGenerationDialog,
        label: const Text('GENERATE DRILL'),
        icon: const Icon(Icons.auto_awesome),
        backgroundColor: AppColors.neonBlue,
        foregroundColor: AppColors.black,
      ),
      body: FutureBuilder<List<Drill>>(
        future: _drillsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No drills found.'));
          }

          final drills = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: drills.length,
            itemBuilder: (context, index) {
              final drill = drills[index];
              return Card(
                color: AppColors.surface,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(
                    drill.title,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${drill.difficulty.name.toUpperCase()} • ${drill.durationSeconds}s',
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.neonBlue,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DrillViewScreen(drill: drill),
                      ),
                    );
                  },
                ),
              ).animate().fadeIn(delay: (100 * index).ms).slideX();
            },
          );
        },
      ),
    );
  }

  void _showGenerationDialog() {
    String selectedCategory = 'Passing';
    String selectedDifficulty = 'Intermediate';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: const Text(
                'GENERATE NEW DRILL',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontFamily: 'Teko',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedCategory,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: AppColors.textWhite),
                    items: ['Passing', 'Dribbling', 'Shooting']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedCategory = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedDifficulty,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: AppColors.textWhite),
                    items: ['Beginner', 'Intermediate', 'Advanced']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedDifficulty = v!),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonBlue,
                    foregroundColor: AppColors.black,
                  ),
                  onPressed: () async {
                    Navigator.pop(context); // Close dialog
                    _generateDrill(selectedCategory, selectedDifficulty);
                  },
                  child: const Text('GENERATE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _generateDrill(String category, String difficulty) async {
    // Show loading
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Generating drill...')));

    final newDrill = await DrillRepository.generateDrill(category, difficulty);

    if (newDrill != null) {
      // Refresh list
      setState(() {
        _drillsFuture = DrillRepository.getDrills();
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Generated: ${newDrill.title}')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate drill.')),
        );
      }
    }
  }
}
