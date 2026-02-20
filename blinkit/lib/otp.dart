
import 'dart:async';
import 'dart:math';
import 'package:blinkit/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ─── OTP Page ─────────────────────────────────────────────────────────────────
class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with TickerProviderStateMixin {
  // 4 OTP fields
  final List<TextEditingController> _otpCtrl = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;
  bool _isVerified = false;
  int _resendTimer = 30;
  bool _canResend = false;
  Timer? _timer;

  // Colors
  static const _yellow = Color(0xFFFFC107);
  static const _deepYellow = Color(0xFFE6A800);
  static const _textDark = Color(0xFF1A1A1A);

  // Animation controllers
  late AnimationController _floatCtrl;
  late AnimationController _bgPulseCtrl;
  late AnimationController _cardCtrl;
  late AnimationController _staggerCtrl;
  late AnimationController _shakeCtrl;
  late AnimationController _successCtrl;

  late Animation<double> _float;
  late Animation<double> _bgPulse;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardFade;
  late Animation<double> _subFade;
  late Animation<double> _boxFade;
  late Animation<Offset> _boxSlide;
  late Animation<double> _btnFade;
  late Animation<Offset> _btnSlide;
  late Animation<double> _socialFade;
  late Animation<double> _shake;
  late Animation<double> _successScale;
  late Animation<double> _successFade;

  @override
  void initState() {
    super.initState();

    _startResendTimer();

    // Float
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _float = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut);

    // BG pulse
    _bgPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _bgPulse = CurvedAnimation(parent: _bgPulseCtrl, curve: Curves.easeInOut);

