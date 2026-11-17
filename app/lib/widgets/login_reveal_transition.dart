import 'package:material_ui/material_ui.dart';

class LoginRevealTransition extends StatefulWidget {
  const LoginRevealTransition({
    required this.child,
    required this.onCompleted,
    super.key,
  });

  final Widget child;
  final VoidCallback onCompleted;

  @override
  State<LoginRevealTransition> createState() => _LoginRevealTransitionState();
}

class _LoginRevealTransitionState extends State<LoginRevealTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1350),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            widget.onCompleted();
          }
        });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final halfWidth = constraints.maxWidth / 2;
        return AbsorbPointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = _controller.value;
              final opening = Curves.easeInOutCubic.transform(
                ((progress - 0.16) / 0.7).clamp(0.0, 1.0),
              );
              final loginOpacity =
                  1 -
                  Curves.easeIn.transform(
                    ((progress - 0.32) / 0.32).clamp(0.0, 1.0),
                  );
              final panelOpacity =
                  1 -
                  Curves.easeIn.transform(
                    ((opening - 0.76) / 0.24).clamp(0.0, 1.0),
                  );
              final light = (1 - ((progress - 0.34) / 0.42).abs()).clamp(
                0.0,
                1.0,
              );
              final lightWidth = 2 + constraints.maxWidth * 0.38 * light;

              return Stack(
                fit: StackFit.expand,
                children: [
                  Opacity(opacity: loginOpacity, child: widget.child),
                  Positioned(
                    left: -halfWidth * opening,
                    top: 0,
                    bottom: 0,
                    width: halfWidth,
                    child: Opacity(
                      opacity: panelOpacity,
                      child: const _GlassWindowPanel(isLeft: true),
                    ),
                  ),
                  Positioned(
                    left: halfWidth + halfWidth * opening,
                    top: 0,
                    bottom: 0,
                    width: halfWidth,
                    child: Opacity(
                      opacity: panelOpacity,
                      child: const _GlassWindowPanel(isLeft: false),
                    ),
                  ),
                  Positioned(
                    left: (constraints.maxWidth - lightWidth) / 2,
                    top: 0,
                    bottom: 0,
                    width: lightWidth,
                    child: Opacity(
                      opacity: light,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0x00FFFFFF),
                              Color(0xFFE9FFFA),
                              Color(0xFFFFFFFF),
                              Color(0xFFE9FFFA),
                              Color(0x00FFFFFF),
                            ],
                            stops: [0, 0.3, 0.5, 0.7, 1],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(
                                223,
                                255,
                                248,
                                0.72 * light,
                              ),
                              blurRadius: 42,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _GlassWindowPanel extends StatelessWidget {
  const _GlassWindowPanel({required this.isLeft});

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x66F4FFFB), Color(0x44D4F5EC), Color(0x55FFFFFF)],
        ),
        border: Border(
          right: isLeft
              ? const BorderSide(color: Color(0xBFFFFFFF), width: 2)
              : BorderSide.none,
          left: isLeft
              ? BorderSide.none
              : const BorderSide(color: Color(0xBFFFFFFF), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB5E5D9).withValues(alpha: 0.32),
            blurRadius: 24,
          ),
        ],
      ),
    );
  }
}
