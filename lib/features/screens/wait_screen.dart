import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class WaitScreen extends StatefulWidget {
  const WaitScreen({Key? key}) : super(key: key);

  @override
  State<WaitScreen> createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  int _currentTipIndex = 0;
  final Random _random = Random();

  final List<String> _tips = [
    'Octopuses have three hearts! Two pump blood to the gills, one pumps to the rest of the body.',
    'A group of flamingos is called a “flamboyance.”',
    'Sloths can hold their breath longer than dolphins – up to 40 minutes underwater!',
    'Butterflies can taste with their feet.',
    'Sea otters hold hands while sleeping so they don’t drift apart.',
    'Bananas are berries, but strawberries aren’t.',
    'Sharks existed before trees – over 400 million years ago!',
    'Koalas have fingerprints almost identical to humans.',
    'A day on Venus is longer than a year on Venus.',
    'Wombat poop is cube-shaped!',
    'Penguins propose with pebbles. Male penguins give a pebble to a female they like.',
    'Some frogs can freeze and come back to life.',
    'Starfish don’t have a brain, but they can still move and eat!',
    'Your stomach gets a new lining every 3-4 days so it doesn’t digest itself.',
    'Honey never spoils – archaeologists found edible honey in 3,000-year-old tombs!',
  ];

  @override
  void initState() {
    super.initState();
    _currentTipIndex = _random.nextInt(_tips.length);
    _startTipRotation();
  }

  void _startTipRotation() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentTipIndex = _random.nextInt(_tips.length);
        });
        _startTipRotation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ), // MOVED UP - reduced from Spacer(flex: 2)
              // Fixed title
              Text(
                'Setting up your playground',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28), // MOVED UP - reduced from 32
              // Fixed Lottie Animation
              Lottie.asset(
                'assets/animations/yay-jump.json',
                width: 160, // MOVED UP - reduced size
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.blue,
                    ),
                  );
                },
              ),

              const SizedBox(height: 32), // MOVED UP - reduced from 40
              // Random rotating tips
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  key: ValueKey(_currentTipIndex),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _tips[_currentTipIndex],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(), // MOVED UP - single spacer instead of flex: 3
            ],
          ),
        ),
      ),
    );
  }
}
