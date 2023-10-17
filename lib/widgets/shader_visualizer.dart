import 'dart:ui';

import 'package:flutter/widgets.dart';

class ShaderVisualizer extends StatefulWidget {
  final String shader;
  final bool animated;

  final Duration duration;
  final Duration? reverseDuration;

  const ShaderVisualizer({
    super.key,
    required this.shader,
    this.animated = false,
    this.duration = const Duration(milliseconds: 1500),
    this.reverseDuration,
  });

  @override
  State<ShaderVisualizer> createState() => _ShaderVisualizerState();
}

class _ShaderVisualizerState extends State<ShaderVisualizer>
    with TickerProviderStateMixin {
  late FragmentProgram _fragmentProgram;
  FragmentShader? _fragmentShader;

  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();

    if (widget.animated) {
      _animationController = AnimationController(
        vsync: this,
        duration: widget.duration,
        reverseDuration: widget.reverseDuration,
      )
        ..addListener(() => setState(() {}))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _animationController!.reverse();
          }

          if (status == AnimationStatus.dismissed) {
            _animationController!.forward();
          }
        });
    }

    _loadProgram();
  }

  Future<void> _loadProgram() async {
    _fragmentProgram = await FragmentProgram.fromAsset(widget.shader);
    _fragmentShader = _fragmentProgram.fragmentShader();

    if (widget.animated) _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _fragmentShader?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _fragmentShader == null
        ? const Placeholder()
        : CustomPaint(
            painter: ShaderPainter(
              shader: _fragmentShader!,
              uTime: _animationController?.value,
            ),
          );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double? uTime;

  const ShaderPainter({
    required this.shader,
    this.uTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    if (uTime != null) {
      shader.setFloat(2, uTime!);
    }

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) =>
      shader != oldDelegate.shader || uTime != oldDelegate.uTime;
}
