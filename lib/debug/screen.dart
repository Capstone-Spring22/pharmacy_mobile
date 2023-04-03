import 'package:flutter/material.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  _DebugScreenState createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  int _currentIndex = 0;

  final List<Widget> _widgets = [
    Container(
      key: const ValueKey(0),
      child: const Center(
        child: Text(
          'Widget 1',
          style: TextStyle(fontSize: 24),
        ),
      ),
    ),
    Container(
      key: const ValueKey(1),
      child: const Center(
        child: Text(
          'Widget 2',
          style: TextStyle(fontSize: 24),
        ),
      ),
    ),
    Container(
      key: const ValueKey(2),
      child: const Center(
        child: Text(
          'Widget 3',
          style: TextStyle(fontSize: 24),
        ),
      ),
    ),
    Container(
      key: const ValueKey(3),
      child: const Center(
        child: Text(
          'Widget 4',
          style: TextStyle(fontSize: 24),
        ),
      ),
    ),
    Container(
      key: const ValueKey(4),
      child: const Center(
        child: Text(
          'Widget 5',
          style: TextStyle(fontSize: 24),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Widget Switcher'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                final index = _widgets.indexOf(child);
                final isEntering = index > _currentIndex;

                final begin = isEntering
                    ? const Offset(0.0, 1.0)
                    : const Offset(0.0, 0.0);
                final end = isEntering
                    ? const Offset(0.0, 0.0)
                    : const Offset(0.0, -1.0);

                return Stack(
                  children: [
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.0),
                        end: begin,
                      ).animate(animation),
                      child: FadeTransition(
                        opacity: Tween<double>(
                          begin: 1.0,
                          end: 0.0,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: end,
                      ).animate(animation),
                      child: FadeTransition(
                        opacity: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(animation),
                        child: _widgets[_currentIndex],
                      ),
                    ),
                  ],
                );
              },
              child: _widgets[_currentIndex],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentIndex = (_currentIndex + 1) % _widgets.length;
                });
              },
              child: const Text('Switch Widget'),
            ),
          ],
        ),
      ),
    );
  }
}
