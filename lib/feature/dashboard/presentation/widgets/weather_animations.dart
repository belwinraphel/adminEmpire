import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/services/weather_service.dart';

// --- Wrapper ---
class WeatherAnimationWrapper extends StatelessWidget {
  final WeatherCondition condition;

  const WeatherAnimationWrapper({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    switch (condition) {
      case WeatherCondition.sun:
        return _buildBackground(
          context,
          const Positioned(
            right: -30,
            top: -30,
            child: Opacity(opacity: 0.1, child: SunWidget(size: 150)),
          ),
          Colors.orangeAccent.withOpacity(0.05),
        );
      case WeatherCondition.snow:
        return _buildBackground(
          context,
          const Positioned.fill(
            child: Opacity(opacity: 0.3, child: SnowWidget()),
          ),
          const Color(0xFF020205), // Dark background like Night
        );
      case WeatherCondition.night:
        return _buildBackground(
          context,
          const Positioned.fill(
            child: Opacity(opacity: 0.4, child: NightWidget()),
          ), // Reduced opacity
          const Color(0xFF020205),
        ); // Very dark background
      case WeatherCondition.thunderRain:
        return _buildBackground(
          context,
          const Positioned.fill(
            child: Opacity(opacity: 0.4, child: ThunderRainWidget()),
          ),
          const Color(0xFF1E1E2D),
        );
      case WeatherCondition.thunderStorm:
        return _buildBackground(
          context,
          const Positioned.fill(
            child: Opacity(opacity: 0.5, child: ThunderStormWidget()),
          ),
          Colors.black87,
        );
    }
  }

  Widget _buildBackground(
    BuildContext context,
    Widget animation,
    Color bgColor,
  ) {
    // If night or storm, we might want to override the card color.
    // For now, we return a stack that sits inside the card logic.
    // However, metrics card provides the decoration. We just provide content.
    // We will rely on the Opacity provided in MetricsCard or here.
    return Stack(
      children: [
        if (condition == WeatherCondition.night ||
            condition == WeatherCondition.thunderStorm ||
            condition == WeatherCondition.thunderRain)
          Positioned.fill(
            child: Container(color: bgColor),
          ), // Override background for dark themes
        animation,
      ],
    );
  }
}

// --- Specific Widgets ---

class SunWidget extends StatefulWidget {
  final double size;
  const SunWidget({super.key, this.size = 24});

  @override
  State<SunWidget> createState() => _SunWidgetState();
}

class _SunWidgetState extends State<SunWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: const FittedBox(
              child: Icon(Icons.wb_sunny, color: Colors.orangeAccent),
            ),
          ),
        );
      },
    );
  }
}

class RainWidget extends StatefulWidget {
  const RainWidget({super.key});

  @override
  State<RainWidget> createState() => _RainWidgetState();
}

class _RainWidgetState extends State<RainWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _drops = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    for (int i = 0; i < 30; i++) {
      _drops.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.015 + _random.nextDouble() * 0.02,
          length: 0.1 + _random.nextDouble() * 0.1,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) =>
            CustomPaint(painter: _RainPainter(_drops, _random)),
      ),
    );
  }
}

class SnowWidget extends StatefulWidget {
  const SnowWidget({super.key});

  @override
  State<SnowWidget> createState() => _SnowWidgetState();
}

class _SnowWidgetState extends State<SnowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _flakes = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    for (int i = 0; i < 40; i++) {
      _flakes.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.002 + _random.nextDouble() * 0.003, // Slower than rain
          length: 0.0,
        ),
      ); // Dot
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) =>
            CustomPaint(painter: _SnowPainter(_flakes, _random)),
      ),
    );
  }
}

class NightWidget extends StatelessWidget {
  const NightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stars
        const Positioned.fill(child: _Stars()),
        // Moon
        Positioned(
          top: 10,
          right: 10,
          child: Opacity(
            opacity: 0.8,
            child: Icon(
              Icons.nightlight_round,
              color: Colors.yellow[100],
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _StarPainter());
  }
}

class ThunderRainWidget extends StatelessWidget {
  const ThunderRainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const RainWidget(),
        _LightningFlash(interval: const Duration(seconds: 3), intensity: 0.3),
      ],
    );
  }
}

class ThunderStormWidget extends StatelessWidget {
  const ThunderStormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const RainWidget(), // Heavy rain reused
        _LightningFlash(
          interval: const Duration(milliseconds: 1500),
          intensity: 0.6,
        ),
        // Bolt
        const Positioned(top: 10, right: 30, child: _FlickeringBolt()),
      ],
    );
  }
}

class _LightningFlash extends StatefulWidget {
  final Duration interval;
  final double intensity; // Opacity max
  const _LightningFlash({required this.interval, required this.intensity});

  @override
  State<_LightningFlash> createState() => _LightningFlashState();
}

class _LightningFlashState extends State<_LightningFlash> {
  Timer? _timer;
  bool _active = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _scheduleFlash();
  }

  void _scheduleFlash() {
    _timer = Timer(
      widget.interval + Duration(milliseconds: _random.nextInt(2000)),
      () async {
        if (!mounted) return;
        setState(() => _active = true);
        await Future.delayed(
          const Duration(milliseconds: 100),
        ); // Flash duration
        if (!mounted) return;
        setState(() => _active = false);
        // Double flash sometimes
        if (_random.nextBool()) {
          await Future.delayed(const Duration(milliseconds: 50));
          if (!mounted) return;
          setState(() => _active = true);
          await Future.delayed(const Duration(milliseconds: 50));
          if (!mounted) return;
          setState(() => _active = false);
        }
        _scheduleFlash();
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      color: _active
          ? Colors.white.withOpacity(widget.intensity)
          : Colors.transparent,
    );
  }
}

class _FlickeringBolt extends StatefulWidget {
  const _FlickeringBolt();

  @override
  State<_FlickeringBolt> createState() => _FlickeringBoltState();
}

class _FlickeringBoltState extends State<_FlickeringBolt>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Icon(Icons.flash_on, color: Colors.yellow, size: 48),
    );
  }
}

// --- Painters ---

class _Particle {
  double x;
  double y;
  double speed;
  double length;
  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
  });
}

class _RainPainter extends CustomPainter {
  final List<_Particle> particles;
  final Random random;
  _RainPainter(this.particles, this.random);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlueAccent
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (var p in particles) {
      p.y += p.speed;
      if (p.y > 1.0) {
        p.y = -p.length;
        p.x = random.nextDouble();
      }
      final xPos = p.x * size.width;
      final yPos = p.y * size.height;
      final endY = (p.y + p.length) * size.height;
      if (endY > 0 && yPos < size.height)
        canvas.drawLine(Offset(xPos, yPos), Offset(xPos, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class _SnowPainter extends CustomPainter {
  final List<_Particle> particles;
  final Random random;
  _SnowPainter(this.particles, this.random);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    for (var p in particles) {
      p.y += p.speed;
      if (p.y > 1.0) {
        p.y = -0.05;
        p.x = random.nextDouble();
      }
      final xPos = p.x * size.width;
      final yPos = p.y * size.height;
      if (yPos > -2 && yPos < size.height)
        canvas.drawCircle(Offset(xPos, yPos), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class _StarPainter extends CustomPainter {
  final Random _random = Random(42); // Seed for consistency
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);
    for (int i = 0; i < 50; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final s = _random.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), s, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
