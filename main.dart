import 'dart:async';
import 'package:flutter/material.dart';

/// Entry point of the Flutter application
void main() {
  runApp(const FitnessExerciseApp());
}

/// Root widget of the application
/// This is a StatelessWidget since we don't need state management for this simple app
class FitnessExerciseApp extends StatelessWidget {
  const FitnessExerciseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove debug banner in top-right corner
      debugShowCheckedModeBanner: false,
      // App title
      title: 'Fitness Exercise App',
      // Define app theme with modern colors
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      // Set home page
      home: const FitnessHomePage(),
    );
  }
}

/// Main home page displaying the list of exercises
/// This is the ONLY page in the app (no navigation)
class FitnessHomePage extends StatelessWidget {
  const FitnessHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        title: const Text(
          'Fitness Exercises',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      // Main body content
      body: Column(
        children: [
          // Header section with description
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              'Start your fitness journey today! Choose an exercise below and get moving.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
          // Spacing
          const SizedBox(height: 20),
          // Exercise list
          Expanded(
            child: ExerciseList(),
          ),
        ],
      ),
    );
  }
}

/// Widget that displays the scrollable list of exercises
class ExerciseList extends StatelessWidget {
  ExerciseList({super.key});

  /// Static data: List of exercises with their details
  /// In a real app, this would come from a database or API
  final List<Map<String, dynamic>> exercises = [
    {
      'name': 'Push-ups',
      'description': 'Build upper body strength with this classic exercise. Great for chest, shoulders, and triceps.',
      'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400&h=300&fit=crop',
      'duration': 30, // Duration in seconds
    },
    {
      'name': 'Squats',
      'description': 'Strengthen your legs and glutes. Perfect for building lower body power and stability.',
      'image': 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400&h=300&fit=crop',
      'duration': 45,
    },
    {
      'name': 'Plank',
      'description': 'Core strengthening exercise that improves posture and builds endurance.',
      'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'duration': 60,
    },
    {
      'name': 'Jumping Jacks',
      'description': 'Full body cardio exercise to get your heart pumping and burn calories fast.',
      'image': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=300&fit=crop',
      'duration': 30,
    },
    {
      'name': 'Sit-ups',
      'description': 'Target your abdominal muscles and build a stronger core with this classic move.',
      'image': 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?w=400&h=300&fit=crop',
      'duration': 40,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Add padding around the list
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Number of items in the list
      itemCount: exercises.length,
      // Builder function to create each card
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return ExerciseCard(
          name: exercise['name']!,
          description: exercise['description']!,
          imageUrl: exercise['image']!,
          duration: exercise['duration']!,
        );
      },
    );
  }
}

/// Individual exercise card widget
/// Displays exercise image, name, description, and start button with timer
/// Now uses StatefulWidget to manage timer state
class ExerciseCard extends StatefulWidget {
  final String name;
  final String description;
  final String imageUrl;
  final int duration; // Duration in seconds

  const ExerciseCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.duration,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  // Timer variables
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;

  @override
  void dispose() {
    // Clean up timer when widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  /// Start the countdown timer
  void _startTimer() {
    // Print to console
    print('Started exercise: ${widget.name}');

    setState(() {
      _remainingSeconds = widget.duration;
      _isRunning = true;
    });

    // Create a periodic timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          // Timer finished
          _timer?.cancel();
          _isRunning = false;

          // Show completion message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Great job! You completed ${widget.name}! 🎉'),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      });
    });
  }

  /// Stop the timer
  void _stopTimer() {
    setState(() {
      _timer?.cancel();
      _isRunning = false;
      _remainingSeconds = 0;
    });
  }

  /// Format seconds into MM:SS format
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margin between cards
      margin: const EdgeInsets.only(bottom: 16),
      // Rounded corners and shadow for modern look
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise image
            Image.network(
              widget.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              // Placeholder while loading
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              // Error widget if image fails to load
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.fitness_center,
                    size: 80,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            // Card content (text, timer, and button)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise name
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Exercise description
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Timer display (only show when running)
                  if (_isRunning)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _formatTime(_remainingSeconds),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keep going!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Start/Stop button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isRunning ? _stopTimer : _startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRunning
                            ? Colors.red
                            : const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        _isRunning ? 'Stop' : 'Start',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }
}