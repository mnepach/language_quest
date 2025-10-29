import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';

enum MascotEmotion { happy, excited, thinking, sad, celebrating, sleeping }

enum MascotSize { small, medium, large }

class MascotWidget extends StatefulWidget {
  final MascotEmotion emotion;
  final MascotSize size;
  final String? message;
  final bool animate;

  const MascotWidget({
    super.key,
    this.emotion = MascotEmotion.happy,
    this.size = MascotSize.medium,
    this.message,
    this.animate = true,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getSize() {
    switch (widget.size) {
      case MascotSize.small:
        return AppDimensions.mascotSmall;
      case MascotSize.medium:
        return AppDimensions.mascotMedium;
      case MascotSize.large:
        return AppDimensions.mascotLarge;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, widget.animate ? -_bounceAnimation.value : 0),
              child: Transform.scale(
                scale: widget.animate ? _scaleAnimation.value : 1.0,
                child: _buildMascot(),
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          SizedBox(height: AppDimensions.spacingM),
          _buildMessageBubble(),
        ],
      ],
    );
  }

  Widget _buildMascot() {
    final size = _getSize();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: _getGradientColors(),
        ),
        boxShadow: [
          BoxShadow(
            color: _getGradientColors()[0].withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Тело маскота
          Container(
            width: size * 0.85,
            height: size * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          // Лицо
          _buildFace(size),
          // Щечки
          Positioned(
            left: size * 0.15,
            top: size * 0.5,
            child: Container(
              width: size * 0.15,
              height: size * 0.1,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            right: size * 0.15,
            top: size * 0.5,
            child: Container(
              width: size * 0.15,
              height: size * 0.1,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFace(double size) {
    switch (widget.emotion) {
      case MascotEmotion.happy:
        return _buildHappyFace(size);
      case MascotEmotion.excited:
        return _buildExcitedFace(size);
      case MascotEmotion.thinking:
        return _buildThinkingFace(size);
      case MascotEmotion.sad:
        return _buildSadFace(size);
      case MascotEmotion.celebrating:
        return _buildCelebratingFace(size);
      case MascotEmotion.sleeping:
        return _buildSleepingFace(size);
    }
  }

  Widget _buildHappyFace(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Глаза
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEye(size * 0.1),
            SizedBox(width: size * 0.2),
            _buildEye(size * 0.1),
          ],
        ),
        SizedBox(height: size * 0.1),
        // Улыбка
        Container(
          width: size * 0.3,
          height: size * 0.15,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.textPrimary,
                width: 3,
              ),
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(100),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExcitedFace(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: size * 0.15, color: AppColors.star),
            SizedBox(width: size * 0.1),
            Icon(Icons.star, size: size * 0.15, color: AppColors.star),
          ],
        ),
        SizedBox(height: size * 0.1),
        Container(
          width: size * 0.35,
          height: size * 0.2,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ],
    );
  }

  Widget _buildThinkingFace(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEye(size * 0.08),
            SizedBox(width: size * 0.2),
            _buildEye(size * 0.12),
          ],
        ),
        SizedBox(height: size * 0.1),
        Transform.rotate(
          angle: 0.3,
          child: Container(
            width: size * 0.25,
            height: size * 0.05,
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSadFace(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEye(size * 0.1),
            SizedBox(width: size * 0.2),
            _buildEye(size * 0.1),
          ],
        ),
        SizedBox(height: size * 0.1),
        Transform.rotate(
          angle: 3.14,
          child: Container(
            width: size * 0.3,
            height: size * 0.15,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.textPrimary,
                  width: 3,
                ),
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(100),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCelebratingFace(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('^', style: TextStyle(fontSize: size * 0.15, fontWeight: FontWeight.bold)),
            SizedBox(width: size * 0.15),
            Text('^', style: TextStyle(fontSize: size * 0.15, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: size * 0.05),
        Container(
          width: size * 0.4,
          height: size * 0.25,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              'w',
              style: TextStyle(
                fontSize: size * 0.2,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSleepingFace(double size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size * 0.15,
              height: size * 0.05,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(width: size * 0.15),
            Container(
              width: size * 0.15,
              height: size * 0.05,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        SizedBox(height: size * 0.15),
        Text('z', style: TextStyle(fontSize: size * 0.12)),
      ],
    );
  }

  Widget _buildEye(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMessageBubble() {
    return Container(
      constraints: BoxConstraints(maxWidth: _getSize() * 2),
      padding: EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        widget.message!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Color> _getGradientColors() {
    switch (widget.emotion) {
      case MascotEmotion.happy:
      case MascotEmotion.excited:
      case MascotEmotion.celebrating:
        return [AppColors.primary, AppColors.secondary];
      case MascotEmotion.thinking:
        return [AppColors.secondary, AppColors.accent];
      case MascotEmotion.sad:
        return [Colors.grey.shade400, Colors.grey.shade600];
      case MascotEmotion.sleeping:
        return [AppColors.accent.withOpacity(0.5), AppColors.secondary.withOpacity(0.5)];
    }
  }
}
