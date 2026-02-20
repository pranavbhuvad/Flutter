import 'dart:async';
import 'package:flutter/material.dart';

class BlinkitWebSearchField extends StatefulWidget {
  const BlinkitWebSearchField({super.key});

  @override
  State<BlinkitWebSearchField> createState() =>
      _BlinkitWebSearchFieldState();
}

class _BlinkitWebSearchFieldState
    extends State<BlinkitWebSearchField> {

  final TextEditingController _controller =
      TextEditingController();

  final PageController _pageController =
      PageController();

  final List<String> hints = [
    'Search "milk"',
    'Search "chocolate"',
    'Search "fruits"',
    'Search "snacks"',
  ];

  int currentPage = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 2),
      (_) {
        if (!mounted) return;
        if (_controller.text.isNotEmpty) return;

        currentPage =
            (currentPage + 1) % hints.length;

        _pageController.animateToPage(
          currentPage,
          duration:
              const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Container(
        width: double.infinity,
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xfff1f1f1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  /// Smooth vertical slide using PageView
                  if (_controller.text.isEmpty)
                    SizedBox(
                      height: 20,
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: hints.length,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              hints[index],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  /// Real TextField
                  TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14),
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