    // Card slide up
    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic));
    _cardFade = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeIn);

    // Stagger
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _subFade = _iv(0.00, 0.35);
    _boxFade = _iv(0.20, 0.55);
    _boxSlide = _sl(0.20, 0.55);
    _btnFade = _iv(0.42, 0.72);
    _btnSlide = _sl(0.42, 0.72);
    _socialFade = _iv(0.65, 1.00);

    // Shake (wrong OTP)
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shake = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn));

    // Success pop
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _successScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut));
    _successFade = CurvedAnimation(parent: _successCtrl, curve: Curves.easeIn);

    _cardCtrl.forward();
    Future.delayed(const Duration(milliseconds: 550), () {
      if (mounted) _staggerCtrl.forward();
    });
  }

  void _startResendTimer() {
    _resendTimer = 30;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  Animation<double> _iv(double a, double b) =>
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerCtrl,
          curve: Interval(a, b, curve: Curves.easeOut),
        ),
      );
  Animation<Offset> _sl(double a, double b) =>
      Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _staggerCtrl,
          curve: Interval(a, b, curve: Curves.easeOutCubic),
        ),
      );

  @override
  void dispose() {
    _timer?.cancel();
    _floatCtrl.dispose();
    _bgPulseCtrl.dispose();
    _cardCtrl.dispose();
    _staggerCtrl.dispose();
    _shakeCtrl.dispose();
    _successCtrl.dispose();
    for (final c in _otpCtrl) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _fullOtp => _otpCtrl.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_fullOtp.length < 4) {
      _shakeCtrl.forward(from: 0);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isVerified = true;
    });
    _successCtrl.forward();
  }

  void _onOtpChanged(String val, int idx) {
    if (val.isNotEmpty && idx < 3) {
      _focusNodes[idx + 1].requestFocus();
    } else if (val.isEmpty && idx > 0) {
      _focusNodes[idx - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bgH = size.height * 0.42;

    return Scaffold(
      backgroundColor: _yellow,
      body: Stack(
        children: [
          // ── Animated BG ──────────────────────────────────────────────────
          AnimatedBuilder(
            animation: _bgPulse,
            builder: (_, __) => Container(
              width: size.width,
              height: bgH + 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      const Color(0xFFFFD740),
                      const Color(0xFFFFB300),
                      _bgPulse.value,
                    )!,
                    Color.lerp(
                      const Color(0xFFFFB300),
                      const Color(0xFFFF8F00),
                      _bgPulse.value,
                    )!,
                  ],
                ),
              ),
            ),
          ),

          // ── Animated burger background image ──────────────────────────────────
          AnimatedBuilder(
            animation: _float,
            builder: (_, __) {
              final f = _float.value;
              final bounce = sin(f * pi) * 10;
              final tilt = sin(_floatCtrl.value * pi * 2) * 0.04;
              return SizedBox(
                width: size.width,
                height: bgH,
                child: ClipRect(
                  child: Transform.translate(
                    offset: Offset(0, -bounce * 0.5),
                    child: Transform.rotate(
                      angle: tilt,
                      child: Transform.scale(
                        scale: 1.15,
                        child: Image.asset(
                          'assets/burger.jpeg',
                          fit: BoxFit.cover,
                          width: size.width,
                          height: bgH + 60,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Back button ──────────────────────────────────────────────────
          Positioned(
            top: 48,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // ── Sliding card ─────────────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: _cardFade,
              child: SlideTransition(
                position: _cardSlide,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: _isVerified
                        ? _buildSuccessCard(size)
                        : _buildOtpCard(size),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── OTP Card ───────────────────────────────────────────────────────────────
  Widget _buildOtpCard(Size size) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height * 0.66),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x35000000),
            blurRadius: 36,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 48),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 26),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Subtitle
            FadeTransition(
              opacity: _subFade,
              child: Column(
                children: [
                  Text(
                    "Foodie has sent a 4 digit OTP to",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.phoneNumber,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _textDark,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ── 4 OTP boxes ─────────────────────────────────────────────
            FadeTransition(
              opacity: _boxFade,
              child: SlideTransition(
                position: _boxSlide,
                child: AnimatedBuilder(
                  animation: _shake,
                  builder: (_, child) {
                    final dx = sin(_shake.value * pi * 6) * 10;
                    return Transform.translate(
                      offset: Offset(dx, 0),
                      child: child,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (i) => _otpBox(i)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Resend OTP ───────────────────────────────────────────────
            FadeTransition(
              opacity: _boxFade,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _canResend
                      ? () {
                          _startResendTimer();
                          for (final c in _otpCtrl) c.clear();
                          _focusNodes[0].requestFocus();
                        }
                      : null,
                  child: Text(
                    _canResend
                        ? "Resend OTP"
                        : "Resend OTP in ${_resendTimer}s",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: _canResend ? _deepYellow : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Continue button ──────────────────────────────────────────
            FadeTransition(
              opacity: _btnFade,
              child: SlideTransition(
                position: _btnSlide,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _yellow,
                      elevation: 4,
                      shadowColor: _deepYellow.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isLoading ? null : _verify,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Continue",
                              key: ValueKey("continue"),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 26),

            // ── or with ─────────────────────────────────────────────────
            FadeTransition(
              opacity: _socialFade,
              child: Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      "or with",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ── Google ───────────────────────────────────────────────────
            FadeTransition(
              opacity: _socialFade,
              child: _socialBtn(
                "Continue with Google",
                FontAwesomeIcons.google,
                const Color(0xFF4285F4),
              ),
            ),

            const SizedBox(height: 12),

            // ── Apple ────────────────────────────────────────────────────
            FadeTransition(
              opacity: _socialFade,
              child: _socialBtn("Apple", Icons.apple_rounded, _textDark),
            ),

            const SizedBox(height: 24),

            // ── Terms ────────────────────────────────────────────────────
            FadeTransition(
              opacity: _socialFade,
              child: Text.rich(
                TextSpan(
                  text: "By continuing, you automatically accept our ",
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  children: [
                    TextSpan(
                      text: "Terms & Conditions",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ", "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Cookies Policy",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── OTP digit box ──────────────────────────────────────────────────────────
  Widget _otpBox(int i) {
    final isFilled = _otpCtrl[i].text.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: isFilled ? _yellow.withOpacity(0.12) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFilled ? _yellow : Colors.grey[300]!,
          width: isFilled ? 2.2 : 1.5,
        ),
        boxShadow: isFilled
            ? [
                BoxShadow(
                  color: _yellow.withOpacity(0.25),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: _otpCtrl[i],
        focusNode: _focusNodes[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: _textDark,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (v) => _onOtpChanged(v, i),
      ),
    );
  }

  // ── Success card ───────────────────────────────────────────────────────────
  Widget _buildSuccessCard(Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.66,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x35000000),
            blurRadius: 36,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: ScaleTransition(
        scale: _successScale,
        child: FadeTransition(
          opacity: _successFade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: _yellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _yellow.withOpacity(0.45),
                      blurRadius: 28,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Verified! 🎉",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: _textDark,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Welcome to Foodie 🍔",
                style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _yellow,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Explore Menu 🍟",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Social button ──────────────────────────────────────────────────────────
  Widget _socialBtn(String label, IconData icon, Color iconColor) {
    final isGoogle = label.contains('Google');
    final baseColor = isGoogle ? const Color(0xFF4285F4) : iconColor;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          side: BorderSide(
            color: isGoogle ? baseColor.withOpacity(0.7) : Colors.grey[300]!,
            width: isGoogle ? 1.6 : 1.2,
          ),
          backgroundColor:
              isGoogle ? Colors.white : const Color(0xFFFDFDFD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          shadowColor: baseColor.withOpacity(isGoogle ? 0.35 : 0.2),
          elevation: isGoogle ? 3 : 1,
        ),
        icon: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: isGoogle
                ? [
                    BoxShadow(
                      color: baseColor.withOpacity(0.25),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 18,
            color: baseColor,
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _textDark,
            ),
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}


