import 'dart:async';
import 'package:flutter/material.dart';

class BlinkitMobileSearchField extends StatefulWidget {
  const BlinkitMobileSearchField({super.key});

  @override
  State<BlinkitMobileSearchField> createState() =>
      _BlinkitMobileSearchFieldState();
}

class _BlinkitMobileSearchFieldState
    extends State<BlinkitMobileSearchField> {
  final TextEditingController _controller = TextEditingController();

  final List<String> hints = [
    'Search "milk"',
    'Search "chocolate"',
    'Search "fruits"',
    'Search "snacks"',
  ];

  final List<Color> colors = [
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.red,
  ];

  int currentIndex = 0;
  Timer? timer;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!isTyping && _controller.text.isEmpty) {
        setState(() {
          currentIndex = (currentIndex + 1) % hints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xfff2f2f2),
        borderRadius: BorderRadius.circular(28), // pill shape
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),

          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [

                /// Animated Placeholder
                if (_controller.text.isEmpty)
                  ClipRect(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        final slide = Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation);

                        return SlideTransition(
                          position: slide,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        hints[currentIndex],
                        key: ValueKey(hints[currentIndex]),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colors[currentIndex],
                        ),
                      ),
                    ),
                  ),

                /// Real TextField
                TextField(
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                  onTap: () {
                    setState(() {
                      isTyping = true;
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          /// Mic Icon (Optional)
          const Icon(Icons.mic_none, color: Colors.grey),
        ],
      ),
    );
  }
}