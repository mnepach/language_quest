import 'package:flutter/material.dart';

/// Виджет для создания эффекта подпрыгивания
class BounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final bool autoPlay;
  final VoidCallback? onTap;

  const BounceAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.offset = 10.0,
    this.autoPlay = true,
    this.onTap,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.offset,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.autoPlay) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_animation.value),
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Виджет для создания эффекта масштабирования при нажатии
class ScaleAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleOnPress;

  const ScaleAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.scaleOnPress = 0.95,
  });

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnPress,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Виджет для создания эффекта вращения
class RotateAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool autoPlay;

  const RotateAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.autoPlay = true,
  });

  @override
  State<RotateAnimation> createState() => _RotateAnimationState();
}

class _RotateAnimationState extends State<RotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.autoPlay) {
      _controller.repeat();
    }
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
          angle: _controller.value * 2 * 3.14159,
          child: widget.child,
        );
      },
    );
  }
}

/// Виджет для создания эффекта пульсации
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool autoPlay;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.autoPlay = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.autoPlay) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Виджет для создания эффекта тряски (shake)
class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final int count;

  const ShakeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.offset = 10.0,
    this.count = 3,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = TweenSequence<double>([
      for (var i = 0; i < widget.count; i++) ...[
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: widget.offset),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: widget.offset, end: -widget.offset),
          weight: 1,
        ),
      ],
      TweenSequenceItem(
        tween: Tween(begin: -widget.offset, end: 0.0),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void shake() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: widget.child,
        );
      },
    );
  }
}

/// Виджет для создания эффекта появления снизу вверх
class SlideUpAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double offset;

  const SlideUpAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
    this.offset = 50.0,
  });

  @override
  State<SlideUpAnimation> createState() => _SlideUpAnimationState();
}

class _SlideUpAnimationState extends State<SlideUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.offset),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    _controller.forward();
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
        return Transform.translate(
          offset: _slideAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
