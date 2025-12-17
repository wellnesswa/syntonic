import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/mood_entry.dart';
import '../services/mood_provider.dart';
import '../utils/constants.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  int? _selectedMood;
  final _noteController = TextEditingController();
  final _uuid = const Uuid();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveMood() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood')),
      );
      return;
    }

    final entry = MoodEntry(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      moodScore: _selectedMood! + 1,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    await context.read<MoodProvider>().addEntry(entry);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood logged successfully!')),
      );
      setState(() {
        _selectedMood = null;
        _noteController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              title: const Text(
                'Mood Tracker',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'How are you feeling?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(5, (index) {
                              final isSelected = _selectedMood == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedMood = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.md),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        moodEmojis[index],
                                        style: TextStyle(
                                          fontSize: isSelected ? 48 : 40,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xxs),
                                      Text(
                                        moodLabels[index],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textSecondary,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TextField(
                            controller: _noteController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Add a note (optional)',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveMood,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                ),
                              ),
                              child: const Text(
                                'Save Mood',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      'Recent Entries',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Consumer<MoodProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (provider.entries.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              child: Text(
                                'No mood entries yet.\nStart tracking your mood!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.entries.length,
                          itemBuilder: (context, index) {
                            final entry = provider.entries[index];
                            return _MoodEntryCard(entry: entry);
                          },
                        );
                      },
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

class _MoodEntryCard extends StatelessWidget {
  final MoodEntry entry;

  const _MoodEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            moodEmojis[entry.moodScore - 1],
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moodLabels[entry.moodScore - 1],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _formatDate(entry.timestamp),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (entry.note != null && entry.note!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    entry.note!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
